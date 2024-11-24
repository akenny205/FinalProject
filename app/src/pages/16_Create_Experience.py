import logging
logger = logging.getLogger(__name__)
import streamlit as st
import pandas as pd
from sklearn import datasets
from sklearn.ensemble import RandomForestClassifier
from streamlit_extras.app_logo import add_logo
from modules.nav import SideBarLinks

SideBarLinks()
if st.sidebar.button('Back'):
    st.switch_page('/appcode/pages/14_Experiences.py')

st.title('Add an Experience to your Profile!')