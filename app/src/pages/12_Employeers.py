import streamlit as st
import pandas as pd
import requests

st.title('Employers')

# Input field for employee ID
employee_id = st.text_input("Enter Employee ID")

if employee_id:
    BACKEND_URL = f"http://api:4000/emp/employers/{employee_id}"

    try:
        response = requests.get(BACKEND_URL)
        response.raise_for_status()
        data = response.json()
        df = pd.DataFrame(data)
        st.subheader("Employee Details")
        
        # Configure the dataframe display
        st.dataframe(df, 
                    use_container_width=True,
                    hide_index=True,
                    column_config={
                "EmpID": "Employee ID",
                "Name": "Name",
                "Description": "Job Description",
                "AdminID": "Admin ID"
        })
    except requests.exceptions.RequestException as e:
        st.error(f"An error occurred: {e}")
else:
    st.info("Please enter an Employee ID to fetch details.")