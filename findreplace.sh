#!/bin/bash
#Change all file names from foo to bar and vice versa. Change content of files from foo to bar and vice versa. Output names of changed files.

DIR=$1

#Choose directory where you want to run the script
if [ -z $1 ]
then
  echo "Usage $0 <path-to-directory>"
  exit 1
fi

#Use sed to replace contents of files
cd $DIR
sed -i '' 's/foo/moo/g' * &&
sed -i '' 's/bar/foo/g' * &&
sed -i '' 's/moo/bar/g' * &&

#Find all files named foo and bar and assign them to variables
FIND_FOO=$(find . -name "*foo*" -type f | sed 's|./||')
FIND_BAR=$(find . -name "*bar*" -type f | sed 's|./||')

#Loop through results of the find command and use sed to change replace file names
for i in $FIND_FOO; do mv $i `echo $i | sed s/foo/moo/g`; done
for i in $FIND_BAR; do mv $i `echo $i | sed s/bar/foo/g`; done

#Find temporary files named moo and rename them
FIND_MOO=$(find . -name "*moo*" -type f | sed 's|./||')
for i in $FIND_MOO; do mv $i `echo $i | sed s/moo/bar/g`; done

#Grep though all files and search for foo or bar, cut the unnecessary part of the output and pipe to uniq to avoid duplicate results. This is to output the files that content has changed.
FILES=$(grep 'foo\|bar' * | sort)

#Echo the results in a friendly format :)
echo -e "These files names changed from foo to bar:\n$FIND_BAR\n"
echo -e "These files names changed from bar to foo:\n$FIND_FOO\n"
echo -e "The content of these files changed:\n$FILES\n"
