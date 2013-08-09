<html><head><title>MySQL Table Viewer</title>
<style>img:hover {
width:400px; /*overflow:visible; z-index:3;*/ }
</style>
</head><body>
<?php
//$db_host = 'localhost';
//$db_user = 'root';
//$db_pwd = 'oawrs';

//$database = 'GOM2006';
//$table = 'whaleCalls2';

//$pic = '"test_resize.jpg"';

//if (!mysql_connect($db_host, $db_user, $db_pwd))
//    die("Can't connect to database");

//if (!mysql_select_db($database))
//    die("Can't select database");

// sending query
//$result = mysql_query("SELECT * FROM {$table}");
//if (!$result) {
//    die("Query to show fields from table failed");
//}

include('connect.php'); // database connection settings


echo "<h1>Table: {$table}</h1>";

//------------------------------------------------------------------------
echo "<h3>Enter a mysql query into the text box.</h3>";
echo "<form method='post' action='$SERVER[PHP_SELF]' />";
echo "Type Here: <input type='text' name='userQuery' value='' size='70'><br />";
echo "<input type='submit' value='Submit' />"; 
echo "</form>"; 

//--- MAKE SPECIFIC QUERIES ----------------------

$trackID = $_POST['trackID'];
$dStart = $_POST['dStart'];
$dStop = $_POST['dStop'];
$ptStart = $_POST['ptStart'];
$ptStop = $_POST['ptStop'];
$tStart = $_POST['tStart'];
$tStop = $_POST['tStop'];
$fStart = $_POST['fStart'];
$fStop = $_POST['fStop'];


echo "Enter TrackID";
echo "<form method='post' action='$SERVER[PHP_SELF]' />";
echo "TrackID: <input type='text' name='trackID' value='$trackID' size='10'><br />"; 
echo "Day: <input type='text' name='dStart' value='$dStart' size='10'> <input type='text' name='dStop' value='$dStop' size='10'><br />"; 
echo "Ping Time: <input type='text' name='ptStart' value='$ptStart' size='10'> <input type='text' name='ptStop' value='$ptStop' size='10'><br />"; 
echo "Time: <input type='text' name='tStart' value='$tStart' size='10'> <input type='text' name='tStop' value='$tStop' size='10'><br />"; 
echo "Freq: <input type='text' name='fStart' value='$fStart' size='10'> <input type='text' name='fStop' value='$fStop' size='10'><br />"; 
echo "<br />";
echo "<input type='submit' value='Submit' />"; 
echo "</form>"; 
//----------------------------------
$queryString = $_POST['userQuery'];

if (empty($trackID)) {
	$trackQuery = NULL;
} else {
	$trackQuery = "AND trackID = '$trackID'";
}

$sqlQuery = "SELECT * FROM $table WHERE datetime >= '$dStart' AND datetime <= '$dStop' $trackQuery;";

echo $sqlQuery;

if (empty($queryString)) {
	echo "Enter a query";
	echo "<br />";
} else if (!empty($queryString)) {
	#include "../lo2_db_connection.inc";
	$query = $queryString;
	if (mysql_query($query)) {
		echo "Success";
	} else {
		echo "Error: ".mysql_error();
	}
}


$result = mysql_query($query); 
//echo "here";
$fields_num = mysql_num_fields($result);
//-------------------------------------------------------------------------------
echo "<table border='1'><tr>";
// printing table headers
for($i=0; $i<$fields_num; $i++)
{
	//echo "here";
    $field = mysql_fetch_field($result);
    echo "<th>{$field->name}</th>";
}
echo "</tr>\n";
// printing table rows
while($row = mysql_fetch_row($result))
{
    echo "<tr>";

    // $row is array... foreach( .. ) puts every element
    // of $row to $cell variable
    foreach($row as $cell)
        echo "<td>$cell</td>";

    $jpgFname = (string)$row[0];   
    $jpgFname2 = substr($jpgFname,0,10);
    $whaleNum = substr($jpgFname,11);
    $formatted = sprintf("%02d", $whaleNum); // << this does the trick!
    $jpgFname = "images/whaleCalls/{$jpgFname2}-{$formatted}.jpg";	

    $jpgImage = "\" {$jpgFname} \"";
	
    if (file_exists($jpgFname)) {
    	echo "<td><img src={$jpgImage} width=\"100\" /></td>"; 
    } else {
	echo "<td>No Image</td>";
    }
    //echo "<td>$jpgImage</td>";
    //echo "<td>$pic</td>"; 
    echo "</tr>\n";
}
mysql_free_result($result);
?>
</body></html>
