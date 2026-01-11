# FitnessAi-MicroService-Springboot
Code file explanation

a). pom.xml
Project Object Model serves as the recipe that tells the computer exactly which tools and libraries are needed to run the fitness recommendation engine.
Key Components:
Spring Boot (v3.5.6): The main framework that powers the application, handling the web server and backend logic.
Database Connectors: Includes drivers for MySQL and MariaDB, allowing the app to save and retrieve user workout data securely.
Java Mail Sender: A tool that enables the application to send emails (likely for user notifications or recommendations).
JSP & Tomcat: These manage the web interface, allowing the application to display dynamic HTML pages to the user.
Spring Security: Provides the underlying structure for securing the application (though specific security rules would be in the Java code).
Lombok: A utility that keeps the code clean by automatically generating repetitive code (like getters and setters).

b). application.properties
Think of this as the "Control Panel" or "Settings Menu" for your application. It tells the code where to find things and how to behave without changing the actual Java code.
The application.properties file acts as the central command center for the application. It connects the different parts of the system together:
Web Server: Sets the application to run on port 8011 (so you access it at localhost:8011).
Visual Interface: Tells the app to look for JSP files (the web pages users see) in the /WEB-INF/jsp/ folder.
Database Connection: Configures the link to the MariaDB database (named springbootprojectaimicroservicefitness) where user profiles and fitness data are stored. It uses standard settings compatible with local servers like XAMPP.
Automation: The ddl-auto=update setting is a helpful feature that automatically updates the database structure (tables and columns) whenever you change the Java code, saving manual work.
Email Service: Sets up the connection to Gmail's SMTP server, allowing the app to send automated emails (like welcome messages or workout updates).

c). 
