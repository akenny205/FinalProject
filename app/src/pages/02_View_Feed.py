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

# Post Feed Initialization

def post_format(post):
    return f"{post['FirstName']} {post['LastName']} - {post['PostDate']}\n{post['Content']}"

posts_response = requests.get('http://web-api:4000/p/viewposts')
if posts_response.status_code == 200:
    posts = posts_response.json()
    st.write(posts)
else:
    st.error(f"Failed to fetch posts: {posts_response.status_code}")

# Add a plus button in the corner that opens a popup dialog
with st.container():
    col1, col2 = st.columns([0.9, 0.1])
    with col2:
        if st.button("➕", help="Create new post"):
            # Create a form popup using st.form
            with st.form(key="new_post_form", clear_on_submit=True):
                st.subheader("Create New Post")
                post_content = st.text_area("What's on your mind?", height=100)
                submit_button = st.form_submit_button("Post")
                
                if submit_button and post_content:
                    # Prepare the post data
                    post_data = {
                        "user_id": st.session_state.get('user_id'),
                        "content": post_content,
                        "post_date": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
                        "admin_id": None
                    }
                    
                    # Send POST request to create new post
                    try:
                        response = requests.post(
                            'http://web-api:4000/p/createpost',
                            json=post_data
                        )
                        if response.status_code == 201:
                            st.success("Post created successfully!")
                            st.experimental_rerun()  # Refresh the page to show new post
                        else:
                            st.error("Failed to create post")
                    except Exception as e:
                        st.error(f"Error creating post: {str(e)}")


