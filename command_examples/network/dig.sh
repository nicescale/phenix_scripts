#!/bin/bash

dig www.google.com
; <> DiG 9.3.3rc2 <> www.google.com
; (1 server found)
;; global options: printcmd
;; Got answer:
;; ->>HEADER<;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 3, ADDITIONAL: 3
;; QUESTION SECTION:
;www.google.com. IN A
;; ANSWER SECTION:
http://www.google.com/. 43200 IN A 200.99.187.2
;; AUTHORITY SECTION:
http://www.google.com/. 43200 IN NS ns2.google.com.
http://www.google.com/. 43200 IN NS ns3.google.com.
http://www.google.com/. 43200 IN NS ns1.google.com.
;; ADDITIONAL SECTION:
ns1.google.com. 43200 IN A 222.54.11.86
ns2.google.com. 43200 IN A 220.225.37.222
ns3.google.com. 43200 IN A 203.199.147.233
;; Query time: 1 msec
;; SERVER: 222.54.11.86#53(222.54.11.86)
;; WHEN: Wed Nov 18 18:31:12 2009
;; MSG SIZE rcvd: 152
[root@ts6741 ~]#



The above out we given in color coding to explain one by one as shown below.

1.DIG version in Green (9.3).

2.Question section in blue (Here it will show what you asked DIG to show up?).

3.Answer secession in red (which will show you the answer for the query you asked).

4.Authority section in brown (Which will show you who given the answer).

5.Addition Section in light blue (It will show you if any additional info that DNS server provided).

6.Total Query time in light green (Which will show how much time it takes to provide the answer).

7.Server info in light brown (This will show what the port DNS server is working).

 Linuxnix-free-e-book
8.Query execute date and time in dark red.



Usage2 : Using DIG for reverse lookup entries

#dig –x ipadd 
Example : 

#dig –x 192.56.78.1
Usage3 : Digging with specified DNS server. Let me put it in this way. My dns server is not working properly and I want to test some server details, for this DIG will allow you to provide a DNS sever so that DIG will get information about the required system from that DNS server. We can provide DNS server by using @ symbol as shown below. 

#dig @ns-server hostname 
Example :

#dig @223.125.43.67 http://www.google.com/
Note : Here in this example my dig will not check /etc/resolve.conf file for default DNS server entry, it will just request details of http://www.google.com/ from a outside world DNS server ie 223.125.43.67


Usage4 : To dig a DNS server on a perticular port,where DNS server is running .

#dig @223.125.43.67 -p 2345 www.google.com
Note:here 223.125.43.67 is the DNS server and port 2345 where that DNS service is running.

Usage5 : To check the trace of the path.

#dig http://www.google.com/ +trace
Usage6 : To get mail server details 

#dig mx www.google.com  
Note : This will provied all the mail servers in google.com

Usage7: To get Name server details

#dig ns http://www.google.com/
Note : This will provide all the Name Server records.
