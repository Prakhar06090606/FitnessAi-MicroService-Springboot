# FitnessAi-MicroService-Springboot
A Spring Boot Application Integrated with Google Gemini AI

About The Project
This isn't just a standard fitness tracker. While most apps simply record what you did (e.g., "Running: 30 mins"), this project answers the question: "Okay, what now?"

This application serves as an intelligent fitness companion. When a user logs a workout, the system uses Generative AI (Google Gemini Model) to instantly analyze the session and act as a professional coach. It provides real-time, personalized advice on recovery, hydration, and nutritional adjustments tailored specifically to that workout.

It bridges the gap between raw data and actionable health advice.

How It Works

For a non-technical user, here is the journey of a single click:

The Input: You log a workout (e.g., "High-Intensity Interval Training for 45 minutes, 500 calories burned").

The Trigger: As soon as you hit save, the application wakes up the AI Service.

The Brain: The app constructs a detailed prompt for Google's Gemini AI: "Act as a professional coach. My user just did HIIT for 45 mins. Give them sentences of advice."

The Output: The AI analyzes the intensity and duration, sending back advice like: "Great session! Focus on replenishing electrolytes immediately. Stretch your hamstrings to prevent stiffness tomorrow."

The Result: This advice is permanently saved to your dashboard, creating a personalized fitness diary.

Key Features

For Users

Smart Activity Logging: Track Run, Swim, Cycle, Yoga, and Weightlifting sessions.

AI Recommendations: Get instant, unique advice for every single workout you log.

Secure Dashboard: View your complete history of workouts and AI tips.

Profile Management: Update personal details and manage account security securely.

Account Safety: Secure "Forgot Password" flow via Email and safe account deletion.

For Admins 

Global Dashboard: View activity statistics across the entire user base.

User Management: Ability to "Ban/Enable" users (e.g., disabling spam accounts).

Content Moderation: View user activities and delete inappropriate entries.

Data Oversight: Access to all logs to ensure the system is running smoothly.

Tech Stack & Tools

Component,Technology Used,Purpose

Backend Framework,Spring Boot 3.5.6,The core engine running the server.

Language,Java 17,The programming language used for logic.

Artificial Intelligence,Google Gemini 2.5,"The ""Brain"" generating fitness advice."

Database,MariaDB / MySQL,Stores user profiles and workout history.

Data Access,Spring Data JPA,Handles database communication automatically.

Security,Spring Security,Encrypts passwords (BCrypt) and manages login roles.

Frontend,JSP & Bootstrap,The visual interface (Web Pages).

Notifications,JavaMailSender,Sends real-time Welcome and Reset emails.

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

Think of this as the "Control Panel" or "Settings Menu" for your application. It tells the code where to find things and how to behave without changing the actual Java code. The application.properties file acts as the central command center for the application. 
It connects the different parts of the system together:

Web Server: Sets the application to run on port 8011 (so you access it at localhost:8011).

Visual Interface: Tells the app to look for JSP files (the web pages users see) in the /WEB-INF/jsp/ folder.

Database Connection: Configures the link to the MariaDB database (named springbootprojectaimicroservicefitness) where user profiles and fitness data are stored. It uses standard settings compatible with local servers like XAMPP.

Automation: The ddl-auto=update setting is a helpful feature that automatically updates the database structure (tables and columns) whenever you change the Java code, saving manual work.

Email Service: Sets up the connection to Gmail's SMTP server, allowing the app to send automated emails (like welcome messages or workout updates).

c). AiMicroServiceSpringFitnessApplication.java 

This file is the entry point of the entire application. It is the digital equivalent of turning the key in a car's ignition.
@SpringBootApplication: This single line is a powerful "auto-pilot" command. 

It tells the system to:

Scan: Automatically find all your files (controllers, database connections, security settings).

Configure: Set up the internal web server (Tomcat) so the app can run without complex manual setup.

main(): The standard starting line for Java programs. When executed, it launches the entire fitness recommendation system.

d). InitialDataLoader.java 

The Automated Setup Assistant This file is a "smart script" that runs automatically every time the application starts. Its job is to ensure the database is never empty or broken. Think of it as the "Factory Reset" or "First-Time Setup" wizard that ensures the essential building blocks are present.

How it works (Step-by-Step):

Checks for Roles:
The system needs to know the difference between a regular User and an Admin. The code asks: "Do the 'ROLE_USER' and 'ROLE_ADMIN' badges exist in the database?" Smart Logic: If they exist, it does nothing. If they are missing (like on a fresh installation), it automatically creates and saves them. This prevents errors when new users try to sign up.

Checks for Admin Account:

It checks if the master account (admin@fit.com) exists. If not, it creates a new Admin user with:

Email: admin@fit.com
Name: Fitness Admin
Role: ROLE_ADMIN

Security & Encryption (PasswordEncoder):

Crucial Security Feature: The code does not save the password "adminpass" directly into the database. Instead, it uses a Password Encoder to scramble the password into a secure "hash" (a long string of random characters). This ensures that even if someone looks at the database, they cannot read the password.

e). PasswordConfig.java

This file is responsible for the Data Privacy and Security of the application. It ensures that sensitive user data (passwords) is never stored in a readable format.

The Concept: The "Digital Shredder" If a user's password is "12345", we cannot save "12345" in the database. If we did, a hacker could read everyone's passwords. Instead, this code passes the password through a cryptographic tool called BCrypt.

Input: password123

Process: The code "hashes" (scrambles) it using a complex mathematical formula.

Output: $2a$10$EixZaYVK1fsbw1ZfbX3OXe... (This is what gets saved).

Code Breakdown:

@Configuration: This annotation tells the Spring Boot framework that this class contains important setup instructions that must be loaded before the app starts.

@Bean: This registers the password encoder as a "global tool." It makes the encryption logic available to any other part of the app (like the Login page or Registration service) that needs to handle passwords securely.

BCryptPasswordEncoder: We use this specific algorithm because it is slow by design, making it extremely difficult for hackers to "guess" passwords using high-speed computers.

f). AuthController.java

This controller handles the front door of the application. It manages who gets in and who stays out.

Login & Logout: Verifies emails and passwords. If correct, it creates a "Session" (a digital ID card) so the user stays logged in as they browse.

Registration: Handles new sign-ups. It enforces password rules (must have symbols, numbers, etc.) to keep accounts safe.

Forgot Password: If a user forgets their password, this controller simulates sending a "Reset Link" to their email (using a secure token system).

g). UserController.java

This is the core of the user experience. Once a regular user logs in, this controller manages their personal journey.

Dashboard: Loads the user's profile and workout history from the database.

Logging Activities (The AI Trigger): When a user submits a new workout (e.g., "Running for 30 mins"), this controller saves it and immediately triggers the AI Service to generate a recommendation.

Profile Management: Allows users to update their name, change passwords, or permanently delete their account.

h). AdminController.java

This controller is for the "Boss" (Administrator). It provides oversight of the entire system.

Global Dashboard: Unlike the user dashboard, the Admin sees everyone's data.

User Management: The Admin can "Toggle" a user's status (enable/disable their account) effectively banning or unbanning them.

Content Moderation: The Admin can view details of any workout logged by any user and delete it if necessary.

i). ActivityType.java

This file defines the Standard Vocabulary for the application. It forces the user to select from a specific list of activities (Running, Cycling, Yoga, etc.) rather than typing free text.

Why is this important for AI?

Consistency: If users could type anything, one might type "Jogging," another "Run," and another "Sprinting." This confuses the data analysis.

AI Accuracy: By forcing a standard category (e.g., RUNNING), we ensure the AI Service receives clear, predictable input every time, leading to higher-quality workout recommendations.

j). FitnessActivity.java

This file defines the structure of the fitness_activity table in the database. Every time a user logs a workout, a new row is created here.

Key Data Fields:

@ManyToOne User user: This creates a relationship link. It says: "Many different activities can belong to One single user." It ensures that your workout data doesn't get mixed up with someone else's.

activityType: Stores the category (Running, Yoga, etc.) selected from the Enum menu.

customDetails: Allows the user to add notes (e.g., "Felt tired today," "Ran uphill").

geminiRecommendation: This is the most important field for this project. It reserves a large text space (2000 characters) specifically to store the advice generated by the AI.

How the Process Works:

User enters data (Duration: 30 mins, Type: Running).

App saves this data to the database.

AI reads the data, generates advice.

App updates this specific row to include the AI's advice in the geminiRecommendation column.

k). Role.java

This file defines the different levels of access users can have within the application. It acts like a security badge system for your gym.

The Roles:

ROLE_USER: The standard membership. These users can log in, view their own dashboard, and track their own fitness activities. They cannot see anyone else's data.

ROLE_ADMIN: The "Gym Manager" badge. This user has special permissions to see all users, view any activity, and manage the system configuration.

How it works: When a user tries to access a protected page (like /admin/dashboard), the application checks this Role entity. If the user doesn't have the correct "Badge" (Role), the door stays locked.

l). User.java

This file defines what a "User" actually is in the system. It is the hub that connects all other parts of the application.

Key Features:

Unique Identity: Uses the email address as a unique username so no two people can share an account.

Security: Stores the Password, but remember—as configured in PasswordConfig.java, this will always be the encrypted version, not the plain text.

The "Kill Switch" (enabled): This simple boolean (True/False) switch allows an Administrator to ban a user instantly. If set to false, the user cannot log in, even if their password is correct.

Database Relationships (How it connects):

User ↔ Role:

Relationship: Many-to-One.

Meaning: Many users can have the "USER" role, but one specific user only holds one primary role at a time.

User ↔ Activities:

Relationship: One-to-Many (@OneToMany).

Meaning: One user can have hundreds of workout logs.

Automatic Cleanup: The code cascade = CascadeType.ALL is a smart feature. It means if you (the Admin) delete a User account, the database automatically deletes all their workout logs too. This prevents "orphan data" (workouts belonging to nobody) from clogging up the system.

m). FitnessActivityRepository.java

This interface handles all the communication between the Java code and the database.
This specific method ensures that when a user opens their dashboard, they see their most recent workouts at the top of the list.

n). RoleRepository.java

This interface is responsible for looking up permission levels in the database.
This allows the system to ask simple questions like: "Does the 'ROLE_ADMIN' badge exist?"
It is used heavily during the Registration process (to assign the default "User" role) and during Startup (to ensure the basic roles are created if they are missing).

o). UserRepository.java

This interface manages the list of all registered users.

Key Functions:

findByEmail(String email)

The Login Key: When someone tries to log in, this method searches the database for that specific email address. It is the foundation of the authentication system.

findByRoleNameNot(String roleName)

The Admin Filter: This is a clever sorting tool. It tells the database: "Give me a list of everyone EXCEPT the Admins."

Why use this? On the Admin Dashboard, you want to manage your customers/members. You don't need to see other Administrators in that list. This keeps the view clean and focused on regular users.

p). EmailService.java

This service handles communication with users. It sends Welcome emails upon registration and Reset Links when a password is forgotten.

Developer Note (Mock Mode):

Currently, this service is set to "Mock Mode" for safety and ease of testing.

Instead of sending a real email (which requires sensitive SMTP server passwords), it prints the email content to the system console.

Why? This allows any developer to download and run the project immediately without needing to configure their own Google/Outlook mail servers.

Production Ready: The code includes the real JavaMailSender logic (currently commented out). To go live, you simply uncomment those lines and add your credentials in application.properties.

q). FitnessService.java

his service acts as the bridge between the user's data and the Artificial Intelligence. It manages the entire workflow of logging a workout.

The AI Workflow (Step-by-Step):

Capture Data: When a user logs a workout (e.g., "30 mins cycling"), the service first saves this raw data to the database.

Prompt Engineering (buildGeminiPrompt):

This is where the magic happens. The code constructs a specific, detailed instruction for the AI.

It pulls data from different places: the User's Name, the Activity Type, Duration, and Calories.

The Prompt: It explicitly tells the AI: "Act as a professional fitness coach... provide a concise recommendation... focus on recovery."

AI Consultation: It sends this prompt to the GeminiService.

Save the Wisdom: Once the AI replies with advice (e.g., "Great cardio! Drink 500ml of water and stretch your hamstrings"), this service updates the database record to permanently store that advice alongside the workout.

r). GeminiService.java

This is the engine room that connects your application to Google's massive brain. It handles the difficult task of translating Java code into a language the AI understands (JSON).

How it works:

Preparation (The Payload): The code takes your fitness data and wraps it in a specific package (JSON format). It also attaches a "System Instruction" which effectively hypnotizes the AI, telling it: "You are now a professional fitness coach, not a generic chatbot."

The Call (HttpClient): It uses Java's modern HTTP Client to dial Google's server securely.

The Response: Google sends back a complex data structure. This service acts as a filter, digging through the technical layers to find the single sentence of text (the advice) and handing it back to the FitnessService.

s). UserService.java

This service manages the lifecycle of every user in the system, from the moment they sign up to the moment they delete their account.
Key Responsibilities:

Secure Registration: When a new user joins, this service takes their password and immediately sends it to the PasswordEncoder to be encrypted. It also automatically assigns them the default "ROLE_USER" badge so they can't access admin features.

Profile Management: Allows users to update their personal details (Name, Email). It includes smart logic to ensure two people don't try to claim the same email address.

The "Ban Hammer" (toggleUserEnabled): This is a critical security feature for Admins. It allows an administrator to instantly disable a suspicious account without deleting the data.

Safety Feature: The code includes a check to ensure an Admin cannot accidentally ban another Admin.

t). activity-details.jsp , admin-dashboard.jsp , forgot-password.jsp , index.jsp , login.jsp , profile.jsp , register.jsp , reset-password.jsp contains code of  basic html , bootstrap 5.3 and javascript which is usedto handle frontent of the project
