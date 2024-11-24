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

ALUMNI_URL = "http://web-api:4000/u/user/alumni"  # Adjust the hostname and port as necessary

# Streamlit App
st.title("Alumni Viewer")

# Fetch alumni data when the button is clicked
if st.button("Get Alumni"):
    try:
        # Send a GET request to the Flask API
        response = requests.get(ALUMNI_URL)

        if response.status_code == 200:
            # Parse the JSON response
            data = response.json()

            # Convert to a Pandas DataFrame
            df = pd.DataFrame(data)

            # Display the data as a table
            st.subheader("List of Alumni")
            st.dataframe(df)

            # Optional: Add a download button for the data
            csv = df.to_csv(index=False).encode('utf-8')
            st.download_button(
                label="Download Alumni Data as CSV",
                data=csv,
                file_name="alumni_data.csv",
                mime="text/csv",
            )
        else:
            st.error(f"Failed to fetch data: {response.status_code} - {response.text}")

    except Exception as e:
        st.error(f"An error occurred: {e}")