from flask import Blueprint
from flask import request
from flask import jsonify
from flask import make_response
from flask import current_app
from backend.db_connection import db

messages = Blueprint('messages', __name__)

@messages.route('/messages', methods=['POST'])
def add_message():
    cursor = db.get_db().cursor()
    message_info = request.json
    query = '''
            NSERT INTO messages (MessageID, SenderID, SentDate, ReceiverID, Content, AdminID)
            VALUES (%s,%s,%s,%s,%s,%s);
    '''
    data = (message_info['message_id'], message_info['sender_id'], message_info['sent_date'], 
            message_info['receiver_id'], message_info['content'], message_info['admin_id']
    )
    cursor.execute(query, data)
    db.get_db().commit()
    return 'Message sent!', 201

@messages.route('/messages/<userID>', methods=['GET'])
def get_advisorID(userID):
    user_id = request.args.get('user_id')
    cursor = db.get_db().cursor()

    query = '''
        SELECT u.AdvisorID, u.fname, u.lname
        FROM users u
        WHERE u.UserID = %s;
    '''
    cursor.execute(query, (user_id,))
    ids = cursor.fetchone()
    if not ids:
        return make_response(jsonify({"error": "User not found"}), 404)
    results = [
     {"AdvisorID": row[0], "FirstName": row[1], "LastName": row[2]}
       for row in ids
    ]
    response = make_response(jsonify(results))
    response.status_code = 200
    return response


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



    

