import logging
logger = logging.getLogger(__name__)
import streamlit as st
import pandas as pd
from sklearn import datasets
from sklearn.ensemble import RandomForestClassifier
from streamlit_extras.app_logo import add_logo
from modules.nav import SideBarLinks
import requests


st.sidebar.header("Quick Links")
if st.sidebar.button("Home"):
    st.switch_page('Home.py')
if st.sidebar.button('Back'):
    st.switch_page('/appcode/pages/10_Exp_Student_Home.py')

SideBarLinks()

st.title('Student Experiences Browser')

response = requests.get('http://api:4000/exp/viewexp')
if response.status_code == 200:
    experiences = response.json()
    if experiences:
        st.dataframe(experiences)
    else:
        st.write('No Experiences Found')
else:
    st.write('Failed to Fetch Experiences')