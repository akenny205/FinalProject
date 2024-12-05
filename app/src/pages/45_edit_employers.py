import logging
import pandas as pd
import streamlit as st
from modules.nav import SideBarLinks
import requests

if st.session_state['role'] == 'admin':
    st.set_page_config(layout='wide')
    SideBarLinks()

    st.title('Admin Employer Editor')
    
    # Add Employer Form
    st.subheader("Add an Employer")
    admin = st.text_input('Input Admin ID:')
    name = st.text_input('Input Employer Name:')
    description = st.text_input('Input Employer Description:')

    # Add Employer
    if st.button('Add Employer', use_container_width=True):
        if admin and name and description:
            try:
                employer_data = {
                    'Name': name,
                    'Description': description,
                    'Admin': admin
                }
                response = requests.post(
                    "http://api:4000/emp/employers",
                    json=employer_data
                )
                if response.status_code in [200, 201]:
                    st.success("Employer added successfully!")
                else:
                    st.error(f"Failed to add employer: {response.text}")
            except requests.exceptions.RequestException as e:
                st.error(f"Connection error: {str(e)}")
        else:
            st.warning("Please fill in all fields.")

    # Delete Employer
    st.subheader("Delete an Employer")
    employer_id = st.text_input('Input Employer ID:')

    if st.button('Delete Employer', use_container_width=True):
        if employer_id:
            try:
                response = requests.delete(f"http://api:4000/emp/employers/{employer_id}")
                if response.status_code == 200:
                    st.success("Employer deleted successfully!")
                else:
                    st.error(f"Failed to delete employer: {response.text}")
            except requests.exceptions.RequestException as e:
                st.error(f"Connection error: {str(e)}")
        else:
            st.warning("Please enter an Employer ID.")

    # Display Current Employers
    st.subheader("Current Employers")
    try:
        response = requests.get('http://api:4000/emp/employers')
        if response.status_code == 200:
            employers = response.json()
            if employers:
                st.dataframe(employers)
            else:
                st.write("No employers available.")
        else:
            st.error("Failed to fetch employers")
    except requests.exceptions.RequestException as e:
        st.error(f"Connection error: {str(e)}")

else:
    if st.session_state['role'] == 'coop_career_advisor':
        page = 'pages/20_Advisor_Home.py'
    elif st.session_state['role'] == 'peer_mentor':
        page = 'pages/10_Exp_Student_Home.py'
    elif st.session_state['role'] == 'inexperienced_student':
        page = 'pages/00_Inexp_Student_Home.py'
    st.switch_page(page)