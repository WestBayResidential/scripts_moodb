/*****************************
Author: plariv@augurynet.commit
Updated: 20200428
Description:
  View of mdl_enrol tbl crossed with mdl_course tbl to get 
  a reference table of course idnumbers to use in flatfile enrollment
  for enrol methods manual or flatfile
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
where F.enrol="manual"
or F.enrol="flatfile"