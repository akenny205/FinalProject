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
    join_date = st.date_input("Join Date")
    reviews = st.text_area("Reviews (Optional)")

    # Related user references and additional details
    mentor_id = st.number_input("Mentor ID (Optional)", min_value=1, step=1, format="%d")
    mentee_id = st.number_input("Mentee ID (Optional)", min_value=1, step=1, format="%d")
    advisor_id = st.number_input("Advisor ID (Optional)", min_value=1, step=1, format="%d")
    emp_id = st.number_input("Employee ID (Optional)", min_value=1, step=1, format="%d")
    admin_id = st.number_input("Admin ID", min_value=1, step=1, format="%d")
    
    # Additional user attributes
    semesters = st.number_input("Semesters (Optional)", min_value=0, step=1, format="%d")
    num_coops = st.number_input("Number of Co-ops (Optional)", min_value=0, step=1, format="%d")
    match_status = st.checkbox("Match Status", value=False)
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
        "join_date": join_date.strftime('%Y-%m-%d'),
        "reviews": reviews if reviews else None,
        "mentor_id": int(mentor_id) if mentor_id else None,
        "mentee_id": int(mentee_id) if mentee_id else None,
        "advisor_id": int(advisor_id) if advisor_id else None,
        "emp_id": int(emp_id) if emp_id else None,
        "admin_id": admin_id,
        "semesters": int(semesters) if semesters else None,
        "num_coops": int(num_coops) if num_coops else None,
        "match_status": match_status,
        "status": status
    }

    try:
        # Send a POST request to the Flask API
        response = requests.post(ADD_USER_URL, json=user_data)

        if response.status_code == 201:
            st.success("User added successfully!")
        else:
            st.error(f"Failed to add user: {response.status_code} - {response.text}")

    except Exception as e:
        st.error(f"An error occurred: {e}")