from flask import Blueprint
from flask import request
from flask import jsonify
from flask import make_response
from flask import current_app
from backend.db_connection import db

employers = Blueprint('employers', __name__)


@employers.route('/employers', methods=['POST'])
def add_employee():
    user_info = request.json
    query = '''
            INSERT INTO employers (Name, Description, AdminID) 
            VALUES (%s, %s, %s);
    '''
    data = (user_info['name'], user_info['description'], user_info['admin_id'])
    cursor = db.get_db().cursor()
    cursor.execute(query, data)
    db.get_db().commit()
    return 'Employee added!', 201



@employers.route('/employers/<userID>', methods=['GET'])
def get_employer_description(userID):

    cursor = db.get_db().cursor()
    query = ('''SELECT e.EmpID, e.Name, e.Description 
                    FROM employers e
                    JOIN users u ON u.EmpID = e.EmpID
                    WHERE u.UserID = %s
    ''')
    cursor.execute(query, (userID,))
    theData = cursor.fetchone()

    if not theData:
        return 'User not Found', 404

    the_response = make_response(jsonify(theData))
    the_response.status_code = 200
    return the_response

