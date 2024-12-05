import logging
logger = logging.getLogger(__name__)
import streamlit as st
import pandas as pd
from streamlit_extras.app_logo import add_logo
from modules.nav import SideBarLinks
import requests
import streamlit as st
from datetime import datetime

SideBarLinks()

st.title("Feed")

if 'authenticated' not in st.session_state or not st.session_state['authenticated']:
    st.error("Please log in first")
    st.stop()

if 'show_post_form' not in st.session_state:
    st.session_state.show_post_form = False

# Create Post Button

with st.container():
    col1, col2 = st.columns([0.0001, 0.7])
    with col2:
        if st.button("➕", help="Create new post"):
            st.session_state.show_post_form = True

if st.session_state.show_post_form:
    with st.form(key="new_post_form", clear_on_submit=True):
        col1, col2 = st.columns([0.9, 0.1])
        with col1:
            st.subheader("Create New Post")
        with col2:
            if st.form_submit_button("❌", help="Close"):
                st.session_state.show_post_form = False
        
        post_content = st.text_area("What's on your mind?", height=100)
        submit_button = st.form_submit_button("Post")
        
        if submit_button and post_content:
            post_data = {
                "user_id": st.session_state.get('user_id'),
                "content": post_content,
                "post_date": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
                "admin_id": None
            }
            
            try:
                response = requests.post(
                    'http://web-api:4000/p/createpost',
                    json=post_data
                )
                if response.status_code == 201:
                    st.success("Post created successfully!")
                    st.session_state.show_post_form = False
                    st.experimental_rerun()
                else:
                    st.error("Failed to create post")
            except Exception as e:
                st.error(f"Error creating post: {str(e)}")

# Post Feed

# Add CSS style once, outside the loop
st.markdown("""
    <style>
        .post-container {
            border: 1px solid #ddd;
            border-radius: 10px;
            padding: 15px;
            margin: 10px 0;
        }
    </style>
""", unsafe_allow_html=True)

posts_response = requests.get('http://web-api:4000/p/viewposts')
if posts_response.status_code == 200:
    posts = posts_response.json()
    for post in posts:
        st.markdown("""
            <div class="post-container">
            </div>
        """, unsafe_allow_html=True)
        
        col1, col2 = st.columns([2, 1])
        with col1:
            st.markdown(f"**{post['fName']} {post['lName']}**")
        with col2:
            post_date = datetime.strptime(post['PostDate'], '%a, %d %b %Y %H:%M:%S GMT')
            st.markdown(f"*{post_date.strftime('%B %d, %Y %I:%M %p')}*")
        
        st.write(post['Content'])
        
        # Initialize like state in session
        if f"liked_{post['PostID']}" not in st.session_state:
            st.session_state[f"liked_{post['PostID']}"] = False
        
        # New column layout for buttons
        button_col1, button_col2 = st.columns([0.5, 0.5])
        with button_col1:
            if st.button("👍" if not st.session_state[f"liked_{post['PostID']}"] else "👍 Liked", 
                         key=f"like_{post['PostID']}", help="Like"):
                st.session_state[f"liked_{post['PostID']}"] = not st.session_state[f"liked_{post['PostID']}"]
        
        with button_col2:
            # Fetch comments for the post
            post_comments = requests.get(
                f'http://web-api:4000/p/viewcomments/{post["PostID"]}'
            )
            
            # Initialize states for this post
            if f"view_comments_{post['PostID']}" not in st.session_state:
                st.session_state[f"view_comments_{post['PostID']}"] = False
            if f"show_comment_input_{post['PostID']}" not in st.session_state:
                st.session_state[f"show_comment_input_{post['PostID']}"] = False
            
            if post_comments.status_code == 200:
                comments = post_comments.json()
                comment_count = len(comments)
                
                # Display comment count and toggle button
                col1, col2 = st.columns([0.7, 0.3])
                with col1:
                    if comment_count == 0:
                        st.write("💬 Be the first to comment")
                    elif comment_count == 1:
                        st.write("💬 1 Comment")
                    else:
                        st.write(f"💬 {comment_count} Comments")
                
                with col2:
                    if st.button("View" if not st.session_state[f"view_comments_{post['PostID']}"] else "Hide", 
                                 key=f"view_{post['PostID']}"):
                        st.session_state[f"view_comments_{post['PostID']}"] = not st.session_state[f"view_comments_{post['PostID']}"]

                # Show comments section if enabled
                if st.session_state[f"view_comments_{post['PostID']}"]:
                    for comment in comments:
                        with st.container():
                            st.markdown("""
                                <style>
                                    .comment-container {
                                        border-left: 2px solid #e6e6e6;
                                        padding-left: 10px;
                                        margin: 5px 0;
                                    }
                                </style>
                            """, unsafe_allow_html=True)
                            
                            st.markdown('<div class="comment-container">', unsafe_allow_html=True)
                            col1, col2 = st.columns([0.7, 0.3])
                            with col1:
                                st.markdown(f"**{comment.get('FirstName', '')} {comment.get('LastName', '')}**")
                            with col2:
                                comment_date = datetime.strptime(comment.get('CommentDate', datetime.now().strftime("%Y-%m-%d %H:%M:%S")), 
                                                               "%Y-%m-%d %H:%M:%S")
                                st.markdown(f"*{comment_date.strftime('%b %d, %Y')}*")
                            st.write(comment['Content'])
                            st.markdown('</div>', unsafe_allow_html=True)

            # Comment input section
            if st.button("💬 Comment", key=f"comment_btn_{post['PostID']}"):
                st.session_state[f"show_comment_input_{post['PostID']}"] = True

            if st.session_state[f"show_comment_input_{post['PostID']}"]:
                with st.form(key=f"comment_form_{post['PostID']}", clear_on_submit=True):
                    comment_text = st.text_area("Write a comment...", key=f"comment_input_{post['PostID']}")
                    col1, col2 = st.columns([0.7, 0.3])
                    with col1:
                        submit = st.form_submit_button("Post")
                    with col2:
                        if st.form_submit_button("Cancel"):
                            st.session_state[f"show_comment_input_{post['PostID']}"] = False
                            st.experimental_rerun()
       
                    
                    if submit and comment_text:
                        comment_data = {
                            "user_id": st.session_state.get('user_id'),
                            "post_id": post['PostID'],
                            "content": comment_text,
                            "comment_date": datetime.now().strftime("%Y-%m-%d %H:%M:%S")
                        }
                        
                        # Placeholder for comment submission route
                        try:
                            response = requests.post(
                                'http://web-api:4000/p/createcomment',  # Replace with actual endpoint
                                json=comment_data
                            )
                            if response.status_code == 201:
                                st.success("Comment posted successfully!")
                                st.session_state[f"show_comment_input_{post['PostID']}"] = False
                           
                            else:
                                st.error("Failed to post comment")
                        except Exception as e:
                            st.error(f"Error posting comment: {str(e)}")

else:
    st.error(f"Failed to fetch posts: {posts_response.status_code}")