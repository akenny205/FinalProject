import logging
logger = logging.getLogger(__name__)
import streamlit as st
from modules.nav import SideBarLinks
import requests

SideBarLinks()


st.title("Mentee and Mentor Chat Dashboard")
userID = st.text_input("Your User ID")
if userID:
  all_matches = requests.get(f'http://web-api:4000/m/matches/{userID}')
  st.write(all_matches.json())

  st.selectbox("Select who you want to chat with", ["all", "me"])