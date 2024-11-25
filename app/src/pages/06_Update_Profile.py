import logging
logger = logging.getLogger(__name__)
import streamlit as st
import pandas as pd
from sklearn import datasets
from sklearn.ensemble import RandomForestClassifier
from streamlit_extras.app_logo import add_logo
from modules.nav import SideBarLinks
import requests
import time

SideBarLinks()

UPDATE_USER_URL = "http://web-api:4000/u/user"  # Adjust the hostname and port as necessary

# Test API connection
try:
    test_response = requests.get(f"{UPDATE_USER_URL}/1")
    st.write("Debug: API Test Response:", test_response.status_code)
except Exception as e:
    st.write("Debug: API Test Error:", str(e))

# Streamlit App
st.title("Update User Profile")

# Input UserID
user_id = st.text_input("Enter UserID to Update", help="Provide the ID of the user whose profile you want to update")

# Add this near the top of your file after the imports
st.write("Debug: Testing form submission")
with st.form("test_form"):
    test_input = st.text_input("Test Input")
    test_submit = st.form_submit_button("Test Submit")
    
if test_submit:
    st.write("Debug: Test form submitted with value:", test_input)

# Create a form to input all user details
# First fetch and display current user data
if user_id:
    try:
        # Get current user profile
        response = requests.get(f"{UPDATE_USER_URL}/{user_id}")
        
        if response.status_code == 200:
            user_data = response.json()
            
            # Display current profile
            st.subheader("Current Profile")
            col1, col2 = st.columns(2)
            with col1:
                st.write("**Name:**", f"{user_data['fname']} {user_data['lname']}")
                st.write("**User Type:**", user_data['usertype'])
                st.write("**Email:**", user_data['email'])
                st.write("**Phone:**", user_data['phone'])
            with col2:
                st.write("**Major:**", user_data['major'])
                st.write("**Minor:**", user_data['minor'])
                st.write("**Semesters:**", user_data['semesters'])
                st.write("**Number of Co-ops:**", user_data['num_coops'])

            # Display multi-value attributes
            st.subheader("Skills")
            st.write(", ".join(user_data['skills']) if user_data['skills'] else "No skills listed")
            
            st.subheader("Interests") 
            st.write(", ".join(user_data['interests']) if user_data['interests'] else "No interests listed")
            
            st.subheader("Career Goals")
            st.write(", ".join(user_data['career_goals']) if user_data['career_goals'] else "No career goals listed")
            
            st.subheader("Career Path")
            st.write(", ".join(user_data['career_path']) if user_data['career_path'] else "No career path listed")
            
            st.subheader("Experiences")
            if user_data['experiences']:
                for exp in user_data['experiences']:
                    st.write(f"**{exp['ExperienceName']}**")
                    st.write(f"Date: {exp['Date']}")
                    st.write(f"Location: {exp['Location']}")
                    st.write(f"Description: {exp['Description']}")
                    st.write("---")
            else:
                st.write("No experiences listed")

            # Remove the edit button wrapper and show form directly
            st.write("Debug: Starting update form section")  # Debug line

            # Create form
            with st.form("update_profile_form", clear_on_submit=False):
                st.subheader("Update Profile")
                
                # Basic info
                fname = st.text_input("First Name", value=user_data['fname'])
                lname = st.text_input("Last Name", value=user_data['lname'])
                usertype = st.selectbox("User Type", 
                                      options=["Mentor", "Mentee", "Advisor"],
                                      index=["Mentor", "Mentee", "Advisor"].index(user_data['usertype']))
                email = st.text_input("Email", value=user_data['email'])
                phone = st.text_input("Phone Number", value=user_data['phone'])
                major = st.text_input("Major", value=user_data['major'])
                minor = st.text_input("Minor", value=user_data['minor'])
                semesters = st.number_input("Semesters", 
                                          value=user_data['semesters'] if user_data['semesters'] else 0,
                                          min_value=0, step=1)
                num_coops = st.number_input("Number of Co-ops",
                                          value=user_data['num_coops'] if user_data['num_coops'] else 0, 
                                          min_value=0, step=1)

                # Multi-value attributes
                skills = st.text_area("Skills (one per line)", 
                                      value="\n".join(user_data['skills']) if user_data['skills'] else "")
                
                interests = st.text_area("Interests (one per line)",
                                       value="\n".join(user_data['interests']) if user_data['interests'] else "")
                
                # Submit button inside form
                submitted = st.form_submit_button("Update Profile")
                st.write("Debug: Form submit button state:", submitted)  # Debug line

            # Process form submission outside the form
            if submitted:
                st.write("Debug: Form was submitted")  # Debug line
                
                # Prepare update data
                update_data = {
                    "fname": fname,
                    "lname": lname,
                    "usertype": usertype,
                    "email": email,
                    "phone": phone,
                    "major": major,
                    "minor": minor,
                    "semesters": int(semesters),
                    "num_coops": int(num_coops),
                    "skills": [s.strip() for s in skills.split('\n') if s.strip()],
                    "interests": [i.strip() for i in interests.split('\n') if i.strip()],
                    "career_goals": user_data['career_goals'],  # Keep existing values
                    "career_path": user_data['career_path'],    # Keep existing values
                    "experiences": user_data['experiences']      # Keep existing values
                }
                
                st.write("Debug: Update data prepared:", update_data)  # Debug line
                
                try:
                    # Make the PUT request
                    full_url = f"{UPDATE_USER_URL}/{user_id}"
                    st.write(f"Debug: Sending PUT request to {full_url}")
                    
                    response = requests.put(
                        full_url,
                        json=update_data,
                        headers={'Content-Type': 'application/json'}
                    )
                    
                    st.write(f"Debug: Response received - Status: {response.status_code}")
                    st.write(f"Debug: Response content: {response.text}")
                    
                    if response.status_code == 200:
                        st.success("Profile updated successfully!")
                        time.sleep(1)
                        st.rerun()
                    else:
                        st.error(f"Failed to update profile. Status: {response.status_code}")
                        st.error(f"Error message: {response.text}")
                except Exception as e:
                    st.error(f"Error sending update request: {str(e)}")
                    st.write(f"Debug: Exception details: {type(e)}, {str(e)}")

                st.write("Debug: Skills to update:", [s.strip() for s in skills.split('\n') if s.strip()])
                st.write("Debug: Interests to update:", [i.strip() for i in interests.split('\n') if i.strip()])

        else:
            st.error(f"Failed to fetch user profile: {response.text}")

    except Exception as e:
        st.error(f"An error occurred while fetching the profile: {e}")
else:
    st.info("Please enter a UserID to view and update profile")