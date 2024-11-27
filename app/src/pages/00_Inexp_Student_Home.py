import logging
logger = logging.getLogger(__name__)

import streamlit as st
from modules.nav import SideBarLinks

st.set_page_config(layout = 'wide')

# Show appropriate sidebar links for the role of the currently logged in user
SideBarLinks()

st.title(f"Peer mentee, {st.session_state['first_name']}")
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

if st.button('View Matches', 
            type='primary',
            use_container_width=True):
  st.switch_page('pages/01_View_Matches.py')

if st.button('View Feed', 
             type='primary',
             use_container_width=True):
  st.switch_page('pages/02_View_Feed.py')

if st.button('Chat With Mentors', 
             type='primary',
             use_container_width=True):
  st.switch_page('pages/03_Chat_Mentors.py')

if st.button('Chat With Your Advisor', 
             type='primary',
             use_container_width=True):
  st.switch_page('pages/04_Chat_Advisor.py')

if st.button('Search for Mentors', 
             type='primary',
             use_container_width=True):
  st.switch_page('pages/05_Search_Mentors.py')

if st.button('Update Profile', 
             type='primary',
             use_container_width=False):
  st.switch_page('pages/06_Update_Profile.py')