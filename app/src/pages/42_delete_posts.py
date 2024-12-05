import logging
import pandas as pd
import streamlit as st
from modules.nav import SideBarLinks
import requests

    
logger = logging.getLogger(__name__)

if st.session_state['role'] == 'admin':
    st.set_page_config(layout='wide')


    SideBarLinks()

    st.title('Admin Feed Editor')

    POST_URL = "http://web-api:4000/p"

    def delete_post(post_id):
        url = f"{POST_URL}/deletepost/{post_id}"
        response = requests.delete(url)
        if response.status_code == 200:
            st.success('Post removed!')
        else:
            st.error('Failed to remove post.')

    # Input to id to delete post
    post_id = st.text_input('Enter Post ID to delete:')
    if st.button('Delete Post'):
        delete_post(post_id)

    # Fetch and display posts
    def fetch_posts():
        url = f"{POST_URL}/viewposts"
        response = requests.get(url)
        if response.status_code == 200:
            posts_data = response.json()
            df = pd.DataFrame(posts_data, columns=['UserID', 'PostID', 'Content', 'PostDate'])
            st.dataframe(df)
        else:
            st.error('Failed to fetch posts.')

    fetch_posts()

    