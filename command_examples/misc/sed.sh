#!/bin/bash

set -e

a)sed is a Stream EDitor.

b)It reads line by line when a file is feed to it.

c)sed will not edit the input file by default and it displays output on the screen.

d)SED is mainly used for search for a term and replace with desired term in a file/stream
SED can do following things.

1) Search and replace (s switch) –90 % of your SED related work is completed with this option

2) Printing (-n and p switch)

3) Editing (-I, w, d switch)

4) Multiple SED commands and continuation operation (-e and ; switch)

5) Line number ( , and = switch)

6) Search operation (/searcterm/)

7) Negation operation(!)

8) SED scripting operator (-f switch)

9) Miscellaneous SED examples
Search and replace operator( s for search)
Below is the syntax for search a term and replace it with another team.

sed ‘s/searchterm/replaceterm/’ inputfile

or

cat inputfilename | sed ‘s/searchterm/replaceterm/’
or

echo “This is test message” | sed ‘s/searchterm/replaceterm/’
Exameple1: Search for google in file:test.txt and replace with yahoo

sed ‘s/google/yahoo/’ test.txt
Example2: How about globally? By default sed will work on only first find term. Suppose I have following sentence.

“sheena leads, sheila needs”. I want to replace sh with le. If I use below example it will replace only first occurrence.

echo “sheena leads, sheila needs” | sed ‘s/sh/le/’
Output

leeena leads, Sheila needs
Solution is g switch, to inform sed to search for the term globally/multiple times within the line.

echo “sheena leads, sheila needs” | sed ‘s/sh/le/g’
Output

Leeena leads, leeeila needs

Example3: How about changing separator: This very much useful when your search term contains separator. At that time your SED can not understand. For example you want to search for /var/ftp/pub and replace it with /opt/ftp/com. The below code will not work properly.

sed ‘s//var/ftp/pub//opt/ftp/com/’ test.txt
For this you should change the separator from / to some other char such as # or $. In fact any character which is not present in search and replace term. For above example this will work.

sed ‘s_/var/ftp/pup_/opt/ftp/com_’ test.txt

Here my separator is _

Example4: Whenever you search for a term, your sed will keep this search term in special character ‘&’, so that you can use it in replace term. Suppose you want to search for Surendra and replace it with Mr. Surendra use below command

sed ‘s/surendra/Mr. &/’ test.txt
& for matched character and surendra is stored in & by default.

From here after if you want to get grip on SED you should know RegExp. Please find RegExp basics here and here.

Example5: () used to match group of characters. And 1 is to store that value.If there are many such they are stored in 2, 3 till 9 respectivly. i.e. First bracket value in 1, second in 2 and so on up to 9

I have a pattern like

Abc123suri

And this should be changed to

suriabc123

echo “abc123suri” | sed ‘s/([a-z]*)([0-9]*)([a-z]*)/312/’
Note:As mention earlier to know more about this you have to learn RegExp using grep here and here.

 Printing operator (-n and p switch)
Example6: SED by default display all the lines when working on them. But there are some times which require only printing of changed lines then use –n(quite output i.e no output) and p option to print only changed lines. I will take below file as my input file.

cat tem.txt

surendra audi

kumar nudi

mouni surendra

baby dudy

 Linuxnix-free-e-book
cat tem.txt | sed 's/surendra/bca/'
Output

surendra audi

kumar nudi

mouni bca

baby dudy

With –n(Suppress output) and p(Print the matched pattern) options

cat tem.txt | sed -n 's/surendra/bca/p'
Output:

bca audi

mouni bca

Editing operators (-i, w, d switch and Shell redirection operators)
Example7: I want to make changes to the file which is fed as input file ie changes are written to original file. To do this we have to use –i for inserting.

sed –I ‘s/bca/Surendra/’ tem.txt
Caution: Use –i option wisely. Because you cannot revert back the changes of original file.

Example8: With output redirection we can do the same thing.

sed ‘s/baby/dady/’ < tem.txt > abc.txt.
Example9: How about writing only changes to another file for future reference?

With w option, we will get only changes to the new file

sed ‘s/baby/dady/w abc.txt’ tem.txt
Example10: How about deleting lines?. Suppose you want to delete line number 3 use the below command

sed ‘3d’ tem.txt
Example10:How about deleting 4 line and update the original file?

sed –i ‘4d’ tem.txt
Caution:Use –i option wisely whenever you are using it. We will play more with lines and numbers in coming post.

Multiple SED commands and continuation operators (-e and ; switch)
Sometimes there are cases where we want to search for multiple patterns and replace these patterns with respective patterns. Suppose I want to find Surendra, mouni, baby and replace them with bca, mca, bba respectively in tem.txt. We can use below command chaining.

cat tem.txt | sed ‘s/Surendra/bca/’ | sed ‘s/mouni/mca/’ | sed ‘s/baby/bba/’
This is not a professional way to write. There is an –e option to do this multiple substitutions.

Example11: Execute multiple commands with –e option

sed –e ‘s/surendra/bca/’ –e ‘s/mouni/mca/’ –e ‘s/baby/bba/’ tem.txt
Example12:How about reducing it more by using ;(Continuation operator) for the same question?

sed ‘s/Surendra/bca/;s/mouni/mca/;s/baby/bba/’ tem.txt

We can search in a file according to line numbers.

Example13: Suppose I want to search in only 3rd line and then replace the term in that line alone.

sed ‘3 s/Surendra/bca/’ tem.txt
Example14:Search from 1st line to 4th line and replace that term.

sed ‘1,4 s/Surendra/bca/’ tem.txt
Example15:Search for a term from 3rd line to 5th line and replace it only between these lines.

sed ‘3,5 s/Surendra/bca/’ tem.txt
Example16:Search for a term from 2nd line to the end of the file and replace it with a term.

sed ‘2,$ s/Surendra/bca/’ tem.txt
Example17:How about combining two-line in to a single line. The below script will use N option which try to merge two, two lines in to single line and it will keep newline character in the combine line.

sed ‘N’ tem.txt
The output will not differ to the input file. If you want to really see the difference you have to use search and replace for n to some space or tab(t)

sed ‘N;s/\n/ /’ tem.txt
Output:

surendra audi kumar nudi

mouni surendra baby dudy

Note:The above command is not used much of the time and I used this example to make it simple for below command for numbering.

Example18: I want to give numbering to all the lines after search and replace. Line numbers are given by using = option

sed = tem.txt
Output

1

surendra audi

2

kumar nudi

3

mouni surendra

4

baby dudy

Example19: But is this right way to do the things? If I can display output as below that would be great.

Output

1 surendra audi

2 kumar nudi

3 mouni surendra

4 baby dudy

To get above output we have to use N option to combine two lines

sed = tem.txt | sed ‘N;s/\n/\t/’
Search operator (/searcterm/)
Example20: sed can work for you on particular line where you given one word which is matching in that line. For example in fle tem.txt where ever it finds Surendra, replace audi with xyz. The code for that one is below

 sed ‘/surendra/ s/audi/xyz/’ tem.txt
Example21: How about a range of lines, search for audi from first line to the search term Surendra and replace audi with xyz

sed ‘1,/Surendra/ s/audi/xyz/’ tem.txt
Example22: How about search from 3rd line to till it find Surendra?

 Linuxnix-free-e-book
sed ‘3,/Surendra/ s/audi/xyz/’ tem.txt
Example23: How about search and replace audi with xyz between two search terms Surendra and mouni?

sed ‘/Surendra/,/mouni/ s/audi/xyz/’ tem.txt
Example24: How about searching from a search pattern to end of the line?

sed ‘/Surendra/,$ s/audi/xyz/’ tem.txt
Negation operation(!)
 
 This operator will work with w, p and d options. We will see some examples below. This operator is bit confusing and require more practice to get more out of this.

This option is useful for negating the search pattern.
Example25: I want to display all the lines which do not contain abc word

sed –n ‘/abc/ !p’ tem.txt

Example26: I want to delete all lines expect the lines which contain surendra.

sed '/surendra/ !d' tem.txt

You can combine all the above mention techniques with this negation option.
For example
Example27: What to delete all the lines expect 1 to 3

sed '1,3 !d'

 SED scripting operator (-f switch)
This option is useful for writing complex SED script, as you people are aware of SED is one more scripting language such as Shell scripting, AWK and Perl etc.

sed -f sedscript.sed
Where sedscript.sed will contain SED script as we do for Bash scripting.

# To replace all occurrences of "day" with "night" and write to stdout:
sed 's/day/night/g' file.txt

# To replace all occurrences of "day" with "night" within file.txt:
sed -i 's/day/night/g' file.txt

# To replace all occurrences of "day" with "night" on stdin:
echo 'It is daytime' | sed 's/day/night/g'

# To remove leading spaces
sed -i -r 's/^\s+//g' file.txt

# To remove empty lines and print results to stdout:
sed '/^$/d' file.txt

# To replace newlines in multiple lines
sed ':a;N;$!ba;s/\n//g'  file.txt
