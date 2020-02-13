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
from mdl_course