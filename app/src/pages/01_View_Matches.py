import logging
logger = logging.getLogger(__name__)
import pandas as pd
import streamlit as st
from streamlit_extras.app_logo import add_logo
import world_bank_data as wb
import matplotlib.pyplot as plt
import numpy as np
import plotly.express as px
from modules.nav import SideBarLinks
import requests

# Call the SideBarLinks from the nav module in the modules directory
SideBarLinks()

# set the header of the page
st.header('Your Matches')

# You can access the session state to make a more customized/personalized app experience
st.write(f"### Hi, {st.session_state['first_name']}! Here are your matches:")

# Function to get matches from the backend
def fetch_matches(user_id):
    try:
        response = requests.get(f'http://web-api:4000/m/matches/{user_id}')
        response.raise_for_status()  # Raise an error for bad responses
        return response.json()
    except requests.exceptions.RequestException as e:
        logger.error(f"Error fetching matches: {e}")
        return []

# Display matches
user_id = st.session_state.get('user_id', None)

if not user_id:
    user_id = st.text_input("Please enter your User ID:")

if user_id:
    matches = fetch_matches(user_id)
    st.write("### Your Matches:")
    for match in matches:
        st.write(f"- Mentor ID: {match['MentorID']}")
else:
    st.write("User ID not found")

st.write(f"### Here are recomendeded your matches:")

user_id = st.text_input("Enter your User ID to see recommended matches:")

# Add a button to fetch recommended matches
if st.button("Get Recommended Matches"):
    if user_id:
        # Make a GET request to the backend to fetch recommended matches
        response = requests.get(f'http://web-api:4000/m/matches/recommended/{user_id}')
        if response.status_code == 200:
            recommended_matches = response.json()
            if recommended_matches:
                st.write("### Recommended Matches:")
                for match in recommended_matches:
                    st.write(f"- Mentor ID: {match['MentorID']}")
            else:
                st.write("No recommended matches found.")
        else:
            st.error("Failed to fetch recommended matches.")
    else:
        st.warning("Please enter your User ID.")