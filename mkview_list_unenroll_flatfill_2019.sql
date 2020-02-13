/*****************************
Author: plariv@augurynet.commit
Updated: 20200201
Description:
  Creates list for export as basis for flatfile unenrollment for all current
  enrollees in 2019 courses that is
  based on certificate completion recorded in 2019. 
  Included literal values in order to create a completed flatfile format.
  Result set can be exported, then uploaded, as flatfile target for Moodle cron enrollment.
Dependencies:
  views - moodle.certcomplete_still_enrolled_2019
******************************/
CREATE OR REPLACE VIEW list_unenroll_flatfile_2019 AS
SELECT 
"del",
"student",
YY.userid,
YY.idnumber
FROM
  (SELECT * FROM moodle.certcomplete_still_enrolled_2019) as YY;