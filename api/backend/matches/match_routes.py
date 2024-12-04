########################################################
# Sample customers blueprint of endpoints
# Remove this file if you are not using it in your project
########################################################
from flask import Blueprint
from flask import request
from flask import jsonify
from flask import make_response
from flask import current_app
from backend.db_connection import db

#------------------------------------------------------------
# Create a new Blueprint object, which is a collection of 
# routes.
matches = Blueprint('matches', __name__)

#------------------------------------------------------------
# Match with a user - Done
@matches.route('/matches/<user_id>/<match_user_id>', methods=['POST'])
def new_match(user_id, match_user_id):
    cursor = db.get_db().cursor()
    cursor.execute('''INSERT INTO matches (MenteeID, MentorID) VALUES (%s, %s)''', (user_id, match_user_id))
    db.get_db().commit()
    return make_response(jsonify(True), 200)

#------------------------------------------------------------
# Get all matches associated with a user - Done (Need to add some stuff, a second query to see info)
@matches.route('/matches/<user_id>', methods=['GET'])
def get_matches(user_id):
    cursor = db.get_db().cursor()
    cursor.execute('''SELECT MentorID FROM matches WHERE MenteeID = %s''', (user_id))
    theData = cursor.fetchall()
    response = make_response(jsonify(theData), 200)
    return response

#------------------------------------------------------------
# Get all recommended matches for a user - Done (Needs testing)
@matches.route('/matches/recommended/<user_id>', methods=['GET'])
def get_recommended_matches(user_id):
    cursor = db.get_db().cursor()
    cursor.execute('''SELECT MentorID FROM matches WHERE MenteeID = %s AND Recommended = 1''', (user_id))
    theData = cursor.fetchall()
    response = make_response(jsonify(theData), 200)
    return response

#------------------------------------------------------------
# Get all matches associated with students and advisor advises - Done
@matches.route('/matches/students/<advisor_id>', methods=['GET'])
def get_matches_for_students(advisor_id):
    cursor = db.get_db().cursor()
    cursor.execute('''SELECT 
                            mentee.UserID AS MenteeID,
                            mentee.fName AS MenteeFirstName,
                            mentee.lName AS MenteeLastName,
                            mentor.UserID AS MentorID,
                            mentor.fName AS MentorFirstName,
                            mentor.lName AS MentorLastName,
                            matches.Recommended,
                            matches.Start,
                            matches.End,
                            matches.Status
                        FROM 
                            matches
                        JOIN 
                            users AS mentee ON matches.MenteeID = mentee.UserID
                        JOIN 
                            users AS mentor ON matches.MentorID = mentor.UserID
                        WHERE 
                            mentee.AdvisorID = %s OR mentor.AdvisorID = %s''', (advisor_id, advisor_id))
    theData = cursor.fetchall()
    response = make_response(jsonify(theData), 200)
    return response

#------------------------------------------------------------
# Recommend matches
@matches.route('/matches/recommended/<user_id>/<match_user_id>', methods=['POST'])
def new_recommended_match(user_id, match_user_id):
    cursor = db.get_db().cursor()
    cursor.execute('''INSERT INTO matches (MenteeID, MentorID, Recommended) VALUES (%s, %s, 1)''', (user_id, match_user_id))
    db.get_db().commit()
    return make_response(jsonify(True), 200)

#------------------------------------------------------------
# End matches
@matches.route('/matches/end/<user_id>/<match_user_id>', methods=['PUT'])
def end_match(user_id, match_user_id):
    cursor = db.get_db().cursor()
    cursor.execute('''UPDATE matches SET Status = 0 WHERE MenteeID = %s AND MentorID = %s''', (user_id, match_user_id))
    db.get_db().commit()
    return make_response(jsonify(True), 200)