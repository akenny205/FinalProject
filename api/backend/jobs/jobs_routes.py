from flask import Blueprint
from flask import request
from flask import jsonify
from flask import make_response
from flask import current_app
from backend.db_connection import db

jobs = Blueprint('jobs', __name__)

# Admin can see all current JobIDs and Titles
@jobs.route('/viewjobs', methods=['GET'])
def view_jobs():
    query = '''
        SELECT JobID, Title FROM jobs
        '''
    cursor = db.get_db().cursor()
    cursor.execute(query)
    theData = cursor.fetchall()
    response = make_response(jsonify(theData))
    response.status_code = 200
    return response

# admin creates jobs
@jobs.route('/createjob/<EmpID>/<Title>/<Description>', methods=['POST'])
def create_job(EmpID, Title, Description):
    current_app.logger.info('/jobs POST request')
    data = (EmpID, Title, Description)
    query = '''
        INSERT INTO jobs (EmpID, Title, Description)
        VALUES (%s, %s, %s)
    '''
    cursor = db.get_db().cursor()
    cursor.execute(query, data)
    db.get_db().commit()
    return 'Job Created!'

# admin deletes jobs
@jobs.route('/deletejob/<JobId>', methods=['DELETE'])
def delete_job(JobID):
    current_app.logger.info('/jobs DELETE request')
    query = 'DELETE FROM jobs WHERE JobID = %s'
    cursor = db.get._db().cursor()
    cursor.execute(query, job_id)
    db.get_db().commit()
    return 'Job Deleted!'
