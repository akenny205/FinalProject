import logging
logger = logging.getLogger(__name__)
import streamlit as st
from modules.nav import SideBarLinks
import requests

st.set_page_config(layout = 'wide')

SideBarLinks()

st.title('Add Students')

st.write('\n\n')
st.write('## Who would you like to add?')

# Function to insert data into the database

# def insert_student_to_database(first_name, last_name, student_id, major, email):
#    try:
#        # Connect to the database
#        connection = mysql.connector.connect(
#            host="localhost",    # Update with your database host
#            user="root",         # Update with your database username
#            password="password", # Update with your database password
#            database="finalproject"
#        )
#        cursor = connection.cursor()
#        
#        # Insert query
#        insert_query = """
#        INSERT INTO users (UserID, lName, fName, Usertype, Email, Major, AdvisorID)
#        VALUES (%s, %s, %s, 'Mentee', %s, %s, NULL)
#        """
#        cursor.execute(insert_query, (student_id, last_name, first_name, email, major))
#        connection.commit()
#        
#        st.success("Student added successfully!")
#    except mysql.connector.Error as err:
#        st.error(f"Error: {err}")
#    finally:
#        if connection.is_connected():
#            cursor.close()
#            connection.close()

with st.form("student_form"):
    first_name = st.text_input("First Name")
    last_name = st.text_input("Last Name")
    student_id = st.number_input("Student ID", min_value=1, step=1)
    major = st.text_input("Major")
    email = st.text_input("Email")
    
    submit_button = st.form_submit_button("Add Student")
    
    if submit_button:
        # Validate input
        if not first_name or not last_name or not student_id or not major or not email:
            st.error("Please fill in all fields.")
        else:
            # insert_student_to_database(first_name, last_name, student_id, major, email)
            st.write('## Thanks for adding your student')
