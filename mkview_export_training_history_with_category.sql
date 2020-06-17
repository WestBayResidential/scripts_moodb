/*****************************
Author: plariv@augurynet.commit
Updated: 20200501
Description:
  Join between export_training_details view and export_course_details
  view to provide the course category detail and indicates the enrollment
  period for an employee to have completed the course. Note that archived
  courses are excluded.
Dependencies:
  joins - export_training_details, export_course_details
******************************/
CREATE OR REPLACE VIEW export_training_history_with_category AS
SELECT 
MM.employee_last,
MM.employee_first,
MM.employeenumber,
MM.training_code,
MM.date_taken,
NN.cat_name,
NN.complete_within
FROM export_training_history as MM
JOIN export_course_details as NN
ON MM.training_code=NN.short_code
WHERE category<>12