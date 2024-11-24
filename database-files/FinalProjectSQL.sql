DROP DATABASE IF EXISTS finalproject;
CREATE DATABASE finalproject;

USE finalproject;

-- Admin Table (independent)
CREATE TABLE admin (
    AdminID INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    lname VARCHAR(50),
    fname VARCHAR(50)
);

-- Employers Table (independent)
CREATE TABLE employers (
    EmpID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(50),
    Description TEXT,
    AdminID INT,
    CONSTRAINT fk_employer_admin FOREIGN KEY (AdminID) REFERENCES admin(AdminID)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- Users Table (dependent on Admin and Employers)
CREATE TABLE users (
    UserID INT PRIMARY KEY AUTO_INCREMENT,
    lName VARCHAR(50),
    fName VARCHAR(50),
    Usertype VARCHAR(20) CHECK (Usertype IN ('Mentor', 'Mentee', 'Advisor')),
    joinDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    Email VARCHAR(75) UNIQUE,
    Phone VARCHAR(15),
    MentorID INT,
    Matchstatus BOOLEAN DEFAULT FALSE,
    Major VARCHAR(50),
    Minor VARCHAR(50),
    MenteeID INT,
    Semesters INT,
    numCoops INT,
    Status BOOLEAN DEFAULT TRUE,
    AdvisorID INT,
    EmpID INT,
    AdminID INT,
    Reviews TEXT,
    CONSTRAINT fk_mentor_id FOREIGN KEY (MentorID) REFERENCES users(UserID)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT fk_mentee_id FOREIGN KEY (MenteeID) REFERENCES users(UserID)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT fk_advisor_id FOREIGN KEY (AdvisorID) REFERENCES users(UserID)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT fk_employer_id FOREIGN KEY (EmpID) REFERENCES employers(EmpID)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT fk_admin_id FOREIGN KEY (AdminID) REFERENCES admin(AdminID)
        ON UPDATE CASCADE ON DELETE SET NULL
);

-- Messages Table (dependent on Users and Admin)
CREATE TABLE messages (
    MessageID INT PRIMARY KEY AUTO_INCREMENT,
    SentDate DATETIME,
    SenderID INT,
    ReceiverID INT,
    Content TEXT,
    AdminID INT,
    CONSTRAINT fk_sender FOREIGN KEY (SenderID) REFERENCES users(UserID)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_receiver FOREIGN KEY (ReceiverID) REFERENCES users(UserID)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_message_admin FOREIGN KEY (AdminID) REFERENCES admin(AdminID)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- Posts Table (dependent on Users and Admin)
CREATE TABLE posts (
    PostID INT PRIMARY KEY AUTO_INCREMENT,
    UserID INT,
    Content TEXT,
    PostDate DATETIME,
    AdminID INT,
    CONSTRAINT fk_post_user FOREIGN KEY (UserID) REFERENCES users(UserID)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_post_admin FOREIGN KEY (AdminID) REFERENCES admin(AdminID)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- Comments Table (dependent on Posts and Users)
CREATE TABLE comments (
    CommentID INT PRIMARY KEY AUTO_INCREMENT,
    PostID INT,
    CommenterID INT,
    CommentDate DATETIME,
    Content TEXT,
    CONSTRAINT fk_post_comment FOREIGN KEY (PostID) REFERENCES posts(PostID)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_commenter FOREIGN KEY (CommenterID) REFERENCES users(UserID)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- Matches Table (dependent on Users)
CREATE TABLE matches (
    MentorID INT,
    MenteeID INT,
    Recommended BOOLEAN,
    Start DATETIME,
    End DATETIME,
    Status BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (MentorID, MenteeID),
    CONSTRAINT fk_mentor FOREIGN KEY (MentorID) REFERENCES users(UserID)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_mentee FOREIGN KEY (MenteeID) REFERENCES users(UserID)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- Interests Table (dependent on Users)
CREATE TABLE interests (
    InterestID INT PRIMARY KEY AUTO_INCREMENT,
    UserID INT,
    Interest VARCHAR(50),
    CONSTRAINT fk_interest FOREIGN KEY (UserID) REFERENCES users(UserID)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- Skills Table (dependent on Users)
CREATE TABLE skills (
    SkillID INT PRIMARY KEY AUTO_INCREMENT,
    UserID INT,
    Skill VARCHAR(50),
    CONSTRAINT fk_skills FOREIGN KEY (UserID) REFERENCES users(UserID)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- Career Goals Table (dependent on Users)
CREATE TABLE career_goals (
    GoalID INT PRIMARY KEY AUTO_INCREMENT,
    UserID INT,
    Goal VARCHAR(50),
    CONSTRAINT fk_career_goals FOREIGN KEY (UserID) REFERENCES users(UserID)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- Experience Table (dependent on Users)
CREATE TABLE experience (
    ExperienceID INT PRIMARY KEY AUTO_INCREMENT,
    UserID INT,
    ExperienceName VARCHAR(50),
    Date DATETIME,
    Location VARCHAR(50),
    Description TEXT,
    CONSTRAINT fk_experience FOREIGN KEY (UserID) REFERENCES users(UserID)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- Career Path Table (dependent on Users)
CREATE TABLE career_path (
    CareerPathID INT PRIMARY KEY AUTO_INCREMENT,
    UserID INT,
    CareerPath VARCHAR(50),
    CONSTRAINT fk_career_path FOREIGN KEY (UserID) REFERENCES users(UserID)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- Jobs Table (dependent on Employers)
CREATE TABLE jobs (
    JobID INT PRIMARY KEY AUTO_INCREMENT,
    EmpID INT,
    Title VARCHAR(50),
    Description TEXT,
    CONSTRAINT fk_jobs FOREIGN KEY (EmpID) REFERENCES employers(EmpID)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- Insert into Admin table
INSERT INTO admin (AdminID, lname, fname)
VALUES
    (1, 'Smith', 'John'),
    (2, 'Doe', 'Jane'),
    (3, 'Johnson', 'Alice');

-- Insert into Employers table
INSERT INTO employers (EmpID, Name, Description, AdminID)
VALUES
    (1, 'TechCorp', 'A leading technology company', 1),
    (2, 'HealthPlus', 'Healthcare and wellness services', 2),
    (3, 'EduWorld', 'Educational services provider', 3);

-- Insert into Users table
INSERT INTO users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Major, Minor, AdminID, EmpID)
VALUES
    (1, 'Smith', 'John', 'Mentor', '2023-01-10 09:00:00', 'john.smith@example.com', '1234567890', 'Computer Science', 'Mathematics', 1, 1),
    (2, 'Johnson', 'Emily', 'Mentee', '2023-01-15 10:30:00', 'emily.johnson@example.com', '0987654321', 'Computer Science', 'Physics', 1, NULL),
    (3, 'Brown', 'Michael', 'Mentor', '2023-01-20 14:00:00', 'michael.brown@example.com', '5678901234', 'Mechanical Engineering', 'Physics', 1, 2),
    (4, 'Taylor', 'Sophia', 'Mentee', '2023-01-25 12:00:00', 'sophia.taylor@example.com', '3456789012', 'Mechanical Engineering', 'Design', 1, NULL),
    (5, 'Davis', 'Liam', 'Mentor', '2023-02-01 16:30:00', 'liam.davis@example.com', '2345678901', 'Data Science', 'Mathematics', 2, 1),
    (6, 'Martinez', 'Isabella', 'Mentee', '2023-02-10 09:15:00', 'isabella.martinez@example.com', '4567890123', 'Data Science', 'Statistics', 2, NULL),
    (7, 'Garcia', 'Oliver', 'Mentor', '2023-02-15 11:00:00', 'oliver.garcia@example.com', '5678901234', 'Biology', 'Chemistry', 3, 3),
    (8, 'Lee', 'Amelia', 'Mentee', '2023-02-20 13:00:00', 'amelia.lee@example.com', '6789012345', 'Biology', 'Environmental Science', 3, NULL),
    (9, 'Walker', 'Ethan', 'Mentor', '2023-02-25 08:30:00', 'ethan.walker@example.com', '7890123456', 'Finance', 'Economics', 1, 1),
    (10, 'Hall', 'Charlotte', 'Mentee', '2023-03-01 14:15:00', 'charlotte.hall@example.com', '8901234567', 'Finance', 'Accounting', 1, NULL),
    (11, 'Martinez', 'Carlos', 'Advisor', '2023-03-05 10:00:00', 'carlos.martinez@example.com', '1234432110', 'Business', 'Marketing', 3, NULL);

-- Insert into Messages table
INSERT INTO messages (MessageID, SentDate, SenderID, ReceiverID, Content, AdminID)
VALUES
    (1, '2023-04-01 12:00:00', 1, 2, 'Welcome to the program!', 1),
    (2, '2023-04-02 15:00:00', 2, 1, 'Thank you for your guidance.', 2),
    (3, '2023-04-03 10:00:00', 3, 1, 'Please schedule a meeting.', 3);

-- Insert into Posts table
INSERT INTO posts (PostID, UserID, Content, PostDate, AdminID)
VALUES
    (1, 1, 'Mentorship is a valuable experience!', '2023-04-05 08:00:00', 1),
    (2, 2, 'Looking forward to learning more!', '2023-04-06 10:00:00', 2),
    (3, 3, 'Advisors play a key role in guidance.', '2023-04-07 14:00:00', 3),
    (4, 4, 'Excited to help mentees learn about machine learning!', '2023-03-01 09:00:00', 1),
    (5, 5, 'Looking forward to learning from experienced mentors!', '2023-03-02 10:00:00', 2),
    (6, 6, 'Sharing my experience in data visualization with mentees.', '2023-03-03 11:00:00', 3);

-- Insert into Comments table
INSERT INTO comments (CommentID, PostID, CommenterID, CommentDate, Content)
VALUES
    (1, 1, 2, '2023-04-06 09:00:00', 'I agree!'),
    (2, 2, 1, '2023-04-07 11:00:00', 'Happy to help!'),
    (3, 3, 2, '2023-04-08 15:00:00', 'Thank you for your insights.');

-- Insert into Matches table
INSERT INTO matches (MentorID, MenteeID, Recommended, Start, End, Status)
VALUES
    (1, 2, TRUE, '2023-04-01 08:00:00', '2023-06-01 18:00:00', FALSE),
    (1, 3, FALSE, '2023-04-02 09:00:00', NULL, TRUE),
    (2, 3, TRUE, '2023-05-01 10:00:00', '2023-07-01 17:00:00', FALSE),
    (3, 4, TRUE, '2023-03-05 14:00:00', NULL, FALSE),
    (5, 6, TRUE, '2023-03-10 09:00:00', NULL, FALSE),
    (7, 8, TRUE, '2023-03-15 11:00:00', NULL, FALSE),
    (9, 10, TRUE, '2023-03-20 08:30:00', NULL, FALSE);

-- Insert into Interests table
INSERT INTO interests (InterestID, UserID, Interest)
VALUES
    (1, 1, 'Machine Learning'),
    (2, 2, 'Machine Learning'),
    (3, 3, 'Renewable Energy'),
    (4, 4, 'Renewable Energy'),
    (5, 5, 'Data Analysis'),
    (6, 6, 'Data Analysis'),
    (7, 7, 'Genetics'),
    (8, 8, 'Genetics'),
    (9, 9, 'Stock Trading'),
    (10, 10, 'Stock Trading');

-- Insert into Skills table
INSERT INTO skills (SkillID, UserID, Skill)
VALUES
    (1, 1, 'Python Programming'),
    (2, 2, 'Python Programming'),
    (3, 3, 'CAD Design'),
    (4, 4, 'CAD Design'),
    (5, 5, 'Data Visualization'),
    (6, 6, 'Data Visualization'),
    (7, 7, 'Lab Techniques'),
    (8, 8, 'Lab Techniques'),
    (9, 9, 'Financial Modeling'),
    (10, 10, 'Financial Modeling');

-- Insert into Career Goals table
INSERT INTO career_goals (GoalID, UserID, Goal)
VALUES
    (1, 1, 'Develop AI tools for healthcare'),
    (2, 2, 'Work in AI healthcare solutions'),
    (3, 3, 'Create sustainable engineering solutions'),
    (4, 4, 'Design renewable energy systems'),
    (5, 5, 'Become a Data Scientist'),
    (6, 6, 'Work in data-driven healthcare analytics'),
    (7, 7, 'Research genetic disorders'),
    (8, 8, 'Contribute to genetic therapies'),
    (9, 9, 'Build a career in Investment Banking'),
    (10, 10, 'Work in financial data analytics');

-- Insert into Experience table
INSERT INTO experience (ExperienceID, UserID, ExperienceName, Date, Location, Description)
VALUES
    (1, 1, 'Software Developer Intern', '2023-03-01 09:00:00', 'TechCorp', 'Worked on developing mobile apps'),
    (2, 2, 'Research Assistant', '2023-04-01 10:00:00', 'HealthPlus', 'Assisted in lab experiments'),
    (3, 3, 'Academic Tutor', '2023-05-01 11:00:00', 'EduWorld', 'Provided career counseling');

-- Insert into Career Path table
INSERT INTO career_path (CareerPathID, UserID, CareerPath)
VALUES
    (1, 1, 'AI Specialist'),
    (2, 2, 'Genetic Researcher'),
    (3, 3, 'Career Coach');

-- Insert into Jobs table
INSERT INTO jobs (JobID, EmpID, Title, Description)
VALUES
    (1, 1, 'Software Engineer', 'Design and develop scalable software solutions.'),
    (2, 2, 'Research Scientist', 'Conduct research in molecular biology.'),
    (3, 3, 'Academic Consultant', 'Provide academic and career guidance.');

