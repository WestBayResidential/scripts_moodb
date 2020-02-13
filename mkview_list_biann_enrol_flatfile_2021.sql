/*****************************
Author: plariv@augurynet.commit
Updated: 20200201
Description:
  Create list as basis for flatfile enrollment for next biannual recert courses in 2021
  based on certificate completion recorded in 2019.
  Literals added in order to generate a complete flatfile format. The result set can be
  exported, then uploaded as the target flatfile for Moodle cron enrollment process.
  Timestamp fields added for enrollment start/stop dates appropriate to the biannual
  course category.
Dependencies:
  views - moodle.certcomplete_still_enrolled_2019
******************************/
CREATE OR REPLACE VIEW list_biann_enrol_flatfile_2021 AS
SELECT 
"add",
"student",
userid,
nxt_course_num,
unix_timestamp('2021-01-01 08:00:00'),
unix_timestamp(timestampadd(YEAR,1,from_unixtime(nxt_unixdline))) as nxt_deadline
FROM 
  (SELECT * 
   FROM moodle.certcomplete_still_enrolled_2019
   where nxt_course_cat=8) as B;