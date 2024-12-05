from flask import Blueprint
from flask import request
from flask import jsonify
from flask import make_response
from flask import current_app
from backend.db_connection import db

employers = Blueprint('employers', __name__)

#------------------------------------------------------------
# Add an employer
@employers.route('/employers/add', methods=['POST'])
def add_employee():
    user_info = request.json
    query = '''
            INSERT INTO employers (Name, Description, AdminID) 
            VALUES (%s, %s, %s);
    '''
    data = (user_info['Name'], user_info['Description'], user_info['AdminID'])
    cursor = db.get_db().cursor()
    cursor.execute(query, data)
    db.get_db().commit()
    return 'Employer added!', 201

#------------------------------------------------------------
# View specific employee by ID
@employers.route('/employers/<employee_id>', methods=['GET'])
def get_employee(employee_id):
    cursor = db.get_db().cursor()
    cursor.execute('''SELECT * FROM employers WHERE EmpID = %s''', (employee_id))
    theData = cursor.fetchall()
    response = make_response(jsonify(theData), 200)
    return response

#------------------------------------------------------------
# admin deletes eployer
@employers.route('/deleteEmployer/<employee_ID>', methods=['DELETE'])
def delete_employee(employee_ID):
    current_app.logger.info(f'/employer DELETE request for EmpID: {employee_ID}')
    query = 'DELETE FROM employers WHERE EmpID = %s'
    try:
        with db.get_db().cursor() as cursor:
            cursor.execute(query, (employee_ID))
        db.get_db().commit()
        return jsonify({'message': 'Employer Deleted!'}), 200
    except Exception as e:
        current_app.logger.error(f"Error deleting employer {employee_ID}: {e}")
        return jsonify({'error': 'Failed to delete employer', 'details': str(e)}), 500

#------------------------------------------------------------   
# View all employers
@employers.route('/employers', methods=['GET'])
def get_employees():
    cursor = db.get_db().cursor()
    cursor.execute('''SELECT * FROM employers''')
    theData = cursor.fetchall()
    response = make_response(jsonify(theData), 200)
    return response

#------------------------------------------------------------   
# Edit employer
@employers.route('/employers/edit/<employee_ID>', methods=['PUT'])
def edit_employee(employee_ID):
    current_app.logger.info(f'/employer PUT request for EmpID: {employee_ID}')
    user_info = request.json
    query = '''
            UPDATE employers SET Name = %s, Description = %s WHERE EmpID = %s;
    '''
    data = (user_info['Name'], user_info['Description'], employee_ID)
    cursor = db.get_db().cursor()
    cursor.execute(query, data)
    db.get_db().commit()
    return 'Employer edited!', 200