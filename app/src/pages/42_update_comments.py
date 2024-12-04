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

    COMMENT_URL = "http://web-api:4000/c/comments"
    POST_URL = "http://web-api:4000/p/posts"

    def delete_comment(comment_id):
        url = f"{COMMENT_URL}/deletecomment/{comment_id}"
        response = requests.delete(url)
        if response.status_code == 200:
            st.success('Comment removed!')
        else:
            st.error('Failed to remove comment.')

    def delete_post(post_id):
        url = f"{POST_URL}/deletepost/{post_id}"
        response = requests.delete(url)
        if response.status_code == 200:
            st.success('Post removed!')
        else:
            st.error('Failed to remove post.')

    # Input to id to delete comment
    comment_id = st.text_input('Enter Comment ID to delete:')
    if st.button('Delete Comment'):
        delete_comment(comment_id)

    # Input to id to delete post
    post_id = st.text_input('Enter Post ID to delete:')
    if st.button('Delete Post'):
        delete_post(post_id)