from flask import Blueprint
from flask import request
from flask import jsonify
from flask import make_response
from flask import current_app
from backend.db_connection import db

messages = Blueprint('messages', __name__)

# adds a message to the database
@messages.route('/messages', methods=['POST'])
def add_message():
    cursor = db.get_db().cursor()
    message_info = request.get_json()
    #print(message_info)
    query = '''
            INSERT INTO messages (SenderID, SentDate, ReceiverID, Content)
            VALUES (%s,NOW(),%s,%s);
    '''
    data = (message_info['sender_id'], message_info['receiver_id'], message_info['content'])
    cursor.execute(query, data)
    db.get_db().commit()
    return 'Message sent!', 201

# simply gets the advisor ID for the given user ID
@messages.route('/messages/<userID>', methods=['GET'])
def get_advisorID(userID):
    user_id = request.args.get('userID')
    cursor = db.get_db().cursor()
    query = '''
        SELECT u.AdvisorID
        FROM users u
        WHERE u.UserID = %s;
    '''
    cursor.execute(query, (userID,))
    ids = cursor.fetchone()
    if not ids:
        return make_response(jsonify({"error": "User not found or User has no Advisor"}), 404)
    return ids

# Gets all the messages between two users
@messages.route('/messages/<userID1>/<userID2>', methods =['GET'])
def get_all_messages(userID1, userID2):

    cursor = db.get_db().cursor()
    query = '''
        SELECT MessageID, SentDate, SenderID, ReceiverID, Content, AdminID
        FROM messages
        WHERE 
            (SenderID = %s AND ReceiverID = %s) OR 
            (SenderID = %s AND ReceiverID = %s)
        ORDER BY SentDate ASC;
        '''
    data = (userID1, userID2, userID2, userID1)
    cursor.execute(query, data)
    messages = cursor.fetchall()

    if not messages:
        return make_response(jsonify({"error": "no messages between users"}), 404)

    the_response = make_response(jsonify(messages))
    the_response.status_code = 200

    return the_response



    

