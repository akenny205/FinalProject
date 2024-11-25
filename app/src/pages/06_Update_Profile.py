import logging
logger = logging.getLogger(__name__)
import streamlit as st
import pandas as pd
from sklearn import datasets
from sklearn.ensemble import RandomForestClassifier
from streamlit_extras.app_logo import add_logo
from modules.nav import SideBarLinks
import requests

SideBarLinks()

UPDATE_USER_URL = "http://web-api:4000/u/user"  # Adjust the hostname and port as necessary

# Streamlit App
st.title("Update User Profile")

# Input UserID
user_id = st.text_input("Enter UserID to Update", help="Provide the ID of the user whose profile you want to update")

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

            # Button to show edit form
            if st.button("Edit Profile"):
                with st.form("update_user_form"):
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
                    
                    career_goals = st.text_area("Career Goals (one per line)",
                                              value="\n".join(user_data['career_goals']) if user_data['career_goals'] else "")
                    
                    career_path = st.text_area("Career Path (one per line)",
                                             value="\n".join(user_data['career_path']) if user_data['career_path'] else "")

                    # Experiences section
                    st.subheader("Experiences")
                    experiences = []
                    num_experiences = st.number_input("Number of experiences", min_value=0, value=len(user_data['experiences']))
                    
                    for i in range(num_experiences):
                        st.write(f"Experience {i+1}")
                        exp_default = user_data['experiences'][i] if i < len(user_data['experiences']) else {}
                        date_input = st.date_input(f"Date {i+1}", value=None)
                        exp = {
                            'ExperienceName': st.text_input(f"Name {i+1}", value=exp_default.get('ExperienceName', '')),
                            'Date': date_input.strftime('%Y-%m-%d') if date_input else '',
                            'Location': st.text_input(f"Location {i+1}", value=exp_default.get('Location', '')),
                            'Description': st.text_area(f"Description {i+1}", value=exp_default.get('Description', ''))
                        }
                        experiences.append(exp)

                    submitted = st.form_submit_button("Submit Updates")

                    if submitted:
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
                            "career_goals": [g.strip() for g in career_goals.split('\n') if g.strip()],
                            "career_path": [p.strip() for p in career_path.split('\n') if p.strip()],
                            "experiences": experiences
                        }

                        try:
                            # Debug output
                            st.write("Debug: Update data being sent:", update_data)
                            
                            update_response = requests.put(f"{UPDATE_USER_URL}/{user_id}", 
                                                        json=update_data)
                            
                            # Debug output
                            st.write("Debug: Response received:", update_response.text)
                            
                            if update_response.status_code == 200:
                                st.success("Thank you! Your profile has been updated successfully.")
                                st.rerun()  # Refresh the page to show updated info
                            else:
                                st.error(f"Failed to update profile: {update_response.text}")
                        except Exception as e:
                            st.error(f"An error occurred: {e}")

        else:
            st.error(f"Failed to fetch user profile: {response.text}")

    except Exception as e:
        st.error(f"An error occurred while fetching the profile: {e}")
else:
    st.info("Please enter a UserID to view and update profile")