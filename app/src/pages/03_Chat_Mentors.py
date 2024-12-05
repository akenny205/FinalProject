import logging
logger = logging.getLogger(__name__)
import streamlit as st
from modules.nav import SideBarLinks
import requests
from collections import defaultdict
import json


SideBarLinks()


st.title("Mentee and Mentor Chat Dashboard")
userID = st.text_input("Your User ID")
if userID:
  all_matches = requests.get(f'http://web-api:4000/m/matches/{userID}')
  st.write(all_matches.status_code)
  st.write(all_matches.json())
  matches = all_matches.json()
  match_names = ["Choose a User"]
  match_names_IDS = defaultdict(int)
  for match in matches:
    currID = match["MentorID"]
    curr_mentor = requests.get(f'http://web-api:4000/u/user/{currID}').json()
    st.write(curr_mentor)
    fname = curr_mentor['fname']
    lname = curr_mentor['lname']
    full_name = fname + " " + lname
    match_names.append(full_name)
    match_names_IDS[full_name] = currID

  mentor = st.selectbox("Select who you want to chat with", match_names)
  if mentor != "Choose a User":
    mentorID = match_names_IDS[mentor]
    all_messages = requests.get(f"http://web-api:4000/me/messages/{userID}/{mentorID}")
    st.write(all_messages.status_code)
    if all_messages.status_code not in (200, 201):
      st.warning("no messages between users")
    else:
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
          elif message["SenderID"] == int(mentorID):
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

        #send message to mentor/mentee
        text = st.text_input("Send a Message")
        if st.button("Send Message"):
          if text:
            message_data = {
                'sender_id': int(userID),
                'receiver_id': actual_advisor_id,
                'content': text
                }
            response = requests.post("http://web-api:4000/me/messages", json=message_data)
            if response.status_code == 201:
              st.success("Message Sent!")
            else:
              st.write(response.status_code)
              st.error("Faled to Send Message")
          else:
            st.warning("Please fill in all fields")
    
    
