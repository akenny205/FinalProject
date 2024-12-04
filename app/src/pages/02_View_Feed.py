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

# Check if user is authenticated and has UserID
if 'authenticated' not in st.session_state or not st.session_state['authenticated']:
    st.error("Please log in first")
    st.stop()

if 'user_id' not in st.session_state:
    st.error("User ID not found in session")
    st.stop()

if 'show_post_form' not in st.session_state:
    st.session_state.show_post_form = False

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


def post_format(post):
    return f"{post['FirstName']} {post['LastName']} - {post['PostDate']}\n{post['Content']}"

posts_response = requests.get('http://web-api:4000/p/viewposts')
if posts_response.status_code == 200:
    posts = posts_response.json()
    st.write(posts)
else:
    st.error(f"Failed to fetch posts: {posts_response.status_code}")