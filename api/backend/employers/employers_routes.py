from flask import Blueprint
from flask import request
from flask import jsonify
from flask import make_response
from flask import current_app
from backend.db_connection import db

employers = Blueprint('employers', __name__)

#------------------------------------------------------------
# Add an employer
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


#------------------------------------------------------------
# View specific employee by ID
@employers.route('/employers/<employee_id>', methods=['GET'])
def get_employee(employee_id):
    cursor = db.get_db().cursor()
    cursor.execute('''SELECT * FROM employers WHERE EmpID = %s''', (employee_id))
    theData = cursor.fetchall()
    response = make_response(jsonify(theData), 200)
    return response
