#!/bin/bash

cat db.txt

Ip,Henry 29 32 23 27
Frank,Joe 26 29 22 28
Gill,Marry 25 30 20 25
Avery,Adam 25 31 19 21
Chow,Samuel 23 29 19 25
Dible,Liz 22 30 20 22
Warn,Suzanne 23 29 19 23
Dow,Juila 24 29 20 20
Low,juila 22 21 19 18
Joe,Sarah 19 21 18 20

Example1: Search for Dow word in the file and print those lines. This is like simulate grep using AWK

awk ‘/Dow/’ db.txt

Sample output:
Dow,Juila 24 29 20 20

Example2: Search for a word and print the lines which contain either Juila or juila in the given file.

awk ‘/[Jj]uila/’ db.txt

Output:
Dow,Juila 24 29 20 20
Low,juila 22 21 19 18

In the above example we used regular expression to match both Juila and juila. Know more about RegExp here.

Example3: Print particular column from db.txt file.

awk ‘{print $2}’ db.txt

Output:
29
26
25
25
23
22
23
24
22
19

Exampl4: Print multiple columns from a given file.

awk ‘{print $2,$4}’ db.txt

Output:
29 23
26 22
25 20
25 19
23 19
22 20
23 19
24 20
22 19
19 18

Example5: Print multiple columns with a tab between columns as separator

awk ‘{print $2,”t”,$4}’ db.txt 

Output:
29   23
26   22
25   20
25   19
23   19
22   20
23   19
24   20
22   19
19   18

Example6: Search for Chow word and print corresponding third column. In most of the programming languages /searchterm/ is meant for searching for a word. AWK too uses same concept when search for a word in a given line.

awk ‘/Chow/{print $3}’ db.txt
Output:
29

Example7: Print all the column 4 values between lines which contain Frank and Low

awk ‘/Frank/,/Low/{print $4}’ db.txt
Output:
29
30
31
29
30
29
29
21

 Linuxnix-free-e-book
Example8: Print line numbers more than 5.
awk ‘NR>5′  db.txt
Output:
Dible,Liz 22 30 20 22
Warn,Suzanne 23 29 19 23
Dow,Juila 24 29 20 20
Low,juila 22 21 19 18
Joe,Sarah 19 21 18 20

Note1: NR is a inbuilt variable which keeps the Line numbers of a file, to know more about it just visit out post on AWK inbuilt variables.

Example9: Print lines from 3 to 6.

awk ‘NR>3 && NR<7 db.txt="">
Output:
Avery,Adam  25  31  19  21
Chow,Samuel 23  29  19  25
Dible,Liz 22  30  20  22

Till this point we search for entire line and then printed desired output. Following examples will search for a particular column.

Example10: Print only lines which have 29 in its third column.

awk’$3 ~/29/’ db.txt

Output:

Frank,Joe   26  29  22  28
Chow,Samuel 23  29  19  25
Warn,Suzanne  23  29  19  23
Dow,Juila 24  29  20  20

We can use Regexp for more control on what we want to print.

Example11: Print column 5 if the column 3 contain 31 in it.

awk ‘$3 ~/31/{print $5}’ db.txt

Output:
21

Example12: Print column 3 for the lines more than 4.

awk ‘(NR>4){print $3}’ db.txt
Output:
29
30
29
29
21
21

Example13: Want to print something other than file content at the start of the output?. We can use inbuilt Block called BEGIN block. Suppose I want to print “This is the filtered output” use below code.

awk ‘BEGIN{print “This is the filtered output”}(NR>4){print $3}’ db.txt

Output:
This is the filtered output
29
30
29
29
21
21

Example14: What about printing after the filter output?. We can use END block for doing this.

awk ‘(NR>4){print $3}END{print “This is the end of filter output”}’ db.txt
Output:
29
30
29
29
21
21
This is the end of filter output
# sum integers from a file or stdin, one integer per line:
printf '1\n2\n3\n' | awk '{ sum += $1} END {print sum}'
