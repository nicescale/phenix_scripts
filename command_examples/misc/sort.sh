#!/bin/bash

set -e

# Example1: Sort a given file according to alpha-bates
sort filename.txt

# Example2: I have a file with host names in third column, how can I sort them according to this column(according to hostname)?. Use -k for sorting according to column(kolumn)
sort -k3 filename.txt

# Example3:I want to sort /etc/passwd file according to home directories but my sort is not working how can I sort them? By default sort will take space/tabs as field separators. But in /etc/passwd file the field separator is : so we have to mention this one when sorting a file. This can be done with -t option
sort -t: -k6 /etc/passwd

# Example4: I want to sort according to number, suppose I want to sort /etc/passwd file according to UID, use -n option to do that. Again sort will not understand numbers by default, we have to use -n to make sure sort command understand it.
sort -n -t: -k3 /etc/passwd

#Note: For example with out -n option sort will put 10 before 3 when it find this values, by default it will sort only first numerical char.

# Example5: Sort the file and reverse the order
sort -r filename.txt

# Example6: Some times its required to sort the file and display only uniq values.
sort -u filename

#Note: though the values on other field are different this will not consider by -u option.

# Example7: I want to sort a file according to my requirement and save it to a different file. Use -o option to save the sorted output to a file.
sort -o temp.txt filename.txt

# Do you have file content with sizes like 10K, 20G, 45M, 32T etc. You can sort accourding to human readable by using -h option. This option works RHEL5 and above versions.
sort -h filename.txt

# Similar to above example we can use -m for sorting according to month of the year.
sort -M filename.txt

# Example9: Check if the file is alrady in sorted format or not by using -c option. This option will show you what is the first occurence disorderd value.
sort -c filename.txt

# To sort a file:
sort file

# To sort a file by keeping only unique:
sort -u file

# To sort a file and reverse the result:
sort -r file

# To sort a file randomly:
sort -R file
