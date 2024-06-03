# Delta_inductions_tasks
induction tasks for the programming club of NITT.

**TASK DESCRIPTION:**

**Normal Mode:**

**(alias - userGen)** Create an account for the Core (Club Admin) with their own Home directory. Create respective folders for mentors and mentees under the Core's home directory. Create accounts and home directories for the respective mentees under the mentees directory. Create three folders Webdev, Appdev, and Sysad under the mentors folder and create accounts and home directories for the respective mentors under their respective domains.

    
All the mentees should have a domain_pref.txt, task_completed.txt file  and a task_submitted.txt files in their home directory
Permissions
Core should be able to access everyone's home directory
Mentors should not be able to access other mentors' home directories
Mentees should be able to access only their home directory
Mentors should have an allocatedMentees.txt file and a submittedTasks directory in their home directory. The submittedTasks should have task1, task2, task3 as subdirectories
Core will have their own mentees_domain.txt file which can be accessed by all the mentees but only with write permissions. (No read and execute)

Note: Use menteeDetails.txt, mentorDetails.txt and mentees_domain.txt


**(alias - domainPref)** When a mentee uses this, It should allow them to take in domain preferences (anywhere from 1 - 3) in their preferred order. Add the domain preferences to the respective mentee's domain_pref.txt file present in their home directory. Append the roll number and domains to the core's mentees_domain.txt file. Create directories for each domain chosen inside the mentee's home directory.

**(alias - mentorAllocation)** When core uses this alias, generate a First-Come-First-Serve mentor allocation in an efficient manner according to the mentee capacity given in the mentorDetails.txt file. Store the names and roll numbers of the mentees in the allocatedMentees.txt file in the home directory of the allocated mentor.

**(alias - submitTask)** When a mentee executes this alias, it will populate the details of the submitted tasks in the task_submitted.txt file and generate the corresponding task folders under the directory of the domain to which that particular task belongs. (Note: This should be a command-line tool). If a mentor runs it, Check for all the task directories of their respective mentees and create a symlink from the mentor's task directory to the mentees' respective task directories. Check if the tasks are completed (If the task folder is not empty, then assume that the task is completed) and modify the task_completed.txt file accordingly.


**(alias - displayStatus)** When the core runs this alias, it will print out the total percentage of people who submitted each task so far along with the list of mentees who submitted the task since the last time the core used this alias. You should also be able to filter by domain using command-line arguments.
 
**SuperUser Mode:**

**(alias - deRegister)** Whenever a mentee wants to deregister out of the induction process, They can use this alias to do it. When deregistering, it should remove the domain dir from their home and remove it from their domain_pref.txt


**(Cronjob)** Create a cronjob to 
Run displayStatus every once a day
Check every mentee to see if they have deregistered, and if so remove all traces of that mentee only if they deregistered from all domains. if not remove all traces from their respective mentor's files. Please consult your mentor about your method, before proceeding. This should occur at 10:10 every three days of the week and on Sundays for May, June, and July. Do not set up multiple cronjobs.

**(alias - setQuiz)** Mentors should be able to make a set of questions (how many ever they want to), and the mentees should be able to view them as a notification at their next login, answer these questions, and save them in quiz_answers in their home directory.
