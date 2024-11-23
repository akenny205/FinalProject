from flask import Blueprint
from flask import request
from flask import jsonify
from flask import make_response
from flask import current_app
from backend.db_connection import db

jobs = Blueprint('jobs', __name__)

# admin creates jobs
@jobs.route('/jobs', methods=['POST'])
def create_job():
    current_app.logger.info('/jobs POST request')
    job_info = request.get_json()
    # init
    EmpID = job_info['EmpID']
    Title = job_info['Title']
    Description = job_info['Description']
    JobID = job_info['JobID']
    data = (EmpID, Title, Description, JobID)
    # query
    query = '''
    INSERT INTO jobs (EmpID, Title, Description, JobID)
    VALUES (%s, %s, %s, %s)
    '''
    # cursor
    cursor = db.get._db().cursor()
    cursor.execute(query, data)
    db.get_db().commit()
    return 'Job Created!'

# admin deletes jobs

@jobs.route('/jobs', methods=['DELETE'])
def delete_job(job_id):
    current_app.logger.info('/jobs/job_id DELETE request')
    # query
    query = 'DELETE FROM jobs WHERE JobID = %s'
    # cursor
    cursor = db.get._db().cursor()
    cursor.execute(query, job_id)
    db.get_db().commit()
    return 'Job Deleted!'
