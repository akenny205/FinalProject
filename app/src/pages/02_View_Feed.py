import logging
logger = logging.getLogger(__name__)
import streamlit as st
import pandas as pd
from streamlit_extras.app_logo import add_logo
from modules.nav import SideBarLinks
import requests
import streamlit as st
from datetime import datetime

# Page Init

SideBarLinks()

st.title("Feed")

if 'authenticated' not in st.session_state or not st.session_state['authenticated']:
    st.error("Please log in first")
    st.stop()

if 'user_id' not in st.session_state:
    st.error("User ID not found in session")
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
            post_comments = requests.post(
                f'http://web-api:4000/p/getcomment/{post["PostID"]}'
            )
            
            # Initialize view_comments state for this post
            if f"view_comments_{post['PostID']}" not in st.session_state:
                st.session_state[f"view_comments_{post['PostID']}"] = False
            
            if post_comments.status_code == 200:
                comments = post_comments.json()
                if len(comments) == 0:
                    st.write("💬 Be the first to comment:")
                elif len(comments) == 1:
                    st.write("💬 1 Comment")
                    # Add view comments button
                    if st.button("View Comment", key=f"view_{post['PostID']}"):
                        st.session_state[f"view_comments_{post['PostID']}"] = not st.session_state[f"view_comments_{post['PostID']}"]
                    
                    # Show comments if button was clicked
                    if st.session_state[f"view_comments_{post['PostID']}"]:
                        st.write(comments[0]['content'])
                else:
                    st.write(f"💬 {len(comments)} Comments")
                    # Add view comments button
                    if st.button("View Comments", key=f"view_{post['PostID']}"):
                        st.session_state[f"view_comments_{post['PostID']}"] = not st.session_state[f"view_comments_{post['PostID']}"]
                    
                    # Show comments if button was clicked
                    if st.session_state[f"view_comments_{post['PostID']}"]:
                        for comment in comments:
                            st.write(comment['content'])

            # Comment button and text area
            if st.button("💬", key=f"comment_{post['PostID']}", help="Comment"):
                comment_content = st.text_area("Add a comment:")
                if comment_content:
                    comment_data = {
                        "user_id": st.session_state.get('user_id'),
                        "post_id": post['PostID'],
                        "content": comment_content
                    }

else:
    st.error(f"Failed to fetch posts: {posts_response.status_code}")