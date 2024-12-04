import logging
logger = logging.getLogger(__name__)
import pandas as pd
import streamlit as st
from streamlit_extras.app_logo import add_logo
import world_bank_data as wb
import matplotlib.pyplot as plt
import numpy as np
import plotly.express as px
from modules.nav import SideBarLinks
import requests

# Call the SideBarLinks from the nav module in the modules directory
SideBarLinks()

# set the header of the page
st.header('Match with a New Mentor or Mentee')

# Add input fields for Mentor ID and Mentee ID
mentor_id = st.text_input("Enter Mentor ID:")
mentee_id = st.text_input("Enter Mentee ID:")

# Add a button to submit the match
if st.button("Create Match"):
    if mentor_id and mentee_id:
        # Here you would call the function to create a new match
        # For example, you might send a request to your backend API
        response = requests.post(f'http://web-api:4000/m/matches/{mentee_id}/{mentor_id}')
        if response.status_code == 200:
            st.success("Match created successfully!")
        else:
            st.error("Failed to create match.")
    else:
        st.warning("Please enter both Mentor ID and Mentee ID.")

