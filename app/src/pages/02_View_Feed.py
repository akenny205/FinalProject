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
        
        # New input for user ID
        user_id = st.text_input("User ID", key="user_id_input")
        
        post_content = st.text_area("What's on your mind?", height=100)
        submit_button = st.form_submit_button("Post")
        
        if submit_button and post_content and user_id:
            post_data = {
                "user_id": user_id,  # Use the input user ID
                "content": post_content,
                "post_date": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
                "admin_id": 1
            }
            
            try:
                response = requests.post(
                    'http://web-api:4000/p/createpost',
                    json=post_data
                )
                if response.status_code == 201:
                    st.success("Post created successfully!")
                    st.session_state.show_post_form = False
                    st.session_state['rerun'] = True
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
        st.write('---')
        st.write('**Comments:**')
        st.write('---')
        # Fetch and display comments for the post
        comments_response = requests.get(f'http://web-api:4000/p/getcomment/{post["PostID"]}')
        if comments_response.status_code == 200:
            comments = comments_response.json()
            for comment in comments:
                st.markdown(f"{comment['Content']}")
                
                if st.button("Edit Comment", key=f"edit_comment_{comment['CommentID']}"):
                    # Debugging: Log that the edit button was clicked
                    logger.debug(f"Edit Comment button clicked for CommentID {comment['CommentID']}")
                    
                    with st.form(key=f"edit_comment_form_{comment['CommentID']}"):
                        edited_comment = st.text_area("Edit your comment", comment['Content'], key=f"edit_comment_content_{comment['CommentID']}")
                        submit_edit = st.form_submit_button("Save")
                        
                        if submit_edit:
                            # Debugging: Log the edited comment content
                            logger.debug(f"Edited comment content for CommentID {comment['CommentID']}: {edited_comment}")
                            
                            try:
                                edit_response = requests.put(
                                    f'http://web-api:4000/com/editcomment/{comment["CommentID"]}',
                                    json=edited_comment
                                )
                                # Debugging: Log the response status and content
                                logger.debug(f"Edit response status: {edit_response.status_code}")
                                logger.debug(f"Edit response content: {edit_response.text}")
                                
                                if edit_response.status_code == 200:
                                    st.success("Comment edited successfully!")
                                else:
                                    st.error(f"Failed to edit comment: {edit_response.status_code} - {edit_response.text}")
                            except Exception as e:
                                # Debugging: Log the exception
                                logger.error(f"Error editing comment: {str(e)}")
                                st.error(f"Error editing comment: {str(e)}")

                st.write('---')
        else:
            st.error(f"Failed to fetch comments for post {post['PostID']}: {comments_response.status_code} - {comments_response.text}")

        # New column layout for buttons
        button_col2, button_col3, button_col4 = st.columns([0.33, 0.33, 0.33])
        
        # Remove the liking functionality
        # with button_col1:
        #     if f"liked_{post['PostID']}" not in st.session_state:
        #         st.session_state[f"liked_{post['PostID']}"] = False

        #     if st.button("Like 👍" if not st.session_state[f"liked_{post['PostID']}"] else "👍 Liked", 
        #                  key=f"like_{post['PostID']}", help="Like"):
        #         st.session_state[f"liked_{post['PostID']}"] = not st.session_state[f"liked_{post['PostID']}"]

        with button_col2:
            if st.button("Edit Post", key=f"edit_{post['PostID']}"):
                st.session_state[f"edit_post_{post['PostID']}"] = True

        with button_col3:
            if st.button("Delete Post", key=f"delete_{post['PostID']}"):
                try:
                    delete_response = requests.delete(f'http://web-api:4000/p/deletepost/{post["PostID"]}')
                    if delete_response.status_code == 200:
                        st.success("Post deleted successfully!")
                        st.session_state['rerun'] = True
                    else:
                        st.error(f"Failed to delete post: {delete_response.status_code} - {delete_response.text}")
                except Exception as e:
                    st.error(f"Error deleting post: {str(e)}")

        with button_col4:
            if st.button("Add Comment", key=f"add_comment_{post['PostID']}"):
                logger.debug(f"Add Comment button clicked for PostID {post['PostID']}")
                with st.form(key=f"add_comment_form_{post['PostID']}", clear_on_submit=True):
                    user_id = st.text_input("User ID", key=f"user_id_input_{post['PostID']}")
                    comment_content = st.text_area("Enter your comment", key=f"comment_content_{post['PostID']}")
                    submit_comment = st.form_submit_button("Submit Comment")
                    
                    if submit_comment and comment_content and user_id:
                        logger.debug(f"Form submitted with content: {comment_content} and user_id: {user_id}")
                        comment_data = {
                            "post_ id": post['PostID'],
                            "commenter_id": user_id,
                            "comment_date": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
                            "content":  comment_content
                        }
                        
                        # Debugging: Log the comment data being sent
                        logger.debug(f"Sending comment data: {comment_data}")
                        
                        try:
                            response = requests.post(
                                'http://web-api:4000/com/createcomment',
                                json=comment_data
                            )
                            # Debugging: Log the response status and content
                            logger.debug(f"Response status: {response.status_code}")
                            logger.debug(f"Response content: {response.text}")
                            
                            if response.status_code == 200:
                                st.success("Comment added successfully!")
                            else:
                                st.error("Failed to add comment")
                        except Exception as e:
                            # Debugging: Log the exception
                            logger.error(f"Error adding comment: {str(e)}")
                            st.error(f"Error adding comment: {str(e)}")

        # Show edit form if the edit button was clicked
        if st.session_state.get(f"edit_post_{post['PostID']}", False):
            with st.form(key=f"edit_form_{post['PostID']}", clear_on_submit=True):
                edited_content = st.text_area("Edit your post", post['Content'], key=f"edit_content_{post['PostID']}")
                submit_edit = st.form_submit_button("Save")
                cancel_edit = st.form_submit_button("Cancel")

                if submit_edit:
                    edit_data = {
                        "content": edited_content,
                        "post_date": datetime.now().strftime("%Y-%m-%d %H:%M:%S")
                    }
                    try:
                        response = requests.put(
                            f'http://web-api:4000/p/editpost/{post["PostID"]}',
                            json=edit_data
                        )
                        if response.status_code == 200:
                            st.success("Post edited successfully!")
                            st.session_state[f"edit_post_{post['PostID']}"] = False
                            st.session_state['rerun'] = True
                        else:
                            st.error("Failed to edit post")
                    except Exception as e:
                        st.error(f"Error editing post: {str(e)}")

                if cancel_edit:
                    st.session_state[f"edit_post_{post['PostID']}"] = False
                    st.session_state['rerun'] = True

        # Check for rerun flag
        if st.session_state.get('rerun', False):
            st.session_state['rerun'] = False

else:
    st.error(f"Failed to fetch posts: {posts_response.status_code}")