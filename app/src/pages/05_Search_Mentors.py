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

filter_type = st.selectbox(
    "Filter By",
    options=["Interest", "Skill", "Career Goal", "Career Path"]
)

if filter_type == "Interest":
    filter_value = st.selectbox(
        "Select Interest",
        options=["Machine Learning", "Renewable Energy", "Data Analysis", 
                "Genetics", "Stock Trading"]
    )
elif filter_type == "Skill":
    filter_value = st.selectbox(
        "Select Skill",
        options=["Python Programming", "CAD Design", "Data Visualization",
                "Lab Techniques", "Financial Modeling"]
    )
elif filter_type == "Career Goal":
    filter_value = st.selectbox(
        "Select Career Goal",
        options=["Develop AI tools for healthcare", "Create sustainable engineering solutions",
                "Become a Data Scientist", "Research genetic disorders",
                "Build a career in Investment Banking"]
    )
elif filter_type == "Career Path":
    filter_value = st.selectbox(
        "Select Career Path",
        options=["AI Specialist", "Genetic Researcher", "Career Coach"]
    )

if st.button("Get Users"):
    try:
        # Base parameters
        params = {"usertype": user_type}
        
        # Add filter parameter if filter value exists
        if filter_value:
            filter_param = filter_type.lower().replace(" ", "_")
            params[filter_param] = filter_value

        # Send request to API
        response = requests.get(BACKEND_URL, params=params)

        if response.status_code == 200:
            data = response.json()
            df = pd.DataFrame(data)

            st.subheader(f"Users of type: {user_type}")
            if filter_value:
                st.caption(f"Filtered by {filter_type}: {filter_value}")
            
            # Configure the dataframe display
            st.dataframe(
                df,
                hide_index=True,
                column_config={
                    "UserID": "User ID",
                    "fname": "First Name",
                    "lname": "Last Name",
                    "joinDate": "Join Date"
                }
            )
        else:
            st.error(f"Failed to fetch data: {response.status_code} - {response.text}")

    except Exception as e:
        st.error(f"An error occurred: {e}")