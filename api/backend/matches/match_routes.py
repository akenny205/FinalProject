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
# Match with a user
@matches.route('/matches/<user_id>/<match_user_id>', methods=['POST'])
def new_match(user_id, match_user_id):
    cursor = db.get_db().cursor()
    cursor.execute('''INSERT INTO matches (MenteeID, MentorID) VALUES (%s, %s)''', (user_id, match_user_id))
    db.get_db().commit()
    return make_response(jsonify(True), 200)

#------------------------------------------------------------
# Get all matches associated with a user
@matches.route('/matches/<user_id>', methods=['GET'])
def get_matches(user_id):
    cursor = db.get_db().cursor()
    cursor.execute('''SELECT MentorID FROM matches WHERE MenteeID = %s''', (user_id))
    theData = cursor.fetchall()
    return make_response(jsonify(theData), 200)

#------------------------------------------------------------
# Get all recommended matches for a user
@matches.route('/matches/recommended/<user_id>', methods=['GET'])
def get_recommended_matches(user_id):
    cursor = db.get_db().cursor()
    cursor.execute('''SELECT MentorID FROM matches WHERE MenteeID = %s AND Recommended = 1''', (user_id))
    theData = cursor.fetchall()
    return make_response(jsonify(theData), 200)

#------------------------------------------------------------
# Get all matches associated with students and advisor advises
@matches.route('/matches/students/<advisor_id>', methods=['GET'])
def get_matches_for_students(advisor_id):
    cursor = db.get_db().cursor()
    cursor.execute('''SELECT MenteeID, MentorID FROM matches WHERE AdvisorID = %s''', (advisor_id))
    theData = cursor.fetchall()
    return make_response(jsonify(theData), 200)

#------------------------------------------------------------
# Recommend matches
@matches.route('/matches/recommended/<user_id>/<match_user_id>', methods=['POST'])
def new_match(user_id, match_user_id):
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