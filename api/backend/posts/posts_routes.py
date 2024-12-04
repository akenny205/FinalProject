from flask import Blueprint
from flask import request
from flask import jsonify
from flask import make_response
from flask import current_app
from backend.db_connection import db

posts = Blueprint('posts', __name__)

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

@posts.route('/viewposts', methods=['GET'])
def get_posts():
    cursor = db.get_db().cursor()
    query = """
        SELECT UserID, PostID, Content, PostDate
        FROM posts
        ORDER BY PostDate DESC;
    """
    cursor.execute(query)
    posts = cursor.fetchall()
    the_response = make_response(jsonify(posts))
    the_response.status_code = 200

    return the_response