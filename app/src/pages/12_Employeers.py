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
        if "error" in data:
            st.error(data["error"])
        else:
            df = pd.DataFrame([data])  # Wrap data in a list to create a DataFrame
            st.subheader("Employee Details")
            # Configure the dataframe display
            st.dataframe(df, hide_index=True, column_config={
                "EmpId": "Employee ID",
                "Name": "Name",
                "Description": "Job Description"
            })
    except requests.exceptions.RequestException as e:
        st.error(f"An error occurred: {e}")
else:
    st.info("Please enter an Employee ID to fetch details.")