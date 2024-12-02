# `database-files` Folder

The SQL file in this folder contains all the DDL and DML to properly run the PeerPoint app. If the docker set-up steps (outlined in the repo general README file) are properly executed, this file will be run. When run, all the nessecary tables will be created and rows inserted. 

# DDL 

The `FinalProjectSQL.sql` file has working SQL that creates, uses, and then creates tables that corresponds with the database diagrams we designed. Tables include admin, employers, users, and more.

# DML

Using Mockeroo we generated enough sample data to allow the platform to function properly. We added this As a social network it is hard to truely judge its effectiveness with fewer that a couple hundred users. The amount of data added gives the user a taste of the intended functionality.

All data was added with `INSERT` statements.

# Trouble shooting

1. Ensure the correct database name is used in the .env file, should be `finalproject`
2. Ensure that you are accessing the correct port `3306`