from flask import Blueprint
from flask import request
from flask import jsonify
from flask import make_response
from flask import current_app
from backend.db_connection import db

experience = Blueprint('experience', __name__)

# Displays an Advisor's students and their experiences
@experience.route('/viewexp', methods=['GET'])
def view_experiences():
    cursor = db.get_db().cursor()
    cursor.execute('SELECT u.AdvisorID,'
                   'e.Date, '
                   'e.Location,  '
                   'e.Description,'
                   ' e.ExperienceName, '
                   'u.UserID, '
                   'u.lName AS LastName,'
                   'u.fName AS FirstName '
                   'FROM experience e JOIN users u ON e.UserID = u.UserID '
                   'ORDER BY u.AdvisorID, e.Date DESC;')
    experiences = cursor.fetchall()
    response = make_response(jsonify(experiences))
    response.status_code = 200
    return response

# Creates experience for a user
@experience.route('/createexp', methods=['POST'])
def create_experience():
    current_app.logger.info('POST /customers route')
    cust_info = request.get_json()
    # init
    userID = cust_info['UserID']
    experienceName = cust_info['ExperienceName']
    date = cust_info['Date']
    location = cust_info['Location']
    description = cust_info['Description']
    experienceID = cust_info['ExperienceID']
    data = (userID, experienceName, date, location, description, experienceID)
    # query
    query = '''
    INSERT INTO experience (ExperienceID, UserID, ExperienceName, Date, Location, Description)
    VALUES (%s, %s, %s, %s, %s, %s);'''
    # cursor
    cursor = db.get_db().cursor()
    cursor.execute(query, data)
    db.get_db().commit()
    return 'Experience Created!'

# Must add filter by traits !

