#!/bin/bash

# For WBLMS Moodle database, this script
# concatenates all individual event and view
# making scripts in this directory into a single
# query (make_allviews.sql) that can be passed to MySQL
# as a single argument.
#
# At the top of the script, the following commands are
# inserted:
#  -"USE" is added to ensure that the queries
#    are applied to moodle database.
#  - the global event scheduler is turned on 
#    for the event query to run.
# After each file is appended, a semicolon is inserted
# after as delimiter.
#
#
rm -f make_allviews.sql
echo "USE moodle;">>make_allviews.sql
echo "SET GLOBAL event_scheduler=ON;">>make_allviews.sql
for file in mkview_*.sql
do
  echo "Appending $file ..."
  cat "$file" >> make_allviews.sql
  echo ";">> make_allviews.sql
done

for file in mkevent_*.sql
do
  echo "Appending $file ..."
  cat "$file" >> make_allviews.sql
  echo ";">> make_allviews.sql
done

