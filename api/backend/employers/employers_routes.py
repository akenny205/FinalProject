from flask import Blueprint
from flask import request
from flask import jsonify
from flask import make_response
from flask import current_app
from backend.db_connection import db

employers = Blueprint('employers', __name__)

#------------------------------------------------------------
# Add an employer
@employers.route('/employers/<Name>/<Description>/<Admin>', methods=['POST'])
def add_employee(Name, Description, Admin):
    user_info = request.json
    query = '''
            INSERT INTO employers (Name, Description, Admin) 
            VALUES (%s, %s, %s);
    '''
    data = (Name, Description, Admin)
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


# admin deletes eployee
@employers.route('/deleteEmployee/<employee_ID>', methods=['DELETE'])
def delete_employee(employee_ID):
    current_app.logger.info(f'/employee DELETE request for EmpID: {employee_ID}')
    query = 'DELETE FROM employers WHERE EmpID = %s'
    try:
        with db.get_db().cursor() as cursor:
            cursor.execute(query, (employee_ID))
        db.get_db().commit()
        return jsonify({'message': 'Employer Deleted!'}), 200
    except Exception as e:
        current_app.logger.error(f"Error deleting employer {employee_ID}: {e}")
        return jsonify({'error': 'Failed to delete employer', 'details': str(e)}), 500
