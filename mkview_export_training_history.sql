/*****************************
Author: plariv@augurynet.commit
Updated: 20200413
Description:
  Listing of training histories by individual, based on certificates
  issued, and ordered by employee last name. The administratively assigned
  "employeenumber" (which is not the same as the record idnumber in the 
  mdl_user table) is included by a JOIN with the mdl_user_info_data_old table.
Dependencies:
  joins - mdl_user, mdl_certificate, mdl_course
  sub-select AA - for retrieving the "employeenumber" text string
******************************/
CREATE OR REPLACE VIEW export_training_history AS
SELECT 
mdl_user.lastname as employee_last, 
mdl_user.firstname as employee_first,
AA.data as employeenumber,
BB.shortname as training_code,
mdl_certificate_issues.timecreated as datetaken_epoch,
from_unixtime(mdl_certificate_issues.timecreated) as date_taken
FROM moodle.mdl_certificate_issues
JOIN mdl_user
ON mdl_certificate_issues.userid=mdl_user.id
JOIN 
   (SELECT 
    mdl_user_info_data_old.userid,
    mdl_user_info_data_old.data
    FROM moodle.mdl_user_info_data_old
    WHERE fieldid=6) as AA
ON mdl_user.id=AA.userid
JOIN mdl_certificate
ON mdl_certificate_issues.certificateid=mdl_certificate.id
JOIN mdl_course as BB
ON mdl_certificate.course=BB.id
ORDER BY employee_last;