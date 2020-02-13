create event ins_user_idnumber
  on schedule every 2 minute
  do
    update moodle.mdl_user
    set mdl_user.idnumber=mdl_user.id
    where mdl_user.idnumber=0