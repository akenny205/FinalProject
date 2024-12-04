import logging
logger = logging.getLogger(__name__)
import streamlit as st
import pandas as pd
from modules.nav import SideBarLinks
import requests

st.sidebar.header("Quick Links")
if st.sidebar.button("Home"):
    st.switch_page('Home.py')
if st.sidebar.button('Back'):
    st.switch_page('/appcode/pages/20_Advisor_Home.py')

SideBarLinks()

st.title('Post')

response = requests.get('http://api:4000/posts')
if response.status_code == 200:
    posts = response.json()
    if posts:
        st.dataframe(posts)
    else:
        st.write('No Posts Found')
else:
    st.write('Failed to Fetch Posts')