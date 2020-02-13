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
WHERE mdl_certificate_issues.timecreated>=1546304100