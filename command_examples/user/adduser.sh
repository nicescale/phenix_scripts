1. How to Add a New User in Linux
To add/create a new user, all you’ve to follow the command ‘useradd‘ or ‘adduser‘ with ‘username’. The ‘username’ is a user login name, that is used by user to login into the system.
Only one user can be added and that username must be unique (different from other username already exists on the system).
For example, to add a new user called ‘tecmint‘, use the following command.
[root@tecmint ~]# useradd tecmint
When we add a new user in Linux with ‘useradd‘ command it gets created in locked state and to unlock that user account, we need to set a password for that account with ‘passwd‘ command.
[root@tecmint ~]# passwd tecmint
Changing password for user tecmint.
New UNIX password:
Retype new UNIX password:
passwd: all authentication tokens updated successfully.
Once a new user created, it’s entry automatically added to the ‘/etc/passwd‘ file. The file is used to store users information and the entry should be.
tecmint:x:504:504:tecmint:/home/tecmint:/bin/bash
The above entry contains a set of seven colon-separated fields, each field has it’s own meaning. Let’s see what are these fields:
Username: User login name used to login into system. It should be between 1 to 32 charcters long.
Password: User password (or x character) stored in /etc/shadow file in encrypted format.
User ID (UID): Every user must have a User ID (UID) User Identification Number. By default UID 0 is reserved for root user and UID’s ranging from 1-99 are reserved for other predefined accounts. Further UID’s ranging from 100-999 are reserved for system accounts and groups.
Group ID (GID): The primary Group ID (GID) Group Identification Number stored in /etc/group file.
User Info: This field is optional and allow you to define extra information about the user. For example, user full name. This field is filled by ‘finger’ command.
Home Directory: The absolute location of user’s home directory.
Shell: The absolute location of a user’s shell i.e. /bin/bash.
2. Create a User with Different Home Directory
By default ‘useradd‘ command creates a user’s home directory under /home directory with username. Thus, for example, we’ve seen above the default home directory for the user ‘tecmint‘ is ‘/home/tecmint‘.
However, this action can be changed by using ‘-d‘ option along with the location of new home directory (i.e. /data/projects). For example, the following command will create a user ‘anusha‘ with a home directory ‘/data/projects‘.
[root@tecmint ~]# useradd -d /data/projects anusha
You can see the user home directory and other user related information like user id, group id, shell and comments.
[root@tecmint ~]# cat /etc/passwd | grep anusha

anusha:x:505:505::/data/projects:/bin/bash
3. Create a User with Specific User ID
In Linux, every user has its own UID (Unique Identification Number). By default, whenever we create a new user accounts in Linux, it assigns userid 500, 501, 502 and so on…
But, we can create user’s with custom userid with ‘-u‘ option. For example, the following command will create a user ‘navin‘ with custom userid ‘999‘.
[root@tecmint ~]# useradd -u 999 navin
Now, let’s verify that the user created with a defined userid (999) using following command.
[root@tecmint ~]# cat /etc/passwd | grep tecmint

navin:x:999:999::/home/navin:/bin/bash
NOTE: Make sure the value of a user ID must be unique from any other already created users on the system.
4. Create a User with Specific Group ID
Similarly, every user has its own GID (Group Identification Number). We can create users with specific group ID’s as well with -g option.
Here in this example, we will add a user ‘tarunika‘ with a specific UID and GID simultaneously with the help of ‘-u‘ and ‘-g‘ options.
[root@tecmint ~]# useradd -u 1000 -g 500 tarunika
Now, see the assigned user id and group id in ‘/etc/passwd‘ file.
[root@tecmint ~]# cat /etc/passwd | grep tarunika

tarunika:x:1000:500::/home/tarunika:/bin/bash
5. Add a User to Multiple Groups
The ‘-G‘ option is used to add a user to additional groups. Each group name is separated by a comma, with no intervening spaces.
Here in this example, we are adding a user ‘tecmint‘ into multiple groups like admins, webadmin and developer.
[root@tecmint ~]# useradd -G admins,webadmin,developers tecmint
Next, verify that the multiple groups assigned to the user with id command.
[root@tecmint ~]# id tecmint

uid=1001(tecmint) gid=1001(tecmint)
groups=1001(tecmint),500(admins),501(webadmin),502(developers)
context=root:system_r:unconfined_t:SystemLow-SystemHigh
6. Add a User without Home Directory
In some situations, where we don’t want to assign a home directories for a user’s, due to some security reasons. In such situation, when a user logs into a system that has just restarted, its home directory will be root. When such user uses su command, its login directory will be the previous user home directory.
To create user’s without their home directories, ‘-M‘ is used. For example, the following command will create a user ‘shilpi‘ without a home directory.
[root@tecmint ~]# useradd -M shilpi
Now, let’s verify that the user is created without home directory, using ls command.
[root@tecmint ~]# ls -l /home/shilpi

ls: cannot access /home/shilpi: No such file or directory
7. Create a User with Account Expiry Date
By default, when we add user’s with ‘useradd‘ command user account never get expires i.e their expiry date is set to 0 (means never expired).
However, we can set the expiry date using ‘-e‘ option, that sets date in YYYY-MM-DD format. This is helpful for creating temporary accounts for a specific period of time.
Here in this example, we create a user ‘aparna‘ with account expiry date i.e. 27th April 2014 in YYYY-MM-DD format.
[root@tecmint ~]# useradd -e 2014-03-27 aparna
Next, verify the age of account and password with ‘chage‘ command for user ‘aparna‘ after setting account expiry date.
[root@tecmint ~]# chage -l aparna

Last password change            : Mar 28, 2014
Password expires            : never
Password inactive           : never
Account expires             : Mar 27, 2014
Minimum number of days between password change            : 0
Maximum number of days between password change            : 99999
Number of days of warning before password expires   : 7
8. Create a User with Password Expiry Date
The ‘-f‘ argument is used to define the number of days after a password expires. A value of 0 inactive the user account as soon as the password has expired. By default, the password expiry value set to -1 means never expire.
Here in this example, we will set a account password expiry date i.e. 45 days on a user ‘tecmint’ using ‘-e‘ and ‘-f‘ options.
[root@tecmint ~]# useradd -e 2014-04-27 -f 45 tecmint
9. Add a User with Custom Comments
The ‘-c‘ option allows you to add custom comments, such as user’s full name, phone number, etc to /etc/passwd file. The comment can be added as a single line without any spaces.
For example, the following command will add a user ‘mansi‘ and would insert that user’s full name, Manis Khurana, into the comment field.
[root@tecmint ~]# useradd -c "Manis Khurana" mansi
You can see your comments in ‘/etc/passwd‘ file in comments section.
[root@tecmint ~]# tail -1 /etc/passwd

mansi:x:1006:1008:Manis Khurana:/home/mansi:/bin/sh
10. Change User Login Shell:
Sometimes, we add users which has nothing to do with login shell or sometimes we require to assign different shells to our users. We can assign different login shells to a each user with ‘-s‘ option.
Here in this example, will add a user ‘tecmint‘ without login shell i.e. ‘/sbin/nologin‘ shell.
[root@tecmint ~]# useradd -s /sbin/nologin tecmint
You can check assigned shell to the user in ‘/etc/passwd‘ file.
[root@tecmint ~]# tail -1 /etc/passwd

tecmint:x:1002:1002::/home/tecmint:/sbin/nologin
Part II – 5 Advance Usage of useradd Commands
11. Add a User with Specific Home Directory, Default Shell and Custom Comment
The following command will create a user ‘ravi‘ with home directory ‘/var/www/tecmint‘, default shell /bin/bash and adds extra information about user.
[root@tecmint ~]# useradd -m -d /var/www/ravi -s /bin/bash -c "TecMint Owner" -U ravi
In the above command ‘-m -d‘ option creates a user with specified home directory and the ‘-s‘ option set the user’s default shell i.e. /bin/bash. The ‘-c‘ option adds the extra information about user and ‘-U‘ argument create/adds a group with the same name as the user.
12. Add a User with Home Directory, Custom Shell, Custom Comment and UID/GID
The command is very similar to above, but here we defining shell as ‘/bin/zsh‘ and custom UID and GID to a user ‘tarunika‘. Where ‘-u‘ defines new user’s UID (i.e. 1000) and whereas ‘-g‘ defines GID (i.e. 1000).
[root@tecmint ~]# useradd -m -d /var/www/tarunika -s /bin/zsh -c "TecMint Technical Writer" -u 1000 -g 1000 tarunika
13. Add a User with Home Directory, No Shell, Custom Comment and User ID
The following command is very much similar to above two commands, the only difference is here, that we disabling login shell to a user called ‘avishek‘ with custom User ID (i.e. 1019).
Here ‘-s‘ option adds the default shell /bin/bash, but in this case we set login to ‘/usr/sbin/nologin‘. That means user ‘avishek‘ will not able to login into the system.
[root@tecmint ~]# useradd -m -d /var/www/avishek -s /usr/sbin/nologin -c "TecMint Sr. Technical Writer" -u 1019 avishek
14. Add a User with Home Directory, Shell, Custom Skell/Comment and User ID
The only change in this command is, we used ‘-k‘ option to set custom skeleton directory i.e. /etc/custom.skell, not the default one /etc/skel. We also used ‘-s‘ option to define different shell i.e. /bin/tcsh to user ‘navin‘.
[root@tecmint ~]# useradd -m -d /var/www/navin -k /etc/custom.skell -s /bin/tcsh -c "No Active Member of TecMint" -u 1027 navin
15. Add a User without Home Directory, No Shell, No Group and Custom Comment
This following command is very different than the other commands explained above. Here we used ‘-M‘ option to create user without user’s home directory and ‘-N‘ argument is used that tells the system to only create username (without group). The ‘-r‘ arguments is for creating a system user.
[root@tecmint ~]# useradd -M -N -r -s /bin/false -c "Disabled TecMint Member" clayton
For more information and options about useradd, run ‘useradd‘ command on the terminal to see available options.
