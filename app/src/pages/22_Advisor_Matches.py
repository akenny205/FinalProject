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
            return response
        else:
            st.error(f"Failed to fetch data. Status code: {response.status_code}. Response: {response.text}")
            return None
    return None

# Display the matches if an advisor ID is provided
if advisor_id:
    matches = fetch_matches(advisor_id)
    if matches:
        st.write("Matches for Advisor ID:", advisor_id)
        try:
            matches_json = matches.json()
            column_order = ['MenteeID', 'MenteeFirstName', 'MenteeLastName', 'MentorID', 'MentorFirstName', 'MentorLastName', 'Recommended', 'Start', 'Status']
            df = pd.DataFrame(matches_json)[column_order]
            st.dataframe(df, 
                         use_container_width=True,
                         hide_index=True,
                         column_config={
                             'MenteeID': st.column_config.TextColumn("Mentee ID"),
                             'MenteeFirstName': st.column_config.TextColumn("Mentee First Name"),
                             'MenteeLastName': st.column_config.TextColumn("Mentee Last Name"),
                             'MentorID': st.column_config.TextColumn("Mentor ID"),
                             'MentorFirstName': st.column_config.TextColumn("Mentor First Name"),
                             'MentorLastName': st.column_config.TextColumn("Mentor Last Name"),
                             'Recommended': st.column_config.TextColumn("Recommended"),
                             'Start': st.column_config.TextColumn("Start Date"),
                             'End': st.column_config.TextColumn("End Date"),
                             'Status': st.column_config.TextColumn("Status")    
                         })
        except ValueError as e:
            st.error(f"Failed to parse JSON: {e}")