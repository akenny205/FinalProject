import logging
logger = logging.getLogger(__name__)
import streamlit as st
import pandas as pd
from sklearn import datasets
from sklearn.ensemble import RandomForestClassifier
from streamlit_extras.app_logo import add_logo
from modules.nav import SideBarLinks


st.title('Student Experiences Home')

SideBarLinks()

# View Experience

if st.button("View Students' Experiences",
             type='primary', use_container_width=True):
    st.switch_page('/appcode/pages/15_View_Experiences.py')

# Create Experience
if st.button("Create Experience",
             type='primary', use_container_width=True):
    st.switch_page('/appcode/pages/16_Create_Experience.py')