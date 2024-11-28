from flask import Blueprint
from flask import request
from flask import jsonify
from flask import make_response
from flask import current_app
from backend.db_connection import db

interests = Blueprint('interests', __name__)


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
    

