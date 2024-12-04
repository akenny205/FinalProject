# Idea borrowed from https://github.com/fsmosca/sample-streamlit-authenticator

# This file has function to add certain functionality to the left side bar of the app

import streamlit as st


#### ------------------------ General ------------------------
def HomeNav():
    st.sidebar.page_link("Home.py", label="Home", icon="🏠")


def AboutPageNav():
    st.sidebar.page_link("pages/30_About.py", label="About", icon="🧠")


#### ------------------------ Examples for Role of Inexp_Student ------------------------
def InexpStudentHomeNav():
    st.sidebar.page_link("pages/00_Inexp_Student_Home.py", label="Student Home", icon="👤")
    st.sidebar.page_link("pages/07_new_match.py", label="New Match", icon="❤️")


## ------------------------ Examples for Role of Exp_Student ------------------------
def ExpStudentHomeNav():
    st.sidebar.page_link("pages/10_Exp_Student_Home.py", label="Student Home", icon="👤")
    st.sidebar.page_link("pages/07_new_match.py", label="New Match", icon="❤️")


#### ------------------------ Advisor Role ------------------------
def AdvisorsHomeNav():
    st.sidebar.page_link("pages/20_Advisor_Home.py", label="Advisor Home", icon="🧑‍🏫")


#### ------------------------ System Admin Role ------------------------
def AdminPageNav():
    st.sidebar.page_link("pages/40_Admin_Home.py", label="Admin Home", icon="🖥️")


# --------------------------------Links Function -----------------------------------------------
def SideBarLinks(show_home=False):
    """
    This function handles adding links to the sidebar of the app based upon the logged-in user's role, which was put in the streamlit session_state object when logging in.
    """

    # add a logo to the sidebar always
    st.sidebar.image("assets/logo.png", width=300)

    # If there is no logged in user, redirect to the Home (Landing) page
    if "authenticated" not in st.session_state:
        st.session_state.authenticated = False
        st.switch_page("Home.py")

    if show_home:
        # Show the Home page link (the landing page)
        HomeNav()

    # Show the other page navigators depending on the users' role.
    if st.session_state["authenticated"]:

        # Show World Bank Link and Map Demo Link if the user is a political strategy advisor role.
        if st.session_state["role"] == 'inexperienced_student':
            InexpStudentHomeNav()

        # If the user role is usaid worker, show the Api Testing page
        if st.session_state["role"] == 'peer_mentor':
            ExpStudentHomeNav()

        # If the user is an advisor, give them access to the advisor pages
        if st.session_state["role"] == 'coop_career_advisor':
            AdvisorsHomeNav()

        # If the user is an administrator, give them access to the administrator pages
        if st.session_state["role"] == "admin":
            AdminPageNav()

    # Always show the About page at the bottom of the list of links
    AboutPageNav()

    if st.session_state["authenticated"]:
        # Always show a logout button if there is a logged in user
        if st.sidebar.button("Logout"):
            del st.session_state["role"]
            del st.session_state["authenticated"]
            st.switch_page("Home.py")

