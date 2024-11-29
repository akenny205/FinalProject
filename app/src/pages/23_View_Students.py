import logging
logger = logging.getLogger(__name__)
import streamlit as st
import pandas as pd
import requests
from sklearn import datasets
from sklearn.ensemble import RandomForestClassifier
from streamlit_extras.app_logo import add_logo
from modules.nav import SideBarLinks


SideBarLinks()

st.title("User Data Viewer")

BACKEND_URL = "http://web-api:4000/u/user"

# Input for advisor ID
advisor_id = st.text_input("Enter Advisor ID (leave blank to view all):")

# Input validation
if advisor_id and not advisor_id.isdigit():
    st.error("Please enter a valid numeric Advisor ID.")
    st.stop()

# Construct the URL with query parameters
url = BACKEND_URL
if advisor_id:
    url += f"?advisor_id={advisor_id}"

try:
    response = requests.get(url)

    if response.status_code == 200:
        data = response.json()

        # Check if any data was returned
        if not data:
            st.warning("No users found for the specified Advisor ID.")
            st.stop()
            
        # Create DataFrame and handle potential missing keys
        df = pd.DataFrame(data)
        
        # Check if required columns exist before processing
        required_columns = ['fname', 'lname', 'joinDate', 'Usertype', 'UserID', 'status']
        if not all(col in df.columns for col in required_columns):
            st.error("The data structure is not in the expected format.")
            st.stop()
            
        # Combine first and last names into a single column
        df['Name'] = df['fname'] + ' ' + df['lname']
        
        # Drop the original first and last name columns
        df = df.drop(columns=['fname', 'lname'])
        
        # Rename columns to be more readable
        df = df.rename(columns={
            'UserID': 'User ID',
            'Usertype': 'Role',
            'joinDate': 'Join Date',
            'status': 'Status'
        })
        
        # Convert joinDate to a more readable format
        df['Join Date'] = pd.to_datetime(df['Join Date']).dt.strftime('%d %b %Y')
        
        # Configure the display
        st.subheader("User Table")
        st.dataframe(
            df,
            column_config={
                "User ID": st.column_config.NumberColumn(
                    "User ID",
                    help="Unique identifier for each user",
                    format="%d"
                ),
                "Role": st.column_config.TextColumn(
                    "Role",
                    help="User's role in the system"
                ),
                "Name": st.column_config.TextColumn(
                    "Name",
                    help="Full name of the user"
                ),
                "Join Date": st.column_config.DateColumn(
                    "Join Date",
                    help="Date when user joined"
                ),
                "Status": st.column_config.NumberColumn(
                    "Status",
                    help="Current status of the user"
                )
            },
            hide_index=True,
            width=1000
        )
        
        # Add download button
        csv = df.to_csv(index=False).encode('utf-8')
        st.download_button(
            label="Download User Data as CSV",
            data=csv,
            file_name="user_data.csv",
            mime="text/csv",
        )
    else:
        st.error(f"Failed to fetch data: {response.status_code} - {response.text}")

except Exception as e:
    st.error(f"An error occurred while fetching data: {str(e)}")

st.subheader("Update User Status")

# Input for User ID
user_id = st.text_input("Enter User ID to update status:")

# Select new status
new_status = st.selectbox("Select New Status", options=["True", "False"]) 

# Button to submit the update
if st.button("Update Status"):
    if user_id:
        try:
            # Prepare the payload for the PATCH request
            payload = {"status": new_status == "True"} 
            
            # Send PATCH request to update user status
            response = requests.patch(f"{BACKEND_URL}/{user_id}/status", json=payload)

            if response.status_code == 200:
                st.success("User status updated successfully!")
            else:
                st.error(f"Failed to update status: {response.status_code} - {response.text}")
        except Exception as e:
            st.error(f"An error occurred: {str(e)}")
    else:
        st.error("Please enter a valid User ID.")

# Add a section to update user reviews
st.subheader("Update User Reviews")

# Input for User ID
user_id = st.text_input("Enter User ID to update reviews:")

# Input for new reviews
new_reviews = st.text_area("Enter New Reviews", height=150)  # Text area for reviews

# Button to submit the update
if st.button("Update Reviews"):
    if user_id and new_reviews:
        try:
            # Prepare the payload for the PATCH request
            payload = {"reviews": new_reviews}  # Prepare the reviews payload
            
            # Send PATCH request to update user reviews
            response = requests.patch(f"{BACKEND_URL}/{user_id}/reviews", json=payload)

            if response.status_code == 200:
                st.success("User reviews updated successfully!")
            else:
                st.error(f"Failed to update reviews: {response.status_code} - {response.text}")
        except Exception as e:
            st.error(f"An error occurred: {str(e)}")
    else:
        st.error("Please enter a valid User ID and reviews.")

# Add a section to remove a user
st.subheader("Remove User")

# Input for User ID
user_id_to_delete = st.text_input("Enter User ID to remove:")

# Button to submit the delete request
if st.button("Remove User"):
    if user_id_to_delete:
        try:
            # Send DELETE request to remove the user
            response = requests.delete(f"{BACKEND_URL}/{user_id_to_delete}")

            if response.status_code == 200:
                st.success("User removed successfully!")
            else:
                st.error(f"Failed to remove user: {response.status_code} - {response.text}")
        except Exception as e:
            st.error(f"An error occurred: {str(e)}")
    else:
        st.error("Please enter a valid User ID.")

