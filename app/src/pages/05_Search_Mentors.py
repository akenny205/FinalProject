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

BACKEND_URL = "http://web-api:4000/u/user/type" 

st.title("Users by Type Viewer")

user_type = st.selectbox("Select User Type", options=["mentor", "mentee"])

if st.button("Get Users"):
    try:
        # Send a GET request to the Flask API with the selected user type
        params = {"usertype": user_type}
        response = requests.get(BACKEND_URL, params=params)

        if response.status_code == 200:
            
            data = response.json()
            df = pd.DataFrame(data)

            st.subheader(f"Users of type: {user_type}")
            st.dataframe(df)

            csv = df.to_csv(index=False).encode('utf-8')
            st.download_button(
                label="Download Data as CSV",
                data=csv,
                file_name=f"{user_type}_users.csv",
                mime="text/csv",
            )
        else:
            st.error(f"Failed to fetch data: {response.status_code} - {response.text}")

    except Exception as e:
        st.error(f"An error occurred: {e}")