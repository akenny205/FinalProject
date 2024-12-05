from flask import Blueprint
from flask import request
from flask import jsonify
from flask import make_response
from flask import current_app
from backend.db_connection import db

posts = Blueprint('posts', __name__)

#------------------------------------------------------------
# Add a post
@posts.route('/createpost', methods=['POST'])
def add_post():
    post_info = request.json
    query = '''
            INSERT INTO posts (UserID, Content, PostDate, AdminID)
            VALUES (%s, %s, %s, %s);
    '''
    data = (post_info['user_id'], post_info['content'], post_info['post_date'], post_info['admin_id'])
    cursor = db.get_db().cursor()
    cursor.execute(query, data)
    db.get_db().commit()
    return 'Post created!', 201

#------------------------------------------------------------
# View posts
@posts.route('/viewposts', methods=['GET'])
def get_posts():
    try:
        cursor = db.get_db().cursor()
        query = '''
            SELECT p.UserID, p.PostID, p.Content, p.PostDate, u.fName, u.lName
            FROM posts as p JOIN users as u ON p.UserID = u.UserID
            ORDER BY p.PostDate DESC;
        '''
        cursor.execute(query)
        theData = cursor.fetchall()
        response = make_response(jsonify(theData), 200)
    except Exception as e:
        current_app.logger.error(f"Error fetching posts: {e}")
        response = make_response(jsonify({"error": "Internal Server Error"}), 500)
    return response

#------------------------------------------------------------
# Get comments on a post
@posts.route('/getcomment/<postID>', methods=['GET'])
def get_comments(postID):
    try:
        query = "SELECT * FROM comments WHERE PostID = %s"
        cursor = db.get_db().cursor()
        cursor.execute(query, (postID,))
        comments = cursor.fetchall()
        return jsonify(comments), 200
    except Exception as e:
        current_app.logger.error(f"Error fetching comments: {e}")
        return jsonify({"error": "Internal Server Error"}), 500

#------------------------------------------------------------
# Delete posts
@posts.route('/deletepost/<PostID>', methods=['DELETE'])
def delete_post(PostID):
    cursor = db.get_db().cursor()
    query = "DELETE FROM posts WHERE PostID = %s"
    cursor.execute(query, (PostID,))
    db.get_db().commit()
    return 'Post deleted!', 200

#------------------------------------------------------------
# Edit posts
@posts.route('/editpost/<PostID>', methods=['PUT'])
def edit_post(PostID):
    post_info = request.json
    query = "UPDATE posts SET Content = %s WHERE PostID = %s"
    data = (post_info['content'], PostID)
    cursor = db.get_db().cursor()
    cursor.execute(query, data)
    db.get_db().commit()
    return 'Post edited!', 200
