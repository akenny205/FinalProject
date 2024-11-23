import logging
logger = logging.getLogger(__name__)

import streamlit as st
from modules.nav import SideBarLinks
import requests

st.set_page_config(layout = 'wide')

SideBarLinks()

st.title(f"Welcome system administrator, {st.session_state['first_name']}.")
st.write('')
st.write('')
st.write('### Welcome to PeerPoint')

st.markdown("""
    <style>
    .stButton > button {
        background-color: #DC143C; /* Crimson Red */
        color: white;
        border: 2px solid #FF4500; /* Orange Red Border */
        border-radius: 10px;
        font-size: 16px;
        padding: 10px 20px;
        transition: background-color 0.3s ease, border-color 0.3s ease, transform 0.2s ease; /* Smooth transitions */
    }
    .stButton > button:hover {
        background-color: #B11234; /* Darker Crimson Red */
        border: 2px solid #FF6347; /* Lighter Orange-Red Border */
        transform: scale(1.05); /* Slightly enlarge button on hover */
    }
    </style>
    """, unsafe_allow_html=True)

if st.button('View Usage Dashboard', 
             type='primary',
             use_container_width=True):
  st.switch_page('pages/21_ML_Model_Mgmt.py')

if st.button('View Flagged Posts', 
             type='primary',
             use_container_width=True):
  st.switch_page('pages/21_ML_Model_Mgmt.py')

if st.button('Update Flagged Comments', 
             type='primary',
             use_container_width=True):
  st.switch_page('pages/21_ML_Model_Mgmt.py')

if st.button('Update User Details', 
             type='primary',
             use_container_width=True):
  st.switch_page('pages/21_ML_Model_Mgmt.py')

if st.button('Create and Delete Jobs',
             type='primary',
             use_container_width=True):
  st.switch_page('pages/11_Jobs.py')