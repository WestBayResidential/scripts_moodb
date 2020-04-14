/*****************************
Author: plariv@augurynet.commit
Updated: 20200414
Description:
  View that lists all current enrollments
Dependencies:
  joins - mdl_user_enrolments, mdl_enrol, mdl_course
  views - ref_employeename_x_empnum
******************************/
CREATE OR REPLACE VIEW export_current_enrollment AS
SELECT 
AA.enrolid,
AA.userid,
DD.lastname,
DD.employee_number,
CC.courseid,
EE.shortname,
EE.idnumber
FROM moodle.mdl_user_enrolments as AA
JOIN ref_employeename_x_empnum as DD
ON AA.userid=DD.userid
JOIN mdl_enrol as CC
ON AA.enrolid=CC.id
JOIN mdl_course as EE
ON CC.courseid=EE.id;