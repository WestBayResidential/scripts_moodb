USE moodle;
SET GLOBAL event_scheduler=ON;
/*****************************
Author: plariv@augurynet.commit
Updated: 20200201
Description:
  View to produce candidate unenrollment list based 
  on awarded completion certificates starting at 
  the specified date (currently set to 1/1/2019)
Dependencies:
  views - moodle.course_cat_sname_num_only
******************************/
create or replace view candid_unenroll_wnextcrs as
SELECT 
   userid, 
   certificateid, 
   mdl_certificate_issues.timecreated as completed, 
   from_unixtime(mdl_certificate_issues.timecreated, '%Y-%m-%d') as completeddate, 
   course,
   XX.idnumber,
   name,
   nxt_course_id,
   ZZ.category as nxt_course_cat,
   ZZ.idnumber as nxt_course_num
FROM mdl_certificate_issues
JOIN mdl_certificate
ON mdl_certificate_issues.certificateid=mdl_certificate.id
/* Start completions list on 1/1/2019 */
join mdl_recertpol
on course = cur_course_id
join mdl_course as XX
on course = XX.id
join course_cat_sname_num_only as ZZ
on nxt_course_id = crsid
WHERE mdl_certificate_issues.timecreated>=1546304100;
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
/*****************************
Author: plariv@augurynet.commit
Updated: 20200201
Description:
  Simple table of all course ids, categories, shortname and coursenum only
Dependencies:
  views - none
******************************/
create or replace view course_cat_sname_num_only as
select
id as crsid,
category,
shortname,
idnumber
from mdl_course;
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
/*****************************
Author: plariv@augurynet.commit
Updated: 20200201
Description:
  List all employees in the user table who are suspended, ordered by 
  last name, and are also
  enrolled in any courses, for any time period. This list should confirm
  the reported status of 'suspended' in a Moodle enrollee listing for 
  any course
Dependencies:
  None
******************************/
CREATE OR REPLACE VIEW list_suspended_enrollees_allcourses AS
SELECT 
AA.id, 
AA.firstname, 
AA.lastname,
from_unixtime(AA.timemodified),
BB.enrolid,
CC.courseid,
DD.shortname
FROM moodle.mdl_user as AA
left join mdl_user_enrolments as BB
on AA.id=BB.userid
join mdl_enrol as CC
on BB.enrolid=CC.id
join mdl_course as DD
on CC.courseid=DD.id
where suspended=1
order by lastname;
/*****************************
Author: plariv@augurynet.commit
Updated: 20200201
Description:
  Creates list for export as basis for flatfile unenrollment for all current
  enrollees in 2019 courses that is
  based on certificate completion recorded in 2019. 
  Included literal values in order to create a completed flatfile format.
  Result set can be exported, then uploaded, as flatfile target for Moodle cron enrollment.
Dependencies:
  views - moodle.certcomplete_still_enrolled_2019
******************************/
CREATE OR REPLACE VIEW list_unenroll_flatfile_2019 AS
SELECT 
"del",
"student",
YY.userid,
YY.idnumber
FROM
  (SELECT * FROM moodle.certcomplete_still_enrolled_2019) as YY;
/*****************************
Author: plariv@augurynet.commit
Updated: 20200201
Description:
  View of new employees record with hired date starting from 01/28/2019
  and joined with mdl_user_info_field for hire date,
  start date, location assignment and employee number
Dependencies:
  views - moodle.course_cat_sname_num_only
******************************/
CREATE OR REPLACE VIEW new_users_since_20190128 AS
SELECT mdl_user.id,
auth,
confirmed,
deleted,
suspended,
username,
password,
firstname,
lastname,
email,
Location,
Empnum,
Hiredate,
Startdate
FROM mdl_user
JOIN (SELECT W1.id AS wid, 
D2.data AS Location
FROM mdl_user AS W1, 
mdl_user_info_field AS D1, 
mdl_user_info_data AS D2
WHERE W1.id = D2.userid
AND D2.fieldid =  "7"
AND D1.id = D2.fieldid) AS locdata ON mdl_user.id=locdata.wid
JOIN (SELECT X1.id AS xid, 
E2.data AS Empnum
FROM mdl_user AS X1, 
mdl_user_info_field AS E1, 
mdl_user_info_data AS E2
WHERE X1.id = E2.userid
AND E2.fieldid =  "6"
AND E1.id = E2.fieldid) AS empnumdata ON mdl_user.id=empnumdata.xid
JOIN (SELECT Y1.id AS yid, 
F2.data AS Hiredate
FROM mdl_user AS Y1, 
mdl_user_info_field AS F1, 
mdl_user_info_data AS F2
WHERE Y1.id = F2.userid
AND F2.fieldid =  "1"
AND F1.id = F2.fieldid) AS hiredate ON mdl_user.id=hiredate.yid
JOIN (SELECT Z1.id AS zid, 
G2.data AS Startdate
FROM mdl_user AS Z1, 
mdl_user_info_field AS G1, 
mdl_user_info_data AS G2
WHERE Z1.id = G2.userid
AND G2.fieldid =  "1"
AND G1.id = G2.fieldid) AS startdate ON mdl_user.id=startdate.zid
WHERE timecreated>1548687521;
/*****************************
Author: plariv@augurynet.commit
Updated: 20200201
Description:
  View of mdl_enrol tbl crossed with mdl_course tbl to get 
  a reference table of course idnumbers to use in flatfile enrollment
Dependencies:
  views - moodle.course_cat_sname_num_only
******************************/
create or replace view ref_enrolxcourse_idnum as
select F.id,
F.enrol,
F.courseid,
shortname,
idnumber 
from mdl_enrol as F
join mdl_course
on F.courseid=mdl_course.id
where F.enrol="manual";
/*****************************
Author: plariv@augurynet.commit
Updated: 20200217
Description:
  Create mysql event to create idnumber field in tbl user
  wherever the idnumber is unset (=0)
  by copying the value from the record's id
Dependencies:
  views - moodle.course_cat_sname_num_only
******************************/
create event ins_user_idnumber
  on schedule every 2 minute
  do
    update moodle.mdl_user
    set mdl_user.idnumber=mdl_user.id
    where mdl_user.idnumber=0
;
