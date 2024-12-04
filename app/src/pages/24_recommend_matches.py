import logging
logger = logging.getLogger(__name__)
import streamlit as st
import pandas as pd
import requests
from sklearn import datasets
from sklearn.ensemble import RandomForestClassifier
from streamlit_extras.app_logo import add_logo
from modules.nav import SideBarLinks


SideBarLinks()

st.title("Recommend Matches")

BACKEND_URL = "http://web-api:4000/m/matches/recommended"

# Add a form to input user IDs
st.subheader("Recommend a Match")
user_id = st.text_input("Enter User ID")
match_user_id = st.text_input("Enter Match User ID")

if st.button("Recommend Match"):
    if user_id and match_user_id:
        # Make a POST request to the backend
        response = requests.post(f"{BACKEND_URL}/{user_id}/{match_user_id}")
        
        if response.status_code == 200:
            st.success("Match recommended successfully!")
        else:
            st.error("Failed to recommend match. Please try again.")
    else:
        st.warning("Please enter both User ID and Match User ID.")

