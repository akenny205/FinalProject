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
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone) values (1, 'Scholl', 'Danell', 'Advisor', '2021-02-27 03:51:50', 'dscholl0@furl.net', '813-513-8430');
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone) values (2, 'Sainer', 'Jeniece', 'Advisor', '2020-05-19 13:04:40', 'jsainer1@edublogs.org', '126-807-5598');
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone) values (3, 'Gatrill', 'Lanny', 'Advisor', '2023-07-09 06:43:13', 'lgatrill2@japanpost.jp', '522-975-5942');
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone) values (4, 'Manilow', 'Hendrick', 'Advisor', '2024-04-21 08:08:27', 'hmanilow3@phpbb.com', '640-677-4520');
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone) values (5, 'Brockwell', 'Marika', 'Advisor', '2023-10-24 23:43:57', 'mbrockwell4@mtv.com', '168-164-9230');
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone) values (6, 'Prendiville', 'Blisse', 'Advisor', '2023-12-16 00:38:49', 'bprendiville5@cyberchimps.com', '948-684-7760');
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone) values (7, 'Goulden', 'Ralina', 'Advisor', '2024-11-18 19:40:25', 'rgoulden6@paypal.com', '964-736-2139');
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone) values (8, 'Pea', 'Shel', 'Advisor', '2023-04-18 01:36:45', 'spea7@time.com', '442-511-1167');
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (9, 'Castro', 'Lutero', 'Mentee', '2019-12-16 15:43:37', 'lcastro8@bloomberg.com', '657-638-1959', false, 'Art', null, 8, 1, 2, 5, 1, 147);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (10, 'Theaker', 'Antonius', 'Mentee', '2022-10-30 21:23:35', 'atheaker9@ucoz.ru', '287-827-9310', true, 'Business', 'Music', 4, 3, 1, 2, null, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (11, 'Lamb-shine', 'Emilio', 'Mentee', '2023-02-16 14:22:10', 'elambshinea@hexun.com', '306-702-9129', false, 'Engineering', null, 4, 2, 3, 8, null, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (12, 'Medgwick', 'Aldous', 'Mentee', '2022-10-14 07:00:12', 'amedgwickb@dmoz.org', '479-875-4704', false, 'English', 'Data Science', 7, 1, 1, 4, null, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (13, 'Drewry', 'Carmela', 'Mentee', '2020-07-03 05:20:47', 'cdrewryc@loc.gov', '281-551-5318', false, 'Art', null, 3, 1, 3, 7, null, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (14, 'Noell', 'Vinson', 'Mentee', '2022-08-09 05:37:39', 'vnoelld@yahoo.com', '983-780-6932', false, 'Engineering', 'Art', 8, 2, 2, 2, null, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (15, 'Silbermann', 'Appolonia', 'Mentee', '2020-05-04 20:14:31', 'asilbermanne@dedecms.com', '472-445-7568', true, 'Business', 'Engineering', 3, 2, 2, 5, null, 118);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (16, 'Eubank', 'Hilliard', 'Mentee', '2022-10-12 21:50:11', 'heubankf@drupal.org', '546-218-8021', true, 'English', 'Computer Science', 7, 3, 3, 7, null, 182);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (17, 'Sellwood', 'Ezmeralda', 'Mentee', '2023-09-07 09:34:46', 'esellwoodg@webs.com', '896-386-4994', true, 'Art', 'Political Science', 3, 3, 1, 2, null, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (18, 'Balch', 'Dene', 'Mentee', '2023-03-06 13:49:13', 'dbalchh@google.co.uk', '802-384-3712', false, 'Computer Science', null, 10, 3, 2, 8, null, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (19, 'Yon', 'Isidor', 'Mentee', '2024-08-20 23:35:49', 'iyoni@163.com', '856-419-8931', true, 'English', null, 4, 1, 2, 5, null, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (20, 'Devonshire', 'Andy', 'Mentee', '2020-10-19 03:53:20', 'adevonshirej@tmall.com', '693-791-4378', false, 'Data Science', 'Business', 1, 1, 3, 3, null, 199);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (21, 'Bottoner', 'Pippo', 'Mentee', '2021-04-05 08:46:12', 'pbottonerk@forbes.com', '284-158-2049', false, 'Math', null, 8, 3, 1, 5, null, 126);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (22, 'Huikerby', 'Moyna', 'Mentee', '2022-04-15 00:02:13', 'mhuikerbyl@deliciousdays.com', '309-866-0617', false, 'Political Science', null, 9, 1, 3, 2, 2, 156);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (23, 'Breche', 'Franni', 'Mentee', '2023-01-18 22:18:54', 'fbrechem@furl.net', '627-923-2045', true, 'Health Sciences', 'Data Science', 1, 1, 2, 6, null, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (24, 'Milsom', 'Jamil', 'Mentee', '2023-12-26 09:27:57', 'jmilsomn@mayoclinic.com', '393-648-8515', false, 'Music', 'Engineering', 7, 3, 2, 6, null, 187);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (25, 'Marland', 'Orion', 'Mentee', '2022-09-26 05:27:26', 'omarlando@hao123.com', '567-334-8720', true, 'English', 'Math', 7, 3, 2, 1, null, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (26, 'Autin', 'Ddene', 'Mentee', '2024-03-20 07:17:39', 'dautinp@imdb.com', '129-483-8986', false, 'Political Science', 'Math', 4, 1, 3, 7, null, 183);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (27, 'Dimitrijevic', 'Maribelle', 'Mentee', '2022-01-23 19:54:18', 'mdimitrijevicq@google.it', '371-410-7532', true, 'Music', null, 7, 2, 3, 3, null, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (28, 'Crothers', 'Doralyn', 'Mentee', '2021-05-24 01:17:33', 'dcrothersr@so-net.ne.jp', '401-554-1780', false, 'Data Science', 'Math', 1, 2, 2, 7, null, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (29, 'McFaul', 'Bartlett', 'Mentee', '2021-09-25 19:57:17', 'bmcfauls@bizjournals.com', '472-450-3466', false, 'Health Sciences', 'Computer Science', 1, 1, 2, 5, null, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (30, 'de Copeman', 'Nils', 'Mentee', '2022-12-26 02:26:10', 'ndecopemant@goo.gl', '910-749-5405', true, 'Music', 'Data Science', 2, 3, 2, 3, null, 192);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (31, 'Denness', 'Violet', 'Mentee', '2021-12-28 10:49:30', 'vdennessu@istockphoto.com', '583-183-1855', true, 'Music', 'Health Sciences', 6, 3, 2, 4, null, 176);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (32, 'Raspel', 'Krisha', 'Mentee', '2024-03-02 02:43:39', 'kraspelv@ebay.com', '538-480-5140', true, 'Engineering', null, 7, 1, 1, 3, null, 192);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (33, 'Baitson', 'Jackquelin', 'Mentee', '2020-01-21 16:54:58', 'jbaitsonw@wired.com', '351-680-2693', false, 'English', 'Health Sciences', 8, 1, 2, 5, null, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (34, 'Langdon', 'Malvin', 'Mentee', '2024-04-22 21:48:51', 'mlangdonx@alibaba.com', '200-845-5776', false, 'Music', null, 5, 2, 3, 6, null, 107);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (35, 'Pitcher', 'Stillman', 'Mentee', '2020-06-18 23:08:23', 'spitchery@gnu.org', '809-147-3214', true, 'Computer Science', null, 5, 2, 1, 6, null, 146);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (36, 'Seville', 'Meta', 'Mentee', '2024-03-12 16:49:25', 'msevillez@amazon.co.jp', '868-456-1338', true, 'Computer Science', 'Music', 10, 2, 2, 4, null, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (37, 'Mark', 'Carl', 'Mentee', '2020-03-27 08:13:23', 'cmark10@163.com', '345-340-2575', true, 'Data Science', null, 10, 1, 1, 5, null, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (38, 'Coche', 'Lissi', 'Mentee', '2022-04-06 20:16:12', 'lcoche11@reddit.com', '772-448-0257', false, 'Data Science', 'Business', 9, 1, 2, 6, null, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (39, 'How to preserve', 'Yorgo', 'Mentee', '2021-01-21 05:26:49', 'yhowtopreserve12@xrea.com', '927-712-5425', false, 'Computer Science', null, 5, 3, 2, 7, null, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (40, 'Pullman', 'Hammad', 'Mentee', '2021-12-01 19:18:39', 'hpullman13@is.gd', '699-305-9939', true, 'English', null, 6, 3, 1, 4, null, 185);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (41, 'Druett', 'Oren', 'Mentee', '2023-10-03 04:29:48', 'odruett14@blog.com', '809-386-5740', false, 'Computer Science', null, 5, 3, 3, 6, null, 196);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (42, 'Gynne', 'Estell', 'Mentee', '2020-05-30 13:20:13', 'egynne15@imdb.com', '922-779-8328', true, 'Art', null, 2, 1, 1, 3, 2, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (43, 'Duckit', 'Petronella', 'Mentee', '2023-06-06 00:21:20', 'pduckit16@answers.com', '636-503-5488', true, 'Engineering', 'Art', 8, 3, 1, 1, null, 196);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (44, 'Popland', 'Ronna', 'Mentee', '2021-04-21 11:33:12', 'rpopland17@github.io', '236-539-9734', false, 'Data Science', 'Music', 7, 2, 2, 4, null, 175);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (45, 'Longson', 'Jori', 'Mentee', '2022-06-24 09:37:17', 'jlongson18@microsoft.com', '986-355-2640', false, 'Math', 'Math', 5, 1, 3, 1, null, 125);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (46, 'Seary', 'Kat', 'Mentee', '2019-10-07 09:19:14', 'kseary19@123-reg.co.uk', '961-458-2844', false, 'Health Sciences', 'Computer Science', 7, 2, 2, 4, null, 149);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (47, 'Dell''Abbate', 'Raynard', 'Mentee', '2021-01-30 04:55:35', 'rdellabbate1a@statcounter.com', '285-791-3506', false, 'Math', 'Music', 8, 1, 1, 5, null, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (48, 'Wiffen', 'Adaline', 'Mentee', '2020-12-23 00:08:52', 'awiffen1b@washingtonpost.com', '286-859-7429', true, 'Engineering', 'Art', 2, 1, 1, 6, null, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (49, 'Leynham', 'Lefty', 'Mentee', '2023-05-09 00:43:21', 'lleynham1c@virginia.edu', '875-513-4991', true, 'Business', 'Music', 2, 3, 3, 4, null, 109);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (50, 'Gorthy', 'Amity', 'Mentee', '2024-01-01 01:14:15', 'agorthy1d@drupal.org', '676-979-5928', true, 'Art', 'Art', 6, 3, 1, 1, 1, 105);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (51, 'Dawtre', 'Penelopa', 'Mentee', '2022-10-02 18:17:57', 'pdawtre1e@wikispaces.com', '400-294-7932', false, 'Art', 'English', 4, 1, 3, 4, 3, 199);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (52, 'Keywood', 'Beckie', 'Mentee', '2020-03-19 19:28:19', 'bkeywood1f@ihg.com', '269-902-8353', true, 'Health Sciences', 'Business', 1, 2, 2, 7, null, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (53, 'McEneny', 'Dorie', 'Mentee', '2024-04-12 22:27:53', 'dmceneny1g@unesco.org', '227-362-4198', true, 'Music', 'Political Science', 7, 3, 3, 4, 2, 110);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (54, 'Trunks', 'Doro', 'Mentee', '2021-04-06 21:00:28', 'dtrunks1h@timesonline.co.uk', '141-808-3877', true, 'Art', null, 9, 2, 3, 7, null, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (55, 'Arrighetti', 'Orland', 'Mentee', '2023-03-18 18:28:39', 'oarrighetti1i@artisteer.com', '492-525-1435', true, 'Health Sciences', null, 1, 1, 1, 2, null, 193);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (56, 'Peggs', 'Adaline', 'Mentee', '2021-12-14 03:40:15', 'apeggs1j@yolasite.com', '259-683-3182', true, 'Engineering', 'Health Sciences', 2, 2, 3, 5, null, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (57, 'Barkly', 'Serena', 'Mentee', '2024-05-15 09:18:56', 'sbarkly1k@google.fr', '175-726-3266', false, 'Art', null, 6, 1, 2, 5, null, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (58, 'Kinforth', 'Marys', 'Mentee', '2023-11-19 13:39:11', 'mkinforth1l@woothemes.com', '510-214-7597', false, 'English', null, 4, 3, 3, 7, null, 135);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (59, 'Allatt', 'Lilly', 'Mentee', '2019-12-02 08:10:11', 'lallatt1m@w3.org', '115-914-2039', true, 'Engineering', 'Engineering', 9, 3, 3, 1, null, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (60, 'Brackpool', 'Jaimie', 'Mentee', '2023-10-30 12:22:40', 'jbrackpool1n@usatoday.com', '660-133-2353', true, 'Computer Science', null, 8, 3, 1, 2, 2, 110);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (61, 'Inglesfield', 'Tome', 'Mentee', '2022-06-10 21:20:36', 'tinglesfield1o@skype.com', '510-182-9703', true, 'English', null, 1, 2, 3, 1, null, 175);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (62, 'Wint', 'Michell', 'Mentee', '2022-06-11 17:10:22', 'mwint1p@printfriendly.com', '577-456-6523', false, 'Art', 'Business', 5, 1, 1, 6, null, 192);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (63, 'Vittery', 'Allistir', 'Mentee', '2022-12-27 01:33:33', 'avittery1q@youtube.com', '565-121-8194', false, 'Data Science', null, 8, 1, 1, 8, null, 155);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (64, 'Bernade', 'Rhiamon', 'Mentee', '2024-03-25 13:14:17', 'rbernade1r@google.nl', '252-412-1938', false, 'Math', null, 10, 1, 2, 4, null, 190);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (65, 'Ricciardelli', 'Theodore', 'Mentee', '2021-02-10 13:59:44', 'tricciardelli1s@yelp.com', '763-177-6039', false, 'Political Science', 'Engineering', 9, 1, 2, 4, null, 191);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (66, 'Chrestien', 'Elwyn', 'Mentee', '2020-10-18 11:39:29', 'echrestien1t@mashable.com', '212-561-5973', true, 'Data Science', null, 1, 1, 3, 7, null, 111);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (67, 'Purvis', 'Curtis', 'Mentee', '2024-06-16 06:44:07', 'cpurvis1u@smh.com.au', '215-317-0952', false, 'Engineering', 'Art', 1, 2, 2, 1, 1, 165);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (68, 'Ryde', 'Tulley', 'Mentee', '2023-08-11 04:31:22', 'tryde1v@joomla.org', '579-998-9191', false, 'Math', 'Computer Science', 9, 1, 3, 4, 3, 148);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (69, 'Angless', 'Iormina', 'Mentee', '2021-08-30 14:46:22', 'iangless1w@webnode.com', '792-327-3979', true, 'English', null, 2, 2, 3, 8, null, 141);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (70, 'Knightly', 'Morris', 'Mentee', '2022-10-23 05:16:37', 'mknightly1x@dion.ne.jp', '392-121-6272', false, 'Business', null, 4, 3, 3, 4, 1, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (71, 'Rembrant', 'Blancha', 'Mentee', '2022-08-30 10:20:37', 'brembrant1y@wikispaces.com', '302-741-7979', true, 'English', 'English', 7, 1, 1, 3, null, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (72, 'Soonhouse', 'Kata', 'Mentee', '2022-10-17 02:44:57', 'ksoonhouse1z@wikispaces.com', '182-609-2726', true, 'Business', null, 7, 1, 2, 5, null, 192);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (73, 'Baugh', 'Mayor', 'Mentee', '2019-11-05 18:27:42', 'mbaugh20@i2i.jp', '540-992-5775', false, 'Business', 'Music', 9, 1, 2, 2, null, 118);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (74, 'Yarrell', 'Nerta', 'Mentee', '2020-12-04 05:32:51', 'nyarrell21@freewebs.com', '256-997-3602', false, 'Music', 'Political Science', 5, 1, 2, 6, null, 119);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (75, 'Fiddymont', 'Thurston', 'Mentee', '2023-08-27 14:44:46', 'tfiddymont22@phoca.cz', '198-404-6214', true, 'Music', 'English', 7, 1, 2, 8, null, 168);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (76, 'Letch', 'Nedda', 'Mentee', '2024-06-25 18:00:31', 'nletch23@comcast.net', '934-803-8744', true, 'Music', null, 6, 1, 2, 2, null, 154);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (77, 'Olennikov', 'Rodney', 'Mentee', '2024-08-20 01:04:46', 'rolennikov24@fotki.com', '806-774-1501', false, 'Music', null, 7, 3, 1, 8, null, 106);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (78, 'Vardey', 'Flemming', 'Mentee', '2021-02-24 02:27:29', 'fvardey25@symantec.com', '148-198-1340', false, 'English', 'Political Science', 7, 2, 1, 6, null, 124);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (79, 'Bricham', 'Juliet', 'Mentee', '2023-08-15 05:41:04', 'jbricham26@microsoft.com', '539-642-8445', false, 'Health Sciences', null, 7, 3, 3, 8, null, 194);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (80, 'MacGillavery', 'Jareb', 'Mentee', '2024-02-26 17:47:46', 'jmacgillavery27@meetup.com', '661-111-9816', false, 'Political Science', 'Math', 4, 2, 3, 1, null, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (81, 'Robardley', 'Olivia', 'Mentee', '2022-10-10 11:19:51', 'orobardley28@weibo.com', '540-744-1629', true, 'Engineering', 'Computer Science', 8, 1, 1, 2, null, 179);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (82, 'Whiscard', 'Edithe', 'Mentee', '2021-01-20 20:41:53', 'ewhiscard29@house.gov', '234-233-8344', true, 'Music', 'English', 6, 3, 1, 2, 1, 189);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (83, 'O''Shevlan', 'Rina', 'Mentee', '2020-06-12 15:27:54', 'roshevlan2a@netscape.com', '140-412-7535', false, 'Data Science', null, 5, 3, 2, 4, null, 148);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (84, 'Tomasz', 'Lanae', 'Mentee', '2022-03-27 09:16:27', 'ltomasz2b@chron.com', '240-897-2832', false, 'Data Science', null, 5, 1, 2, 4, null, 106);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (85, 'Holson', 'Christel', 'Mentee', '2020-08-15 06:21:53', 'cholson2c@ow.ly', '593-679-5131', true, 'Art', 'Music', 5, 2, 3, 5, null, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (86, 'Fleckness', 'Mychal', 'Mentee', '2020-06-29 14:40:55', 'mfleckness2d@squidoo.com', '994-680-8824', true, 'English', 'Math', 10, 1, 1, 4, null, 114);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (87, 'Cheke', 'Obed', 'Mentee', '2024-07-21 03:19:36', 'ocheke2e@dot.gov', '656-827-2879', true, 'Math', null, 4, 3, 3, 1, null, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (88, 'Twigg', 'Melvyn', 'Mentee', '2023-02-07 22:36:25', 'mtwigg2f@hhs.gov', '897-807-4136', false, 'Business', 'Health Sciences', 8, 3, 1, 8, null, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (89, 'Matuszak', 'Raphaela', 'Mentee', '2020-05-09 11:56:11', 'rmatuszak2g@hc360.com', '234-867-4142', true, 'English', 'Art', 2, 1, 3, 1, null, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (90, 'Fragino', 'Brigit', 'Mentee', '2024-02-21 18:31:37', 'bfragino2h@ucoz.ru', '859-882-7383', false, 'Art', 'Political Science', 4, 1, 3, 4, null, 186);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (91, 'Adelman', 'Andreas', 'Mentee', '2023-07-08 15:34:12', 'aadelman2i@slashdot.org', '804-821-5714', true, 'Computer Science', null, 8, 3, 2, 7, null, 130);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (92, 'Worsham', 'Abagail', 'Mentee', '2023-04-12 02:37:52', 'aworsham2j@t.co', '681-992-7672', false, 'Health Sciences', null, 9, 2, 2, 2, null, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (93, 'Broadey', 'Thibaud', 'Mentee', '2022-03-19 05:00:36', 'tbroadey2k@phpbb.com', '609-285-7331', true, 'Music', 'Health Sciences', 6, 2, 2, 6, 3, 111);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (94, 'Daveridge', 'Padraic', 'Mentee', '2024-01-08 13:06:31', 'pdaveridge2l@creativecommons.org', '230-686-3065', false, 'Computer Science', null, 6, 2, 2, 4, null, 140);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (95, 'Darth', 'Ralph', 'Mentee', '2022-04-05 10:51:43', 'rdarth2m@goo.gl', '695-394-7077', true, 'Math', null, 5, 3, 3, 8, null, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (96, 'Hatfield', 'Raquela', 'Mentee', '2023-02-17 22:12:52', 'rhatfield2n@java.com', '868-392-7872', false, 'Computer Science', 'English', 7, 1, 3, 7, null, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (97, 'Capnerhurst', 'Riki', 'Mentee', '2019-09-09 16:23:42', 'rcapnerhurst2o@lycos.com', '700-379-5187', false, 'Music', null, 9, 2, 3, 3, null, 118);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (98, 'Tremlett', 'Oates', 'Mentee', '2020-07-16 17:20:34', 'otremlett2p@friendfeed.com', '902-627-9244', true, 'Music', null, 3, 3, 3, 2, 2, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (99, 'Sussex', 'Robinson', 'Mentee', '2024-06-17 02:28:56', 'rsussex2q@psu.edu', '817-158-8200', false, 'Art', 'Health Sciences', 7, 1, 3, 3, 1, 157);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID) values (100, 'Cockshot', 'Linc', 'Mentee', '2024-08-27 16:07:10', 'lcockshot2r@sohu.com', '409-895-2647', false, 'Art', 'Computer Science', 7, 2, 3, 6, null, 110);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (101, 'Fairham', 'Codi', 'Mentor', '2024-10-31 20:15:28', 'cfairham2s@geocities.jp', '427-830-4024', false, 'Computer Science', 'Math', 3, 1, 1, 5, 3, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (102, 'Alvin', 'Hyacinthie', 'Mentor', '2022-04-26 06:52:03', 'halvin2t@theglobeandmail.com', '331-860-1388', false, 'Data Science', 'Health Sciences', 1, 2, 3, 1, 2, 66);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (103, 'Hastie', 'Shaughn', 'Mentor', '2019-10-16 10:48:25', 'shastie2u@independent.co.uk', '100-538-1435', false, 'Computer Science', null, 5, 1, 2, 7, 1, 86);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (104, 'Sapsford', 'Johnathan', 'Mentor', '2024-06-18 13:26:32', 'jsapsford2v@fotki.com', '543-628-1380', true, 'Health Sciences', 'Art', 4, 1, 3, 4, 2, 34);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (105, 'Pacey', 'Dur', 'Mentor', '2020-11-10 14:53:14', 'dpacey2w@privacy.gov.au', '373-557-1977', true, 'Music', 'Data Science', 10, 2, 3, 1, null, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (106, 'Trayhorn', 'Cordi', 'Mentor', '2024-09-25 05:31:39', 'ctrayhorn2x@simplemachines.org', '175-588-3995', false, 'Music', 'Computer Science', 5, 3, 2, 6, null, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (107, 'McCawley', 'Oliviero', 'Mentor', '2019-09-18 08:01:09', 'omccawley2y@businessweek.com', '685-220-9316', true, 'Computer Science', null, 10, 2, 1, 7, 1, 82);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (108, 'Corter', 'Gustie', 'Mentor', '2023-05-24 11:31:09', 'gcorter2z@yandex.ru', '166-478-1120', true, 'Business', 'Music', 4, 1, 3, 8, 1, 47);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (109, 'Rean', 'Deane', 'Mentor', '2022-08-10 12:44:18', 'drean30@spiegel.de', '429-681-3935', true, 'Math', null, 9, 3, 3, 2, null, 31);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (110, 'Heinicke', 'Sidnee', 'Mentor', '2024-01-05 03:40:08', 'sheinicke31@geocities.jp', '844-763-5767', false, 'Art', 'Music', 10, 1, 2, 2, 2, 83);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (111, 'Vogeler', 'Juliana', 'Mentor', '2021-03-04 02:57:27', 'jvogeler32@i2i.jp', '496-605-7389', false, 'Business', 'Engineering', 6, 2, 2, 6, 1, 29);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (112, 'Blackledge', 'Samuele', 'Mentor', '2020-10-16 08:46:13', 'sblackledge33@ed.gov', '488-179-1120', false, 'Computer Science', null, 1, 3, 1, 4, 3, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (113, 'Skupinski', 'Mira', 'Mentor', '2019-09-22 10:12:55', 'mskupinski34@youku.com', '896-565-4393', false, 'Health Sciences', 'Health Sciences', 3, 2, 1, 2, 1, 39);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (114, 'Jessope', 'Latrena', 'Mentor', '2023-05-29 15:29:43', 'ljessope35@w3.org', '246-740-2540', true, 'Art', null, 1, 3, 1, 5, 3, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (115, 'Birdis', 'Bryna', 'Mentor', '2023-10-05 11:26:45', 'bbirdis36@cbc.ca', '966-698-2165', false, 'Math', 'Health Sciences', 7, 1, 1, 7, 3, 38);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (116, 'Mayell', 'Elwood', 'Mentor', '2022-12-18 20:24:39', 'emayell37@theatlantic.com', '436-306-6196', true, 'Math', null, 5, 1, 3, 3, 3, 24);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (117, 'Cathee', 'Adrianna', 'Mentor', '2023-08-04 19:02:28', 'acathee38@dmoz.org', '549-960-4437', false, 'Engineering', 'Music', 3, 2, 3, 5, null, 56);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (118, 'Fain', 'Mallory', 'Mentor', '2019-12-03 03:05:16', 'mfain39@squidoo.com', '929-474-2075', false, 'Art', 'Data Science', 9, 2, 1, 1, 2, 32);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (119, 'Clinnick', 'Demeter', 'Mentor', '2022-04-19 13:57:32', 'dclinnick3a@nsw.gov.au', '663-991-6626', true, 'Art', 'English', 6, 1, 2, 1, null, 67);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (120, 'Ruspine', 'Aurie', 'Mentor', '2019-12-26 21:34:20', 'aruspine3b@discuz.net', '682-223-0679', false, 'Computer Science', 'Data Science', 8, 1, 3, 4, null, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (121, 'Barradell', 'Merridie', 'Mentor', '2024-10-04 12:57:55', 'mbarradell3c@4shared.com', '316-268-0191', false, 'Engineering', 'Political Science', 9, 3, 3, 8, 1, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (122, 'Stukings', 'Lissy', 'Mentor', '2024-04-01 23:41:22', 'lstukings3d@i2i.jp', '235-616-3070', false, 'Business', 'Health Sciences', 4, 3, 2, 1, 1, 74);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (123, 'Espinas', 'Gwynne', 'Mentor', '2024-11-15 23:10:19', 'gespinas3e@acquirethisname.com', '731-558-6577', true, 'Music', null, 6, 1, 1, 5, 3, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (124, 'Rubinfeld', 'Lanette', 'Mentor', '2021-07-20 00:25:17', 'lrubinfeld3f@canalblog.com', '440-315-4621', true, 'Political Science', null, 6, 1, 2, 6, 3, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (125, 'Fargie', 'Susie', 'Mentor', '2023-07-07 18:39:18', 'sfargie3g@nsw.gov.au', '128-146-9024', true, 'English', null, 2, 1, 3, 4, 3, 58);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (126, 'Gorsse', 'Fabe', 'Mentor', '2023-05-20 04:40:11', 'fgorsse3h@instagram.com', '443-921-1911', false, 'Business', null, 1, 3, 3, 5, 2, 18);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (127, 'Deviney', 'Al', 'Mentor', '2020-02-06 02:25:03', 'adeviney3i@e-recht24.de', '108-255-8474', false, 'Art', 'Art', 5, 3, 2, 3, 1, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (128, 'Bernardi', 'Schuyler', 'Mentor', '2023-07-10 18:01:22', 'sbernardi3j@boston.com', '154-958-5053', true, 'Math', null, 2, 1, 2, 4, 1, 53);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (129, 'Mattes', 'Burke', 'Mentor', '2023-07-07 01:14:25', 'bmattes3k@icio.us', '745-746-9662', true, 'Health Sciences', 'Engineering', 5, 1, 2, 2, 2, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (130, 'Eustace', 'Evangelin', 'Mentor', '2020-07-20 10:58:05', 'eeustace3l@home.pl', '555-219-1656', false, 'Engineering', 'Computer Science', 5, 1, 1, 4, 2, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (131, 'Vezey', 'Ludvig', 'Mentor', '2024-08-09 05:03:49', 'lvezey3m@elpais.com', '510-149-2697', true, 'Computer Science', 'Data Science', 5, 3, 1, 7, 1, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (132, 'Pickless', 'Vasili', 'Mentor', '2021-05-07 20:20:13', 'vpickless3n@arizona.edu', '672-912-4743', false, 'Math', 'Math', 6, 1, 3, 1, 3, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (133, 'Bowmen', 'Paulette', 'Mentor', '2019-12-31 23:17:33', 'pbowmen3o@vistaprint.com', '718-315-7478', false, 'Data Science', 'Political Science', 4, 2, 2, 8, 3, 51);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (134, 'Deelay', 'Baron', 'Mentor', '2023-10-19 00:46:15', 'bdeelay3p@spotify.com', '455-594-4263', true, 'Data Science', 'Data Science', 8, 1, 1, 4, 1, 58);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (135, 'Dorant', 'Susette', 'Mentor', '2020-10-21 00:59:45', 'sdorant3q@ft.com', '889-847-4216', false, 'Math', null, 2, 3, 3, 6, 2, 98);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (136, 'Sibley', 'Courtney', 'Mentor', '2021-05-22 17:31:07', 'csibley3r@reference.com', '496-209-4441', true, 'Music', null, 7, 1, 2, 4, 3, 84);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (137, 'McCotter', 'Nissie', 'Mentor', '2021-07-08 07:29:22', 'nmccotter3s@ameblo.jp', '938-787-0922', true, 'Engineering', 'Health Sciences', 6, 1, 3, 6, 2, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (138, 'Merricks', 'Vern', 'Mentor', '2020-06-25 02:02:16', 'vmerricks3t@photobucket.com', '206-717-1523', false, 'Computer Science', 'Engineering', 6, 2, 2, 2, 2, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (139, 'Diggons', 'Veronique', 'Mentor', '2024-09-13 03:30:52', 'vdiggons3u@github.io', '252-512-7169', false, 'Data Science', 'Health Sciences', 5, 1, 1, 5, 2, 70);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (140, 'Jorge', 'Ilse', 'Mentor', '2024-06-11 21:36:59', 'ijorge3v@yahoo.co.jp', '363-594-4085', false, 'Computer Science', 'Art', 9, 2, 3, 6, 2, 88);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (141, 'Maylour', 'Gar', 'Mentor', '2022-12-15 23:56:51', 'gmaylour3w@edublogs.org', '721-739-9317', true, 'Health Sciences', 'Engineering', 9, 1, 1, 2, 2, 71);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (142, 'Prettyjohns', 'Bayard', 'Mentor', '2020-11-14 17:19:04', 'bprettyjohns3x@wsj.com', '316-332-4822', false, 'Math', null, 3, 1, 2, 8, 2, 37);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (143, 'Crow', 'Idell', 'Mentor', '2021-06-15 19:24:03', 'icrow3y@youtu.be', '907-113-0441', false, 'Health Sciences', null, 7, 1, 3, 2, 3, 57);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (144, 'Gabits', 'Henka', 'Mentor', '2023-05-22 02:32:30', 'hgabits3z@php.net', '809-946-0443', false, 'Computer Science', 'Engineering', 10, 1, 2, 6, 2, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (145, 'Deshorts', 'Karim', 'Mentor', '2019-11-12 09:15:34', 'kdeshorts40@blog.com', '201-335-4419', true, 'Math', null, 10, 3, 2, 6, 3, 27);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (146, 'Runciman', 'Davey', 'Mentor', '2020-04-07 16:56:18', 'drunciman41@live.com', '376-961-8042', true, 'Math', 'Engineering', 5, 3, 1, 2, 1, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (147, 'Cristofolo', 'Ermengarde', 'Mentor', '2019-11-14 19:09:14', 'ecristofolo42@statcounter.com', '568-580-7873', false, 'Math', 'Math', 7, 3, 1, 2, 3, 64);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (148, 'Slimme', 'Thorpe', 'Mentor', '2022-05-18 00:46:53', 'tslimme43@state.gov', '203-857-1698', true, 'Engineering', 'Business', 1, 3, 2, 8, 2, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (149, 'Derisly', 'Alethea', 'Mentor', '2023-02-08 00:27:41', 'aderisly44@topsy.com', '887-871-3591', false, 'Engineering', null, 5, 1, 1, 7, 1, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (150, 'Woolf', 'Towney', 'Mentor', '2023-08-06 11:14:13', 'twoolf45@nps.gov', '656-777-6740', false, 'Math', 'Engineering', 9, 1, 3, 1, null, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (151, 'Roncelli', 'Stirling', 'Mentor', '2021-01-04 02:50:12', 'sroncelli46@rambler.ru', '632-663-8584', true, 'Political Science', 'Engineering', 9, 2, 3, 8, 2, 86);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (152, 'Kornyshev', 'Marne', 'Mentor', '2021-12-13 13:07:47', 'mkornyshev47@boston.com', '482-134-8244', true, 'Art', 'Engineering', 2, 1, 3, 6, 2, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (153, 'Storrock', 'Joete', 'Mentor', '2020-01-07 20:55:25', 'jstorrock48@hexun.com', '850-484-8536', true, 'Math', 'Math', 8, 1, 3, 8, 1, 93);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (154, 'Clempton', 'Andy', 'Mentor', '2023-02-24 01:01:48', 'aclempton49@boston.com', '113-286-4711', true, 'Data Science', null, 7, 1, 3, 4, 2, 40);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (155, 'Bathersby', 'Reube', 'Mentor', '2024-08-11 20:42:15', 'rbathersby4a@jiathis.com', '671-114-8004', false, 'Math', 'Engineering', 8, 3, 2, 5, 1, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (156, 'Griffiths', 'Odell', 'Mentor', '2022-01-02 06:14:54', 'ogriffiths4b@state.gov', '291-565-7129', false, 'Engineering', 'Music', 10, 1, 1, 4, 3, 69);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (157, 'Flanner', 'Adan', 'Mentor', '2024-08-11 15:46:43', 'aflanner4c@joomla.org', '748-787-5515', true, 'Math', 'English', 7, 2, 2, 2, null, 78);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (158, 'Troak', 'Arel', 'Mentor', '2024-05-02 16:39:17', 'atroak4d@tamu.edu', '165-660-5943', false, 'Computer Science', null, 4, 1, 1, 4, 3, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (159, 'Wallett', 'Fanchette', 'Mentor', '2021-06-18 23:56:50', 'fwallett4e@cafepress.com', '572-512-3529', false, 'Political Science', 'Computer Science', 10, 1, 2, 3, 1, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (160, 'Lempke', 'Ichabod', 'Mentor', '2022-07-24 03:15:15', 'ilempke4f@cdc.gov', '202-300-5994', false, 'English', null, 4, 1, 1, 7, 3, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (161, 'Swain', 'Haroun', 'Mentor', '2021-06-29 05:22:54', 'hswain4g@yellowpages.com', '184-428-5301', true, 'Computer Science', 'Math', 6, 2, 3, 5, 2, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (162, 'Lillow', 'Roby', 'Mentor', '2024-02-23 16:12:39', 'rlillow4h@360.cn', '713-643-8127', false, 'English', 'English', 3, 1, 2, 5, null, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (163, 'Greatrakes', 'Neddy', 'Mentor', '2021-08-12 21:47:04', 'ngreatrakes4i@state.gov', '974-831-7709', true, 'English', 'Business', 9, 1, 2, 7, 1, 80);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (164, 'Fursland', 'Kristo', 'Mentor', '2023-12-15 15:08:34', 'kfursland4j@unesco.org', '714-321-3468', true, 'Health Sciences', 'Health Sciences', 9, 3, 2, 5, 2, 68);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (165, 'Devo', 'Paula', 'Mentor', '2020-02-05 17:13:54', 'pdevo4k@aboutads.info', '956-315-0603', false, 'Political Science', 'Data Science', 1, 2, 3, 6, 3, 58);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (166, 'Brinkley', 'Mattie', 'Mentor', '2021-04-21 18:25:15', 'mbrinkley4l@reddit.com', '582-481-6620', false, 'Math', null, 2, 2, 1, 2, 2, 90);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (167, 'Rossborough', 'Jacquenetta', 'Mentor', '2021-09-17 03:36:02', 'jrossborough4m@geocities.jp', '540-348-8737', false, 'Data Science', 'Art', 5, 2, 1, 8, 2, 86);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (168, 'Pharro', 'Dre', 'Mentor', '2020-12-24 11:34:31', 'dpharro4n@usgs.gov', '567-270-1765', true, 'Political Science', 'Health Sciences', 1, 2, 2, 5, null, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (169, 'Dunthorne', 'Clemens', 'Mentor', '2023-06-09 05:22:47', 'cdunthorne4o@photobucket.com', '565-649-8637', false, 'Health Sciences', 'Computer Science', 5, 1, 3, 6, 3, 18);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (170, 'Loche', 'Welch', 'Mentor', '2023-04-22 02:29:10', 'wloche4p@tiny.cc', '270-252-6864', false, 'Engineering', 'Math', 6, 2, 1, 1, null, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (171, 'Laffan', 'Elfrida', 'Mentor', '2021-03-14 08:19:33', 'elaffan4q@sfgate.com', '499-642-3127', false, 'English', 'Music', 4, 3, 2, 8, null, 47);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (172, 'Thornally', 'Merrick', 'Mentor', '2022-03-01 07:06:51', 'mthornally4r@icio.us', '679-512-5414', false, 'Business', 'Math', 10, 3, 1, 5, 3, 71);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (173, 'Dyball', 'Stacey', 'Mentor', '2024-06-21 19:45:36', 'sdyball4s@tumblr.com', '747-854-5969', true, 'Engineering', null, 3, 1, 2, 3, 1, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (174, 'Davall', 'Ronica', 'Mentor', '2023-05-27 12:44:24', 'rdavall4t@weebly.com', '380-774-8162', false, 'Data Science', 'Music', 6, 2, 1, 7, 3, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (175, 'Bilofsky', 'Hobard', 'Mentor', '2020-02-23 02:45:47', 'hbilofsky4u@ed.gov', '511-880-1480', false, 'Math', null, 10, 2, 3, 6, 2, 100);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (176, 'Ianne', 'Oriana', 'Mentor', '2023-06-22 13:14:50', 'oianne4v@behance.net', '640-523-9579', false, 'Political Science', null, 6, 2, 1, 7, 2, 41);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (177, 'Sydenham', 'Ambrosio', 'Mentor', '2022-07-12 06:09:59', 'asydenham4w@odnoklassniki.ru', '102-767-9543', true, 'Math', null, 9, 2, 1, 1, 1, 51);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (178, 'Muller', 'Ania', 'Mentor', '2022-02-10 07:20:32', 'amuller4x@google.nl', '373-842-8673', true, 'Health Sciences', 'Computer Science', 1, 3, 2, 7, 1, 12);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (179, 'Scamal', 'Isabelita', 'Mentor', '2020-08-19 09:06:41', 'iscamal4y@wordpress.org', '770-694-2330', false, 'Data Science', 'Math', 6, 2, 1, 6, null, 71);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (180, 'Isakovitch', 'Candis', 'Mentor', '2021-04-29 18:39:36', 'cisakovitch4z@vistaprint.com', '433-412-3657', false, 'Data Science', null, 10, 2, 1, 8, null, 98);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (181, 'Starbeck', 'Felicdad', 'Mentor', '2022-07-09 00:28:43', 'fstarbeck50@opensource.org', '421-909-9261', true, 'English', 'Music', 8, 2, 1, 2, null, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (182, 'Streater', 'Kary', 'Mentor', '2020-04-30 01:21:56', 'kstreater51@springer.com', '822-994-5707', true, 'Health Sciences', 'Business', 9, 1, 3, 4, null, 59);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (183, 'Jurgen', 'Lydia', 'Mentor', '2019-09-21 02:21:29', 'ljurgen52@tripod.com', '716-201-0508', false, 'Political Science', null, 6, 1, 2, 2, 2, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (184, 'Greguoli', 'Janetta', 'Mentor', '2019-11-28 11:21:09', 'jgreguoli53@networksolutions.com', '213-351-0409', true, 'Art', 'Business', 6, 3, 2, 8, 2, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (185, 'Kluss', 'Jacquelyn', 'Mentor', '2022-06-15 20:44:20', 'jkluss54@symantec.com', '469-858-2226', true, 'Computer Science', null, 3, 1, 3, 3, 2, 59);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (186, 'Waples', 'Cathrin', 'Mentor', '2020-03-04 10:09:05', 'cwaples55@meetup.com', '540-405-1972', true, 'Art', null, 2, 3, 3, 4, 3, 52);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (187, 'Petts', 'Nichole', 'Mentor', '2021-05-16 07:58:37', 'npetts56@myspace.com', '191-172-1314', false, 'Computer Science', 'Health Sciences', 10, 1, 1, 8, 1, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (188, 'Comins', 'Wes', 'Mentor', '2022-09-11 17:55:27', 'wcomins57@stumbleupon.com', '386-190-2795', false, 'Engineering', null, 2, 3, 2, 4, 3, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (189, 'Lepper', 'Inger', 'Mentor', '2023-10-10 01:18:11', 'ilepper58@1688.com', '135-677-3308', false, 'English', 'Engineering', 6, 1, 2, 3, 1, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (190, 'Hollingby', 'Johna', 'Mentor', '2020-07-31 12:18:42', 'jhollingby59@usda.gov', '563-211-6809', true, 'Political Science', 'Computer Science', 9, 3, 3, 4, 1, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (191, 'Sysland', 'Faber', 'Mentor', '2024-07-14 22:11:17', 'fsysland5a@technorati.com', '215-782-9573', true, 'Art', null, 1, 2, 3, 8, 2, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (192, 'Cowwell', 'Georges', 'Mentor', '2022-12-23 17:14:50', 'gcowwell5b@miibeian.gov.cn', '414-606-4834', true, 'Health Sciences', null, 7, 1, 3, 7, 1, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (193, 'Martlew', 'Karrie', 'Mentor', '2022-11-16 11:46:40', 'kmartlew5c@loc.gov', '523-786-9181', true, 'Computer Science', null, 4, 1, 1, 1, 2, 19);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (194, 'Purshouse', 'Fawn', 'Mentor', '2021-07-16 12:16:17', 'fpurshouse5d@umn.edu', '576-517-8198', true, 'Math', null, 10, 3, 1, 8, 1, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (195, 'Websdale', 'Natalya', 'Mentor', '2021-12-10 10:48:35', 'nwebsdale5e@java.com', '367-270-5529', true, 'Math', 'Engineering', 5, 2, 2, 4, 2, 67);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (196, 'Munnion', 'Barny', 'Mentor', '2021-06-17 22:50:40', 'bmunnion5f@weibo.com', '503-839-6726', true, 'Data Science', 'Health Sciences', 2, 3, 3, 8, null, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (197, 'Manuely', 'Theodore', 'Mentor', '2023-04-20 19:07:17', 'tmanuely5g@ihg.com', '555-935-9925', true, 'Math', 'English', 8, 1, 2, 2, null, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (198, 'Dowman', 'Hanson', 'Mentor', '2020-03-16 00:05:41', 'hdowman5h@hibu.com', '726-335-9821', true, 'Health Sciences', 'Computer Science', 10, 2, 1, 2, 3, 98);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (199, 'Croisdall', 'Marylee', 'Mentor', '2021-04-19 16:35:32', 'mcroisdall5i@marriott.com', '404-973-3566', false, 'Computer Science', 'Health Sciences', 9, 3, 2, 7, 3, null);
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID) values (200, 'Fishbourn', 'Aleen', 'Mentor', '2021-04-20 20:57:20', 'afishbourn5j@imageshack.us', '720-814-2743', false, 'Music', null, 2, 2, 3, 8, 3, null);

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

