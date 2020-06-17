/*****************************
Author: plariv@augurynet.commit
Updated: 20200428
Description:
  Create a list of currently enrolled employees with start and stop
  timestamps of the current enrollment, along with course id, shortname and 
  assigned course idnumber
Dependencies:
  views - moodle.employeename_x_empnum, moodle.enrolxcourse_idnum
******************************/
CREATE OR REPLACE VIEW export_userenrol_startstop AS
SELECT 
ZZ.employee_number,
ZZ.lastname,
ZZ.firstname,
ZZ.enrol_open,
ZZ.enrol_close,
ZZ.enrolled_on,
CC.courseid,
CC.shortname,
CC.idnumber
FROM 
  (SELECT AA.id,
   AA.enrolid,
   AA.userid,
   BB.employee_number,
   BB.lastname,
   BB.firstname,
   from_unixtime(timestart) as enrol_open,
   from_unixtime(timeend) as enrol_close,
   from_unixtime(timecreated) as enrolled_on
   FROM moodle.mdl_user_enrolments as AA
   JOIN ref_employeename_x_empnum as BB
   ON AA.userid=BB.userid
   WHERE timeend>0
   AND AA.status=0) as ZZ
JOIN ref_enrolxcourse_idnum as CC
ON ZZ.enrolid=CC.id;