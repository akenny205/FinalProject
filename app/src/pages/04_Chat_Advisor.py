import logging
logger = logging.getLogger(__name__)
import streamlit as st
from modules.nav import SideBarLinks
import requests
import json

st.set_page_config(layout = 'wide')

BASEURL = 'http://web-api:4000/me/messages/'

# Display the appropriate sidebar links for the role of the logged in user
SideBarLinks()

st.title('Students and Advisor Chat Board')
userID = st.text_input("Your User ID")
if userID:
  advisorID = requests.get(f'{BASEURL}{userID}')
  if advisorID:
    actual_advisor_id = advisorID.json()['AdvisorID']
    all_messages = requests.get(f"{BASEURL}{userID}/{actual_advisor_id}")
    decoded = json.loads(all_messages.content.decode('utf-8'))

    st.markdown(
    """
    <style>
    .chat-message {
        border-radius: 12px;
        padding: 10px 15px;
        margin: 5px 0;
        max-width: 70%;
        display: inline-block;
        word-wrap: break-word;
    }
    .sender {
        background-color: #DCF8C6;
        text-align: right;
        float: right;
        clear: both;
    }
    .receiver {
        background-color: #F1F0F0;
        text-align: left;
        float: left;
        clear: both;
    }
    </style>
    """,
    unsafe_allow_html=True,
    )

    

    st.title("All Chats")
    if "error" in decoded:
      st.warning('you do not have any messages between you and your advisor')
    else:
      for message in decoded:
        if message["SenderID"] == int(userID):
            # Sender message (right-aligned, green bubble)
            st.markdown(
                f"""
                <div class="chat-message sender">
                    <p>{message['Content']}</p>
                    <small>{message['SentDate']}</small>
                </div>
                """,
                unsafe_allow_html=True,
            )
        elif message["SenderID"] == int(actual_advisor_id):
            # Receiver message (left-aligned, gray bubble)
            st.markdown(
                f"""
                <div class="chat-message receiver">
                    <p>{message['Content']}</p>
                    <small>{message['SentDate']}</small>
                </div>
                """,
                unsafe_allow_html=True,
            )


      st.markdown("<div style='margin-bottom: 50px;'></div>", unsafe_allow_html=True)

      #send message to advisor
      text = st.text_input("Send a Message")
      date = st.date_input('What is the Date?')
      if st.button("Send Message"):
        if text and date:
          message_data = {
              'sender_id': int(userID),
              'receiver_id': actual_advisor_id,
              'sent_date': str(date),
              'content': text
              }
          response = requests.post(BASEURL[:-1], json=message_data)
          if response.status_code == 201:
            st.success("Message Sent!")
          else:
            st.write(response.status_code)
            st.error("Faled to Send Message")
        else:
          st.warning("Please fill in all fields")
  
      
    
  else:
    st.warning('Looks like you do not have an advisor!')

