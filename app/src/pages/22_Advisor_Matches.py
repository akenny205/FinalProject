import logging
logger = logging.getLogger(__name__)
import streamlit as st
import pandas as pd
from sklearn import datasets
from sklearn.ensemble import RandomForestClassifier
from streamlit_extras.app_logo import add_logo
from modules.nav import SideBarLinks
import requests

SideBarLinks()
# Set up the Streamlit app
st.title("Advisor Matches Viewer")

# Ask the user for the advisor ID
advisor_id = st.text_input("Enter Advisor ID:")

# Function to fetch matches for the given advisor ID
def fetch_matches(advisor_id):
    if advisor_id:
        # Make a request to your Flask API
        response = requests.get(f"http://web-api:4000/m/matches/students/{advisor_id}")
        if response.status_code == 200:
            return response.json()
        else:
            st.error("Failed to fetch data. Please check the advisor ID and try again.")
            return None
    return None

# Display the matches if an advisor ID is provided
if advisor_id:
    matches = fetch_matches(advisor_id)
    if matches:
        st.write("Matches for Advisor ID:", advisor_id)
        st.json(matches)