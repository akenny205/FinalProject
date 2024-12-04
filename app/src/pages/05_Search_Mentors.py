import logging
logger = logging.getLogger(__name__)
import streamlit as st
import pandas as pd
from streamlit_extras.app_logo import add_logo
from modules.nav import SideBarLinks
import requests

SideBarLinks()

BACKEND_URL = "http://web-api:4000/u/user/type" 

st.title("Users by Type Viewer")

user_type = st.selectbox("Select User Type", options=["mentor", "mentee"])

filter_value = None

filter_type = st.selectbox(
    "Filter By",
    options=["Interest", "Skill", "Career Goal", "Career Path", "Status"]
)

if filter_type == "Interest":
    filter_value = st.selectbox(
        "Select Interest",
        options=["machine learning", "artificial intelligence", "entrepreneurship", "software development",
                "blockchain technology", "statistical analysis", "digital marketing", 
                "data visualization", "cybersecurity", "public health", "creative writing", 
                "political theory", "graphic design", "classical music", "robotics", 
                "social justice", "literature analysis", "biomechanics", "renewable energy", "music production"]
    )
elif filter_type == "Skill":
    filter_value = st.selectbox(
        "Select Skill",
        options=["data analysis", 
                "programming", 
                "problem-solving", 
                "critical thinking", 
                "communication", 
                "teamwork", 
                "leadership", 
                "time management", 
                "project management", 
                "research", 
                "writing", 
                "creativity", 
                "public speaking", 
                "adaptability", 
                "coding", 
                "statistical modeling", 
                "graphic design", 
                "technical writing", 
                "networking", 
                "conflict resolution"]
    )

elif filter_type == "Career Goal":
    filter_value = st.selectbox(
        "Select Career Goal",
        options=["become a data scientist", 
                "develop innovative software", 
                "start a successful business", 
                "lead a research project", 
                "design sustainable technology", 
                "improve public health outcomes", 
                "publish a novel", 
                "work as a political strategist", 
                "create impactful art", 
                "compose music for films", 
                "manage a high-performing team", 
                "build a personal brand", 
                "become a university professor", 
                "solve real-world problems through AI", 
                "advocate for policy change", 
                "revolutionize user experiences", 
                "mentor future professionals", 
                "establish a health startup", 
                "conduct groundbreaking research", 
                "achieve financial independence"]
    )
elif filter_type == "Career Path":
    filter_value = st.selectbox(
        "Select Career Path",
        options=["data scientist", 
                "software engineer", 
                "business analyst", 
                "financial analyst", 
                "project manager", 
                "mechanical engineer", 
                "electrical engineer", 
                "marketing specialist", 
                "public health consultant", 
                "writer", 
                "editor", 
                "political consultant", 
                "ux designer", 
                "musician", 
                "music producer", 
                "biomedical engineer", 
                "research scientist", 
                "teacher", 
                "policy analyst", 
                "graphic designer"]
    )

elif filter_type == "Status":
    filter_value = st.selectbox(
        "Select Student Status",
        options=["TRUE", "FALSE"]
    )

if st.button("Get Users"):
    try:
        # Base parameters
        params = {"usertype": user_type}
        
        # Add filter parameter if filter value exists
        if filter_value:
            filter_param = filter_type.lower().replace(" ", "_")
            params[filter_param] = filter_value

        # Send request to API
        response = requests.get(BACKEND_URL, params=params)

        if response.status_code == 200:
            data = response.json()
            df = pd.DataFrame(data)

            st.subheader(f"Users of type: {user_type}")
            if filter_value:
                st.caption(f"Filtered by {filter_type}: {filter_value}")
            
            # Configure the dataframe display
            st.dataframe(
                df,
                hide_index=True,
                column_config={
                    "UserID": "User ID",
                    "fname": "First Name",
                    "lname": "Last Name",
                    "joinDate": "Join Date"
                }
            )
        else:
            st.error(f"Failed to fetch data: {response.status_code} - {response.text}")

    except Exception as e:
        st.error(f"An error occurred: {e}")
        