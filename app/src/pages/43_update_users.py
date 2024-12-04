import logging
import pandas as pd
import streamlit as st
from modules.nav import SideBarLinks
import requests

    
logger = logging.getLogger(__name__)

def remove_user(user_id):
    url = f"http://web-api:4000/u/user/{user_id}"
    response = requests.delete(url)
    if response.status_code == 200:
        st.success('User removed!')
    else:
        st.error('Failed to remove user.')

if st.session_state['role'] == 'admin':
    st.set_page_config(layout='wide')

    SideBarLinks()

    st.title('Remove Users')

    user_id = st.text_input('Enter User ID to remove:')
    if st.button('Remove User'):
        remove_user(user_id)

    