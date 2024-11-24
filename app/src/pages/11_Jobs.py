import logging
import streamlit as st
from modules.nav import SideBarLinks
import requests

logger = logging.getLogger(__name__)

st.set_page_config(layout='wide')

# Display the appropriate sidebar links for the role of the logged-in user
def SideBarLinks():
    st.sidebar.header("Menu")
    st.sidebar.button("Home")
    st.sidebar.button("Admin Job Editor")

SideBarLinks()

st.title('Admin Job Editor')

# Create a 2-column layout
col1, col2 = st.columns(2)

# Column 1: Add and delete jobs
with col1:
    if st.button('Add Job', type="primary", use_container_width=True):
        result = 1 # fill with routes
    if st.button('Delete Job', type="primary", use_container_width=True):
        result = 2 # fill with routes

# Displays all jobIDs and Titles
with col2:
    st.write("Insert Job Table (Title, JobID).")
