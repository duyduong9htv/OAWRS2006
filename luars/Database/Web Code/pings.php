<?php
    
    /*
    Search form for dynamically building a search query which uses the full text search facility in
    MySQL. The form is built as an array where you can choose to use AND or OR in the search.
    If you don't enter any search words, you'll get the full table, which might not be a good idea
    for a big table...
    Arrays are also used to store the result (if any), which are then displayed with a small 
    function. There's also a function for determing if we should
    use WHERE, AND or HAVING before the dynamically built where clause.
    The database is included at the bottom of this script...
    
    Use it or loose it... ;)
    //NoXcuz
    */

?>

<html>
  <head>
    <title>Search for Pings</title>
  </head>
  <body>

<?php
    include('connect.php'); // database connection settings
    if(!isset($_POST['submit']) && empty($_POST['submit'])) {
      // form hasn't been submitted

    
    //$numrows=mysql_num_rows($tracksresult);

    
      
?>     
    <h1 align="center">Search results</h1>
    
<?php
        
        $find=$_POST['find']; // just being lazy...
        $w=0; // used for building the WHERE part of the query
        $h=0; // used for building the HAVING part of the query - though not in this example...
        $searcharray=array(); // used for storing the results
        
        
        $query='SELECT * FROM pings ORDER BY start_time;';
         
        echo $query; //debugging

        echo '<p align="center"><a href="' .$_SERVER['PHP_SELF'] .'">New search</a></p>';
        $result=mysql_query($query) or die('Error in query: ' .mysql_error());
        $numrows=mysql_num_rows($result);
        
        if ($numrows!=0) {
        
            $searcharray['status']='Your search returned ' .$numrows .' results...';
            
            while($row=mysql_fetch_assoc($result)) {
		
		$searcharray[$row['ping_id']]=array();  //Create a new array
		$searcharray[$row['ping_id']]['pingID']=$row['ping_id'];
		$searcharray[$row['ping_id']]['startTime']=$row['start_time'];
                $searcharray[$row['ping_id']]['heading']=sprintf("%6.3f", $row['heading']);
                $searcharray[$row['ping_id']]['rcvLat']=sprintf("%6.3f", $row['rcvLat']);
                $searcharray[$row['ping_id']]['rcvLon']=sprintf("%6.3f", $row['rcvLon']);
                $searcharray[$row['ping_id']]['srcLat']=sprintf("%6.3f", $row['srcLat']);
                $searcharray[$row['ping_id']]['srcLon']=sprintf("%6.3f", $row['srcLon']);        

		if ($row['rcvLat'] == 0){
			$searcharray[$row['ping_id']]['rcvLat']="--";
		} else {
			$searcharray[$row['ping_id']]['rcvLat']=sprintf("%6.3f", $row['rcvLat']);
		}   

		if ($row['heading'] == 0){
			$searcharray[$row['ping_id']]['heading']="--";
		} else {
			$searcharray[$row['ping_id']]['heading']=sprintf("%6.3f", $row['heading']);
		}   

		if ($row['rcvLon'] == 0){
			$searcharray[$row['ping_id']]['rcvLon']="--";
		} else {
			$searcharray[$row['ping_id']]['rcvLon']=sprintf("%6.3f", $row['rcvLon']);
		}   

		if ($row['srcLat'] == 0){
			$searcharray[$row['ping_id']]['srcLat']="--";
		} else {
			$searcharray[$row['ping_id']]['srcLat']=sprintf("%6.3f", $row['srcLat']);
		}     
		if ($row['srcLon'] == 0){
			$searcharray[$row['ping_id']]['srcLon']="--";
		} else {
			$searcharray[$row['ping_id']]['srcLon']=sprintf("%6.3f", $row['srcLon']);
		}       
            }
            mysql_free_result($result);
        
        } else {
            
            $searcharray['status']='Your search did not return any results...';
            
        }
            
        echo '<p>' .$searcharray['status'] .'</p>';
        
        array_shift($searcharray);
        if(!empty($searcharray)) {
        
            echo '<table align="center" border="1" cellspacing="0" cellpadding="4">';
              echo '<tr>';
		echo '<th>';
                  echo 'Ping ID';
                echo '</th>';
		echo '<th>';
                  echo 'Start Time';
                echo '</th>';
                echo '<th>';
                  echo 'Heading';
                echo '</th>';
                echo '<th>';
                  echo 'Receiver Latitude';
                echo '</th>';
                echo '<th>';
                  echo 'Receiver Longitude';
                echo '</th>';
                echo '<th>';
                  echo 'Source Latitude';
                echo '</th>';
                echo '<th>';
                  echo 'Source Longitude';
                echo '</th>';                
              echo '</tr>';
              echo '<tr>';
            
                showarray($searcharray);
                
              echo '</tr>';
            echo '</table>';
            
            echo '<p align="center"><a href="' .$_SERVER['PHP_SELF'] .'">New search</a></p>';
        
        }
        
    }
    
    function check_prefix($counter, $type) {
      // This function will return the correct 'prefix' for the WHERE or the HAVING part of the query
      // It either returns WHERE/HAVING or AND/OR depending on the count for the passed type and
      // the passed query type.
      // Might be overkill for this example, but it's otherways handy ;)
    
        if ($counter==0) {

            $prefix=' WHERE ';

        } else {
            $prefix=' AND ';

        }

        return $prefix;
    }
    
    function showarray($array) {
      //This recursive function will simply display what's in the array
      
        foreach ($array as $key => $value) {
            
            if (is_array($value)) {

                echo '</tr><tr>';
                showarray($value);

            } else {

                echo '<td valign="top">' .$value .'</td>';

            }
        }
    }

?>

  </body>
</html>
