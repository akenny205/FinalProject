import logging
import pandas as pd
import streamlit as st
from modules.nav import SideBarLinks
import requests


logger = logging.getLogger(__name__)

if st.session_state['role'] == 'admin':
    st.set_page_config(layout='wide')
  
    SideBarLinks()

    st.title('Admin Job Editor')
    # Add Job Form
    st.subheader("Add a Employer")
    admin = st.text_input('Input Admin')
    name = st.text_input('Input Employer Name:')
    description = st.text_input('Input Employer Description:')
# Add Jobs
    if st.button('Add Employer', use_container_width=True):
        if admin and name and description:
            job_data = {
                'Admin': admin,
                'Name': name,
                'Description': description
            }
            response = requests.post(f"http://api:4000/emp/employers/{name}/{description}/{admin}", json=job_data)

            if response.status_code == 200:
                st.success("Employer added successfully!")
            else:
                st.error("Failed to add job.")
        else:
            st.warning("Please fill in all fields.")
    st.subheader("Delete an Employer")
    JobID = st.text_input('Input Job ID:')

    # Delete Jobs
    if st.button('Delete Employer', use_container_width=True):
        if JobID:
            response = requests.delete(f"http://api:4000/emp/deleteEmployee/{JobID}")
            if response.status_code == 200:
                st.success("Job deleted successfully!")
            else:
                st.error("Failed to delete job.")
        else:
            st.warning("Please fill in all fields.")

else:
    # Init Back Button:
    if st.session_state['role'] == 'coop_career_advisor':
        page = 'pages/20_Advisor_Home.py'
    elif st.session_state['role'] == 'peer_mentor':
        page = 'pages/10_Exp_Student_Home.py'
    elif st.session_state['role'] == 'inexperienced_student':
        page = 'pages/00_Inexp_Student_Home.py'
    
    st.set_page_config(layout='wide')

    SideBarLinks()