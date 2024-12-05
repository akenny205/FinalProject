########################################################
# Sample customers blueprint of endpoints
# Remove this file if you are not using it in your project
########################################################
from flask import Blueprint
from flask import request
from flask import jsonify
from flask import make_response
from flask import current_app
from backend.db_connection import db

#------------------------------------------------------------
# Create a new Blueprint object, which is a collection of 
# routes.
career_path = Blueprint('career_path', __name__)


#------------------------------------------------------------
# Get all career paths from the system
@career_path.route('/career_path', methods=['GET'])
def get_all_users_by_career_path():

    cursor = db.get_db().cursor()
    info = request.json
    career_paths = set(info['career_paths'])
    career_paths_str = ', '.join([f"'{career_path}'" for career_path in career_paths])
    query = f'''
            SELECT * FROM users u JOIN career_paths cp ON
            u.UserID = cp.UserID WHERE cp.CareerPath in ({career_paths_str})
            '''
    cursor.execute(query)
    theData = cursor.fetchall()
    the_response = make_response(jsonify(theData))
    the_response.status_code = 200
    return the_response


#------------------------------------------------------------
# Add new career paths to the system
@career_path.route('/career_path', methods=['POST'])
def add_career_path():
    career_path_info = request.json
    query = '''
            INSERT INTO career_paths (UserID, Career_Path)
            VALUES (%s, %s)
    '''
    data = (career_path_info['user_id'], career_path_info['career_path'])
    cursor = db.get_db().cursor()
    cursor.execute(query, data)
    db.get_db().commit()
    return 'CareerPath added!', 200


#------------------------------------------------------------
# Delete career paths from the system
@career_path.route('/career_path/<userID>', methods=['DELETE'])
def delete_career_path(userID):
    query = '''DELETE FROM career_paths WHERE UserID = %s'''
    cursor = db.get_db().cursor()
    cursor.execute(query, (userID,))
    db.get_db().commit()
    return 'CareerPath removed!', 200


#------------------------------------------------------------
# Update career paths that exist within the system
@career_path.route('/career_path/<userID>', methods=['PATCH'])
def update_career_path(userID):
    content = request.json['career_path']
    query = '''UPDATE career_paths SET CareerPath = %s WHERE UserID = %s;'''
    cursor = db.get_db().cursor()
    cursor.execute(query, (content, userID))
    db.get_db().commit()
    return 'User CareerPath updated!', 200