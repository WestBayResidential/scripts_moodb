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
