/*****************************
Author: plariv@augurynet.commit
Updated: 20200201
Description:
  Create list as basis for flatfile enrollment for next annual recert courses in 2020
  based on certificate completion recorded in 2019
  Included literals in order to generate a complete flatfile format. Result set
  can be exported, then uploaded as target flatfile for Moodle cron enrollment.
  Timestamp field added for enrollment start time appropriate to the annual course category.
Dependencies:
  views - moodle.certcomplete_still_enrolled_2019
******************************/
CREATE OR REPLACE VIEW list_ann_enrol_flatfile_2020 AS
SELECT 
"add",
"student",
A.userid,
A.nxt_course_num,
unix_timestamp('2020-01-01 08:00:00'),
A.nxt_unixdline as nxt_deadline
FROM 
  (SELECT * 
   FROM moodle.certcomplete_still_enrolled_2019
   where nxt_course_cat=7) as A;