SELECT * 
FROM moodle.candid_unenroll_wnextcrs AS X
LEFT JOIN (select A.userid,A.enrolid,A.timecreated,A.status as estatus,B.courseid
from mdl_user_enrolments as A
join mdl_enrol as B
on A.enrolid=B.id) as Y
ON X.userid=Y.userid
AND X.course=Y.courseid
where nxt_course_id>0
and estatus=0
and courseid is not null;