<?php
$db_host = 'localhost';
$db_user = 'nontriv1_dave';
$db_pwd = 'n0ntr1v22';

$database = 'nontriv1_luars';
$table = 'whaleCalls2';

$pic = '"test_resize.jpg"';

$con = mysql_connect($db_host, $db_user, $db_pwd);
if (!$con)
    die("Can't connect to database");

if (!mysql_select_db($database))
    die("Can't select database");
?>