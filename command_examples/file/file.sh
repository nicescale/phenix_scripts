"How many types of files are there in Linux/Unix and what are they?" This is a common question to every person who starts to learn Linux. O.K, why is it that much important to know file types?


 
Answer: This is because Linux considers every thing as a file. When ever you start working on Linux/Unix box you have to deal with different file types to effectively manage them.

How many types of file are there in Linux/Unix?

By default Unix have only 3 types of files. They are..

Regular files
Directory files
Special files(This category is having 5 sub types in it.)
So in practical we have total 7 types(1+1+5) of files in Linux/Unix. And in Solaris we have 8 types. And you can see the file type indication at leftmost part of “ls -l” command.

Here are those files type.

Regular file(-)
Directory files(d)
Special files
Block file(b)
Character device file(c)
Named pipe file or just a pipe file(p)
Symbolic link file(l)
Socket file(s)
For your information there is one more file type called door file(D) which is present in Sun Solaris as mention earlier. A door is a special file for inter-process communication between a client and server (so total 8 types in Unix machines). We will learn about different types of files as below sequence for every file type.

Definition and information of the file type
How to create particular file type
How to list/see particular file type
Regular file type Explained in Linux
These are the files which are indicated with "-" in ls -l command output at the starting of the line. And these files are.

1. Readable file or
2. A binary file or
3. Image files or
4. Compressed files etc.
How to create regular files in Linux/Unix? 
Ans: Use touch/vi command and redirection operators etc.

How can we list regular files?

ls -l | grep ^-
Example listing of regular files :

-rw-r–r– 1 krishna krishna 20986522 2010-01-31 13:48 test.wmv
-rw-r–r– 1 krishna krishna 173448 2010-01-30 21:20 Transformers-Teaser-Wallpaper-310.jpg
-r-xr-xr-x 1 root root 135168 2009-12-12 19:14 VIDEO_TS.VOB
-rw-r–r– 1 krishna krishna 2113536 2009-12-01 13:32 Aditya 365 – Janavule.mp3
-rwxrwxrwx 1 root root 168 2010-02-14 14:12 xyz.sh
Directory file type explained in Linux/Unix
These type of files contains regular files/folders/special files stored on a physical device. And this type of files will be in blue in color with link greater than or equal 2.

How can we list them in my present working directory? 
ls -l | grep ^d
Example listing of directories.

drwxr-xr-x 2 surendra surendra 4096 2010-01-19 18:37 bin
drwxr-xr-x 5 surendra surendra 4096 2010-02-15 18:46 Desktop
drwxr-xr-x 2 surendra surendra 4096 2010-01-18 14:36 Documents
drwxr-xr-x 2 surendra surendra 4096 2010-02-13 17:45 Downloads
How to create them? 
Ans : Use mkdir command

Block file type in Linux
These files are hardware files most of them are present in /dev.

How to create them? 
Ans : Use fdisk command or create virtual partition.

How can we list them in my present working directory?

ls -l | grep ^b

Example listing of Block files(for you to see these file, they are located in /dev).

brw-rw—- 1 root disk 8, 1 2010-02-15 09:35 sda1
brw-rw—- 1 root disk 8, 2 2010-02-15 09:35 sda2
brw-rw—- 1 root disk 8, 5 2010-02-15 09:35 sda5
Character device files in Linux
Provides a serial stream of input or output.Your terminals are classic example for this type of files.

How can we list character files in my present working directory?

ls -l | grep ^c

Example listing of character files(located in /dev)

 Linuxnix-free-e-book
crw-rw-rw- 1 root tty 5, 0 2010-02-15 16:52 tty
crw–w—- 1 root root 4, 0 2010-02-15 09:35 tty0
crw——- 1 root root 4, 1 2010-02-15 09:35 tty1
Pipe files in Linux/Unix
The other name of pipe is a “named” pipe, which is sometimes called a FIFO. FIFO stands for “First In, First Out” and refers to the property that the order of bytes going in is the same coming out. The “name” of a named pipe is actually a file name within the file system.

How to create them? 
Ans: Use mkfifo command.

How can we list character files in my present working directory?

ls -l | grep ^p

Example listing of pipe files

prw-r—– 1 root root 0 2010-02-15 09:35 /dev/.initramfs/usplash_outfifo
prw-r—– 1 root root 0 2010-02-15 09:35 /dev/.initramfs/usplash_fifo
prw——- 1 syslog syslog 0 2010-02-15 15:38 /var/run/rsyslog/kmsg
symbolic link files in Linux
These are linked files to other files. They are either Directory/Regular File. The inode number for this file and its parent files are same. There are two types of link files available in Linux/Unix ie soft and hard link.

How to create them? 
Ans : use ln command

How can we list linked files in my present working directory?

ls -l | grep ^l

Example listing of linked files
lrwxrwxrwx 1 root root 24 2010-02-15 09:35 sndstat -> /proc/asound/oss/sndstat
lrwxrwxrwx 1 root root 15 2010-02-15 09:35 stderr -> /proc/self/fd/2
lrwxrwxrwx 1 root root 15 2010-02-15 09:35 stdin -> /proc/self/fd/0
lrwxrwxrwx 1 root root 15 2010-02-15 09:35 stdout -> /proc/self/fd/1
Socket files in Linux
A socket file is used to pass information between applications for communication purpose

How to create them? 
Ans : You can create a socket file using socket() system call available under

Example in C programming

int sockfd = socket(AF_INET, SOCK_STREAM, 0);
You can refer to this socket file using the sockfd. This is same as the file descriptor, and you can use read(), write() system calls to read and write from the socket.

How can we list Socket files in my present working directory?

ls -l | grep ^s

Example listing of socket files.

srw-rw-rw- 1 root root 0 2010-02-15 09:35 /dev/log

srwxrwxrwx 1 root root 0 2010-02-15 10:07 /var/run/cups/cups.sock
srwxrwxrwx 1 root root 0 2010-02-15 09:35 /var/run/samba/winbindd_privileged/pipe
srwxrwxrwx 1 mysql mysql 0 2010-02-15 09:35 /var/run/mysqld/mysqld.sock
A tip for you guys. How to find your desired type of file ?

Ans : Use find command with -type option. For example if you want to find socket file, just use below command. find / -type s If you want to find linked file then how? Find / -type l
