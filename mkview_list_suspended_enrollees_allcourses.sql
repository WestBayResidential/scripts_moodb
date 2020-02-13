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