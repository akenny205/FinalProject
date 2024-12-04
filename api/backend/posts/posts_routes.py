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
    data = (post_info['user_id'], post_info['content'], post_info['post_date'], 
            post_info.get('admin_id'))
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
        query = """
            SELECT p.UserID, p.PostID, p.Content, p.PostDate, u.fName, u.lName
            FROM posts as p JOIN users as u ON p.UserID = u.UserID
            ORDER BY p.PostDate DESC;
        """
        cursor.execute(query)
        posts = cursor.fetchall()
        the_response = make_response(jsonify(posts))
        the_response.status_code = 200
    except Exception as e:
        current_app.logger.error(f"Error fetching posts: {e}")
        the_response = make_response(jsonify({"error": "Internal Server Error"}))
        the_response.status_code = 500

    return the_response

#------------------------------------------------------------
# Get comments on a post
@posts.route('/getcomment/<postID>', methods=['POST'])
def get_comments():
    post_id = request.json['post_id']
    query = f"SELECT * FROM comments WHERE PostID = {post_id}"
    cursor = db.get_db().cursor()
    cursor.execute(query)
    comments = cursor.fetchall()
    return jsonify(comments)

#------------------------------------------------------------
# Delete posts
@posts.route('/deletepost/<PostID>', methods=['DELETE'])
def delete_post(PostID):
    cursor = db.get_db().cursor()
    query = "DELETE FROM posts WHERE PostID = %s"
    cursor.execute(query, (PostID,))
    db.get_db().commit()
    return 'Post deleted!', 200