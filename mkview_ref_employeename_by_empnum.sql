/*****************************
Author: plariv@augurynet.commit
Updated: 20200414
Description:
  View listing all employees names by assigned employee number
Dependencies:
  tables - mdl_user_info_data_old, mdl_user
******************************/
create or replace view ref_employeename_x_empnum as
SELECT 
AA.lastname,
AA.firstname,
CC.data as employee_number,
AA.id as userid
FROM mdl_user as AA
JOIN mdl_user_info_data_old as CC
ON AA.id=CC.userid
WHERE CC.fieldid=6
ORDER BY AA.lastname;