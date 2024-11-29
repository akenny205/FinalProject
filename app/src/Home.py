##################################################
# This is the main/entry-point file for the 
# sample application for your project
##################################################

# Set up basic logging infrastructure
import logging
logging.basicConfig(format='%(filename)s:%(lineno)s:%(levelname)s -- %(message)s', level=logging.INFO)
logger = logging.getLogger(__name__)

# import the main streamlit library as well
# as SideBarLinks function from src/modules folder
import streamlit as st
from modules.nav import SideBarLinks

# streamlit supports reguarl and wide layout (how the controls
# are organized/displayed on the screen).
st.set_page_config(layout = 'wide')

# If a user is at this page, we assume they are not 
# authenticated.  So we change the 'authenticated' value
# in the streamlit session_state to false. 
st.session_state['authenticated'] = False

# Use the SideBarLinks function from src/modules/nav.py to control
# the links displayed on the left-side panel. 
# IMPORTANT: ensure src/.streamlit/config.toml sets
# showSidebarNavigation = false in the [client] section
SideBarLinks(show_home=True)

# ***************************************************
#    The major content of this page
# ***************************************************

# set the title of the page and provide a simple prompt. 
logger.info("Loading the Home page of the app")
st.title('PeerPoint')
st.write('\n\n')
st.write('### Please select a user type')

# For each of the user personas for which we are implementing
# functionality, we put a button on the screen that the user 
# can click to MIMIC logging in as that mock user. 

st.markdown("""
    <style>
    .stButton > button {
        background-color: #DC143C; /* Crimson Red */
        color: white;
        border: 2px solid #FF4500; /* Orange Red Border */
        border-radius: 10px;
        font-size: 16px;
        padding: 10px 20px;
        transition: background-color 0.3s ease, border-color 0.3s ease, transform 0.2s ease; /* Smooth transitions */
    }
    .stButton > button:hover {
        background-color: #B11234; /* Darker Crimson Red */
        border: 2px solid #FF6347; /* Lighter Orange-Red Border */
        transform: scale(1.05); /* Slightly enlarge button on hover */
    }
    </style>
    """, unsafe_allow_html=True)

if st.button("Act as Bill, an inexperienced student", 
            type = 'primary', 
            use_container_width=True):
    # when user clicks the button, they are now considered authenticated
    st.session_state['authenticated'] = True
    # we set the role of the current user
    st.session_state['role'] = 'inexperienced_student'
    # we add the first name of the user (so it can be displayed on 
    # subsequent pages). 
    st.session_state['first_name'] = 'Bill'
    # finally, we ask streamlit to switch to another page, in this case, the 
    # landing page for this particular user type
    logger.info("Logging in as Inexperienced Student Persona")
    st.switch_page('pages/00_Inexp_Student_Home.py')

if st.button('Act as Tom, a peer mentor', 
            type = 'primary', 
            use_container_width=True):
    st.session_state['authenticated'] = True
    st.session_state['role'] = 'peer_mentor'
    st.session_state['first_name'] = 'Tom'
    st.switch_page('pages/10_Exp_Student_Home.py')

if st.button('Act as John, a CO-OP/Career Advisor', 
            type = 'primary', 
            use_container_width=True):
    st.session_state['authenticated'] = True
    st.session_state['role'] = 'coop_career_advisor'
    st.session_state['first_name'] = 'John'
    st.switch_page('pages/20_Advisor_Home.py')

if st.button('Act as Mike, System Administrator',
             type = 'primary',
             use_container_width = True):
    st.session_state['authenticated'] = True
    st.session_state['role'] = 'admin'
    st.session_state['first_name'] = 'Mike'
    st.switch_page('pages/40_Admin_Home.py')