/*****************************
Author: plariv@augurynet.commit
Updated: 20200201
Description:
  All employees with completed certs in 2019 but are still enrolled
  as active in the course. This is the basis for flatfile unenroll and
  recert enroll in next course per policy. It also calculates the end date
  for the next course enrollment.
Dependencies:
  views - moodle.candid_unenroll_wnextcrs
******************************/
CREATE OR REPLACE VIEW certcomplete_still_enrolled_2019 AS
SELECT 
X.userid,
X.certificateid,
X.completed,
from_unixtime(X.completed) as compldate,
X.course,
X.idnumber,
X.name,
X.nxt_course_id,
X.nxt_course_cat,
X.nxt_course_num,
timestampadd(YEAR,1,from_unixtime(X.completed)) as nxt_deadline,
unix_timestamp(timestampadd(YEAR,1,from_unixtime(X.completed))) as nxt_unixdline,
Y.enrolid,
Y.timecreated,
Y.estatus,
Y.courseid
FROM moodle.candid_unenroll_wnextcrs AS X
LEFT JOIN (select A.userid,A.enrolid,A.timecreated,A.status as estatus,B.courseid
from mdl_user_enrolments as A
join mdl_enrol as B
on A.enrolid=B.id) as Y
ON X.userid=Y.userid
AND X.course=Y.courseid
where nxt_course_id>0
and estatus=0
and courseid is not null;