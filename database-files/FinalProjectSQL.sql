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
    Start DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    End DATETIME,
    Status BOOLEAN DEFAULT TRUE,
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

-- Insert advisors into Users table
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone)
values
    (1, 'Scholl', 'Danell', 'Advisor', '2021-02-27 03:51:50', 'dscholl0@furl.net', '813-513-8430'),
    (2, 'Sainer', 'Jeniece', 'Advisor', '2020-05-19 13:04:40', 'jsainer1@edublogs.org', '126-807-5598'),
    (3, 'Gatrill', 'Lanny', 'Advisor', '2023-07-09 06:43:13', 'lgatrill2@japanpost.jp', '522-975-5942'),
    (4, 'Manilow', 'Hendrick', 'Advisor', '2024-04-21 08:08:27', 'hmanilow3@phpbb.com', '640-677-4520'),
    (5, 'Brockwell', 'Marika', 'Advisor', '2023-10-24 23:43:57', 'mbrockwell4@mtv.com', '168-164-9230'),
    (6, 'Prendiville', 'Blisse', 'Advisor', '2023-12-16 00:38:49', 'bprendiville5@cyberchimps.com', '948-684-7760'),
    (7, 'Goulden', 'Ralina', 'Advisor', '2024-11-18 19:40:25', 'rgoulden6@paypal.com', '964-736-2139'),
    (8, 'Pea', 'Shel', 'Advisor', '2023-04-18 01:36:45', 'spea7@time.com', '442-511-1167');

-- Insert inexperienced students into Users table
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MentorID)
values
    (9, 'Castro', 'Lutero', 'Mentee', '2019-12-16 15:43:37', 'lcastro8@bloomberg.com', '657-638-1959', false, 'Art', null, 8, 1, 2, 5, 1, null),
    (10, 'Theaker', 'Antonius', 'Mentee', '2022-10-30 21:23:35', 'atheaker9@ucoz.ru', '287-827-9310', true, 'Business', 'Music', 4, 3, 1, 2, null, null),
    (11, 'Lamb-shine', 'Emilio', 'Mentee', '2023-02-16 14:22:10', 'elambshinea@hexun.com', '306-702-9129', false, 'Engineering', null, 4, 2, 3, 8, null, null),
    (12, 'Medgwick', 'Aldous', 'Mentee', '2022-10-14 07:00:12', 'amedgwickb@dmoz.org', '479-875-4704', false, 'English', 'Data Science', 7, 1, 1, 4, null, null),
    (13, 'Drewry', 'Carmela', 'Mentee', '2020-07-03 05:20:47', 'cdrewryc@loc.gov', '281-551-5318', false, 'Art', null, 3, 1, 3, 7, null, null),
    (14, 'Noell', 'Vinson', 'Mentee', '2022-08-09 05:37:39', 'vnoelld@yahoo.com', '983-780-6932', false, 'Engineering', 'Art', 8, 2, 2, 2, null, null),
    (15, 'Silbermann', 'Appolonia', 'Mentee', '2020-05-04 20:14:31', 'asilbermanne@dedecms.com', '472-445-7568', true, 'Business', 'Engineering', 3, 2, 2, 5, null, null),
    (16, 'Eubank', 'Hilliard', 'Mentee', '2022-10-12 21:50:11', 'heubankf@drupal.org', '546-218-8021', true, 'English', 'Computer Science', 7, 3, 3, 7, null, null),
    (17, 'Sellwood', 'Ezmeralda', 'Mentee', '2023-09-07 09:34:46', 'esellwoodg@webs.com', '896-386-4994', true, 'Art', 'Political Science', 3, 3, 1, 2, null, null),
    (18, 'Balch', 'Dene', 'Mentee', '2023-03-06 13:49:13', 'dbalchh@google.co.uk', '802-384-3712', false, 'Computer Science', null, 10, 3, 2, 8, null, null),
    (19, 'Yon', 'Isidor', 'Mentee', '2024-08-20 23:35:49', 'iyoni@163.com', '856-419-8931', true, 'English', null, 4, 1, 2, 5, null, null),
    (20, 'Devonshire', 'Andy', 'Mentee', '2020-10-19 03:53:20', 'adevonshirej@tmall.com', '693-791-4378', false, 'Data Science', 'Business', 1, 1, 3, 3, null, null),
    (21, 'Bottoner', 'Pippo', 'Mentee', '2021-04-05 08:46:12', 'pbottonerk@forbes.com', '284-158-2049', false, 'Math', null, 8, 3, 1, 5, null, null),
    (22, 'Huikerby', 'Moyna', 'Mentee', '2022-04-15 00:02:13', 'mhuikerbyl@deliciousdays.com', '309-866-0617', false, 'Political Science', null, 9, 1, 3, 2, 2, null),
    (23, 'Breche', 'Franni', 'Mentee', '2023-01-18 22:18:54', 'fbrechem@furl.net', '627-923-2045', true, 'Health Sciences', 'Data Science', 1, 1, 2, 6, null, null),
    (24, 'Milsom', 'Jamil', 'Mentee', '2023-12-26 09:27:57', 'jmilsomn@mayoclinic.com', '393-648-8515', false, 'Music', 'Engineering', 7, 3, 2, 6, null, null),
    (25, 'Marland', 'Orion', 'Mentee', '2022-09-26 05:27:26', 'omarlando@hao123.com', '567-334-8720', true, 'English', 'Math', 7, 3, 2, 1, null, null),
    (26, 'Autin', 'Ddene', 'Mentee', '2024-03-20 07:17:39', 'dautinp@imdb.com', '129-483-8986', false, 'Political Science', 'Math', 4, 1, 3, 7, null, null),
    (27, 'Dimitrijevic', 'Maribelle', 'Mentee', '2022-01-23 19:54:18', 'mdimitrijevicq@google.it', '371-410-7532', true, 'Music', null, 7, 2, 3, 3, null, null),
    (28, 'Crothers', 'Doralyn', 'Mentee', '2021-05-24 01:17:33', 'dcrothersr@so-net.ne.jp', '401-554-1780', false, 'Data Science', 'Math', 1, 2, 2, 7, null, null),
    (29, 'McFaul', 'Bartlett', 'Mentee', '2021-09-25 19:57:17', 'bmcfauls@bizjournals.com', '472-450-3466', false, 'Health Sciences', 'Computer Science', 1, 1, 2, 5, null, null),
    (30, 'de Copeman', 'Nils', 'Mentee', '2022-12-26 02:26:10', 'ndecopemant@goo.gl', '910-749-5405', true, 'Music', 'Data Science', 2, 3, 2, 3, null, null),
    (31, 'Denness', 'Violet', 'Mentee', '2021-12-28 10:49:30', 'vdennessu@istockphoto.com', '583-183-1855', true, 'Music', 'Health Sciences', 6, 3, 2, 4, null, null),
    (32, 'Raspel', 'Krisha', 'Mentee', '2024-03-02 02:43:39', 'kraspelv@ebay.com', '538-480-5140', true, 'Engineering', null, 7, 1, 1, 3, null, null),
    (33, 'Baitson', 'Jackquelin', 'Mentee', '2020-01-21 16:54:58', 'jbaitsonw@wired.com', '351-680-2693', false, 'English', 'Health Sciences', 8, 1, 2, 5, null, null),
    (34, 'Langdon', 'Malvin', 'Mentee', '2024-04-22 21:48:51', 'mlangdonx@alibaba.com', '200-845-5776', false, 'Music', null, 5, 2, 3, 6, null, null),
    (35, 'Pitcher', 'Stillman', 'Mentee', '2020-06-18 23:08:23', 'spitchery@gnu.org', '809-147-3214', true, 'Computer Science', null, 5, 2, 1, 6, null, null),
    (36, 'Seville', 'Meta', 'Mentee', '2024-03-12 16:49:25', 'msevillez@amazon.co.jp', '868-456-1338', true, 'Computer Science', 'Music', 10, 2, 2, 4, null, null),
    (37, 'Mark', 'Carl', 'Mentee', '2020-03-27 08:13:23', 'cmark10@163.com', '345-340-2575', true, 'Data Science', null, 10, 1, 1, 5, null, null),
    (38, 'Coche', 'Lissi', 'Mentee', '2022-04-06 20:16:12', 'lcoche11@reddit.com', '772-448-0257', false, 'Data Science', 'Business', 9, 1, 2, 6, null, null),
    (39, 'How to preserve', 'Yorgo', 'Mentee', '2021-01-21 05:26:49', 'yhowtopreserve12@xrea.com', '927-712-5425', false, 'Computer Science', null, 5, 3, 2, 7, null, null),
    (40, 'Pullman', 'Hammad', 'Mentee', '2021-12-01 19:18:39', 'hpullman13@is.gd', '699-305-9939', true, 'English', null, 6, 3, 1, 4, null, null),
    (41, 'Druett', 'Oren', 'Mentee', '2023-10-03 04:29:48', 'odruett14@blog.com', '809-386-5740', false, 'Computer Science', null, 5, 3, 3, 6, null, null),
    (42, 'Gynne', 'Estell', 'Mentee', '2020-05-30 13:20:13', 'egynne15@imdb.com', '922-779-8328', true, 'Art', null, 2, 1, 1, 3, 2, null),
    (43, 'Duckit', 'Petronella', 'Mentee', '2023-06-06 00:21:20', 'pduckit16@answers.com', '636-503-5488', true, 'Engineering', 'Art', 8, 3, 1, 1, null, null),
    (44, 'Popland', 'Ronna', 'Mentee', '2021-04-21 11:33:12', 'rpopland17@github.io', '236-539-9734', false, 'Data Science', 'Music', 7, 2, 2, 4, null, null),
    (45, 'Longson', 'Jori', 'Mentee', '2022-06-24 09:37:17', 'jlongson18@microsoft.com', '986-355-2640', false, 'Math', 'Math', 5, 1, 3, 1, null, null),
    (46, 'Seary', 'Kat', 'Mentee', '2019-10-07 09:19:14', 'kseary19@123-reg.co.uk', '961-458-2844', false, 'Health Sciences', 'Computer Science', 7, 2, 2, 4, null, null),
    (47, 'Dell''Abbate', 'Raynard', 'Mentee', '2021-01-30 04:55:35', 'rdellabbate1a@statcounter.com', '285-791-3506', false, 'Math', 'Music', 8, 1, 1, 5, null, null),
    (48, 'Wiffen', 'Adaline', 'Mentee', '2020-12-23 00:08:52', 'awiffen1b@washingtonpost.com', '286-859-7429', true, 'Engineering', 'Art', 2, 1, 1, 6, null, null),
    (49, 'Leynham', 'Lefty', 'Mentee', '2023-05-09 00:43:21', 'lleynham1c@virginia.edu', '875-513-4991', true, 'Business', 'Music', 2, 3, 3, 4, null, null),
    (50, 'Gorthy', 'Amity', 'Mentee', '2024-01-01 01:14:15', 'agorthy1d@drupal.org', '676-979-5928', true, 'Art', 'Art', 6, 3, 1, 1, 1, null),
    (51, 'Dawtre', 'Penelopa', 'Mentee', '2022-10-02 18:17:57', 'pdawtre1e@wikispaces.com', '400-294-7932', false, 'Art', 'English', 4, 1, 3, 4, 3, null),
    (52, 'Keywood', 'Beckie', 'Mentee', '2020-03-19 19:28:19', 'bkeywood1f@ihg.com', '269-902-8353', true, 'Health Sciences', 'Business', 1, 2, 2, 7, null, null),
    (53, 'McEneny', 'Dorie', 'Mentee', '2024-04-12 22:27:53', 'dmceneny1g@unesco.org', '227-362-4198', true, 'Music', 'Political Science', 7, 3, 3, 4, 2, null),
    (54, 'Trunks', 'Doro', 'Mentee', '2021-04-06 21:00:28', 'dtrunks1h@timesonline.co.uk', '141-808-3877', true, 'Art', null, 9, 2, 3, 7, null, null),
    (55, 'Arrighetti', 'Orland', 'Mentee', '2023-03-18 18:28:39', 'oarrighetti1i@artisteer.com', '492-525-1435', true, 'Health Sciences', null, 1, 1, 1, 2, null, null),
    (56, 'Peggs', 'Adaline', 'Mentee', '2021-12-14 03:40:15', 'apeggs1j@yolasite.com', '259-683-3182', true, 'Engineering', 'Health Sciences', 2, 2, 3, 5, null, null),
    (57, 'Barkly', 'Serena', 'Mentee', '2024-05-15 09:18:56', 'sbarkly1k@google.fr', '175-726-3266', false, 'Art', null, 6, 1, 2, 5, null, null),
    (58, 'Kinforth', 'Marys', 'Mentee', '2023-11-19 13:39:11', 'mkinforth1l@woothemes.com', '510-214-7597', false, 'English', null, 4, 3, 3, 7, null, null),
    (59, 'Allatt', 'Lilly', 'Mentee', '2019-12-02 08:10:11', 'lallatt1m@w3.org', '115-914-2039', true, 'Engineering', 'Engineering', 9, 3, 3, 1, null, null),
    (60, 'Brackpool', 'Jaimie', 'Mentee', '2023-10-30 12:22:40', 'jbrackpool1n@usatoday.com', '660-133-2353', true, 'Computer Science', null, 8, 3, 1, 2, 2, null),
    (61, 'Inglesfield', 'Tome', 'Mentee', '2022-06-10 21:20:36', 'tinglesfield1o@skype.com', '510-182-9703', true, 'English', null, 1, 2, 3, 1, null, null),
    (62, 'Wint', 'Michell', 'Mentee', '2022-06-11 17:10:22', 'mwint1p@printfriendly.com', '577-456-6523', false, 'Art', 'Business', 5, 1, 1, 6, null, null),
    (63, 'Vittery', 'Allistir', 'Mentee', '2022-12-27 01:33:33', 'avittery1q@youtube.com', '565-121-8194', false, 'Data Science', null, 8, 1, 1, 8, null, null),
    (64, 'Bernade', 'Rhiamon', 'Mentee', '2024-03-25 13:14:17', 'rbernade1r@google.nl', '252-412-1938', false, 'Math', null, 10, 1, 2, 4, null, null),
    (65, 'Ricciardelli', 'Theodore', 'Mentee', '2021-02-10 13:59:44', 'tricciardelli1s@yelp.com', '763-177-6039', false, 'Political Science', 'Engineering', 9, 1, 2, 4, null, null),
    (66, 'Chrestien', 'Elwyn', 'Mentee', '2020-10-18 11:39:29', 'echrestien1t@mashable.com', '212-561-5973', true, 'Data Science', null, 1, 1, 3, 7, null, null),
    (67, 'Purvis', 'Curtis', 'Mentee', '2024-06-16 06:44:07', 'cpurvis1u@smh.com.au', '215-317-0952', false, 'Engineering', 'Art', 1, 2, 2, 1, 1, null),
    (68, 'Ryde', 'Tulley', 'Mentee', '2023-08-11 04:31:22', 'tryde1v@joomla.org', '579-998-9191', false, 'Math', 'Computer Science', 9, 1, 3, 4, 3, null),
    (69, 'Angless', 'Iormina', 'Mentee', '2021-08-30 14:46:22', 'iangless1w@webnode.com', '792-327-3979', true, 'English', null, 2, 2, 3, 8, null, null),
    (70, 'Knightly', 'Morris', 'Mentee', '2022-10-23 05:16:37', 'mknightly1x@dion.ne.jp', '392-121-6272', false, 'Business', null, 4, 3, 3, 4, 1, null),
    (71, 'Rembrant', 'Blancha', 'Mentee', '2022-08-30 10:20:37', 'brembrant1y@wikispaces.com', '302-741-7979', true, 'English', 'English', 7, 1, 1, 3, null, null),
    (72, 'Soonhouse', 'Kata', 'Mentee', '2022-10-17 02:44:57', 'ksoonhouse1z@wikispaces.com', '182-609-2726', true, 'Business', null, 7, 1, 2, 5, null, null),
    (73, 'Baugh', 'Mayor', 'Mentee', '2019-11-05 18:27:42', 'mbaugh20@i2i.jp', '540-992-5775', false, 'Business', 'Music', 9, 1, 2, 2, null, null),
    (74, 'Yarrell', 'Nerta', 'Mentee', '2020-12-04 05:32:51', 'nyarrell21@freewebs.com', '256-997-3602', false, 'Music', 'Political Science', 5, 1, 2, 6, null, null),
    (75, 'Fiddymont', 'Thurston', 'Mentee', '2023-08-27 14:44:46', 'tfiddymont22@phoca.cz', '198-404-6214', true, 'Music', 'English', 7, 1, 2, 8, null, null),
    (76, 'Letch', 'Nedda', 'Mentee', '2024-06-25 18:00:31', 'nletch23@comcast.net', '934-803-8744', true, 'Music', null, 6, 1, 2, 2, null, null),
    (77, 'Olennikov', 'Rodney', 'Mentee', '2024-08-20 01:04:46', 'rolennikov24@fotki.com', '806-774-1501', false, 'Music', null, 7, 3, 1, 8, null, null),
    (78, 'Vardey', 'Flemming', 'Mentee', '2021-02-24 02:27:29', 'fvardey25@symantec.com', '148-198-1340', false, 'English', 'Political Science', 7, 2, 1, 6, null, null),
    (79, 'Bricham', 'Juliet', 'Mentee', '2023-08-15 05:41:04', 'jbricham26@microsoft.com', '539-642-8445', false, 'Health Sciences', null, 7, 3, 3, 8, null, null),
    (80, 'MacGillavery', 'Jareb', 'Mentee', '2024-02-26 17:47:46', 'jmacgillavery27@meetup.com', '661-111-9816', false, 'Political Science', 'Math', 4, 2, 3, 1, null, null),
    (81, 'Robardley', 'Olivia', 'Mentee', '2022-10-10 11:19:51', 'orobardley28@weibo.com', '540-744-1629', true, 'Engineering', 'Computer Science', 8, 1, 1, 2, null, null),
    (82, 'Whiscard', 'Edithe', 'Mentee', '2021-01-20 20:41:53', 'ewhiscard29@house.gov', '234-233-8344', true, 'Music', 'English', 6, 3, 1, 2, 1, null),
    (83, 'O''Shevlan', 'Rina', 'Mentee', '2020-06-12 15:27:54', 'roshevlan2a@netscape.com', '140-412-7535', false, 'Data Science', null, 5, 3, 2, 4, null, null),
    (84, 'Tomasz', 'Lanae', 'Mentee', '2022-03-27 09:16:27', 'ltomasz2b@chron.com', '240-897-2832', false, 'Data Science', null, 5, 1, 2, 4, null, null),
    (85, 'Holson', 'Christel', 'Mentee', '2020-08-15 06:21:53', 'cholson2c@ow.ly', '593-679-5131', true, 'Art', 'Music', 5, 2, 3, 5, null, null),
    (86, 'Fleckness', 'Mychal', 'Mentee', '2020-06-29 14:40:55', 'mfleckness2d@squidoo.com', '994-680-8824', true, 'English', 'Math', 10, 1, 1, 4, null, null),
    (87, 'Cheke', 'Obed', 'Mentee', '2024-07-21 03:19:36', 'ocheke2e@dot.gov', '656-827-2879', true, 'Math', null, 4, 3, 3, 1, null, null),
    (88, 'Twigg', 'Melvyn', 'Mentee', '2023-02-07 22:36:25', 'mtwigg2f@hhs.gov', '897-807-4136', false, 'Business', 'Health Sciences', 8, 3, 1, 8, null, null),
    (89, 'Matuszak', 'Raphaela', 'Mentee', '2020-05-09 11:56:11', 'rmatuszak2g@hc360.com', '234-867-4142', true, 'English', 'Art', 2, 1, 3, 1, null, null),
    (90, 'Fragino', 'Brigit', 'Mentee', '2024-02-21 18:31:37', 'bfragino2h@ucoz.ru', '859-882-7383', false, 'Art', 'Political Science', 4, 1, 3, 4, null, null),
    (91, 'Adelman', 'Andreas', 'Mentee', '2023-07-08 15:34:12', 'aadelman2i@slashdot.org', '804-821-5714', true, 'Computer Science', null, 8, 3, 2, 7, null, null),
    (92, 'Worsham', 'Abagail', 'Mentee', '2023-04-12 02:37:52', 'aworsham2j@t.co', '681-992-7672', false, 'Health Sciences', null, 9, 2, 2, 2, null, null),
    (93, 'Broadey', 'Thibaud', 'Mentee', '2022-03-19 05:00:36', 'tbroadey2k@phpbb.com', '609-285-7331', true, 'Music', 'Health Sciences', 6, 2, 2, 6, 3, null),
    (94, 'Daveridge', 'Padraic', 'Mentee', '2024-01-08 13:06:31', 'pdaveridge2l@creativecommons.org', '230-686-3065', false, 'Computer Science', null, 6, 2, 2, 4, null, null),
    (95, 'Darth', 'Ralph', 'Mentee', '2022-04-05 10:51:43', 'rdarth2m@goo.gl', '695-394-7077', true, 'Math', null, 5, 3, 3, 8, null, null),
    (96, 'Hatfield', 'Raquela', 'Mentee', '2023-02-17 22:12:52', 'rhatfield2n@java.com', '868-392-7872', false, 'Computer Science', 'English', 7, 1, 3, 7, null, null),
    (97, 'Capnerhurst', 'Riki', 'Mentee', '2019-09-09 16:23:42', 'rcapnerhurst2o@lycos.com', '700-379-5187', false, 'Music', null, 9, 2, 3, 3, null, null),
    (98, 'Tremlett', 'Oates', 'Mentee', '2020-07-16 17:20:34', 'otremlett2p@friendfeed.com', '902-627-9244', true, 'Music', null, 3, 3, 3, 2, 2, null),
    (99, 'Sussex', 'Robinson', 'Mentee', '2024-06-17 02:28:56', 'rsussex2q@psu.edu', '817-158-8200', false, 'Art', 'Health Sciences', 7, 1, 3, 3, 1, null),
    (100, 'Cockshot', 'Linc', 'Mentee', '2024-08-27 16:07:10', 'lcockshot2r@sohu.com', '409-895-2647', false, 'Art', 'Computer Science', 7, 2, 3, 6, null, null);

-- Insert Mentor Students
insert into users (UserID, lName, fName, Usertype, joinDate, Email, Phone, Matchstatus, Major, Minor, Semesters, numCoops, AdminID, AdvisorID, EmpID, MenteeID)
values
    (101, 'Fairham', 'Codi', 'Mentor', '2024-10-31 20:15:28', 'cfairham2s@geocities.jp', '427-830-4024', false, 'Computer Science', 'Math', 3, 1, 1, 5, 3, null),
    (102, 'Alvin', 'Hyacinthie', 'Mentor', '2022-04-26 06:52:03', 'halvin2t@theglobeandmail.com', '331-860-1388', false, 'Data Science', 'Health Sciences', 1, 2, 3, 1, 2, null),
    (103, 'Hastie', 'Shaughn', 'Mentor', '2019-10-16 10:48:25', 'shastie2u@independent.co.uk', '100-538-1435', false, 'Computer Science', null, 5, 1, 2, 7, 1, null),
    (104, 'Sapsford', 'Johnathan', 'Mentor', '2024-06-18 13:26:32', 'jsapsford2v@fotki.com', '543-628-1380', true, 'Health Sciences', 'Art', 4, 1, 3, 4, 2, null),
    (105, 'Pacey', 'Dur', 'Mentor', '2020-11-10 14:53:14', 'dpacey2w@privacy.gov.au', '373-557-1977', true, 'Music', 'Data Science', 10, 2, 3, 1, null, null),
    (106, 'Trayhorn', 'Cordi', 'Mentor', '2024-09-25 05:31:39', 'ctrayhorn2x@simplemachines.org', '175-588-3995', false, 'Music', 'Computer Science', 5, 3, 2, 6, null, null),
    (107, 'McCawley', 'Oliviero', 'Mentor', '2019-09-18 08:01:09', 'omccawley2y@businessweek.com', '685-220-9316', true, 'Computer Science', null, 10, 2, 1, 7, 1, null),
    (108, 'Corter', 'Gustie', 'Mentor', '2023-05-24 11:31:09', 'gcorter2z@yandex.ru', '166-478-1120', true, 'Business', 'Music', 4, 1, 3, 8, 1, null),
    (109, 'Rean', 'Deane', 'Mentor', '2022-08-10 12:44:18', 'drean30@spiegel.de', '429-681-3935', true, 'Math', null, 9, 3, 3, 2, null, null),
    (110, 'Heinicke', 'Sidnee', 'Mentor', '2024-01-05 03:40:08', 'sheinicke31@geocities.jp', '844-763-5767', false, 'Art', 'Music', 10, 1, 2, 2, 2, null),
    (111, 'Vogeler', 'Juliana', 'Mentor', '2021-03-04 02:57:27', 'jvogeler32@i2i.jp', '496-605-7389', false, 'Business', 'Engineering', 6, 2, 2, 6, 1, null),
    (112, 'Blackledge', 'Samuele', 'Mentor', '2020-10-16 08:46:13', 'sblackledge33@ed.gov', '488-179-1120', false, 'Computer Science', null, 1, 3, 1, 4, 3, null),
    (113, 'Skupinski', 'Mira', 'Mentor', '2019-09-22 10:12:55', 'mskupinski34@youku.com', '896-565-4393', false, 'Health Sciences', 'Health Sciences', 3, 2, 1, 2, 1, null),
    (114, 'Jessope', 'Latrena', 'Mentor', '2023-05-29 15:29:43', 'ljessope35@w3.org', '246-740-2540', true, 'Art', null, 1, 3, 1, 5, 3, null),
    (115, 'Birdis', 'Bryna', 'Mentor', '2023-10-05 11:26:45', 'bbirdis36@cbc.ca', '966-698-2165', false, 'Math', 'Health Sciences', 7, 1, 1, 7, 3, null),
    (116, 'Mayell', 'Elwood', 'Mentor', '2022-12-18 20:24:39', 'emayell37@theatlantic.com', '436-306-6196', true, 'Math', null, 5, 1, 3, 3, 3, 24),
    (117, 'Cathee', 'Adrianna', 'Mentor', '2023-08-04 19:02:28', 'acathee38@dmoz.org', '549-960-4437', false, 'Engineering', 'Music', 3, 2, 3, 5, null, null),
    (118, 'Fain', 'Mallory', 'Mentor', '2019-12-03 03:05:16', 'mfain39@squidoo.com', '929-474-2075', false, 'Art', 'Data Science', 9, 2, 1, 1, 2, null),
    (119, 'Clinnick', 'Demeter', 'Mentor', '2022-04-19 13:57:32', 'dclinnick3a@nsw.gov.au', '663-991-6626', true, 'Art', 'English', 6, 1, 2, 1, null, null),
    (120, 'Ruspine', 'Aurie', 'Mentor', '2019-12-26 21:34:20', 'aruspine3b@discuz.net', '682-223-0679', false, 'Computer Science', 'Data Science', 8, 1, 3, 4, null, null),
    (121, 'Barradell', 'Merridie', 'Mentor', '2024-10-04 12:57:55', 'mbarradell3c@4shared.com', '316-268-0191', false, 'Engineering', 'Political Science', 9, 3, 3, 8, 1, null),
    (122, 'Stukings', 'Lissy', 'Mentor', '2024-04-01 23:41:22', 'lstukings3d@i2i.jp', '235-616-3070', false, 'Business', 'Health Sciences', 4, 3, 2, 1, 1, null),
    (123, 'Espinas', 'Gwynne', 'Mentor', '2024-11-15 23:10:19', 'gespinas3e@acquirethisname.com', '731-558-6577', true, 'Music', null, 6, 1, 1, 5, 3, null),
    (124, 'Rubinfeld', 'Lanette', 'Mentor', '2021-07-20 00:25:17', 'lrubinfeld3f@canalblog.com', '440-315-4621', true, 'Political Science', null, 6, 1, 2, 6, 3, null),
    (125, 'Fargie', 'Susie', 'Mentor', '2023-07-07 18:39:18', 'sfargie3g@nsw.gov.au', '128-146-9024', true, 'English', null, 2, 1, 3, 4, 3, null),
    (126, 'Gorsse', 'Fabe', 'Mentor', '2023-05-20 04:40:11', 'fgorsse3h@instagram.com', '443-921-1911', false, 'Business', null, 1, 3, 3, 5, 2, null),
    (127, 'Deviney', 'Al', 'Mentor', '2020-02-06 02:25:03', 'adeviney3i@e-recht24.de', '108-255-8474', false, 'Art', 'Art', 5, 3, 2, 3, 1, null),
    (128, 'Bernardi', 'Schuyler', 'Mentor', '2023-07-10 18:01:22', 'sbernardi3j@boston.com', '154-958-5053', true, 'Math', null, 2, 1, 2, 4, 1, null),
    (129, 'Mattes', 'Burke', 'Mentor', '2023-07-07 01:14:25', 'bmattes3k@icio.us', '745-746-9662', true, 'Health Sciences', 'Engineering', 5, 1, 2, 2, 2, null),
    (130, 'Eustace', 'Evangelin', 'Mentor', '2020-07-20 10:58:05', 'eeustace3l@home.pl', '555-219-1656', false, 'Engineering', 'Computer Science', 5, 1, 1, 4, 2, null),
    (131, 'Vezey', 'Ludvig', 'Mentor', '2024-08-09 05:03:49', 'lvezey3m@elpais.com', '510-149-2697', true, 'Computer Science', 'Data Science', 5, 3, 1, 7, 1, null),
    (132, 'Pickless', 'Vasili', 'Mentor', '2021-05-07 20:20:13', 'vpickless3n@arizona.edu', '672-912-4743', false, 'Math', 'Math', 6, 1, 3, 1, 3, null),
    (133, 'Bowmen', 'Paulette', 'Mentor', '2019-12-31 23:17:33', 'pbowmen3o@vistaprint.com', '718-315-7478', false, 'Data Science', 'Political Science', 4, 2, 2, 8, 3, null),
    (134, 'Deelay', 'Baron', 'Mentor', '2023-10-19 00:46:15', 'bdeelay3p@spotify.com', '455-594-4263', true, 'Data Science', 'Data Science', 8, 1, 1, 4, 1, null),
    (135, 'Dorant', 'Susette', 'Mentor', '2020-10-21 00:59:45', 'sdorant3q@ft.com', '889-847-4216', false, 'Math', null, 2, 3, 3, 6, 2, null),
    (136, 'Sibley', 'Courtney', 'Mentor', '2021-05-22 17:31:07', 'csibley3r@reference.com', '496-209-4441', true, 'Music', null, 7, 1, 2, 4, 3, null),
    (137, 'McCotter', 'Nissie', 'Mentor', '2021-07-08 07:29:22', 'nmccotter3s@ameblo.jp', '938-787-0922', true, 'Engineering', 'Health Sciences', 6, 1, 3, 6, 2, null),
    (138, 'Merricks', 'Vern', 'Mentor', '2020-06-25 02:02:16', 'vmerricks3t@photobucket.com', '206-717-1523', false, 'Computer Science', 'Engineering', 6, 2, 2, 2, 2, null),
    (139, 'Diggons', 'Veronique', 'Mentor', '2024-09-13 03:30:52', 'vdiggons3u@github.io', '252-512-7169', false, 'Data Science', 'Health Sciences', 5, 1, 1, 5, 2, null),
    (140, 'Jorge', 'Ilse', 'Mentor', '2024-06-11 21:36:59', 'ijorge3v@yahoo.co.jp', '363-594-4085', false, 'Computer Science', 'Art', 9, 2, 3, 6, 2, null),
    (141, 'Maylour', 'Gar', 'Mentor', '2022-12-15 23:56:51', 'gmaylour3w@edublogs.org', '721-739-9317', true, 'Health Sciences', 'Engineering', 9, 1, 1, 2, 2, null),
    (142, 'Prettyjohns', 'Bayard', 'Mentor', '2020-11-14 17:19:04', 'bprettyjohns3x@wsj.com', '316-332-4822', false, 'Math', null, 3, 1, 2, 8, 2, null),
    (143, 'Crow', 'Idell', 'Mentor', '2021-06-15 19:24:03', 'icrow3y@youtu.be', '907-113-0441', false, 'Health Sciences', null, 7, 1, 3, 2, 3, null),
    (144, 'Gabits', 'Henka', 'Mentor', '2023-05-22 02:32:30', 'hgabits3z@php.net', '809-946-0443', false, 'Computer Science', 'Engineering', 10, 1, 2, 6, 2, null),
    (145, 'Deshorts', 'Karim', 'Mentor', '2019-11-12 09:15:34', 'kdeshorts40@blog.com', '201-335-4419', true, 'Math', null, 10, 3, 2, 6, 3, null),
    (146, 'Runciman', 'Davey', 'Mentor', '2020-04-07 16:56:18', 'drunciman41@live.com', '376-961-8042', true, 'Math', 'Engineering', 5, 3, 1, 2, 1, null),
    (147, 'Cristofolo', 'Ermengarde', 'Mentor', '2019-11-14 19:09:14', 'ecristofolo42@statcounter.com', '568-580-7873', false, 'Math', 'Math', 7, 3, 1, 2, 3, null),
    (148, 'Slimme', 'Thorpe', 'Mentor', '2022-05-18 00:46:53', 'tslimme43@state.gov', '203-857-1698', true, 'Engineering', 'Business', 1, 3, 2, 8, 2, null),
    (149, 'Derisly', 'Alethea', 'Mentor', '2023-02-08 00:27:41', 'aderisly44@topsy.com', '887-871-3591', false, 'Engineering', null, 5, 1, 1, 7, 1, null),
    (150, 'Woolf', 'Towney', 'Mentor', '2023-08-06 11:14:13', 'twoolf45@nps.gov', '656-777-6740', false, 'Math', 'Engineering', 9, 1, 3, 1, null, null),
    (151, 'Roncelli', 'Stirling', 'Mentor', '2021-01-04 02:50:12', 'sroncelli46@rambler.ru', '632-663-8584', true, 'Political Science', 'Engineering', 9, 2, 3, 8, 2, null),
    (152, 'Kornyshev', 'Marne', 'Mentor', '2021-12-13 13:07:47', 'mkornyshev47@boston.com', '482-134-8244', true, 'Art', 'Engineering', 2, 1, 3, 6, 2, null),
    (153, 'Storrock', 'Joete', 'Mentor', '2020-01-07 20:55:25', 'jstorrock48@hexun.com', '850-484-8536', true, 'Math', 'Math', 8, 1, 3, 8, 1, null),
    (154, 'Clempton', 'Andy', 'Mentor', '2023-02-24 01:01:48', 'aclempton49@boston.com', '113-286-4711', true, 'Data Science', null, 7, 1, 3, 4, 2, null),
    (155, 'Bathersby', 'Reube', 'Mentor', '2024-08-11 20:42:15', 'rbathersby4a@jiathis.com', '671-114-8004', false, 'Math', 'Engineering', 8, 3, 2, 5, 1, null),
    (156, 'Griffiths', 'Odell', 'Mentor', '2022-01-02 06:14:54', 'ogriffiths4b@state.gov', '291-565-7129', false, 'Engineering', 'Music', 10, 1, 1, 4, 3, null),
    (157, 'Flanner', 'Adan', 'Mentor', '2024-08-11 15:46:43', 'aflanner4c@joomla.org', '748-787-5515', true, 'Math', 'English', 7, 2, 2, 2, null, null),
    (158, 'Troak', 'Arel', 'Mentor', '2024-05-02 16:39:17', 'atroak4d@tamu.edu', '165-660-5943', false, 'Computer Science', null, 4, 1, 1, 4, 3, null),
    (159, 'Wallett', 'Fanchette', 'Mentor', '2021-06-18 23:56:50', 'fwallett4e@cafepress.com', '572-512-3529', false, 'Political Science', 'Computer Science', 10, 1, 2, 3, 1, null),
    (160, 'Lempke', 'Ichabod', 'Mentor', '2022-07-24 03:15:15', 'ilempke4f@cdc.gov', '202-300-5994', false, 'English', null, 4, 1, 1, 7, 3, null),
    (161, 'Swain', 'Haroun', 'Mentor', '2021-06-29 05:22:54', 'hswain4g@yellowpages.com', '184-428-5301', true, 'Computer Science', 'Math', 6, 2, 3, 5, 2, null),
    (162, 'Lillow', 'Roby', 'Mentor', '2024-02-23 16:12:39', 'rlillow4h@360.cn', '713-643-8127', false, 'English', 'English', 3, 1, 2, 5, null, null),
    (163, 'Greatrakes', 'Neddy', 'Mentor', '2021-08-12 21:47:04', 'ngreatrakes4i@state.gov', '974-831-7709', true, 'English', 'Business', 9, 1, 2, 7, 1, null),
    (164, 'Fursland', 'Kristo', 'Mentor', '2023-12-15 15:08:34', 'kfursland4j@unesco.org', '714-321-3468', true, 'Health Sciences', 'Health Sciences', 9, 3, 2, 5, 2, null),
    (165, 'Devo', 'Paula', 'Mentor', '2020-02-05 17:13:54', 'pdevo4k@aboutads.info', '956-315-0603', false, 'Political Science', 'Data Science', 1, 2, 3, 6, 3, null),
    (166, 'Brinkley', 'Mattie', 'Mentor', '2021-04-21 18:25:15', 'mbrinkley4l@reddit.com', '582-481-6620', false, 'Math', null, 2, 2, 1, 2, 2, null),
    (167, 'Rossborough', 'Jacquenetta', 'Mentor', '2021-09-17 03:36:02', 'jrossborough4m@geocities.jp', '540-348-8737', false, 'Data Science', 'Art', 5, 2, 1, 8, 2, null),
    (168, 'Pharro', 'Dre', 'Mentor', '2020-12-24 11:34:31', 'dpharro4n@usgs.gov', '567-270-1765', true, 'Political Science', 'Health Sciences', 1, 2, 2, 5, null, null),
    (169, 'Dunthorne', 'Clemens', 'Mentor', '2023-06-09 05:22:47', 'cdunthorne4o@photobucket.com', '565-649-8637', false, 'Health Sciences', 'Computer Science', 5, 1, 3, 6, 3, null),
    (170, 'Loche', 'Welch', 'Mentor', '2023-04-22 02:29:10', 'wloche4p@tiny.cc', '270-252-6864', false, 'Engineering', 'Math', 6, 2, 1, 1, null, null),
    (171, 'Laffan', 'Elfrida', 'Mentor', '2021-03-14 08:19:33', 'elaffan4q@sfgate.com', '499-642-3127', false, 'English', 'Music', 4, 3, 2, 8, null, null),
    (172, 'Thornally', 'Merrick', 'Mentor', '2022-03-01 07:06:51', 'mthornally4r@icio.us', '679-512-5414', false, 'Business', 'Math', 10, 3, 1, 5, 3, null),
    (173, 'Dyball', 'Stacey', 'Mentor', '2024-06-21 19:45:36', 'sdyball4s@tumblr.com', '747-854-5969', true, 'Engineering', null, 3, 1, 2, 3, 1, null),
    (174, 'Davall', 'Ronica', 'Mentor', '2023-05-27 12:44:24', 'rdavall4t@weebly.com', '380-774-8162', false, 'Data Science', 'Music', 6, 2, 1, 7, 3, null),
    (175, 'Bilofsky', 'Hobard', 'Mentor', '2020-02-23 02:45:47', 'hbilofsky4u@ed.gov', '511-880-1480', false, 'Math', null, 10, 2, 3, 6, 2, null),
    (176, 'Ianne', 'Oriana', 'Mentor', '2023-06-22 13:14:50', 'oianne4v@behance.net', '640-523-9579', false, 'Political Science', null, 6, 2, 1, 7, 2, null),
    (177, 'Sydenham', 'Ambrosio', 'Mentor', '2022-07-12 06:09:59', 'asydenham4w@odnoklassniki.ru', '102-767-9543', true, 'Math', null, 9, 2, 1, 1, 1, null),
    (178, 'Muller', 'Ania', 'Mentor', '2022-02-10 07:20:32', 'amuller4x@google.nl', '373-842-8673', true, 'Health Sciences', 'Computer Science', 1, 3, 2, 7, 1, null),
    (179, 'Scamal', 'Isabelita', 'Mentor', '2020-08-19 09:06:41', 'iscamal4y@wordpress.org', '770-694-2330', false, 'Data Science', 'Math', 6, 2, 1, 6, null, null),
    (180, 'Isakovitch', 'Candis', 'Mentor', '2021-04-29 18:39:36', 'cisakovitch4z@vistaprint.com', '433-412-3657', false, 'Data Science', null, 10, 2, 1, 8, null, null),
    (181, 'Starbeck', 'Felicdad', 'Mentor', '2022-07-09 00:28:43', 'fstarbeck50@opensource.org', '421-909-9261', true, 'English', 'Music', 8, 2, 1, 2, null, null),
    (182, 'Streater', 'Kary', 'Mentor', '2020-04-30 01:21:56', 'kstreater51@springer.com', '822-994-5707', true, 'Health Sciences', 'Business', 9, 1, 3, 4, null, null),
    (183, 'Jurgen', 'Lydia', 'Mentor', '2019-09-21 02:21:29', 'ljurgen52@tripod.com', '716-201-0508', false, 'Political Science', null, 6, 1, 2, 2, 2, null),
    (184, 'Greguoli', 'Janetta', 'Mentor', '2019-11-28 11:21:09', 'jgreguoli53@networksolutions.com', '213-351-0409', true, 'Art', 'Business', 6, 3, 2, 8, 2, null),
    (185, 'Kluss', 'Jacquelyn', 'Mentor', '2022-06-15 20:44:20', 'jkluss54@symantec.com', '469-858-2226', true, 'Computer Science', null, 3, 1, 3, 3, 2, null),
    (186, 'Waples', 'Cathrin', 'Mentor', '2020-03-04 10:09:05', 'cwaples55@meetup.com', '540-405-1972', true, 'Art', null, 2, 3, 3, 4, 3, null),
    (187, 'Petts', 'Nichole', 'Mentor', '2021-05-16 07:58:37', 'npetts56@myspace.com', '191-172-1314', false, 'Computer Science', 'Health Sciences', 10, 1, 1, 8, 1, null),
    (188, 'Comins', 'Wes', 'Mentor', '2022-09-11 17:55:27', 'wcomins57@stumbleupon.com', '386-190-2795', false, 'Engineering', null, 2, 3, 2, 4, 3, null),
    (189, 'Lepper', 'Inger', 'Mentor', '2023-10-10 01:18:11', 'ilepper58@1688.com', '135-677-3308', false, 'English', 'Engineering', 6, 1, 2, 3, 1, null),
    (190, 'Hollingby', 'Johna', 'Mentor', '2020-07-31 12:18:42', 'jhollingby59@usda.gov', '563-211-6809', true, 'Political Science', 'Computer Science', 9, 3, 3, 4, 1, null),
    (191, 'Sysland', 'Faber', 'Mentor', '2024-07-14 22:11:17', 'fsysland5a@technorati.com', '215-782-9573', true, 'Art', null, 1, 2, 3, 8, 2, null),
    (192, 'Cowwell', 'Georges', 'Mentor', '2022-12-23 17:14:50', 'gcowwell5b@miibeian.gov.cn', '414-606-4834', true, 'Health Sciences', null, 7, 1, 3, 7, 1, null),
    (193, 'Martlew', 'Karrie', 'Mentor', '2022-11-16 11:46:40', 'kmartlew5c@loc.gov', '523-786-9181', true, 'Computer Science', null, 4, 1, 1, 1, 2, null),
    (194, 'Purshouse', 'Fawn', 'Mentor', '2021-07-16 12:16:17', 'fpurshouse5d@umn.edu', '576-517-8198', true, 'Math', null, 10, 3, 1, 8, 1, null),
    (195, 'Websdale', 'Natalya', 'Mentor', '2021-12-10 10:48:35', 'nwebsdale5e@java.com', '367-270-5529', true, 'Math', 'Engineering', 5, 2, 2, 4, 2, null),
    (196, 'Munnion', 'Barny', 'Mentor', '2021-06-17 22:50:40', 'bmunnion5f@weibo.com', '503-839-6726', true, 'Data Science', 'Health Sciences', 2, 3, 3, 8, null, null),
    (197, 'Manuely', 'Theodore', 'Mentor', '2023-04-20 19:07:17', 'tmanuely5g@ihg.com', '555-935-9925', true, 'Math', 'English', 8, 1, 2, 2, null, null),
    (198, 'Dowman', 'Hanson', 'Mentor', '2020-03-16 00:05:41', 'hdowman5h@hibu.com', '726-335-9821', true, 'Health Sciences', 'Computer Science', 10, 2, 1, 2, 3, null),
    (199, 'Croisdall', 'Marylee', 'Mentor', '2021-04-19 16:35:32', 'mcroisdall5i@marriott.com', '404-973-3566', false, 'Computer Science', 'Health Sciences', 9, 3, 2, 7, 3, null),
    (200, 'Fishbourn', 'Aleen', 'Mentor', '2021-04-20 20:57:20', 'afishbourn5j@imageshack.us', '720-814-2743', false, 'Music', null, 2, 2, 3, 8, 3, null);

-- Insert into Messages table
insert into messages (MessageID, SentDate, SenderID, ReceiverID, Content, AdminID) values (1, '2023-07-15 08:20:21', 1, 102, 'Intuitive static circuit', 2);
insert into messages (MessageID, SentDate, SenderID, ReceiverID, Content, AdminID) values (2, '2023-12-13 09:08:19', 2, 99, 'Proactive even-keeled product', 3);
insert into messages (MessageID, SentDate, SenderID, ReceiverID, Content, AdminID) values (3, '2021-11-27 06:41:09', 3, 105, 'Implemented tertiary project', 1);
insert into messages (MessageID, SentDate, SenderID, ReceiverID, Content, AdminID) values (4, '2023-03-02 02:51:39', 4, 68, 'Persevering 4th generation challenge', 1);
insert into messages (MessageID, SentDate, SenderID, ReceiverID, Content, AdminID) values (5, '2024-05-29 07:15:10', 5, 186, 'Profound full-range algorithm', 1);
insert into messages (MessageID, SentDate, SenderID, ReceiverID, Content, AdminID) values (6, '2022-10-05 02:26:43', 6, 73, 'Configurable high-level task-force', 3);
insert into messages (MessageID, SentDate, SenderID, ReceiverID, Content, AdminID) values (7, '2024-09-24 16:36:00', 7, 91, 'Profit-focused coherent neural-net', 2);
insert into messages (MessageID, SentDate, SenderID, ReceiverID, Content, AdminID) values (8, '2024-02-10 23:59:04', 8, 52, 'Digitized clear-thinking adapter', 1);
insert into messages (MessageID, SentDate, SenderID, ReceiverID, Content, AdminID) values (9, '2024-01-04 15:50:38', 9, 161, 'Profound tertiary forecast', 2);
insert into messages (MessageID, SentDate, SenderID, ReceiverID, Content, AdminID) values (10, '2020-11-08 09:00:08', 10, 89, 'Progressive solution-oriented task-force', 1);
insert into messages (MessageID, SentDate, SenderID, ReceiverID, Content, AdminID) values (11, '2022-06-12 20:33:05', 11, 164, 'Front-line web-enabled firmware', 1);
insert into messages (MessageID, SentDate, SenderID, ReceiverID, Content, AdminID) values (12, '2021-10-08 14:11:55', 12, 135, 'Function-based multi-tasking challenge', 2);
insert into messages (MessageID, SentDate, SenderID, ReceiverID, Content, AdminID) values (13, '2021-07-28 06:56:46', 13, 70, 'Quality-focused bifurcated analyzer', 1);
insert into messages (MessageID, SentDate, SenderID, ReceiverID, Content, AdminID) values (14, '2021-06-21 03:08:23', 14, 79, 'Reverse-engineered bandwidth-monitored moratorium', 2);
insert into messages (MessageID, SentDate, SenderID, ReceiverID, Content, AdminID) values (15, '2023-05-18 14:56:04', 15, 193, 'Multi-layered radical paradigm', 3);
insert into messages (MessageID, SentDate, SenderID, ReceiverID, Content, AdminID) values (16, '2023-11-07 08:05:46', 16, 104, 'Decentralized 3rd generation leverage', 3);
insert into messages (MessageID, SentDate, SenderID, ReceiverID, Content, AdminID) values (17, '2023-12-14 19:46:34', 17, 147, 'Profit-focused executive migration', 3);
insert into messages (MessageID, SentDate, SenderID, ReceiverID, Content, AdminID) values (18, '2023-04-17 19:15:24', 18, 173, 'Realigned client-server paradigm', 1);
insert into messages (MessageID, SentDate, SenderID, ReceiverID, Content, AdminID) values (19, '2022-01-29 22:05:00', 19, 120, 'Reduced bifurcated forecast', 2);
insert into messages (MessageID, SentDate, SenderID, ReceiverID, Content, AdminID) values (20, '2024-09-30 06:56:56', 20, 129, 'Front-line radical benchmark', 3);
insert into messages (MessageID, SentDate, SenderID, ReceiverID, Content, AdminID) values (21, '2021-04-19 16:05:37', 21, 52, 'Innovative motivating adapter', 2);
insert into messages (MessageID, SentDate, SenderID, ReceiverID, Content, AdminID) values (22, '2021-10-22 07:58:20', 22, 165, 'Multi-layered even-keeled pricing structure', 3);
insert into messages (MessageID, SentDate, SenderID, ReceiverID, Content, AdminID) values (23, '2024-03-15 01:49:33', 23, 52, 'User-centric systematic archive', 2);
insert into messages (MessageID, SentDate, SenderID, ReceiverID, Content, AdminID) values (24, '2023-05-05 18:33:04', 24, 197, 'Vision-oriented tangible moratorium', 2);
insert into messages (MessageID, SentDate, SenderID, ReceiverID, Content, AdminID) values (25, '2022-04-05 19:05:44', 25, 78, 'Switchable reciprocal database', 1);
insert into messages (MessageID, SentDate, SenderID, ReceiverID, Content, AdminID) values (26, '2023-06-14 12:47:40', 26, 55, 'Integrated asynchronous internet solution', 2);
insert into messages (MessageID, SentDate, SenderID, ReceiverID, Content, AdminID) values (27, '2021-06-22 09:16:24', 27, 94, 'Business-focused even-keeled array', 3);
insert into messages (MessageID, SentDate, SenderID, ReceiverID, Content, AdminID) values (28, '2023-02-27 18:32:58', 28, 91, 'User-centric hybrid hierarchy', 1);
insert into messages (MessageID, SentDate, SenderID, ReceiverID, Content, AdminID) values (29, '2024-04-30 18:50:06', 29, 124, 'Centralized eco-centric local area network', 3);
insert into messages (MessageID, SentDate, SenderID, ReceiverID, Content, AdminID) values (30, '2024-11-07 14:24:52', 30, 110, 'Extended actuating migration', 1);
insert into messages (MessageID, SentDate, SenderID, ReceiverID, Content, AdminID) values (31, '2022-08-11 21:37:39', 31, 189, 'Open-architected human-resource neural-net', 2);
insert into messages (MessageID, SentDate, SenderID, ReceiverID, Content, AdminID) values (32, '2024-03-09 05:05:40', 32, 163, 'Polarised responsive internet solution', 2);
insert into messages (MessageID, SentDate, SenderID, ReceiverID, Content, AdminID) values (33, '2024-03-21 19:40:41', 33, 67, 'Persevering asynchronous orchestration', 1);
insert into messages (MessageID, SentDate, SenderID, ReceiverID, Content, AdminID) values (34, '2023-07-12 17:00:34', 34, 178, 'Secured cohesive frame', 3);
insert into messages (MessageID, SentDate, SenderID, ReceiverID, Content, AdminID) values (35, '2022-09-25 04:41:11', 35, 194, 'Reduced coherent approach', 1);
insert into messages (MessageID, SentDate, SenderID, ReceiverID, Content, AdminID) values (36, '2023-03-29 23:59:15', 36, 177, 'Phased maximized structure', 1);
insert into messages (MessageID, SentDate, SenderID, ReceiverID, Content, AdminID) values (37, '2024-04-28 15:02:54', 37, 172, 'Fully-configurable high-level time-frame', 2);
insert into messages (MessageID, SentDate, SenderID, ReceiverID, Content, AdminID) values (38, '2021-09-09 18:51:17', 38, 64, 'Progressive asymmetric paradigm', 2);
insert into messages (MessageID, SentDate, SenderID, ReceiverID, Content, AdminID) values (39, '2021-10-29 18:46:08', 39, 84, 'Right-sized tangible neural-net', 2);
insert into messages (MessageID, SentDate, SenderID, ReceiverID, Content, AdminID) values (40, '2020-11-30 10:20:59', 40, 113, 'Innovative empowering info-mediaries', 2);
insert into messages (MessageID, SentDate, SenderID, ReceiverID, Content, AdminID) values (41, '2023-02-17 11:33:24', 41, 196, 'Enhanced tertiary definition', 3);
insert into messages (MessageID, SentDate, SenderID, ReceiverID, Content, AdminID) values (42, '2020-12-28 21:32:31', 42, 142, 'Profound multi-tasking support', 1);
insert into messages (MessageID, SentDate, SenderID, ReceiverID, Content, AdminID) values (43, '2024-04-17 23:02:32', 43, 160, 'Versatile actuating secured line', 1);
insert into messages (MessageID, SentDate, SenderID, ReceiverID, Content, AdminID) values (44, '2024-08-04 02:44:12', 44, 143, 'Proactive actuating ability', 2);
insert into messages (MessageID, SentDate, SenderID, ReceiverID, Content, AdminID) values (45, '2020-12-03 03:53:26', 45, 187, 'Automated holistic local area network', 2);
insert into messages (MessageID, SentDate, SenderID, ReceiverID, Content, AdminID) values (46, '2023-02-17 15:19:57', 46, 54, 'Profit-focused systemic emulation', 2);
insert into messages (MessageID, SentDate, SenderID, ReceiverID, Content, AdminID) values (47, '2020-11-09 13:14:05', 47, 116, 'Phased web-enabled core', 1);
insert into messages (MessageID, SentDate, SenderID, ReceiverID, Content, AdminID) values (48, '2021-02-18 02:51:33', 48, 56, 'Networked neutral framework', 3);
insert into messages (MessageID, SentDate, SenderID, ReceiverID, Content, AdminID) values (49, '2024-01-16 16:33:22', 49, 55, 'Horizontal cohesive solution', 3);
insert into messages (MessageID, SentDate, SenderID, ReceiverID, Content, AdminID) values (50, '2024-04-21 16:19:06', 50, 64, 'Cross-group high-level standardization', 1);

-- Insert into Posts table
INSERT INTO posts (PostID, UserID, Content, PostDate, AdminID)
VALUES
    (1, 10, 'Mentorship is a valuable experience!', '2023-04-05 08:00:00', 1),
    (2, 34, 'Looking forward to learning more!', '2023-04-06 10:00:00', 2),
    (3, 27, 'Advisors play a key role in guidance.', '2023-04-07 14:00:00', 3),
    (4, 109, 'Excited to help mentees learn about machine learning!', '2023-03-01 09:00:00', 1),
    (5, 182, 'Looking forward to learning from experienced mentors!', '2023-03-02 10:00:00', 2),
    (6, 63, 'Sharing my experience in data visualization with mentees.', '2023-03-03 11:00:00', 3);

-- Insert into Comments table
INSERT INTO comments (CommentID, PostID, CommenterID, CommentDate, Content)
VALUES
    (1, 1, 24, '2023-04-06 09:00:00', 'I agree!'),
    (2, 2, 167, '2023-04-07 11:00:00', 'Happy to help!'),
    (3, 3, 96, '2023-04-08 15:00:00', 'Thank you for your insights.');

-- Insert into Matches table
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (150, 9, true, '2021-12-23 03:33:31', null);
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (114, 10, false, '2022-05-01 19:27:00', null);
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (141, 11, true, '2024-05-28 03:03:43', null);
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (175, 12, false, '2024-07-23 02:33:07', null);
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (136, 13, true, '2021-10-16 01:09:21', null);
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (148, 14, false, '2023-02-04 06:13:00', null);
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (195, 15, false, '2022-06-06 15:33:41', '2023-03-06 02:42:00');
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (155, 16, false, '2022-09-16 23:45:02', null);
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (180, 17, false, '2023-03-08 01:44:57', null);
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (144, 18, false, '2022-10-30 17:43:20', null);
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (105, 19, false, '2021-09-02 11:27:42', null);
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (187, 20, true, '2023-10-18 03:47:40', '2021-01-25 09:23:40');
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (114, 21, false, '2021-08-15 16:39:39', null);
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (148, 22, true, '2022-04-07 15:53:19', '2023-11-04 23:58:56');
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (177, 23, true, '2024-09-05 21:32:05', null);
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (126, 24, true, '2023-03-01 06:44:01', null);
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (197, 25, false, '2022-08-03 00:14:01', null);
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (103, 26, false, '2024-10-10 10:05:50', null);
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (150, 27, true, '2021-12-16 18:19:27', null);
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (152, 28, true, '2024-10-24 01:32:38', null);
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (153, 29, true, '2023-03-18 04:55:37', null);
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (180, 30, true, '2022-07-19 13:52:26', null);
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (137, 31, false, '2022-08-18 19:05:36', '2021-11-22 06:19:45');
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (123, 32, true, '2023-07-28 18:08:50', null);
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (198, 33, false, '2024-05-17 06:05:54', '2022-10-14 23:40:15');
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (181, 34, true, '2023-09-22 04:33:00', null);
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (107, 35, true, '2023-09-15 20:48:20', null);
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (120, 36, false, '2022-09-21 19:30:18', null);
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (146, 37, true, '2021-10-02 14:22:27', null);
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (147, 38, true, '2024-03-05 20:30:32', '2024-06-07 21:11:58');
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (125, 39, true, '2021-08-31 19:13:53', null);
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (181, 40, true, '2021-11-27 11:04:36', null);
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (164, 41, false, '2023-09-28 07:34:50', '2023-12-30 01:40:28');
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (122, 42, true, '2022-01-01 14:12:40', null);
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (194, 43, true, '2021-03-17 20:39:39', '2024-09-27 23:47:57');
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (118, 44, false, '2021-03-26 23:04:28', '2024-09-27 07:22:29');
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (125, 45, true, '2023-11-09 06:16:11', null);
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (120, 46, true, '2022-01-31 06:41:22', null);
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (135, 47, true, '2022-03-16 01:54:26', null);
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (171, 48, false, '2022-04-06 08:20:34', null);
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (167, 49, false, '2021-05-06 22:29:33', null);
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (177, 50, true, '2021-02-17 04:11:18', null);
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (121, 51, true, '2022-10-08 01:32:09', null);
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (138, 52, false, '2024-10-28 14:41:47', null);
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (173, 53, false, '2023-04-07 18:46:55', '2022-01-04 09:48:17');
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (107, 54, false, '2020-10-21 18:06:07', '2024-06-16 23:59:11');
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (114, 55, false, '2021-08-23 00:34:57', null);
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (144, 56, true, '2020-12-05 15:31:52', null);
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (149, 57, true, '2021-12-29 02:53:40', null);
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (134, 58, false, '2021-01-12 20:14:44', null);
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (164, 59, false, '2022-08-15 03:11:05', '2021-11-29 16:29:37');
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (192, 60, false, '2021-02-17 18:33:16', null);
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (128, 61, false, '2024-02-11 00:40:27', null);
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (185, 62, true, '2024-06-13 00:16:15', null);
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (143, 63, true, '2024-07-18 01:18:48', null);
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (139, 64, true, '2022-04-23 19:56:26', null);
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (178, 65, false, '2021-10-11 07:37:59', null);
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (102, 66, true, '2024-07-02 02:33:14', null);
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (153, 67, false, '2021-04-22 21:46:40', null);
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (137, 68, true, '2022-07-13 00:41:55', null);
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (111, 69, false, '2022-09-12 15:28:07', null);
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (128, 70, false, '2022-08-18 05:05:50', null);
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (126, 71, true, '2023-12-09 19:48:00', null);
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (121, 72, false, '2023-12-30 07:15:03', null);
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (180, 73, false, '2021-12-28 00:19:18', null);
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (185, 74, false, '2020-10-08 23:58:11', null);
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (190, 75, true, '2021-10-04 01:59:38', null);
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (131, 76, true, '2023-03-31 22:00:36', null);
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (143, 77, false, '2023-08-14 09:28:21', null);
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (187, 78, true, '2023-09-14 08:33:44', '2021-11-15 17:44:29');
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (200, 79, true, '2024-06-11 23:53:27', '2022-09-12 23:08:01');
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (165, 80, true, '2020-12-23 22:19:17', null);
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (151, 81, false, '2023-02-05 21:37:08', null);
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (196, 82, false, '2022-03-18 09:23:36', null);
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (165, 83, true, '2021-11-14 09:52:49', '2022-11-11 21:06:46');
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (134, 84, false, '2022-09-27 19:35:24', null);
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (127, 85, true, '2021-03-31 23:38:49', null);
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (178, 86, true, '2022-03-04 10:41:58', null);
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (138, 87, false, '2024-02-11 14:58:27', null);
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (199, 88, false, '2024-08-17 07:43:37', '2021-08-08 11:17:07');
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (133, 89, false, '2021-11-27 16:22:43', null);
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (144, 90, true, '2022-10-03 13:15:23', null);
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (145, 91, true, '2023-04-25 13:27:18', null);
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (137, 92, true, '2021-04-30 05:49:51', null);
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (157, 93, true, '2024-08-06 19:08:39', null);
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (105, 94, false, '2023-06-07 04:38:26', null);
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (149, 95, true, '2023-02-07 00:28:04', null);
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (106, 96, true, '2024-04-07 01:03:09', null);
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (153, 97, false, '2021-12-06 22:00:58', null);
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (119, 98, true, '2023-03-14 09:35:54', null);
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (103, 99, false, '2022-06-17 14:51:41', null);
insert into matches (MentorID, MenteeID, Recommended, Start, End) values (105, 100, false, '2024-03-21 20:30:24', null);

-- Insert into Interests table
insert into interests (InterestID, UserID, Interest) values (9, 9, 'social justice');
insert into interests (InterestID, UserID, Interest) values (10, 10, 'creative writing');
insert into interests (InterestID, UserID, Interest) values (11, 11, 'social justice');
insert into interests (InterestID, UserID, Interest) values (12, 12, 'statistical analysis');
insert into interests (InterestID, UserID, Interest) values (13, 13, 'music production');
insert into interests (InterestID, UserID, Interest) values (14, 14, 'music production');
insert into interests (InterestID, UserID, Interest) values (15, 15, 'classical music');
insert into interests (InterestID, UserID, Interest) values (16, 16, 'political theory');
insert into interests (InterestID, UserID, Interest) values (17, 17, 'political theory');
insert into interests (InterestID, UserID, Interest) values (18, 18, 'entrepreneurship');
insert into interests (InterestID, UserID, Interest) values (19, 19, 'music production');
insert into interests (InterestID, UserID, Interest) values (20, 20, 'social justice');
insert into interests (InterestID, UserID, Interest) values (21, 21, 'public health');
insert into interests (InterestID, UserID, Interest) values (22, 22, 'entrepreneurship');
insert into interests (InterestID, UserID, Interest) values (23, 23, 'entrepreneurship');
insert into interests (InterestID, UserID, Interest) values (24, 24, 'software development');
insert into interests (InterestID, UserID, Interest) values (25, 25, 'social justice');
insert into interests (InterestID, UserID, Interest) values (26, 26, 'digital marketing');
insert into interests (InterestID, UserID, Interest) values (27, 27, 'cybersecurity');
insert into interests (InterestID, UserID, Interest) values (28, 28, 'literature analysis');
insert into interests (InterestID, UserID, Interest) values (29, 29, 'social justice');
insert into interests (InterestID, UserID, Interest) values (30, 30, 'biomechanics');
insert into interests (InterestID, UserID, Interest) values (31, 31, 'cybersecurity');
insert into interests (InterestID, UserID, Interest) values (32, 32, 'artificial intelligence');
insert into interests (InterestID, UserID, Interest) values (33, 33, 'cybersecurity');
insert into interests (InterestID, UserID, Interest) values (34, 34, 'renewable energy');
insert into interests (InterestID, UserID, Interest) values (35, 35, 'data visualization');
insert into interests (InterestID, UserID, Interest) values (36, 36, 'software development');
insert into interests (InterestID, UserID, Interest) values (37, 37, 'social justice');
insert into interests (InterestID, UserID, Interest) values (38, 38, 'classical music');
insert into interests (InterestID, UserID, Interest) values (39, 39, 'robotics');
insert into interests (InterestID, UserID, Interest) values (40, 40, 'graphic design');
insert into interests (InterestID, UserID, Interest) values (41, 41, 'software development');
insert into interests (InterestID, UserID, Interest) values (42, 42, 'machine learning');
insert into interests (InterestID, UserID, Interest) values (43, 43, 'creative writing');
insert into interests (InterestID, UserID, Interest) values (44, 44, 'creative writing');
insert into interests (InterestID, UserID, Interest) values (45, 45, 'entrepreneurship');
insert into interests (InterestID, UserID, Interest) values (46, 46, 'blockchain technology');
insert into interests (InterestID, UserID, Interest) values (47, 47, 'statistical analysis');
insert into interests (InterestID, UserID, Interest) values (48, 48, 'statistical analysis');
insert into interests (InterestID, UserID, Interest) values (49, 49, 'cybersecurity');
insert into interests (InterestID, UserID, Interest) values (50, 50, 'social justice');
insert into interests (InterestID, UserID, Interest) values (51, 51, 'digital marketing');
insert into interests (InterestID, UserID, Interest) values (52, 52, 'renewable energy');
insert into interests (InterestID, UserID, Interest) values (53, 53, 'machine learning');
insert into interests (InterestID, UserID, Interest) values (54, 54, 'cybersecurity');
insert into interests (InterestID, UserID, Interest) values (55, 55, 'blockchain technology');
insert into interests (InterestID, UserID, Interest) values (56, 56, 'literature analysis');
insert into interests (InterestID, UserID, Interest) values (57, 57, 'robotics');
insert into interests (InterestID, UserID, Interest) values (58, 58, 'statistical analysis');
insert into interests (InterestID, UserID, Interest) values (59, 59, 'robotics');
insert into interests (InterestID, UserID, Interest) values (60, 60, 'public health');
insert into interests (InterestID, UserID, Interest) values (61, 61, 'graphic design');
insert into interests (InterestID, UserID, Interest) values (62, 62, 'statistical analysis');
insert into interests (InterestID, UserID, Interest) values (63, 63, 'machine learning');
insert into interests (InterestID, UserID, Interest) values (64, 64, 'music production');
insert into interests (InterestID, UserID, Interest) values (65, 65, 'literature analysis');
insert into interests (InterestID, UserID, Interest) values (66, 66, 'graphic design');
insert into interests (InterestID, UserID, Interest) values (67, 67, 'cybersecurity');
insert into interests (InterestID, UserID, Interest) values (68, 68, 'classical music');
insert into interests (InterestID, UserID, Interest) values (69, 69, 'artificial intelligence');
insert into interests (InterestID, UserID, Interest) values (70, 70, 'political theory');
insert into interests (InterestID, UserID, Interest) values (71, 71, 'public health');
insert into interests (InterestID, UserID, Interest) values (72, 72, 'music production');
insert into interests (InterestID, UserID, Interest) values (73, 73, 'statistical analysis');
insert into interests (InterestID, UserID, Interest) values (74, 74, 'graphic design');
insert into interests (InterestID, UserID, Interest) values (75, 75, 'blockchain technology');
insert into interests (InterestID, UserID, Interest) values (76, 76, 'graphic design');
insert into interests (InterestID, UserID, Interest) values (77, 77, 'literature analysis');
insert into interests (InterestID, UserID, Interest) values (78, 78, 'creative writing');
insert into interests (InterestID, UserID, Interest) values (79, 79, 'robotics');
insert into interests (InterestID, UserID, Interest) values (80, 80, 'artificial intelligence');
insert into interests (InterestID, UserID, Interest) values (81, 81, 'digital marketing');
insert into interests (InterestID, UserID, Interest) values (82, 82, 'blockchain technology');
insert into interests (InterestID, UserID, Interest) values (83, 83, 'blockchain technology');
insert into interests (InterestID, UserID, Interest) values (84, 84, 'cybersecurity');
insert into interests (InterestID, UserID, Interest) values (85, 85, 'public health');
insert into interests (InterestID, UserID, Interest) values (86, 86, 'classical music');
insert into interests (InterestID, UserID, Interest) values (87, 87, 'statistical analysis');
insert into interests (InterestID, UserID, Interest) values (88, 88, 'data visualization');
insert into interests (InterestID, UserID, Interest) values (89, 89, 'artificial intelligence');
insert into interests (InterestID, UserID, Interest) values (90, 90, 'social justice');
insert into interests (InterestID, UserID, Interest) values (91, 91, 'political theory');
insert into interests (InterestID, UserID, Interest) values (92, 92, 'classical music');
insert into interests (InterestID, UserID, Interest) values (93, 93, 'digital marketing');
insert into interests (InterestID, UserID, Interest) values (94, 94, 'social justice');
insert into interests (InterestID, UserID, Interest) values (95, 95, 'classical music');
insert into interests (InterestID, UserID, Interest) values (96, 96, 'statistical analysis');
insert into interests (InterestID, UserID, Interest) values (97, 97, 'music production');
insert into interests (InterestID, UserID, Interest) values (98, 98, 'digital marketing');
insert into interests (InterestID, UserID, Interest) values (99, 99, 'creative writing');
insert into interests (InterestID, UserID, Interest) values (100, 100, 'social justice');
insert into interests (InterestID, UserID, Interest) values (101, 101, 'public health');
insert into interests (InterestID, UserID, Interest) values (102, 102, 'classical music');
insert into interests (InterestID, UserID, Interest) values (103, 103, 'classical music');
insert into interests (InterestID, UserID, Interest) values (104, 104, 'entrepreneurship');
insert into interests (InterestID, UserID, Interest) values (105, 105, 'robotics');
insert into interests (InterestID, UserID, Interest) values (106, 106, 'entrepreneurship');
insert into interests (InterestID, UserID, Interest) values (107, 107, 'literature analysis');
insert into interests (InterestID, UserID, Interest) values (108, 108, 'renewable energy');
insert into interests (InterestID, UserID, Interest) values (109, 109, 'biomechanics');
insert into interests (InterestID, UserID, Interest) values (110, 110, 'public health');
insert into interests (InterestID, UserID, Interest) values (111, 111, 'data visualization');
insert into interests (InterestID, UserID, Interest) values (112, 112, 'entrepreneurship');
insert into interests (InterestID, UserID, Interest) values (113, 113, 'biomechanics');
insert into interests (InterestID, UserID, Interest) values (114, 114, 'machine learning');
insert into interests (InterestID, UserID, Interest) values (115, 115, 'artificial intelligence');
insert into interests (InterestID, UserID, Interest) values (116, 116, 'music production');
insert into interests (InterestID, UserID, Interest) values (117, 117, 'renewable energy');
insert into interests (InterestID, UserID, Interest) values (118, 118, 'statistical analysis');
insert into interests (InterestID, UserID, Interest) values (119, 119, 'classical music');
insert into interests (InterestID, UserID, Interest) values (120, 120, 'software development');
insert into interests (InterestID, UserID, Interest) values (121, 121, 'biomechanics');
insert into interests (InterestID, UserID, Interest) values (122, 122, 'social justice');
insert into interests (InterestID, UserID, Interest) values (123, 123, 'classical music');
insert into interests (InterestID, UserID, Interest) values (124, 124, 'machine learning');
insert into interests (InterestID, UserID, Interest) values (125, 125, 'cybersecurity');
insert into interests (InterestID, UserID, Interest) values (126, 126, 'digital marketing');
insert into interests (InterestID, UserID, Interest) values (127, 127, 'social justice');
insert into interests (InterestID, UserID, Interest) values (128, 128, 'blockchain technology');
insert into interests (InterestID, UserID, Interest) values (129, 129, 'software development');
insert into interests (InterestID, UserID, Interest) values (130, 130, 'renewable energy');
insert into interests (InterestID, UserID, Interest) values (131, 131, 'data visualization');
insert into interests (InterestID, UserID, Interest) values (132, 132, 'statistical analysis');
insert into interests (InterestID, UserID, Interest) values (133, 133, 'classical music');
insert into interests (InterestID, UserID, Interest) values (134, 134, 'entrepreneurship');
insert into interests (InterestID, UserID, Interest) values (135, 135, 'cybersecurity');
insert into interests (InterestID, UserID, Interest) values (136, 136, 'creative writing');
insert into interests (InterestID, UserID, Interest) values (137, 137, 'blockchain technology');
insert into interests (InterestID, UserID, Interest) values (138, 138, 'artificial intelligence');
insert into interests (InterestID, UserID, Interest) values (139, 139, 'robotics');
insert into interests (InterestID, UserID, Interest) values (140, 140, 'creative writing');
insert into interests (InterestID, UserID, Interest) values (141, 141, 'data visualization');
insert into interests (InterestID, UserID, Interest) values (142, 142, 'graphic design');
insert into interests (InterestID, UserID, Interest) values (143, 143, 'classical music');
insert into interests (InterestID, UserID, Interest) values (144, 144, 'literature analysis');
insert into interests (InterestID, UserID, Interest) values (145, 145, 'renewable energy');
insert into interests (InterestID, UserID, Interest) values (146, 146, 'robotics');
insert into interests (InterestID, UserID, Interest) values (147, 147, 'artificial intelligence');
insert into interests (InterestID, UserID, Interest) values (148, 148, 'political theory');
insert into interests (InterestID, UserID, Interest) values (149, 149, 'graphic design');
insert into interests (InterestID, UserID, Interest) values (150, 150, 'software development');
insert into interests (InterestID, UserID, Interest) values (151, 151, 'classical music');
insert into interests (InterestID, UserID, Interest) values (152, 152, 'creative writing');
insert into interests (InterestID, UserID, Interest) values (153, 153, 'public health');
insert into interests (InterestID, UserID, Interest) values (154, 154, 'cybersecurity');
insert into interests (InterestID, UserID, Interest) values (155, 155, 'robotics');
insert into interests (InterestID, UserID, Interest) values (156, 156, 'classical music');
insert into interests (InterestID, UserID, Interest) values (157, 157, 'statistical analysis');
insert into interests (InterestID, UserID, Interest) values (158, 158, 'biomechanics');
insert into interests (InterestID, UserID, Interest) values (159, 159, 'graphic design');
insert into interests (InterestID, UserID, Interest) values (160, 160, 'public health');
insert into interests (InterestID, UserID, Interest) values (161, 161, 'digital marketing');
insert into interests (InterestID, UserID, Interest) values (162, 162, 'artificial intelligence');
insert into interests (InterestID, UserID, Interest) values (163, 163, 'blockchain technology');
insert into interests (InterestID, UserID, Interest) values (164, 164, 'creative writing');
insert into interests (InterestID, UserID, Interest) values (165, 165, 'music production');
insert into interests (InterestID, UserID, Interest) values (166, 166, 'software development');
insert into interests (InterestID, UserID, Interest) values (167, 167, 'graphic design');
insert into interests (InterestID, UserID, Interest) values (168, 168, 'classical music');
insert into interests (InterestID, UserID, Interest) values (169, 169, 'software development');
insert into interests (InterestID, UserID, Interest) values (170, 170, 'literature analysis');
insert into interests (InterestID, UserID, Interest) values (171, 171, 'political theory');
insert into interests (InterestID, UserID, Interest) values (172, 172, 'statistical analysis');
insert into interests (InterestID, UserID, Interest) values (173, 173, 'graphic design');
insert into interests (InterestID, UserID, Interest) values (174, 174, 'creative writing');
insert into interests (InterestID, UserID, Interest) values (175, 175, 'public health');
insert into interests (InterestID, UserID, Interest) values (176, 176, 'public health');
insert into interests (InterestID, UserID, Interest) values (177, 177, 'machine learning');
insert into interests (InterestID, UserID, Interest) values (178, 178, 'biomechanics');
insert into interests (InterestID, UserID, Interest) values (179, 179, 'blockchain technology');
insert into interests (InterestID, UserID, Interest) values (180, 180, 'classical music');
insert into interests (InterestID, UserID, Interest) values (181, 181, 'cybersecurity');
insert into interests (InterestID, UserID, Interest) values (182, 182, 'digital marketing');
insert into interests (InterestID, UserID, Interest) values (183, 183, 'social justice');
insert into interests (InterestID, UserID, Interest) values (184, 184, 'music production');
insert into interests (InterestID, UserID, Interest) values (185, 185, 'artificial intelligence');
insert into interests (InterestID, UserID, Interest) values (186, 186, 'biomechanics');
insert into interests (InterestID, UserID, Interest) values (187, 187, 'biomechanics');
insert into interests (InterestID, UserID, Interest) values (188, 188, 'cybersecurity');
insert into interests (InterestID, UserID, Interest) values (189, 189, 'entrepreneurship');
insert into interests (InterestID, UserID, Interest) values (190, 190, 'statistical analysis');
insert into interests (InterestID, UserID, Interest) values (191, 191, 'biomechanics');
insert into interests (InterestID, UserID, Interest) values (192, 192, 'software development');
insert into interests (InterestID, UserID, Interest) values (193, 193, 'data visualization');
insert into interests (InterestID, UserID, Interest) values (194, 194, 'biomechanics');
insert into interests (InterestID, UserID, Interest) values (195, 195, 'cybersecurity');
insert into interests (InterestID, UserID, Interest) values (196, 196, 'public health');
insert into interests (InterestID, UserID, Interest) values (197, 197, 'artificial intelligence');
insert into interests (InterestID, UserID, Interest) values (198, 198, 'music production');
insert into interests (InterestID, UserID, Interest) values (199, 199, 'music production');
insert into interests (InterestID, UserID, Interest) values (200, 200, 'machine learning');

-- Insert into Skills table
insert into skills (SkillID, UserID, Skill) values (9, 9, 'statistical modeling');
insert into skills (SkillID, UserID, Skill) values (10, 10, 'networking');
insert into skills (SkillID, UserID, Skill) values (11, 11, 'research');
insert into skills (SkillID, UserID, Skill) values (12, 12, 'research');
insert into skills (SkillID, UserID, Skill) values (13, 13, 'statistical modeling');
insert into skills (SkillID, UserID, Skill) values (14, 14, 'creativity');
insert into skills (SkillID, UserID, Skill) values (15, 15, 'Data analysis');
insert into skills (SkillID, UserID, Skill) values (16, 16, 'adaptability');
insert into skills (SkillID, UserID, Skill) values (17, 17, 'technical writing');
insert into skills (SkillID, UserID, Skill) values (18, 18, 'project management');
insert into skills (SkillID, UserID, Skill) values (19, 19, 'writing');
insert into skills (SkillID, UserID, Skill) values (20, 20, 'creativity');
insert into skills (SkillID, UserID, Skill) values (21, 21, 'research');
insert into skills (SkillID, UserID, Skill) values (22, 22, 'research');
insert into skills (SkillID, UserID, Skill) values (23, 23, 'public speaking');
insert into skills (SkillID, UserID, Skill) values (24, 24, 'statistical modeling');
insert into skills (SkillID, UserID, Skill) values (25, 25, 'statistical modeling');
insert into skills (SkillID, UserID, Skill) values (26, 26, 'problem-solving');
insert into skills (SkillID, UserID, Skill) values (27, 27, 'time management');
insert into skills (SkillID, UserID, Skill) values (28, 28, 'leadership');
insert into skills (SkillID, UserID, Skill) values (29, 29, 'conflict resolution');
insert into skills (SkillID, UserID, Skill) values (30, 30, 'communication');
insert into skills (SkillID, UserID, Skill) values (31, 31, 'Data analysis');
insert into skills (SkillID, UserID, Skill) values (32, 32, 'statistical modeling');
insert into skills (SkillID, UserID, Skill) values (33, 33, 'problem-solving');
insert into skills (SkillID, UserID, Skill) values (34, 34, 'technical writing');
insert into skills (SkillID, UserID, Skill) values (35, 35, 'communication');
insert into skills (SkillID, UserID, Skill) values (36, 36, 'public speaking');
insert into skills (SkillID, UserID, Skill) values (37, 37, 'research');
insert into skills (SkillID, UserID, Skill) values (38, 38, 'technical writing');
insert into skills (SkillID, UserID, Skill) values (39, 39, 'technical writing');
insert into skills (SkillID, UserID, Skill) values (40, 40, 'programming');
insert into skills (SkillID, UserID, Skill) values (41, 41, 'graphic design');
insert into skills (SkillID, UserID, Skill) values (42, 42, 'coding');
insert into skills (SkillID, UserID, Skill) values (43, 43, 'critical thinking');
insert into skills (SkillID, UserID, Skill) values (44, 44, 'project management');
insert into skills (SkillID, UserID, Skill) values (45, 45, 'conflict resolution');
insert into skills (SkillID, UserID, Skill) values (46, 46, 'Data analysis');
insert into skills (SkillID, UserID, Skill) values (47, 47, 'conflict resolution');
insert into skills (SkillID, UserID, Skill) values (48, 48, 'time management');
insert into skills (SkillID, UserID, Skill) values (49, 49, 'creativity');
insert into skills (SkillID, UserID, Skill) values (50, 50, 'conflict resolution');
insert into skills (SkillID, UserID, Skill) values (51, 51, 'project management');
insert into skills (SkillID, UserID, Skill) values (52, 52, 'adaptability');
insert into skills (SkillID, UserID, Skill) values (53, 53, 'creativity');
insert into skills (SkillID, UserID, Skill) values (54, 54, 'public speaking');
insert into skills (SkillID, UserID, Skill) values (55, 55, 'graphic design');
insert into skills (SkillID, UserID, Skill) values (56, 56, 'conflict resolution');
insert into skills (SkillID, UserID, Skill) values (57, 57, 'conflict resolution');
insert into skills (SkillID, UserID, Skill) values (58, 58, 'graphic design');
insert into skills (SkillID, UserID, Skill) values (59, 59, 'statistical modeling');
insert into skills (SkillID, UserID, Skill) values (60, 60, 'project management');
insert into skills (SkillID, UserID, Skill) values (61, 61, 'teamwork');
insert into skills (SkillID, UserID, Skill) values (62, 62, 'communication');
insert into skills (SkillID, UserID, Skill) values (63, 63, 'teamwork');
insert into skills (SkillID, UserID, Skill) values (64, 64, 'graphic design');
insert into skills (SkillID, UserID, Skill) values (65, 65, 'project management');
insert into skills (SkillID, UserID, Skill) values (66, 66, 'conflict resolution');
insert into skills (SkillID, UserID, Skill) values (67, 67, 'leadership');
insert into skills (SkillID, UserID, Skill) values (68, 68, 'conflict resolution');
insert into skills (SkillID, UserID, Skill) values (69, 69, 'problem-solving');
insert into skills (SkillID, UserID, Skill) values (70, 70, 'adaptability');
insert into skills (SkillID, UserID, Skill) values (71, 71, 'public speaking');
insert into skills (SkillID, UserID, Skill) values (72, 72, 'teamwork');
insert into skills (SkillID, UserID, Skill) values (73, 73, 'coding');
insert into skills (SkillID, UserID, Skill) values (74, 74, 'leadership');
insert into skills (SkillID, UserID, Skill) values (75, 75, 'statistical modeling');
insert into skills (SkillID, UserID, Skill) values (76, 76, 'time management');
insert into skills (SkillID, UserID, Skill) values (77, 77, 'time management');
insert into skills (SkillID, UserID, Skill) values (78, 78, 'writing');
insert into skills (SkillID, UserID, Skill) values (79, 79, 'writing');
insert into skills (SkillID, UserID, Skill) values (80, 80, 'research');
insert into skills (SkillID, UserID, Skill) values (81, 81, 'communication');
insert into skills (SkillID, UserID, Skill) values (82, 82, 'creativity');
insert into skills (SkillID, UserID, Skill) values (83, 83, 'public speaking');
insert into skills (SkillID, UserID, Skill) values (84, 84, 'problem-solving');
insert into skills (SkillID, UserID, Skill) values (85, 85, 'communication');
insert into skills (SkillID, UserID, Skill) values (86, 86, 'coding');
insert into skills (SkillID, UserID, Skill) values (87, 87, 'adaptability');
insert into skills (SkillID, UserID, Skill) values (88, 88, 'writing');
insert into skills (SkillID, UserID, Skill) values (89, 89, 'graphic design');
insert into skills (SkillID, UserID, Skill) values (90, 90, 'creativity');
insert into skills (SkillID, UserID, Skill) values (91, 91, 'problem-solving');
insert into skills (SkillID, UserID, Skill) values (92, 92, 'problem-solving');
insert into skills (SkillID, UserID, Skill) values (93, 93, 'project management');
insert into skills (SkillID, UserID, Skill) values (94, 94, 'creativity');
insert into skills (SkillID, UserID, Skill) values (95, 95, 'public speaking');
insert into skills (SkillID, UserID, Skill) values (96, 96, 'adaptability');
insert into skills (SkillID, UserID, Skill) values (97, 97, 'time management');
insert into skills (SkillID, UserID, Skill) values (98, 98, 'project management');
insert into skills (SkillID, UserID, Skill) values (99, 99, 'statistical modeling');
insert into skills (SkillID, UserID, Skill) values (100, 100, 'public speaking');
insert into skills (SkillID, UserID, Skill) values (101, 101, 'adaptability');
insert into skills (SkillID, UserID, Skill) values (102, 102, 'communication');
insert into skills (SkillID, UserID, Skill) values (103, 103, 'public speaking');
insert into skills (SkillID, UserID, Skill) values (104, 104, 'technical writing');
insert into skills (SkillID, UserID, Skill) values (105, 105, 'communication');
insert into skills (SkillID, UserID, Skill) values (106, 106, 'writing');
insert into skills (SkillID, UserID, Skill) values (107, 107, 'coding');
insert into skills (SkillID, UserID, Skill) values (108, 108, 'public speaking');
insert into skills (SkillID, UserID, Skill) values (109, 109, 'statistical modeling');
insert into skills (SkillID, UserID, Skill) values (110, 110, 'leadership');
insert into skills (SkillID, UserID, Skill) values (111, 111, 'critical thinking');
insert into skills (SkillID, UserID, Skill) values (112, 112, 'public speaking');
insert into skills (SkillID, UserID, Skill) values (113, 113, 'communication');
insert into skills (SkillID, UserID, Skill) values (114, 114, 'Data analysis');
insert into skills (SkillID, UserID, Skill) values (115, 115, 'conflict resolution');
insert into skills (SkillID, UserID, Skill) values (116, 116, 'conflict resolution');
insert into skills (SkillID, UserID, Skill) values (117, 117, 'graphic design');
insert into skills (SkillID, UserID, Skill) values (118, 118, 'Data analysis');
insert into skills (SkillID, UserID, Skill) values (119, 119, 'graphic design');
insert into skills (SkillID, UserID, Skill) values (120, 120, 'research');
insert into skills (SkillID, UserID, Skill) values (121, 121, 'adaptability');
insert into skills (SkillID, UserID, Skill) values (122, 122, 'graphic design');
insert into skills (SkillID, UserID, Skill) values (123, 123, 'critical thinking');
insert into skills (SkillID, UserID, Skill) values (124, 124, 'public speaking');
insert into skills (SkillID, UserID, Skill) values (125, 125, 'creativity');
insert into skills (SkillID, UserID, Skill) values (126, 126, 'leadership');
insert into skills (SkillID, UserID, Skill) values (127, 127, 'creativity');
insert into skills (SkillID, UserID, Skill) values (128, 128, 'Data analysis');
insert into skills (SkillID, UserID, Skill) values (129, 129, 'networking');
insert into skills (SkillID, UserID, Skill) values (130, 130, 'problem-solving');
insert into skills (SkillID, UserID, Skill) values (131, 131, 'public speaking');
insert into skills (SkillID, UserID, Skill) values (132, 132, 'time management');
insert into skills (SkillID, UserID, Skill) values (133, 133, 'networking');
insert into skills (SkillID, UserID, Skill) values (134, 134, 'writing');
insert into skills (SkillID, UserID, Skill) values (135, 135, 'leadership');
insert into skills (SkillID, UserID, Skill) values (136, 136, 'graphic design');
insert into skills (SkillID, UserID, Skill) values (137, 137, 'public speaking');
insert into skills (SkillID, UserID, Skill) values (138, 138, 'research');
insert into skills (SkillID, UserID, Skill) values (139, 139, 'research');
insert into skills (SkillID, UserID, Skill) values (140, 140, 'problem-solving');
insert into skills (SkillID, UserID, Skill) values (141, 141, 'problem-solving');
insert into skills (SkillID, UserID, Skill) values (142, 142, 'critical thinking');
insert into skills (SkillID, UserID, Skill) values (143, 143, 'programming');
insert into skills (SkillID, UserID, Skill) values (144, 144, 'project management');
insert into skills (SkillID, UserID, Skill) values (145, 145, 'Data analysis');
insert into skills (SkillID, UserID, Skill) values (146, 146, 'public speaking');
insert into skills (SkillID, UserID, Skill) values (147, 147, 'time management');
insert into skills (SkillID, UserID, Skill) values (148, 148, 'time management');
insert into skills (SkillID, UserID, Skill) values (149, 149, 'adaptability');
insert into skills (SkillID, UserID, Skill) values (150, 150, 'critical thinking');
insert into skills (SkillID, UserID, Skill) values (151, 151, 'research');
insert into skills (SkillID, UserID, Skill) values (152, 152, 'time management');
insert into skills (SkillID, UserID, Skill) values (153, 153, 'problem-solving');
insert into skills (SkillID, UserID, Skill) values (154, 154, 'graphic design');
insert into skills (SkillID, UserID, Skill) values (155, 155, 'adaptability');
insert into skills (SkillID, UserID, Skill) values (156, 156, 'coding');
insert into skills (SkillID, UserID, Skill) values (157, 157, 'writing');
insert into skills (SkillID, UserID, Skill) values (158, 158, 'communication');
insert into skills (SkillID, UserID, Skill) values (159, 159, 'research');
insert into skills (SkillID, UserID, Skill) values (160, 160, 'statistical modeling');
insert into skills (SkillID, UserID, Skill) values (161, 161, 'creativity');
insert into skills (SkillID, UserID, Skill) values (162, 162, 'leadership');
insert into skills (SkillID, UserID, Skill) values (163, 163, 'coding');
insert into skills (SkillID, UserID, Skill) values (164, 164, 'research');
insert into skills (SkillID, UserID, Skill) values (165, 165, 'Data analysis');
insert into skills (SkillID, UserID, Skill) values (166, 166, 'networking');
insert into skills (SkillID, UserID, Skill) values (167, 167, 'statistical modeling');
insert into skills (SkillID, UserID, Skill) values (168, 168, 'coding');
insert into skills (SkillID, UserID, Skill) values (169, 169, 'technical writing');
insert into skills (SkillID, UserID, Skill) values (170, 170, 'adaptability');
insert into skills (SkillID, UserID, Skill) values (171, 171, 'public speaking');
insert into skills (SkillID, UserID, Skill) values (172, 172, 'communication');
insert into skills (SkillID, UserID, Skill) values (173, 173, 'graphic design');
insert into skills (SkillID, UserID, Skill) values (174, 174, 'leadership');
insert into skills (SkillID, UserID, Skill) values (175, 175, 'creativity');
insert into skills (SkillID, UserID, Skill) values (176, 176, 'public speaking');
insert into skills (SkillID, UserID, Skill) values (177, 177, 'coding');
insert into skills (SkillID, UserID, Skill) values (178, 178, 'adaptability');
insert into skills (SkillID, UserID, Skill) values (179, 179, 'technical writing');
insert into skills (SkillID, UserID, Skill) values (180, 180, 'Data analysis');
insert into skills (SkillID, UserID, Skill) values (181, 181, 'critical thinking');
insert into skills (SkillID, UserID, Skill) values (182, 182, 'project management');
insert into skills (SkillID, UserID, Skill) values (183, 183, 'leadership');
insert into skills (SkillID, UserID, Skill) values (184, 184, 'graphic design');
insert into skills (SkillID, UserID, Skill) values (185, 185, 'graphic design');
insert into skills (SkillID, UserID, Skill) values (186, 186, 'critical thinking');
insert into skills (SkillID, UserID, Skill) values (187, 187, 'writing');
insert into skills (SkillID, UserID, Skill) values (188, 188, 'writing');
insert into skills (SkillID, UserID, Skill) values (189, 189, 'graphic design');
insert into skills (SkillID, UserID, Skill) values (190, 190, 'communication');
insert into skills (SkillID, UserID, Skill) values (191, 191, 'graphic design');
insert into skills (SkillID, UserID, Skill) values (192, 192, 'writing');
insert into skills (SkillID, UserID, Skill) values (193, 193, 'research');
insert into skills (SkillID, UserID, Skill) values (194, 194, 'time management');
insert into skills (SkillID, UserID, Skill) values (195, 195, 'critical thinking');
insert into skills (SkillID, UserID, Skill) values (196, 196, 'graphic design');
insert into skills (SkillID, UserID, Skill) values (197, 197, 'networking');
insert into skills (SkillID, UserID, Skill) values (198, 198, 'project management');
insert into skills (SkillID, UserID, Skill) values (199, 199, 'time management');
insert into skills (SkillID, UserID, Skill) values (200, 200, 'graphic design');

-- Insert into Career Goals table
insert into career_goals (GoalID, UserID, Goal) values (9, 9, 'design sustainable technology');
insert into career_goals (GoalID, UserID, Goal) values (10, 10, 'lead a research project');
insert into career_goals (GoalID, UserID, Goal) values (11, 11, 'build a personal brand');
insert into career_goals (GoalID, UserID, Goal) values (12, 12, 'publish a novel');
insert into career_goals (GoalID, UserID, Goal) values (13, 13, 'become a university professor');
insert into career_goals (GoalID, UserID, Goal) values (14, 14, 'design sustainable technology');
insert into career_goals (GoalID, UserID, Goal) values (15, 15, 'revolutionize user experiences');
insert into career_goals (GoalID, UserID, Goal) values (16, 16, 'start a successful business');
insert into career_goals (GoalID, UserID, Goal) values (17, 17, 'lead a research project');
insert into career_goals (GoalID, UserID, Goal) values (18, 18, 'achieve financial independence');
insert into career_goals (GoalID, UserID, Goal) values (19, 19, 'develop innovative software');
insert into career_goals (GoalID, UserID, Goal) values (20, 20, 'achieve financial independence');
insert into career_goals (GoalID, UserID, Goal) values (21, 21, 'establish a health startup');
insert into career_goals (GoalID, UserID, Goal) values (22, 22, 'establish a health startup');
insert into career_goals (GoalID, UserID, Goal) values (23, 23, 'lead a research project');
insert into career_goals (GoalID, UserID, Goal) values (24, 24, 'establish a health startup');
insert into career_goals (GoalID, UserID, Goal) values (25, 25, 'develop innovative software');
insert into career_goals (GoalID, UserID, Goal) values (26, 26, 'work as a political strategist');
insert into career_goals (GoalID, UserID, Goal) values (27, 27, 'develop innovative software');
insert into career_goals (GoalID, UserID, Goal) values (28, 28, 'mentor future professionals');
insert into career_goals (GoalID, UserID, Goal) values (29, 29, 'advocate for policy change');
insert into career_goals (GoalID, UserID, Goal) values (30, 30, 'create impactful art');
insert into career_goals (GoalID, UserID, Goal) values (31, 31, 'publish a novel');
insert into career_goals (GoalID, UserID, Goal) values (32, 32, 'become a university professor');
insert into career_goals (GoalID, UserID, Goal) values (33, 33, 'conduct groundbreaking research');
insert into career_goals (GoalID, UserID, Goal) values (34, 34, 'develop innovative software');
insert into career_goals (GoalID, UserID, Goal) values (35, 35, 'improve public health outcomes');
insert into career_goals (GoalID, UserID, Goal) values (36, 36, 'work as a political strategist');
insert into career_goals (GoalID, UserID, Goal) values (37, 37, 'advocate for policy change');
insert into career_goals (GoalID, UserID, Goal) values (38, 38, 'publish a novel');
insert into career_goals (GoalID, UserID, Goal) values (39, 39, 'become a data scientist');
insert into career_goals (GoalID, UserID, Goal) values (40, 40, 'advocate for policy change');
insert into career_goals (GoalID, UserID, Goal) values (41, 41, 'achieve financial independence');
insert into career_goals (GoalID, UserID, Goal) values (42, 42, 'conduct groundbreaking research');
insert into career_goals (GoalID, UserID, Goal) values (43, 43, 'start a successful business');
insert into career_goals (GoalID, UserID, Goal) values (44, 44, 'solve real-world problems through AI');
insert into career_goals (GoalID, UserID, Goal) values (45, 45, 'revolutionize user experiences');
insert into career_goals (GoalID, UserID, Goal) values (46, 46, 'conduct groundbreaking research');
insert into career_goals (GoalID, UserID, Goal) values (47, 47, 'manage a high-performing team');
insert into career_goals (GoalID, UserID, Goal) values (48, 48, 'lead a research project');
insert into career_goals (GoalID, UserID, Goal) values (49, 49, 'advocate for policy change');
insert into career_goals (GoalID, UserID, Goal) values (50, 50, 'achieve financial independence');
insert into career_goals (GoalID, UserID, Goal) values (51, 51, 'lead a research project');
insert into career_goals (GoalID, UserID, Goal) values (52, 52, 'work as a political strategist');
insert into career_goals (GoalID, UserID, Goal) values (53, 53, 'build a personal brand');
insert into career_goals (GoalID, UserID, Goal) values (54, 54, 'compose music for films');
insert into career_goals (GoalID, UserID, Goal) values (55, 55, 'establish a health startup');
insert into career_goals (GoalID, UserID, Goal) values (56, 56, 'lead a research project');
insert into career_goals (GoalID, UserID, Goal) values (57, 57, 'compose music for films');
insert into career_goals (GoalID, UserID, Goal) values (58, 58, 'design sustainable technology');
insert into career_goals (GoalID, UserID, Goal) values (59, 59, 'work as a political strategist');
insert into career_goals (GoalID, UserID, Goal) values (60, 60, 'build a personal brand');
insert into career_goals (GoalID, UserID, Goal) values (61, 61, 'compose music for films');
insert into career_goals (GoalID, UserID, Goal) values (62, 62, 'design sustainable technology');
insert into career_goals (GoalID, UserID, Goal) values (63, 63, 'become a data scientist');
insert into career_goals (GoalID, UserID, Goal) values (64, 64, 'manage a high-performing team');
insert into career_goals (GoalID, UserID, Goal) values (65, 65, 'lead a research project');
insert into career_goals (GoalID, UserID, Goal) values (66, 66, 'publish a novel');
insert into career_goals (GoalID, UserID, Goal) values (67, 67, 'publish a novel');
insert into career_goals (GoalID, UserID, Goal) values (68, 68, 'lead a research project');
insert into career_goals (GoalID, UserID, Goal) values (69, 69, 'manage a high-performing team');
insert into career_goals (GoalID, UserID, Goal) values (70, 70, 'conduct groundbreaking research');
insert into career_goals (GoalID, UserID, Goal) values (71, 71, 'lead a research project');
insert into career_goals (GoalID, UserID, Goal) values (72, 72, 'establish a health startup');
insert into career_goals (GoalID, UserID, Goal) values (73, 73, 'lead a research project');
insert into career_goals (GoalID, UserID, Goal) values (74, 74, 'compose music for films');
insert into career_goals (GoalID, UserID, Goal) values (75, 75, 'work as a political strategist');
insert into career_goals (GoalID, UserID, Goal) values (76, 76, 'achieve financial independence');
insert into career_goals (GoalID, UserID, Goal) values (77, 77, 'lead a research project');
insert into career_goals (GoalID, UserID, Goal) values (78, 78, 'work as a political strategist');
insert into career_goals (GoalID, UserID, Goal) values (79, 79, 'solve real-world problems through AI');
insert into career_goals (GoalID, UserID, Goal) values (80, 80, 'publish a novel');
insert into career_goals (GoalID, UserID, Goal) values (81, 81, 'become a data scientist');
insert into career_goals (GoalID, UserID, Goal) values (82, 82, 'design sustainable technology');
insert into career_goals (GoalID, UserID, Goal) values (83, 83, 'build a personal brand');
insert into career_goals (GoalID, UserID, Goal) values (84, 84, 'work as a political strategist');
insert into career_goals (GoalID, UserID, Goal) values (85, 85, 'become a data scientist');
insert into career_goals (GoalID, UserID, Goal) values (86, 86, 'start a successful business');
insert into career_goals (GoalID, UserID, Goal) values (87, 87, 'manage a high-performing team');
insert into career_goals (GoalID, UserID, Goal) values (88, 88, 'achieve financial independence');
insert into career_goals (GoalID, UserID, Goal) values (89, 89, 'mentor future professionals');
insert into career_goals (GoalID, UserID, Goal) values (90, 90, 'create impactful art');
insert into career_goals (GoalID, UserID, Goal) values (91, 91, 'improve public health outcomes');
insert into career_goals (GoalID, UserID, Goal) values (92, 92, 'advocate for policy change');
insert into career_goals (GoalID, UserID, Goal) values (93, 93, 'achieve financial independence');
insert into career_goals (GoalID, UserID, Goal) values (94, 94, 'manage a high-performing team');
insert into career_goals (GoalID, UserID, Goal) values (95, 95, 'design sustainable technology');
insert into career_goals (GoalID, UserID, Goal) values (96, 96, 'lead a research project');
insert into career_goals (GoalID, UserID, Goal) values (97, 97, 'work as a political strategist');
insert into career_goals (GoalID, UserID, Goal) values (98, 98, 'advocate for policy change');
insert into career_goals (GoalID, UserID, Goal) values (99, 99, 'revolutionize user experiences');
insert into career_goals (GoalID, UserID, Goal) values (100, 100, 'revolutionize user experiences');
insert into career_goals (GoalID, UserID, Goal) values (101, 101, 'lead a research project');
insert into career_goals (GoalID, UserID, Goal) values (102, 102, 'advocate for policy change');
insert into career_goals (GoalID, UserID, Goal) values (103, 103, 'mentor future professionals');
insert into career_goals (GoalID, UserID, Goal) values (104, 104, 'conduct groundbreaking research');
insert into career_goals (GoalID, UserID, Goal) values (105, 105, 'improve public health outcomes');
insert into career_goals (GoalID, UserID, Goal) values (106, 106, 'manage a high-performing team');
insert into career_goals (GoalID, UserID, Goal) values (107, 107, 'improve public health outcomes');
insert into career_goals (GoalID, UserID, Goal) values (108, 108, 'start a successful business');
insert into career_goals (GoalID, UserID, Goal) values (109, 109, 'conduct groundbreaking research');
insert into career_goals (GoalID, UserID, Goal) values (110, 110, 'publish a novel');
insert into career_goals (GoalID, UserID, Goal) values (111, 111, 'establish a health startup');
insert into career_goals (GoalID, UserID, Goal) values (112, 112, 'work as a political strategist');
insert into career_goals (GoalID, UserID, Goal) values (113, 113, 'revolutionize user experiences');
insert into career_goals (GoalID, UserID, Goal) values (114, 114, 'revolutionize user experiences');
insert into career_goals (GoalID, UserID, Goal) values (115, 115, 'develop innovative software');
insert into career_goals (GoalID, UserID, Goal) values (116, 116, 'start a successful business');
insert into career_goals (GoalID, UserID, Goal) values (117, 117, 'conduct groundbreaking research');
insert into career_goals (GoalID, UserID, Goal) values (118, 118, 'establish a health startup');
insert into career_goals (GoalID, UserID, Goal) values (119, 119, 'become a data scientist');
insert into career_goals (GoalID, UserID, Goal) values (120, 120, 'lead a research project');
insert into career_goals (GoalID, UserID, Goal) values (121, 121, 'work as a political strategist');
insert into career_goals (GoalID, UserID, Goal) values (122, 122, 'become a data scientist');
insert into career_goals (GoalID, UserID, Goal) values (123, 123, 'improve public health outcomes');
insert into career_goals (GoalID, UserID, Goal) values (124, 124, 'design sustainable technology');
insert into career_goals (GoalID, UserID, Goal) values (125, 125, 'advocate for policy change');
insert into career_goals (GoalID, UserID, Goal) values (126, 126, 'build a personal brand');
insert into career_goals (GoalID, UserID, Goal) values (127, 127, 'improve public health outcomes');
insert into career_goals (GoalID, UserID, Goal) values (128, 128, 'lead a research project');
insert into career_goals (GoalID, UserID, Goal) values (129, 129, 'start a successful business');
insert into career_goals (GoalID, UserID, Goal) values (130, 130, 'become a university professor');
insert into career_goals (GoalID, UserID, Goal) values (131, 131, 'work as a political strategist');
insert into career_goals (GoalID, UserID, Goal) values (132, 132, 'conduct groundbreaking research');
insert into career_goals (GoalID, UserID, Goal) values (133, 133, 'build a personal brand');
insert into career_goals (GoalID, UserID, Goal) values (134, 134, 'publish a novel');
insert into career_goals (GoalID, UserID, Goal) values (135, 135, 'start a successful business');
insert into career_goals (GoalID, UserID, Goal) values (136, 136, 'manage a high-performing team');
insert into career_goals (GoalID, UserID, Goal) values (137, 137, 'publish a novel');
insert into career_goals (GoalID, UserID, Goal) values (138, 138, 'mentor future professionals');
insert into career_goals (GoalID, UserID, Goal) values (139, 139, 'establish a health startup');
insert into career_goals (GoalID, UserID, Goal) values (140, 140, 'achieve financial independence');
insert into career_goals (GoalID, UserID, Goal) values (141, 141, 'solve real-world problems through AI');
insert into career_goals (GoalID, UserID, Goal) values (142, 142, 'advocate for policy change');
insert into career_goals (GoalID, UserID, Goal) values (143, 143, 'lead a research project');
insert into career_goals (GoalID, UserID, Goal) values (144, 144, 'mentor future professionals');
insert into career_goals (GoalID, UserID, Goal) values (145, 145, 'start a successful business');
insert into career_goals (GoalID, UserID, Goal) values (146, 146, 'conduct groundbreaking research');
insert into career_goals (GoalID, UserID, Goal) values (147, 147, 'conduct groundbreaking research');
insert into career_goals (GoalID, UserID, Goal) values (148, 148, 'start a successful business');
insert into career_goals (GoalID, UserID, Goal) values (149, 149, 'conduct groundbreaking research');
insert into career_goals (GoalID, UserID, Goal) values (150, 150, 'advocate for policy change');
insert into career_goals (GoalID, UserID, Goal) values (151, 151, 'revolutionize user experiences');
insert into career_goals (GoalID, UserID, Goal) values (152, 152, 'become a university professor');
insert into career_goals (GoalID, UserID, Goal) values (153, 153, 'revolutionize user experiences');
insert into career_goals (GoalID, UserID, Goal) values (154, 154, 'start a successful business');
insert into career_goals (GoalID, UserID, Goal) values (155, 155, 'build a personal brand');
insert into career_goals (GoalID, UserID, Goal) values (156, 156, 'build a personal brand');
insert into career_goals (GoalID, UserID, Goal) values (157, 157, 'publish a novel');
insert into career_goals (GoalID, UserID, Goal) values (158, 158, 'become a data scientist');
insert into career_goals (GoalID, UserID, Goal) values (159, 159, 'become a data scientist');
insert into career_goals (GoalID, UserID, Goal) values (160, 160, 'design sustainable technology');
insert into career_goals (GoalID, UserID, Goal) values (161, 161, 'create impactful art');
insert into career_goals (GoalID, UserID, Goal) values (162, 162, 'start a successful business');
insert into career_goals (GoalID, UserID, Goal) values (163, 163, 'revolutionize user experiences');
insert into career_goals (GoalID, UserID, Goal) values (164, 164, 'become a data scientist');
insert into career_goals (GoalID, UserID, Goal) values (165, 165, 'start a successful business');
insert into career_goals (GoalID, UserID, Goal) values (166, 166, 'publish a novel');
insert into career_goals (GoalID, UserID, Goal) values (167, 167, 'manage a high-performing team');
insert into career_goals (GoalID, UserID, Goal) values (168, 168, 'achieve financial independence');
insert into career_goals (GoalID, UserID, Goal) values (169, 169, 'work as a political strategist');
insert into career_goals (GoalID, UserID, Goal) values (170, 170, 'establish a health startup');
insert into career_goals (GoalID, UserID, Goal) values (171, 171, 'manage a high-performing team');
insert into career_goals (GoalID, UserID, Goal) values (172, 172, 'manage a high-performing team');
insert into career_goals (GoalID, UserID, Goal) values (173, 173, 'achieve financial independence');
insert into career_goals (GoalID, UserID, Goal) values (174, 174, 'become a data scientist');
insert into career_goals (GoalID, UserID, Goal) values (175, 175, 'solve real-world problems through AI');
insert into career_goals (GoalID, UserID, Goal) values (176, 176, 'manage a high-performing team');
insert into career_goals (GoalID, UserID, Goal) values (177, 177, 'conduct groundbreaking research');
insert into career_goals (GoalID, UserID, Goal) values (178, 178, 'become a university professor');
insert into career_goals (GoalID, UserID, Goal) values (179, 179, 'create impactful art');
insert into career_goals (GoalID, UserID, Goal) values (180, 180, 'publish a novel');
insert into career_goals (GoalID, UserID, Goal) values (181, 181, 'publish a novel');
insert into career_goals (GoalID, UserID, Goal) values (182, 182, 'compose music for films');
insert into career_goals (GoalID, UserID, Goal) values (183, 183, 'develop innovative software');
insert into career_goals (GoalID, UserID, Goal) values (184, 184, 'start a successful business');
insert into career_goals (GoalID, UserID, Goal) values (185, 185, 'develop innovative software');
insert into career_goals (GoalID, UserID, Goal) values (186, 186, 'become a data scientist');
insert into career_goals (GoalID, UserID, Goal) values (187, 187, 'mentor future professionals');
insert into career_goals (GoalID, UserID, Goal) values (188, 188, 'solve real-world problems through AI');
insert into career_goals (GoalID, UserID, Goal) values (189, 189, 'become a data scientist');
insert into career_goals (GoalID, UserID, Goal) values (190, 190, 'lead a research project');
insert into career_goals (GoalID, UserID, Goal) values (191, 191, 'build a personal brand');
insert into career_goals (GoalID, UserID, Goal) values (192, 192, 'manage a high-performing team');
insert into career_goals (GoalID, UserID, Goal) values (193, 193, 'build a personal brand');
insert into career_goals (GoalID, UserID, Goal) values (194, 194, 'design sustainable technology');
insert into career_goals (GoalID, UserID, Goal) values (195, 195, 'start a successful business');
insert into career_goals (GoalID, UserID, Goal) values (196, 196, 'improve public health outcomes');
insert into career_goals (GoalID, UserID, Goal) values (197, 197, 'become a university professor');
insert into career_goals (GoalID, UserID, Goal) values (198, 198, 'compose music for films');
insert into career_goals (GoalID, UserID, Goal) values (199, 199, 'establish a health startup');
insert into career_goals (GoalID, UserID, Goal) values (200, 200, 'improve public health outcomes');

-- Insert into Experience table
INSERT INTO experience (ExperienceID, UserID, ExperienceName, Date, Location, Description)
VALUES
    (1, 9, 'Software Developer Intern', '2023-03-01 09:00:00', 'TechCorp', 'Worked on developing mobile apps'),
    (2, 10, 'Research Assistant', '2023-04-01 10:00:00', 'HealthPlus', 'Assisted in lab experiments'),
    (3, 11, 'Academic Tutor', '2023-05-01 11:00:00', 'EduWorld', 'Provided career counseling');

-- Insert into Career Path table
insert into career_path (CareerPathID, UserID, CareerPath) values (9, 9, 'software engineer');
insert into career_path (CareerPathID, UserID, CareerPath) values (10, 10, 'music producer');
insert into career_path (CareerPathID, UserID, CareerPath) values (11, 11, 'political consultant');
insert into career_path (CareerPathID, UserID, CareerPath) values (12, 12, 'data scientist');
insert into career_path (CareerPathID, UserID, CareerPath) values (13, 13, 'public health consultant');
insert into career_path (CareerPathID, UserID, CareerPath) values (14, 14, 'data scientist');
insert into career_path (CareerPathID, UserID, CareerPath) values (15, 15, 'mechanical engineer');
insert into career_path (CareerPathID, UserID, CareerPath) values (16, 16, 'electrical engineer');
insert into career_path (CareerPathID, UserID, CareerPath) values (17, 17, 'data scientist');
insert into career_path (CareerPathID, UserID, CareerPath) values (18, 18, 'editor');
insert into career_path (CareerPathID, UserID, CareerPath) values (19, 19, 'UX designer');
insert into career_path (CareerPathID, UserID, CareerPath) values (20, 20, 'marketing specialist');
insert into career_path (CareerPathID, UserID, CareerPath) values (21, 21, 'research scientist');
insert into career_path (CareerPathID, UserID, CareerPath) values (22, 22, 'editor');
insert into career_path (CareerPathID, UserID, CareerPath) values (23, 23, 'biomedical engineer');
insert into career_path (CareerPathID, UserID, CareerPath) values (24, 24, 'marketing specialist');
insert into career_path (CareerPathID, UserID, CareerPath) values (25, 25, 'electrical engineer');
insert into career_path (CareerPathID, UserID, CareerPath) values (26, 26, 'editor');
insert into career_path (CareerPathID, UserID, CareerPath) values (27, 27, 'musician');
insert into career_path (CareerPathID, UserID, CareerPath) values (28, 28, 'musician');
insert into career_path (CareerPathID, UserID, CareerPath) values (29, 29, 'business analyst');
insert into career_path (CareerPathID, UserID, CareerPath) values (30, 30, 'political consultant');
insert into career_path (CareerPathID, UserID, CareerPath) values (31, 31, 'project manager');
insert into career_path (CareerPathID, UserID, CareerPath) values (32, 32, 'marketing specialist');
insert into career_path (CareerPathID, UserID, CareerPath) values (33, 33, 'public health consultant');
insert into career_path (CareerPathID, UserID, CareerPath) values (34, 34, 'research scientist');
insert into career_path (CareerPathID, UserID, CareerPath) values (35, 35, 'writer');
insert into career_path (CareerPathID, UserID, CareerPath) values (36, 36, 'marketing specialist');
insert into career_path (CareerPathID, UserID, CareerPath) values (37, 37, 'policy analyst');
insert into career_path (CareerPathID, UserID, CareerPath) values (38, 38, 'musician');
insert into career_path (CareerPathID, UserID, CareerPath) values (39, 39, 'UX designer');
insert into career_path (CareerPathID, UserID, CareerPath) values (40, 40, 'research scientist');
insert into career_path (CareerPathID, UserID, CareerPath) values (41, 41, 'editor');
insert into career_path (CareerPathID, UserID, CareerPath) values (42, 42, 'graphic designer');
insert into career_path (CareerPathID, UserID, CareerPath) values (43, 43, 'music producer');
insert into career_path (CareerPathID, UserID, CareerPath) values (44, 44, 'research scientist');
insert into career_path (CareerPathID, UserID, CareerPath) values (45, 45, 'UX designer');
insert into career_path (CareerPathID, UserID, CareerPath) values (46, 46, 'political consultant');
insert into career_path (CareerPathID, UserID, CareerPath) values (47, 47, 'electrical engineer');
insert into career_path (CareerPathID, UserID, CareerPath) values (48, 48, 'policy analyst');
insert into career_path (CareerPathID, UserID, CareerPath) values (49, 49, 'electrical engineer');
insert into career_path (CareerPathID, UserID, CareerPath) values (50, 50, 'financial analyst');
insert into career_path (CareerPathID, UserID, CareerPath) values (51, 51, 'software engineer');
insert into career_path (CareerPathID, UserID, CareerPath) values (52, 52, 'marketing specialist');
insert into career_path (CareerPathID, UserID, CareerPath) values (53, 53, 'business analyst');
insert into career_path (CareerPathID, UserID, CareerPath) values (54, 54, 'editor');
insert into career_path (CareerPathID, UserID, CareerPath) values (55, 55, 'policy analyst');
insert into career_path (CareerPathID, UserID, CareerPath) values (56, 56, 'musician');
insert into career_path (CareerPathID, UserID, CareerPath) values (57, 57, 'graphic designer');
insert into career_path (CareerPathID, UserID, CareerPath) values (58, 58, 'electrical engineer');
insert into career_path (CareerPathID, UserID, CareerPath) values (59, 59, 'business analyst');
insert into career_path (CareerPathID, UserID, CareerPath) values (60, 60, 'research scientist');
insert into career_path (CareerPathID, UserID, CareerPath) values (61, 61, 'electrical engineer');
insert into career_path (CareerPathID, UserID, CareerPath) values (62, 62, 'policy analyst');
insert into career_path (CareerPathID, UserID, CareerPath) values (63, 63, 'research scientist');
insert into career_path (CareerPathID, UserID, CareerPath) values (64, 64, 'political consultant');
insert into career_path (CareerPathID, UserID, CareerPath) values (65, 65, 'marketing specialist');
insert into career_path (CareerPathID, UserID, CareerPath) values (66, 66, 'marketing specialist');
insert into career_path (CareerPathID, UserID, CareerPath) values (67, 67, 'writer');
insert into career_path (CareerPathID, UserID, CareerPath) values (68, 68, 'UX designer');
insert into career_path (CareerPathID, UserID, CareerPath) values (69, 69, 'teacher');
insert into career_path (CareerPathID, UserID, CareerPath) values (70, 70, 'software engineer');
insert into career_path (CareerPathID, UserID, CareerPath) values (71, 71, 'musician');
insert into career_path (CareerPathID, UserID, CareerPath) values (72, 72, 'public health consultant');
insert into career_path (CareerPathID, UserID, CareerPath) values (73, 73, 'public health consultant');
insert into career_path (CareerPathID, UserID, CareerPath) values (74, 74, 'financial analyst');
insert into career_path (CareerPathID, UserID, CareerPath) values (75, 75, 'teacher');
insert into career_path (CareerPathID, UserID, CareerPath) values (76, 76, 'research scientist');
insert into career_path (CareerPathID, UserID, CareerPath) values (77, 77, 'business analyst');
insert into career_path (CareerPathID, UserID, CareerPath) values (78, 78, 'financial analyst');
insert into career_path (CareerPathID, UserID, CareerPath) values (79, 79, 'UX designer');
insert into career_path (CareerPathID, UserID, CareerPath) values (80, 80, 'electrical engineer');
insert into career_path (CareerPathID, UserID, CareerPath) values (81, 81, 'project manager');
insert into career_path (CareerPathID, UserID, CareerPath) values (82, 82, 'software engineer');
insert into career_path (CareerPathID, UserID, CareerPath) values (83, 83, 'marketing specialist');
insert into career_path (CareerPathID, UserID, CareerPath) values (84, 84, 'marketing specialist');
insert into career_path (CareerPathID, UserID, CareerPath) values (85, 85, 'financial analyst');
insert into career_path (CareerPathID, UserID, CareerPath) values (86, 86, 'data scientist');
insert into career_path (CareerPathID, UserID, CareerPath) values (87, 87, 'business analyst');
insert into career_path (CareerPathID, UserID, CareerPath) values (88, 88, 'teacher');
insert into career_path (CareerPathID, UserID, CareerPath) values (89, 89, 'editor');
insert into career_path (CareerPathID, UserID, CareerPath) values (90, 90, 'marketing specialist');
insert into career_path (CareerPathID, UserID, CareerPath) values (91, 91, 'graphic designer');
insert into career_path (CareerPathID, UserID, CareerPath) values (92, 92, 'public health consultant');
insert into career_path (CareerPathID, UserID, CareerPath) values (93, 93, 'musician');
insert into career_path (CareerPathID, UserID, CareerPath) values (94, 94, 'music producer');
insert into career_path (CareerPathID, UserID, CareerPath) values (95, 95, 'data scientist');
insert into career_path (CareerPathID, UserID, CareerPath) values (96, 96, 'mechanical engineer');
insert into career_path (CareerPathID, UserID, CareerPath) values (97, 97, 'financial analyst');
insert into career_path (CareerPathID, UserID, CareerPath) values (98, 98, 'UX designer');
insert into career_path (CareerPathID, UserID, CareerPath) values (99, 99, 'data scientist');
insert into career_path (CareerPathID, UserID, CareerPath) values (100, 100, 'music producer');
insert into career_path (CareerPathID, UserID, CareerPath) values (101, 101, 'project manager');
insert into career_path (CareerPathID, UserID, CareerPath) values (102, 102, 'mechanical engineer');
insert into career_path (CareerPathID, UserID, CareerPath) values (103, 103, 'research scientist');
insert into career_path (CareerPathID, UserID, CareerPath) values (104, 104, 'project manager');
insert into career_path (CareerPathID, UserID, CareerPath) values (105, 105, 'mechanical engineer');
insert into career_path (CareerPathID, UserID, CareerPath) values (106, 106, 'teacher');
insert into career_path (CareerPathID, UserID, CareerPath) values (107, 107, 'business analyst');
insert into career_path (CareerPathID, UserID, CareerPath) values (108, 108, 'data scientist');
insert into career_path (CareerPathID, UserID, CareerPath) values (109, 109, 'teacher');
insert into career_path (CareerPathID, UserID, CareerPath) values (110, 110, 'political consultant');
insert into career_path (CareerPathID, UserID, CareerPath) values (111, 111, 'project manager');
insert into career_path (CareerPathID, UserID, CareerPath) values (112, 112, 'software engineer');
insert into career_path (CareerPathID, UserID, CareerPath) values (113, 113, 'writer');
insert into career_path (CareerPathID, UserID, CareerPath) values (114, 114, 'marketing specialist');
insert into career_path (CareerPathID, UserID, CareerPath) values (115, 115, 'research scientist');
insert into career_path (CareerPathID, UserID, CareerPath) values (116, 116, 'research scientist');
insert into career_path (CareerPathID, UserID, CareerPath) values (117, 117, 'writer');
insert into career_path (CareerPathID, UserID, CareerPath) values (118, 118, 'business analyst');
insert into career_path (CareerPathID, UserID, CareerPath) values (119, 119, 'writer');
insert into career_path (CareerPathID, UserID, CareerPath) values (120, 120, 'musician');
insert into career_path (CareerPathID, UserID, CareerPath) values (121, 121, 'electrical engineer');
insert into career_path (CareerPathID, UserID, CareerPath) values (122, 122, 'financial analyst');
insert into career_path (CareerPathID, UserID, CareerPath) values (123, 123, 'financial analyst');
insert into career_path (CareerPathID, UserID, CareerPath) values (124, 124, 'teacher');
insert into career_path (CareerPathID, UserID, CareerPath) values (125, 125, 'electrical engineer');
insert into career_path (CareerPathID, UserID, CareerPath) values (126, 126, 'editor');
insert into career_path (CareerPathID, UserID, CareerPath) values (127, 127, 'musician');
insert into career_path (CareerPathID, UserID, CareerPath) values (128, 128, 'editor');
insert into career_path (CareerPathID, UserID, CareerPath) values (129, 129, 'software engineer');
insert into career_path (CareerPathID, UserID, CareerPath) values (130, 130, 'teacher');
insert into career_path (CareerPathID, UserID, CareerPath) values (131, 131, 'political consultant');
insert into career_path (CareerPathID, UserID, CareerPath) values (132, 132, 'electrical engineer');
insert into career_path (CareerPathID, UserID, CareerPath) values (133, 133, 'research scientist');
insert into career_path (CareerPathID, UserID, CareerPath) values (134, 134, 'financial analyst');
insert into career_path (CareerPathID, UserID, CareerPath) values (135, 135, 'electrical engineer');
insert into career_path (CareerPathID, UserID, CareerPath) values (136, 136, 'software engineer');
insert into career_path (CareerPathID, UserID, CareerPath) values (137, 137, 'electrical engineer');
insert into career_path (CareerPathID, UserID, CareerPath) values (138, 138, 'public health consultant');
insert into career_path (CareerPathID, UserID, CareerPath) values (139, 139, 'business analyst');
insert into career_path (CareerPathID, UserID, CareerPath) values (140, 140, 'UX designer');
insert into career_path (CareerPathID, UserID, CareerPath) values (141, 141, 'data scientist');
insert into career_path (CareerPathID, UserID, CareerPath) values (142, 142, 'policy analyst');
insert into career_path (CareerPathID, UserID, CareerPath) values (143, 143, 'financial analyst');
insert into career_path (CareerPathID, UserID, CareerPath) values (144, 144, 'music producer');
insert into career_path (CareerPathID, UserID, CareerPath) values (145, 145, 'biomedical engineer');
insert into career_path (CareerPathID, UserID, CareerPath) values (146, 146, 'musician');
insert into career_path (CareerPathID, UserID, CareerPath) values (147, 147, 'data scientist');
insert into career_path (CareerPathID, UserID, CareerPath) values (148, 148, 'music producer');
insert into career_path (CareerPathID, UserID, CareerPath) values (149, 149, 'biomedical engineer');
insert into career_path (CareerPathID, UserID, CareerPath) values (150, 150, 'financial analyst');
insert into career_path (CareerPathID, UserID, CareerPath) values (151, 151, 'graphic designer');
insert into career_path (CareerPathID, UserID, CareerPath) values (152, 152, 'musician');
insert into career_path (CareerPathID, UserID, CareerPath) values (153, 153, 'writer');
insert into career_path (CareerPathID, UserID, CareerPath) values (154, 154, 'graphic designer');
insert into career_path (CareerPathID, UserID, CareerPath) values (155, 155, 'data scientist');
insert into career_path (CareerPathID, UserID, CareerPath) values (156, 156, 'software engineer');
insert into career_path (CareerPathID, UserID, CareerPath) values (157, 157, 'policy analyst');
insert into career_path (CareerPathID, UserID, CareerPath) values (158, 158, 'UX designer');
insert into career_path (CareerPathID, UserID, CareerPath) values (159, 159, 'public health consultant');
insert into career_path (CareerPathID, UserID, CareerPath) values (160, 160, 'political consultant');
insert into career_path (CareerPathID, UserID, CareerPath) values (161, 161, 'business analyst');
insert into career_path (CareerPathID, UserID, CareerPath) values (162, 162, 'musician');
insert into career_path (CareerPathID, UserID, CareerPath) values (163, 163, 'editor');
insert into career_path (CareerPathID, UserID, CareerPath) values (164, 164, 'electrical engineer');
insert into career_path (CareerPathID, UserID, CareerPath) values (165, 165, 'data scientist');
insert into career_path (CareerPathID, UserID, CareerPath) values (166, 166, 'electrical engineer');
insert into career_path (CareerPathID, UserID, CareerPath) values (167, 167, 'mechanical engineer');
insert into career_path (CareerPathID, UserID, CareerPath) values (168, 168, 'mechanical engineer');
insert into career_path (CareerPathID, UserID, CareerPath) values (169, 169, 'marketing specialist');
insert into career_path (CareerPathID, UserID, CareerPath) values (170, 170, 'graphic designer');
insert into career_path (CareerPathID, UserID, CareerPath) values (171, 171, 'marketing specialist');
insert into career_path (CareerPathID, UserID, CareerPath) values (172, 172, 'data scientist');
insert into career_path (CareerPathID, UserID, CareerPath) values (173, 173, 'research scientist');
insert into career_path (CareerPathID, UserID, CareerPath) values (174, 174, 'biomedical engineer');
insert into career_path (CareerPathID, UserID, CareerPath) values (175, 175, 'business analyst');
insert into career_path (CareerPathID, UserID, CareerPath) values (176, 176, 'music producer');
insert into career_path (CareerPathID, UserID, CareerPath) values (177, 177, 'software engineer');
insert into career_path (CareerPathID, UserID, CareerPath) values (178, 178, 'graphic designer');
insert into career_path (CareerPathID, UserID, CareerPath) values (179, 179, 'business analyst');
insert into career_path (CareerPathID, UserID, CareerPath) values (180, 180, 'project manager');
insert into career_path (CareerPathID, UserID, CareerPath) values (181, 181, 'musician');
insert into career_path (CareerPathID, UserID, CareerPath) values (182, 182, 'business analyst');
insert into career_path (CareerPathID, UserID, CareerPath) values (183, 183, 'music producer');
insert into career_path (CareerPathID, UserID, CareerPath) values (184, 184, 'UX designer');
insert into career_path (CareerPathID, UserID, CareerPath) values (185, 185, 'musician');
insert into career_path (CareerPathID, UserID, CareerPath) values (186, 186, 'marketing specialist');
insert into career_path (CareerPathID, UserID, CareerPath) values (187, 187, 'data scientist');
insert into career_path (CareerPathID, UserID, CareerPath) values (188, 188, 'writer');
insert into career_path (CareerPathID, UserID, CareerPath) values (189, 189, 'public health consultant');
insert into career_path (CareerPathID, UserID, CareerPath) values (190, 190, 'music producer');
insert into career_path (CareerPathID, UserID, CareerPath) values (191, 191, 'graphic designer');
insert into career_path (CareerPathID, UserID, CareerPath) values (192, 192, 'writer');
insert into career_path (CareerPathID, UserID, CareerPath) values (193, 193, 'writer');
insert into career_path (CareerPathID, UserID, CareerPath) values (194, 194, 'business analyst');
insert into career_path (CareerPathID, UserID, CareerPath) values (195, 195, 'music producer');
insert into career_path (CareerPathID, UserID, CareerPath) values (196, 196, 'policy analyst');
insert into career_path (CareerPathID, UserID, CareerPath) values (197, 197, 'political consultant');
insert into career_path (CareerPathID, UserID, CareerPath) values (198, 198, 'business analyst');
insert into career_path (CareerPathID, UserID, CareerPath) values (199, 199, 'data scientist');
insert into career_path (CareerPathID, UserID, CareerPath) values (200, 200, 'software engineer');

-- Insert into Jobs table
INSERT INTO jobs (JobID, EmpID, Title, Description)
VALUES
    (1, 1, 'Software Engineer', 'Design and develop scalable software solutions.'),
    (2, 2, 'Research Scientist', 'Conduct research in molecular biology.'),
    (3, 3, 'Academic Consultant', 'Provide academic and career guidance.');

