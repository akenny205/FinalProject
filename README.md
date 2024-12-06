# PeerPoint: 

This repo is for PeerPoint, an app created as the final project for CS3200 Database Design by Jonathon Piesik, Andrew Kenney, Ian Solberg, Zac Labit, and Jack Young.  It includes the infrastructure setup (containers), front end code, REST API code, and SQL database files.

Video Walk-Through Link: https://youtu.be/WcwxHZKXhMc

Briefly, PeerPoint is a campus social networking platform that encourages peer mentorship while allowing continuous monitoring by advisors. 

when bootstrapping make sure that:
DB_NAME in the .env file is set to 'finalproject'
SECRET_KEY is set to a unique key
DB_USER is root
DB_HOST is db
DB_PORT is 3306
And that you set a unique password in MYSQL_ROOT_PASSWORD

Once a valid env file is set, docker compose up -d will properly build the containers


# PeerPoint Elevator Pitch

PeerPoint is a data-driven platform that builds valuable connections among students and alumni, specifically students navigating co-op and early career moves. Unlike general professional platforms like Linkedin, our app proactively connects students with seasoned peer mentors or alumni who share similar interests, career goals, and skills. By seamlessly connecting students to tailored peer mentors, we empower them to build relationships that support their career and personal growth. College career or co-op advisors also gain a unique, data-backed way to oversee and encourage their students’ networking efforts, ensuring that they’re actively building connections through networking. 

Key pain points in traditional platforms, like LinkedIn, revolve around an impersonal and often crowded user experience. Finding relevant connections is arduous. Our app addresses this issue by being hyper-personalized and localized. The experience is curated to match mentees and mentors based on shared interests, goals, and experiences. Users are not tasked with searching for applicable connections. The platform makes the connections for them. Additionally, advisors struggle to measure if the networking and career building lessons they teach are applied. Our app provides data backed dashboards that can be leveraged by advisors to assess how their students are progressing professionally. In addition to mentees (inexperienced students), mentors (experienced students and alumni), co-op/career advisors, the final user persona will be the career services system administrator. This user is a university employee that cares about system performance and user activity at a high level. We plan to offer many useful features. For mentees we will offer a social networking type interface that suggests a set of mentors that match their interests and career goals. Mentees can swipe through and read each mentor’s profile. Mentees, mentors, and advisors will be able to communicate seamlessly through two way messaging. Finally, advisors will be able to monitor the progress of all their students through a comprehensive networking dashboard. 

## Current Project Components

Currently, there are three major components each running in their own Docker Containers:

- Front End Streamlit App in the `./app` directory
- Flask REST api in the `./api` directory
- SQL files for your data model and data base in the `./database-files` directory

## How to bootstrap the repo on your personal machine

1. In GitHub, click the **fork** button in the upper right corner of the repo screen. 
2. When prompted, give the new repo a unique name.
3. Once the fork has been created, clone YOUR forked version of the repo to your computer. 
4. Set up the `.env` file in the `api` folder based on the `.env.template` file.
5. Start the docker containers using `docker compose build` and `docker compose up -d`.  

## How to Use PeerPoint

PeerPoint uses Role-based Access Control. Upon opening the App, the user is prompted to choose from four unique user profiles. First, an inexperienced student. The inexperienced student may be a first or second year on campus, they are looking to shape their future on campus and in their careers through peer mentorship. Second, experienced students act as peer mentors. They have similar functionalities to inexperienced students but have more access to career information and job postings as they are closer to graduation. Third, the co-op/career advisor. The advisor's functionalities within the app are focused on monitoring and assisting students in their peer mentorship journeys. Finally, the system admin is tasked with maintaining the integrity of the platform. 

The user has the ability to switch between these profiles by logging out (in the sidebar) or refreshing the page. Each user has 5-8 unique pages that correspond to functionalities. Users can return to a specific 'role home page' with the sidebar. 

## High Level Overview of top Features and Functionalities 

### Detailed user profiles

Detailed, linkedin style, user profiles allow students to maintain an updated record of what kind of student they are for others to view and match with. Experiences can be added or updated as the student progresses through their career.

### Fine-tuned filtering

Advanced search platform allows those in search of mentees and mentors to drill down the search results based on a series of traits. Those traits inclue interests, career goals, caree path, skills, and student status. 

### Administrative control

Perfect for a college campus application, advisors and administrators have advanced control of the network. Advisors are responsible for adding new students, updating their status when they graduate, adding employeer reviews, or removing users. The admin can view the system from a high level, seeing all students, posts, comments, and messages. The admin has complete control over all the content. 

 
