from flask import Blueprint
from flask import request
from flask import jsonify
from flask import make_response
from flask import current_app
from backend.db_connection import db

#------------------------------------------------------------
# Create a new Blueprint object, which is a collection of routes.
comments = Blueprint('comments', __name__)

#------------------------------------------------------------
# Add a comment
@comments.route('/createcomment', methods=['POST'])
def add_comment():
    comment_info = request.json
    query = '''
        INSERT INTO comments (CommenterID, PostID, Content, CommentDate)
        VALUES (%s, %s, %s, NOW())
    '''
    data = (comment_info['commenter_id'], comment_info['post_id'], comment_info['content'])
    cursor = db.get_db().cursor()
    cursor.execute(query, data)
    db.get_db().commit()
    return 'Comment created!', 201

#------------------------------------------------------------
# View comments on a post
@comments.route('/viewcomments/<PostID>', methods=['GET'])
def get_comments(PostID):
    try:
        cursor = db.get_db().cursor()
        query = """
            SELECT u.FirstName, u.LastName, c.Content, c.CommentDate
            FROM comments c
            JOIN users u ON c.CommenterID = u.UserID
            WHERE c.PostID = %s
            ORDER BY c.CommentDate DESC;
        """
        cursor.execute(query, (PostID,))
        comments = cursor.fetchall()
        the_response = make_response(jsonify(comments))
        the_response.status_code = 200
    except Exception as e:
        current_app.logger.error(f"Error fetching comments: {e}")
        the_response = make_response(jsonify({"error": "Internal Server Error"}))
        the_response.status_code = 500
    return the_response

#------------------------------------------------------------
# Delete comments
@comments.route('/deletecomment/<CommentID>', methods=['DELETE'])
def delete_comment(CommentID):
    cursor = db.get_db().cursor()
    query = "DELETE FROM comments WHERE CommentID = %s"
    cursor.execute(query, (CommentID,))
    db.get_db().commit()
    return 'Comment deleted!', 200

