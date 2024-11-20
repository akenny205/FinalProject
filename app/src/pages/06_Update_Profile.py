import logging
logger = logging.getLogger(__name__)
import streamlit as st
import pandas as pd
from sklearn import datasets
from sklearn.ensemble import RandomForestClassifier
from streamlit_extras.app_logo import add_logo
from modules.nav import SideBarLinks

SideBarLinks()

# import mysql.connector

# Function to update student profile in the database
# def update_student_profile(user_id, last_name, first_name, email, phone, major, minor, semesters, mentor_cap, num_coops):
#    try:
    #     # Connect to the database
    #     connection = mysql.connector.connect(
    #         host="localhost",    # Update with your database host
    #         user="root",         # Update with your database username
    #         password="password", # Update with your database password
    #         database="finalproject"
    #     )
    #     cursor = connection.cursor()
        
    #     # Update query
    #     update_query = """
    #     UPDATE users
    #     SET lName = %s, fName = %s, Email = %s, Phone = %s, Major = %s, Minor = %s,
    #         Semesters = %s, mentorCap = %s, numCoops = %s
    #     WHERE UserID = %s
    #     """
    #     cursor.execute(update_query, (last_name, first_name, email, phone, major, minor, semesters, mentor_cap, num_coops, user_id))
    #     connection.commit()
        
    #     st.success("Profile updated successfully!")
    # except mysql.connector.Error as err:
    #     st.error(f"Error: {err}")
    # finally:
    #     if connection.is_connected():
    #         cursor.close()
    #         connection.close()

# Streamlit form
st.title("Update Your Profile")

# Prompt the user for their UserID
# user_id = st.number_input("Enter Your User ID", min_value=1, step=1)

# if user_id:
    # try:
        # # Connect to the database to retrieve existing profile details
        # connection = mysql.connector.connect(
        #     host="localhost",    # Update with your database host
        #     user="root",         # Update with your database username
        #     password="password", # Update with your database password
        #     database="finalproject"
        # )
        # cursor = connection.cursor(dictionary=True)
        
        # # Query to fetch user details
        # select_query = "SELECT * FROM users WHERE UserID = %s"
        # cursor.execute(select_query, (user_id,))
        # user = cursor.fetchone()
        
        # if user:
with st.form("update_profile_form"):
    # Populate the form with existing data
    # last_name = st.text_input("Last Name", value=user["lName"])
    # first_name = st.text_input("First Name", value=user["fName"])
    # email = st.text_input("Email", value=user["Email"])
    # phone = st.text_input("Phone", value=user["Phone"] or "")
    # major = st.text_input("Major", value=user["Major"] or "")
    # minor = st.text_input("Minor", value=user["Minor"] or "")
    # semesters = st.number_input("Semesters", min_value=0, step=1, value=user["Semesters"] or 0)
    # mentor_cap = st.number_input("Mentor Capacity", min_value=0, step=1, value=user["mentorCap"] or 0)
    # num_coops = st.number_input("Number of Co-ops", min_value=0, step=1, value=user["numCoops"] or 0)
    last_name = st.text_input("Last Name")
    first_name = st.text_input("First Name")
    email = st.text_input("Email")
    phone = st.text_input("Phone")
    major = st.text_input("Major")
    minor = st.text_input("Minor")
    semesters = st.number_input("Semesters", min_value=0, step=1)
    mentor_cap = st.number_input("Mentor Capacity", min_value=0, step=1)
    num_coops = st.number_input("Number of Co-ops", min_value=0, step=1)

    submit_button = st.form_submit_button("Update Profile")
    
    if submit_button:
        # Validate input
        if not last_name or not first_name or not email:
            st.error("Please fill in all required fields.")
        else:
            # update_student_profile(user_id, last_name, first_name, email, phone, major, minor, semesters, mentor_cap, num_coops)
            st.write('## Thanks for Updating Your Profile')
        # else:
            # st.warning("No user found with the given User ID.")
    # except mysql.connector.Error as err:
    #     st.error(f"Error: {err}")
    # finally:
    #     if connection.is_connected():
    #         cursor.close()
    #         connection.close()
