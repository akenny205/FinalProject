import logging
import pandas as pd
import streamlit as st
from modules.nav import SideBarLinks
import requests

    
logger = logging.getLogger(__name__)

if st.session_state['role'] == 'admin':
    st.set_page_config(layout='wide')


    SideBarLinks()

    st.title('Admin Employer Editor (Reference Jobs page use same format)')