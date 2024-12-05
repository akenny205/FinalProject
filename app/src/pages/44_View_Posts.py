import logging
logger = logging.getLogger(__name__)
import streamlit as st
import pandas as pd
from modules.nav import SideBarLinks
import requests

st.sidebar.header("Quick Links")
if st.sidebar.button("Home"):
    st.switch_page('Home.py')
if st.sidebar.button('Back'):
    st.switch_page('/appcode/pages/20_Advisor_Home.py')

SideBarLinks()

st.title('Posts')

BACKEND_URL = "http://api:4000/p/viewposts"

# Optional user ID filter input
user_id = st.text_input("Filter by User ID (optional):", placeholder="Leave blank to view all posts")

try:
    # Fetch posts
    response = requests.get(BACKEND_URL)

    if response.status_code == 200:
        data = response.json()

        # Convert to DataFrame
        df = pd.DataFrame(data)

        # Optional filtering if user_id is provided
        if user_id and user_id.strip():
            df = df[df['UserID'] == int(user_id)]

        # Check if any posts remain after filtering
        if df.empty:
            st.warning("No posts found for the specified user.")
            st.stop()

        # Combine names and sort by post date
        df['Name'] = df['fName'] + ' ' + df['lName']
        df['PostDate'] = pd.to_datetime(df['PostDate'])
        df = df.sort_values('PostDate', ascending=False)

        # Display posts
        st.subheader("Posts")
        for _, post in df.iterrows():
            st.markdown(f"""
            **Post ID:** {post['PostID']}
            **User ID:** {post['UserID']}
            **Posted By:** {post['Name']}
            **Date:** {post['PostDate'].strftime('%d %b %Y %H:%M')}
            
            {post['Content']}
            
            ---
            """)
    else:
        st.error(f"Failed to fetch posts: {response.status_code}")
        st.write(response.json())

except Exception as e:
    st.error(f"An error occurred: {str(e)}")