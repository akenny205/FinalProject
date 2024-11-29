import logging
logger = logging.getLogger(__name__)
import streamlit as st
from modules.nav import SideBarLinks
import requests

st.set_page_config(layout = 'wide')

SideBarLinks()

ADD_USER_URL = "http://web-api:4000/u/user/add"

st.title('Add Students')

st.write('\n\n')
st.write('## Who would you like to add?')

with st.form("add_user_form"):
    st.subheader("Enter New User Details")
    # Basic user details
    fname = st.text_input("First Name")
    lname = st.text_input("Last Name")
    usertype = st.selectbox("User Type", options=["Mentor", "Mentee", "Advisor"])
    email = st.text_input("Email")
    phone = st.text_input("Phone Number")
    major = st.text_input("Major")
    minor = st.text_input("Minor")
    advisor_id = st.number_input("Advisor ID (Optional)", min_value=1, step=1, format="%d")
    admin_id = st.number_input("Admin ID", min_value=1, step=1, format="%d")
    status = st.checkbox("Active Status", value=True)

    # Submit button
    submitted = st.form_submit_button("Add User")

# Handle form submission
if submitted:
    # Prepare the data payload
    user_data = {
        "fname": fname,
        "lname": lname,
        "usertype": usertype,
        "email": email,
        "phone": phone,
        "major": major,
        "minor": minor,
        "advisor_id": int(advisor_id) if advisor_id else None,
        "admin_id": admin_id,
        "status": status
    }

    try:
        # Send a POST request to the Flask API
        response = requests.post(ADD_USER_URL, json=user_data)

        if response.status_code == 201:
            st.success("User added successfully!")
            st.experimental_rerun()
        else:
            st.error(f"Failed to add user: {response.status_code} - {response.text}")

    except Exception as e:
        st.error(f"An error occurred: {e}")