/*****************************
Author: plariv@augurynet.commit
Updated: 20200201
Description:
  View of new employees record with hired date starting from 01/28/2019
  and joined with mdl_user_info_field for hire date,
  start date, location assignment and employee number
Dependencies:
  views - moodle.course_cat_sname_num_only
******************************/
CREATE OR REPLACE VIEW new_users_since_20190128 AS
SELECT mdl_user.id,
auth,
confirmed,
deleted,
suspended,
username,
password,
firstname,
lastname,
email,
Location,
Empnum,
Hiredate,
Startdate
FROM mdl_user
JOIN (SELECT W1.id AS wid, 
D2.data AS Location
FROM mdl_user AS W1, 
mdl_user_info_field AS D1, 
mdl_user_info_data AS D2
WHERE W1.id = D2.userid
AND D2.fieldid =  "7"
AND D1.id = D2.fieldid) AS locdata ON mdl_user.id=locdata.wid
JOIN (SELECT X1.id AS xid, 
E2.data AS Empnum
FROM mdl_user AS X1, 
mdl_user_info_field AS E1, 
mdl_user_info_data AS E2
WHERE X1.id = E2.userid
AND E2.fieldid =  "6"
AND E1.id = E2.fieldid) AS empnumdata ON mdl_user.id=empnumdata.xid
JOIN (SELECT Y1.id AS yid, 
F2.data AS Hiredate
FROM mdl_user AS Y1, 
mdl_user_info_field AS F1, 
mdl_user_info_data AS F2
WHERE Y1.id = F2.userid
AND F2.fieldid =  "1"
AND F1.id = F2.fieldid) AS hiredate ON mdl_user.id=hiredate.yid
JOIN (SELECT Z1.id AS zid, 
G2.data AS Startdate
FROM mdl_user AS Z1, 
mdl_user_info_field AS G1, 
mdl_user_info_data AS G2
WHERE Z1.id = G2.userid
AND G2.fieldid =  "1"
AND G1.id = G2.fieldid) AS startdate ON mdl_user.id=startdate.zid
WHERE timecreated>1548687521