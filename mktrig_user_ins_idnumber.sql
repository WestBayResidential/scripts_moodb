CREATE DEFINER=`root`@`localhost` TRIGGER `moodle`.`ins_idnumber` AFTER INSERT ON `mdl_user` FOR EACH ROW
BEGIN
  UPDATE mdl_user
  SET idnumber=id
  WHERE idnumber=0;
END