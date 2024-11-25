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


