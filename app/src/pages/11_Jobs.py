import logging
import pandas as pd
import streamlit as st
from modules.nav import SideBarLinks
import requests

logger = logging.getLogger(__name__)

st.set_page_config(layout='wide')

# Display the appropriate sidebar links for the role of the logged-in user
def SideBarLinks():
    st.sidebar.header("")
    st.sidebar.button("Home")
    st.sidebar.button("Admin Job Editor")

SideBarLinks()

st.title('Admin Job Editor')

# Create a 2-column layout
col1, col2 = st.columns(2)

# Column 1: Add and delete jobs
with col1:
    # Add Job Form
    st.subheader("Add a New Job")
    title = st.text_input('Input Job Title:')
    empid = st.text_input('Input Employer ID:')
    description = st.text_input('Input Job Description:')
# Add Jobs
    if st.button('Add Job', use_container_width=True):
        if title and empid and description:

            job_data = {
                'Title': title,
                'EmpID': empid,
                'Description': description
            }

            response = requests.post("/jobs", json=job_data) # Error here

            if response.status_code == 200:
                st.success("Job added successfully!")
            else:
                st.error("Failed to add job.")
        else:
            st.warning("Please fill in all fields.")
    st.subheader("Delete a Job")
    JobID = st.text_input('Input Job ID:')
# Delete Jobs
    if st.button('Delete Job', use_container_width=True):
        if JobID:
            response = requests.delete(f"/jobs/{JobID}") # Error here
            if response.status_code == 200:
                st.success("Job deleted successfully!")
            else:
                st.error("Failed to delete job.")
        else:
            st.warning("Please fill in all fields.")

# Displays all jobIDs and Titles
with col2:
    st.subheader("Current Jobs")
    response = requests.get('http://api:4000/j/viewjobs')
    if response.status_code == 200:
        jobs = response.json()
        if jobs:
            st.dataframe(jobs)
        else:
            st.write("No jobs available.")
    else:
        st.error("Failed to fetch jobs.")

'''
# add one number input for variable 1 into column 1
with col1:
  var_01 = st.number_input('Variable 01:',
                           step=1)

# add another number input for variable 2 into column 2
with col2:
  var_02 = st.number_input('Variable 02:',
                           step=1)

logger.info(f'var_01 = {var_01}')
logger.info(f'var_02 = {var_02}')

# add a button to use the values entered into the number field to send to the 
# prediction function via the REST API
if st.button('Calculate Prediction',
             type='primary',
             use_container_width=True):
  results = requests.get(f'http://api:4000/c/prediction/{var_01}/{var_02}').json()
  st.dataframe(results)
'''