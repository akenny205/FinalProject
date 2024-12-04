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
    try:
        query = 'SELECT JobID, Title FROM jobs'
        cursor = db.get_db().cursor()
        cursor.execute(query)
        theData = cursor.fetchall()
        return jsonify(theData), 200
    except Exception as e:
        current_app.logger.error(f"Error in view_jobs: {str(e)}")
        return jsonify({'error': str(e)}), 500

@jobs.route('/create_job/<EmpID>/<Title>/<Description>', methods=['POST'])
def create_job(EmpID, Title, Description):
    try:
        current_app.logger.info('/jobs POST request')
        data = (EmpID, Title, Description)
        query = '''
            INSERT INTO jobs (EmpID, Title, Description)
            VALUES (%s, %s, %s)
        '''
        cursor = db.get_db().cursor()
        cursor.execute(query, data)
        db.get_db().commit()
        return jsonify({'message': 'Job Created!'}), 200
    except Exception as e:
        current_app.logger.error(f"Error in create_job: {str(e)}")
        return jsonify({'error': str(e)}), 500

# admin creates jobs
@jobs.route('/deletejob/<JobID>', methods=['DELETE'])
def delete_job(JobID):
    current_app.logger.info(f'/jobs DELETE request for JobID: {JobID}')
    query = 'DELETE FROM jobs WHERE JobID = %s'
    try:
        with db.get_db().cursor() as cursor:
            cursor.execute(query, (JobID,))
        db.get_db().commit()
        return jsonify({'message': 'Job Deleted!'}), 200
    except Exception as e:
        current_app.logger.error(f"Error deleting job {JobID}: {e}")
        return jsonify({'error': 'Failed to delete job', 'details': str(e)}), 500


