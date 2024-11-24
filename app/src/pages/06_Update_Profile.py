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

UPDATE_USER_URL = "http://web-api:4000/u/user"  # Adjust the hostname and port as necessary

# Streamlit App
st.title("Update User Profile")

# Input UserID
user_id = st.text_input("Enter UserID to Update", help="Provide the ID of the user whose profile you want to update")

# Create a form to input all user details
with st.form("update_user_form"):
    st.subheader("Enter Updated User Details")
    # Basic user details
    fname = st.text_input("First Name")
    lname = st.text_input("Last Name")
    usertype = st.selectbox("User Type", options=["Mentor", "Mentee", "Advisor"])
    email = st.text_input("Email")
    phone = st.text_input("Phone Number")
    major = st.text_input("Major")
    minor = st.text_input("Minor")
    
    # Additional user attributes
    semesters = st.number_input("Semesters (Optional)", min_value=0, step=1, format="%d")
    num_coops = st.number_input("Number of Co-ops (Optional)", min_value=0, step=1, format="%d")

    # Submit button
    submitted = st.form_submit_button("Update User")

# Handle form submission
if submitted:
    if not user_id:
        st.error("UserID is required to update the profile.")
    else:
        # Prepare the data payload
        user_data = {
            "fname": fname,
            "lname": lname,
            "usertype": usertype,
            "email": email,
            "phone": phone,
            "major": major,
            "minor": minor,
            "semesters": int(semesters) if semesters else None,
            "num_coops": int(num_coops) if num_coops else None,
        }

        try:
            # Send a PUT request to the Flask API
            response = requests.put(f"{UPDATE_USER_URL}/{user_id}", json=user_data)

            if response.status_code == 200:
                st.success("User profile updated successfully!")
            else:
                st.error(f"Failed to update user: {response.status_code} - {response.text}")

        except Exception as e:
            st.error(f"An error occurred: {e}")