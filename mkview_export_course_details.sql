/*****************************
Author: plariv@augurynet.commit
Updated: 20200411
Description:
  Create a view listing all courses details required for export to
  third party training data management systems. List is ordered by 
  "time_from_hire" which is Moodle "course category" and corresponds 
  with "to_be_taken_by_x_days_from_hire"
Dependencies:
  tables - mdl_course, mdl_course_cat
******************************/
create or replace view export_course_details as
SELECT mdl_course.category, 
mdl_course_categories.name as time_from_hire, 
mdl_course.fullname as training_class, 
mdl_course.shortname as short_code, 
mdl_course.idnumber as training_code, 
mdl_course.summary as description, 
mdl_course.startdate as start_epoch, 
from_unixtime(mdl_course.startdate) as start_time,
mdl_course.timecreated as created_epoch,
from_unixtime(mdl_course.timecreated) as publication_date
FROM moodle.mdl_course
JOIN mdl_course_categories
ON mdl_course.category=mdl_course_categories.id
ORDER BY time_from_hire;