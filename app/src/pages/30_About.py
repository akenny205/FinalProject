import streamlit as st
from streamlit_extras.app_logo import add_logo
from modules.nav import SideBarLinks

SideBarLinks(show_home=True)

st.title("About PeerPoint")

st.write(
    """
    PeerPoint is a platform designed to empower students through meaningful mentorship connections. 
    We believe that the best advice comes from peers who’ve walked the same path, so we’ve created a 
    space where students can share insights, experiences, and tips for succeeding in co-ops and beyond.
    """
)

st.subheader("At PeerPoint, you can:")
st.markdown(
    """
    - Connect with mentors who’ve experienced the co-op process firsthand.
    - Gain practical advice on resumes, interviews, and navigating workplace challenges.
    - Learn about diverse industries and career paths directly from peers.
    """
)

st.write(
    """
    Our mission is to foster a supportive community where students help each other grow professionally 
    and personally. PeerPoint isn’t just about mentorship; it’s about building relationships that 
    inspire and guide you toward achieving your goals.
    """
)