from flask import Blueprint
from flask import request
from flask import jsonify
from flask import make_response
from flask import current_app
from backend.db_connection import db

interests = Blueprint('interests', __name__)


# gets all the users who have one or more interests
@interests.route('/interests', methods=['GET'])
def get_all_users_by_interests():

    cursor = db.get_db().cursor()
    info = request.json
    interests = set(info['interests'])
    interests_str = ', '.join([f"'{interest}'" for interest in interests])
    query = f'''
            SELECT * FROM users u JOIN interests i ON
            u.UserID = i.UserID WHERE i.Interest in ({interests_str});
    '''
    cursor.execute(query)
    data = cursor.fetchall()
    response = make_response(jsonify(data))
    response.status_code = 200
    return response

# Adds an interest to the database
@interests.route('/interests', methods=['POST'])
def add_interest():
    interest_info = request.json
    query = '''
            INSERT INTO interests (UserID, Interest)
            VALUES (%s, %s)
    '''
    data = (interest_info['user_id'], interest_info['interest'])
    cursor = db.get_db().cursor()
    cursor.execute(query, data)
    db.get_db().commit()
    return 'Interest added!', 201

# Deletes an interest to the database
@interests.route('/interess/<userID>', methods=['DELETE'])
def delete_interest(userID):
    query = '''DELETE FROM interests WHERE UserID = %s'''
    cursor = db.get_db().cursor()
    cursor.execute(query, (userID,))
    db.get_db().commit()
    return 'Interest removed!', 200

# Updates an interest to the database
@interests.route('/interests/<userID>', methods=['PATCH'])
def update_interest(userID):
    content = request.json['interest']
    query = '''UPDATE interests SET Interest = %s WHERE UserID = %s;'''
    cursor = db.get_db().cursor()
    cursor.execute(query, (content, userID))
    db.get_db().commit()
    return 'User interest updated!', 200





    

