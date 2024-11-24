import logging
logger = logging.getLogger(__name__)
import streamlit as st
import pandas as pd
from sklearn import datasets
from sklearn.ensemble import RandomForestClassifier
from streamlit_extras.app_logo import add_logo
from modules.nav import SideBarLinks
import requests
import matplotlib.pyplot as plt

SideBarLinks()

# Define the backend API URL for user count
USER_COUNT_URL = "http://web-api:4000/u/user/count"  # Adjust the hostname and port as necessary

# Streamlit App
st.title("User Type Counts")

try:
    # Send a GET request to the Flask API
    response = requests.get(USER_COUNT_URL)

    if response.status_code == 200:
        # Parse the JSON response
        data = response.json()

        # Convert to a Pandas DataFrame
        df = pd.DataFrame(data, columns=["Usertype", "Count"])

        # Display the data as a table
        st.subheader("User Counts by Type")
        st.dataframe(df)

        # Plot the data as a bar chart
        st.subheader("User Counts by Type (Bar Chart)")
        fig, ax = plt.subplots()
        df.plot(kind="bar", x="Usertype", y="Count", legend=False, ax=ax)
        ax.set_xlabel("User Type")
        ax.set_ylabel("Count")
        ax.set_title("User Counts by Type")
        st.pyplot(fig)

    else:
        st.error(f"Failed to fetch data: {response.status_code} - {response.text}")

except Exception as e:
    st.error(f"An error occurred: {e}")