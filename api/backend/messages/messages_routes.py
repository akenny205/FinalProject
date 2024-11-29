from flask import Blueprint
from flask import request
from flask import jsonify
from flask import make_response
from flask import current_app
from backend.db_connection import db

messages = Blueprint('messages', __name__)


@message.route('/messages', methods=['POST'])
def add_message():
    message_info = request.json
    query = '''
            NSERT INTO messages (MessageID, SenderID, SentDate, ReceiverID, Content, AdminID)
            VALUES (%s,%s,%s,%s,%s,%s);
    '''
    data = (message_info['message_id'], message_info['sender_id'], message_info['sent_date'], 
            message_info['receiver_id'], message_info['content'], message_info['admin_id']
    )
    cursor = db.get_db().cursor()
    cursor.execute(query, data)
    db.get_db().commit()
    return 'Message sent!', 201



@messages.route('/messages/<userID1>/<userID2>',  methods =['GET'])
def get_all_messages(userID1, userID2):

    cursor = db.get_db.cursor()
    query = """
        SELECT MessageID, SentDate, SenderID, ReceiverID, Content, AdminID
        FROM messages
        WHERE 
            (SenderID = %s AND ReceiverID = %s) OR 
            (SenderID = %s AND ReceiverID = %s)
        ORDER BY SentDate ASC;
    """
    data = (userID1, userID2, userID2, userID1)
    cursor.execute(query, data)
    messages = cursor.fetchall()
    the_response = make_response(jsonify(messages))
    the_response.status_code = 200

    return the_response



    

