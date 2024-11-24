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

st.title("User Data Viewer")

BACKEND_URL = "http://web-api:4000/u/user"

# Fetch Data from the Flask API
try:
    response = requests.get(BACKEND_URL)

    if response.status_code == 200:
        # Parse the JSON data
        data = response.json()

        st.subheader("User Table")
        st.dataframe(response)

        # Optionally, include download functionality
        csv = response.to_csv(index=False).encode('utf-8')
        st.download_button(
            label="Download User Data as CSV",
            data=csv,
            file_name="user_data.csv",
            mime="text/csv",
        )
    else:
        st.error(f"Failed to fetch data: {response.status_code} - {response.text}")

except Exception as e:
    st.error(f"An error occurred while fetching data: {e}")