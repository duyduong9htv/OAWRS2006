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
    <title>Search for lyrics</title>
  </head>
  <body>

<?php
    
    if(!isset($_POST['submit']) && empty($_POST['submit'])) {
      // form hasn't been submitted
      
?>        

    <h1 align="center">Search the database</h1>
    <p>Enter your search criterias in the form below and hit the search button.<br>
       If you enter multiple words in the Artist/Album/Track fields, you can choose to search using 
       either AND or OR for <b>that</b> field.</p>
    <p>There's also a choice to be made whether to use AND or OR for the combination of information 
       entered in the form fields.</p>
    <p>Right now, there are only three albums in the database, so there's not much to search really...<br>
       The albums you can search are My own prison, Human Clay and Weathered, all by Creed.</p>
    <form method="POST">
    <table align="center">
      <tr>
        <td>
          <b>Artist</b>
        </td>
        <td>
          <input type="text" name="find[artist][value]" size="40"> 
          <input type="radio" value="AND" checked name="find[artist][picker]"> and 
          <input type="radio" value="OR" name="find[artist][picker]"> or 
        </td>
      </tr>
      
      <tr>
        <td>
          <b>Album</b>
        </td>
        <td>
          <input type="text" name="find[album][value]" size="40">
          <input type="radio" value="AND" checked name="find[album][picker]"> and 
          <input type="radio" value="OR" name="find[album][picker]"> or 
        </td>
      </tr>
      
      <tr>
        <td>
          <b>Track</b>
        </td>
        <td>
          <input type="text" name="find[track][value]" size="40">
          <input type="radio" value="AND" checked name="find[track][picker]"> and 
          <input type="radio" value="OR" name="find[track][picker]"> or 
        </td>
      </tr>
      
      <tr>
        <td>
          <b>Lyrics</b>
        </td>
        <td>
          <textarea name=find[lyrics] cols="30" rows="5"></textarea>
        </td>
      </tr>
      
      <tr>
        <td colspan="2" align="center">
          <b>Use </b>
          <input type="radio" value="AND" checked name="find[picker]"> and 
          <input type="radio" value="OR" name="find[picker]"> or 
          <b>with the above criterias </b>
        </td>
      </tr>

      <tr>
        <td colspan="2" align="center">
          <input type="submit" name="submit" value="search">
        </td>
      </tr>
    </table>
    </form>

<?php
        
    } else {
      // form has been submitted

?>

    <h1 align="center">Search results</h1>
    
<?php
        
        $find=$_POST['find']; // just being lazy...
        $w=0; // used for building the WHERE part of the query
        $h=0; // used for building the HAVING part of the query - though not in this example...
        $searcharray=array(); // used for storing the results
        include('../connect.php'); // database connection settings
        
        $query='SELECT tracks.tra_id, artists.art_name, albums.alb_title, tracks.tra_title, tracks.tra_lyrics '
              .'FROM artists INNER JOIN art_alb USING (art_id) INNER JOIN albums USING (alb_id) INNER JOIN alb_tra USING (alb_id) INNER JOIN tracks USING (tra_id) ';
          // the above part is always the same
            
          // now let's start building the dynamic parts of the query
        if (!empty($find['artist']['value'])) {
            $s_artist=explode(' ', $find['artist']['value']);
            $num_artist=count($s_artist);
            $query.=check_prefix($w, 'w', $find[picker]);
            $query.='( artists.art_name LIKE \'%' .$s_artist[0] .'%\' ';
            for ($i = 1; $i < $num_artist; $i++) {
                $query.=$find['artist']['picker'] .' artists.art_name LIKE \'%' .$s_artist[$i] .'%\' ';
            }
            $query.=') ';
            $w++;
        }
            
        if (!empty($find['album']['value'])) {
            $s_album=explode(' ', $find['album']['value']);
            $num_album=count($s_album);
            $query.=check_prefix($w, 'w', $find[picker]);
            $query.='( albums.alb_title LIKE \'%' .$s_album[0] .'%\' ';
            for ($i = 1; $i < $num_album; $i++) {
                $query.=$find['album']['picker'] .' albums.alb_title LIKE \'%' .$s_album[$i] .'%\' ';
            }
            $query.=') ';
            $w++;
        }
            
        if (!empty($find['track']['value'])) {
            $s_track=explode(' ', $find['track']['value']);
            $num_track=count($s_track);
            $query.=check_prefix($w, 'w', $find[picker]);
            $query.='( tracks.tra_title LIKE \'%' .$s_track[0] .'%\' ';
            for ($i = 1; $i < $num_track; $i++) {
                $query.=$find['track']['picker'] .' tracks.tra_title LIKE \'%' .$s_track[$i] .'%\' ';
            }
            $query.=') ';
            $w++;
        }
            
        if (!empty($find['lyrics'])) {
            $query.=check_prefix($w, 'w', $find[picker]);
            $query.='MATCH(tracks.tra_lyrics) AGAINST (\'' .$find['lyrics'] .'\') ';
            $w++;
        }
            
        $query.='ORDER BY artists.art_name ASC, albums.alb_title ASC, tracks.tra_title ASC';
            
//      echo $query; //debugging
        $result=@mysql_query($query, $con) or die('Error in query: ' .mysql_error());
        $numrows=@mysql_num_rows($result);
        
        if ($numrows!=0) {
        
            $searcharray['status']='Your search returned ' .$numrows .' results...';
            
            while($row=mysql_fetch_assoc($result)) {
                $searcharray[$row['tra_id']]=array();
                $searcharray[$row['tra_id']]['artist']=$row['art_name'];
                $searcharray[$row['tra_id']]['album']=$row['alb_title'];
                $searcharray[$row['tra_id']]['track']=$row['tra_title'];
                $searcharray[$row['tra_id']]['lyrics']=nl2br($row['tra_lyrics']);
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
                  echo 'Artist';
                echo '</th>';
                echo '<th>';
                  echo 'Album';
                echo '</th>';
                echo '<th>';
                  echo 'Track';
                echo '</th>';
                echo '<th>';
                  echo 'Lyrics';
                echo '</th>';
              echo '</tr>';
              echo '<tr>';
            
                showarray($searcharray);
                
              echo '</tr>';
            echo '</table>';
            
            echo '<p align="center"><a href="' .$_SERVER['PHP_SELF'] .'">New search</a></p>';
        
        }
        
    }
    
    function check_prefix($counter, $type, $q_type) {
      // This function will return the correct 'prefix' for the WHERE or the HAVING part of the query
      // It either returns WHERE/HAVING or AND/OR depending on the count for the passed type and
      // the passed query type.
      // Might be overkill for this example, but it's otherways handy ;)
    
        if ($counter==0 && $type=='w') {

            $prefix='WHERE ';

        } elseif ($counter==0 && $type=='h') {

            $prefix='HAVING ';

        } elseif ($q_type=='OR') {
            
            $prefix='OR ';

        } elseif ($q_type=='AND') {
            
            $prefix='AND ';

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

/*
  And here's the database...

#
# Table structure for table `alb_tra`
#
CREATE TABLE alb_tra (
  alb_id int(11) NOT NULL default '0',
  tra_id int(11) NOT NULL default '0',
  UNIQUE KEY alb_tra (alb_id,tra_id)
) TYPE=MyISAM;

#
# Dumping data for table `alb_tra`
#
INSERT INTO alb_tra VALUES (1, 1);
INSERT INTO alb_tra VALUES (1, 2);
INSERT INTO alb_tra VALUES (1, 3);
INSERT INTO alb_tra VALUES (1, 4);
INSERT INTO alb_tra VALUES (1, 5);
INSERT INTO alb_tra VALUES (1, 6);
INSERT INTO alb_tra VALUES (1, 7);
INSERT INTO alb_tra VALUES (1, 8);
INSERT INTO alb_tra VALUES (1, 9);
INSERT INTO alb_tra VALUES (1, 10);
INSERT INTO alb_tra VALUES (1, 11);
INSERT INTO alb_tra VALUES (1, 12);
INSERT INTO alb_tra VALUES (1, 13);
INSERT INTO alb_tra VALUES (2, 14);
INSERT INTO alb_tra VALUES (2, 15);
INSERT INTO alb_tra VALUES (2, 16);
INSERT INTO alb_tra VALUES (2, 17);
INSERT INTO alb_tra VALUES (2, 18);
INSERT INTO alb_tra VALUES (2, 19);
INSERT INTO alb_tra VALUES (2, 20);
INSERT INTO alb_tra VALUES (2, 21);
INSERT INTO alb_tra VALUES (2, 22);
INSERT INTO alb_tra VALUES (2, 23);
INSERT INTO alb_tra VALUES (2, 24);
INSERT INTO alb_tra VALUES (3, 25);
INSERT INTO alb_tra VALUES (3, 26);
INSERT INTO alb_tra VALUES (3, 27);
INSERT INTO alb_tra VALUES (3, 28);
INSERT INTO alb_tra VALUES (3, 29);
INSERT INTO alb_tra VALUES (3, 30);
INSERT INTO alb_tra VALUES (3, 31);
INSERT INTO alb_tra VALUES (3, 32);
INSERT INTO alb_tra VALUES (3, 33);
INSERT INTO alb_tra VALUES (3, 34);
INSERT INTO alb_tra VALUES (3, 35);

#
# Table structure for table `albums`
#
CREATE TABLE albums (
  alb_id int(11) NOT NULL auto_increment,
  alb_title varchar(100) NOT NULL default '',
  PRIMARY KEY  (alb_id)
) TYPE=MyISAM;

#
# Dumping data for table `albums`
#
INSERT INTO albums VALUES (1, 'Human Clay');
INSERT INTO albums VALUES (2, 'Weathered');
INSERT INTO albums VALUES (3, 'My Own Prison');

#
# Table structure for table `art_alb`
#
CREATE TABLE art_alb (
  art_id int(11) NOT NULL default '0',
  alb_id int(11) NOT NULL default '0',
  UNIQUE KEY art_alb (art_id,alb_id)
) TYPE=MyISAM;

#
# Dumping data for table `art_alb`
#
INSERT INTO art_alb VALUES (1, 1);
INSERT INTO art_alb VALUES (1, 2);
INSERT INTO art_alb VALUES (1, 3);

#
# Table structure for table `artists`
#
CREATE TABLE artists (
  art_id int(11) NOT NULL auto_increment,
  art_name varchar(100) NOT NULL default '',
  PRIMARY KEY  (art_id)
) TYPE=MyISAM;

#
# Dumping data for table `artists`
#
INSERT INTO artists VALUES (1, 'Creed');

#
# Table structure for table 'tracks'
#
CREATE TABLE `tracks` (
  `tra_id` int(11) NOT NULL auto_increment,
  `tra_title` varchar(100) NOT NULL default '',
  `tra_lyrics` text,
  PRIMARY KEY  (`tra_id`),
  FULLTEXT KEY `tra_lyrics` (`tra_lyrics`)
) TYPE=MyISAM;

#
# Dumping data for table 'tracks'
#

INSERT INTO `tracks` (`tra_id`, `tra_title`, `tra_lyrics`) VALUES (1,'Are you ready?','Hey, Mr. Seeker Hold on to this advice\r\nIf you keep seeking you will find\r\nDon\'t want to follow\r\nDown roads been walked before\r\nIt\'s so hard to find unopened doors\r\nAre you ready? Are you ready?\r\nHey, Mr. Hero Walking a thin, fine line\r\nUnder the microscope of life\r\nRemember your roots, my friend\r\nThey\'re right down below\r\n\'Cause heroes come and heroes go\r\nTen, nine, eight, seven, six, five, four, three, two, one\r\nCount down to the change in life that\'s soon to come\r\nYour life has just begun');
INSERT INTO `tracks` (`tra_id`, `tra_title`, `tra_lyrics`) VALUES (2,'What if','I can\'t find the rhyme in all my reason\r\nI\'ve lost sense of time and all seasons\r\nI feel I\'ve been beaten down\r\nBy the words of men who have no grounds\r\nI can\'t sleep beneath the trees of wisdom\r\nWhen your ax has cut the roots that feed them\r\nForked tongues in bitter mouths\r\nCan drive a man to bleed from inside out\r\nWhat if you did?\r\nWhat if you lied?\r\nWhat if I avenge?\r\nWhat if eye for an eye?\r\nI\'ve seen the wicked fruit of your vine\r\nDestroy the man who lacks a strong mind\r\nHuman pride sings a vengeful song\r\nInspired by the times you\'ve been walked on\r\nMy stage is shared by many millions\r\nWho lift their hands up high because they feel this\r\nWe are one We are strong\r\nThe more you hold us down the more we press on\r\nWhat if you did?\r\nWhat if you lied?\r\nWhat if I avenge?\r\nWhat if eye for an eye?\r\nI know I can\'t hold the hate inside my mind\r\n\'Cause what consumes your thoughts controls your life\r\nSo I\'ll just ask a question\r\nWhat if?\r\nWhat if your words could be judged like a crime?');
INSERT INTO `tracks` (`tra_id`, `tra_title`, `tra_lyrics`) VALUES (3,'Beautiful','She wears a coat of color\r\nLoved by some, feared by others\r\nShe\'s immortalized in young men\'s eyes\r\nLust she breeds in the eyes of brothers\r\nViolent sons make bitter mothers\r\nSo close your eyes, here\'s your surprise\r\nBeautiful is empty\r\nBeautiful is free\r\nBeautiful loves no one\r\nBeautiful stripped me\r\nIn your mind she\'s your companion\r\nVile instincts often candid\r\nYour regret is all that\'s left\r\nShe told me where I\'m going\r\nAnd it\'s far away from home\r\nI think I\'ll go there on my own');
INSERT INTO `tracks` (`tra_id`, `tra_title`, `tra_lyrics`) VALUES (4,'Say I','The dust has finally settled on the field of human clay\r\nJust enough light has shown through\r\nTo tell the night from the day\r\nWe are incomplete and hollow\r\nFor our maker has gone away\r\nWho is to blame?\r\nWe\'ll surely melt in the rain\r\nSay I\r\nThe stillness is so lifeless with no spirit in your soul\r\nLike children with no vision do exactly what they\'re told\r\nBeing led into the desert\r\nFor your strength will surely fade\r\nWho is to blame?\r\nWe\'ll surely melt in the rain\r\nSay I\r\nFrantic, faction, focus\r\nThe world breathes\r\nAnd out forms this misconception we call man\r\nBut I don\'t know him\r\nNo, I don\'t know him\r\nBecause he lies \r\nSay I');
INSERT INTO `tracks` (`tra_id`, `tra_title`, `tra_lyrics`) VALUES (5,'Wrong way','What makes you touch?\r\nWhat makes you feel?\r\nWhat makes you stop and smell the roses in an open field?\r\nWhat makes you unclean?\r\nYeah, Yeah\r\nWhat makes you laugh?\r\nWhat makes you cry?\r\nWhat makes our youth run\r\nFrom the thought that we might die?\r\nWhat makes you bleed?\r\nSomebody told me the wrong way\r\nWhat if I died?\r\nWhat did I give?\r\nI hope it was an answer so you might live\r\nI hope I helped you live\r\nI hope I helped you live\r\nSomebody told me the wrong way');
INSERT INTO `tracks` (`tra_id`, `tra_title`, `tra_lyrics`) VALUES (6,'Faceless man','I spent a day by the river\r\nIt was quiet and the wind stood still\r\nI spent some time with nature\r\nTo remind me of all that\'s real\r\nIt\'s funny how silence speaks sometimes when you\'re alone\r\nAnd remember that you feel\r\nAgain I stand against the Faceless Man\r\nNow I saw a face on the water\r\nIt looked humble but willing to fight\r\nI saw the will of a warrior\r\nHis yoke is easy and His burden is light\r\nHe looked me right in the eyes\r\nDirect and concise to remind me\r\nTo always do what\'s right\r\nAgain I stand against the Faceless Man\r\n\'Cause if the face inside can\'t see the light\r\nI know I\'ll have to walk alone\r\nAnd if I walk alone to the other side\r\nI know I might not make it home\r\nAgain I stand against the Faceless Man\r\nNext time I see this face\r\nI\'ll say I choose to live for always\r\nSo won\'t you come inside And never go away');
INSERT INTO `tracks` (`tra_id`, `tra_title`, `tra_lyrics`) VALUES (7,'Never die','Hands on a window pane\r\nWatching some children laugh and play\r\nThey\'re running in circles\r\nWith candy canes and French braids\r\nInspired to question\r\nWhat makes us grown-ups anyway?\r\nLet\'s search for the moment\r\nWhen youth betrayed itself to age\r\nSo let the children play Inside your heart always\r\nAnd death you will defy\r\n\'Cause your youth will never die\r\nIn searching for substance\r\nWe\'re clouded by struggle\'s haze\r\nRemember the meaning\r\nOf playing out in the rain\r\nWe swim in the fountain\r\nOf youth\'s timeless maze\r\nIf you drink the water\r\nYour youth will never fade\r\nNever die I won\'t let go of that youthful soul\r\nDespite body and mind my youth will never die');
INSERT INTO `tracks` (`tra_id`, `tra_title`, `tra_lyrics`) VALUES (8,'With arms wide open','Well I just heard the news today\r\nIt seems my life is going to change\r\nI closed my eyes, begin to pray\r\nThen tears of joy stream down my face\r\nWith arms wide open\r\nUnder the sunlight\r\nWelcome to this place\r\nI\'ll show you everything\r\nWith arms wide open\r\nWell I don\'t know if I\'m ready\r\nTo be the man I have to be\r\nI\'ll take a breath, take her by my side\r\nWe stand in awe, we\'ve created life\r\nWith arms wide open\r\nUnder the sunlight\r\nWelcome to this place\r\nI\'ll show you everything\r\nWith arms wide open\r\nNow everything has changed\r\nI\'ll show you love\r\nI\'ll show you everything\r\nWith arms wide open\r\nIf I had just one wish\r\nOnly one demand\r\nI hope he\'s not like me\r\n\r\nI hope he understands\r\nThat he can take this life\r\nAnd hold it by the hand\r\nAnd he can greet the world\r\nWith arms wide open...');
INSERT INTO `tracks` (`tra_id`, `tra_title`, `tra_lyrics`) VALUES (9,'Higher','When dreaming I\'m guided through another world\r\nTime and time again\r\nAt sunrise I fight to stay asleep\r\n\'Cause I don\'t want to leave the comfort of this place\r\n\'Cause there\'s a hunger, a longing to escape\r\nFrom the life I live when I\'m awake\r\nSo let\'s go there\r\nLet\'s make our escape\r\nCome on, let\'s go there\r\nLet\'s ask can we stay?\r\nCan you take me higher?\r\nTo the place where blind men see\r\nCan you take me higher?\r\nTo the place with golden streets\r\nAlthough I would like our world to change\r\nIt helps me to appreciate\r\nThose nights and those dreams\r\nBut, my friend, I\'d sacrifice all those nights\r\nIf I could make the Earth and my dreams the same\r\nThe only difference is\r\nTo let love replace all our hate\r\nSo let\'s go there\r\nLet\'s make our escape\r\nCome on, let\'s go there\r\nLet\'s ask can we stay?\r\nUp high I feel like I\'m alive for the very first time\r\nUp high I\'m strong enough to take these dreams\r\nAnd make them mine');
INSERT INTO `tracks` (`tra_id`, `tra_title`, `tra_lyrics`) VALUES (10,'Wash away those years','She came calling\r\nOne early morning\r\nShe showed her crown of thorns\r\nShe whispered softly\r\nTo tell a story\r\nAbout how she had been wronged\r\nAs she lay lifeless\r\nHe stole her innocence\r\nAnd this is how she carried on\r\nWell I guess she closed her eyes\r\nAnd just imagined everything\'s alright\r\nBut she could not hide her tears\r\n\'Cause they were sent to wash away those years\r\nThey were sent to wash away those years\r\nMy anger\'s violent\r\nBut still I\'m silent\r\nWhen tragedy strikes at home\r\nI know this decadence Is shared by millions\r\nRemember you\'re not alone\r\nFor we have crossed many oceans\r\nAnd we labor in between\r\nIn life there are many quotients\r\nAnd I hope I find the mean');
INSERT INTO `tracks` (`tra_id`, `tra_title`, `tra_lyrics`) VALUES (11,'Inside us all','When I\'m all alone\r\nAnd no one else is there\r\nWaiting by the phone\r\nTo remind me\r\nI\'m still here\r\nWhen shadows paint the scenes\r\nWhere spotlights used to fall\r\nAnd I\'m left wondering\r\nIs it really worth it all?\r\nThere\'s a peace inside us all\r\nLet it be your friend\r\nIt will help you carry on In the end\r\nThere\'s a peace inside us all\r\nLife can hold you down\r\nWhen you\'re not looking up\r\nCan\'t you hear the sound?\r\nHearts beating out loud\r\nAlthough the names change\r\nInside we\'re all the same\r\nWhy can\'t we tear down these walls?\r\nTo show the scars we\'re covering\r\nThere\'s a peace\r\nThere\'s a peace inside us all\r\nLet it be Oh, can\'t it be your friend?');
INSERT INTO `tracks` (`tra_id`, `tra_title`, `tra_lyrics`) VALUES (12,'Young grow old','He said he\'s falling to pieces\r\nFighting the boy and the man\r\nOver his shoulder there was freedom\r\nBut consciousness has tied his hands\r\nEmbodied youth was his distinction\r\nNow inhibition\'s in demand\r\nSo driven by his fear of weakness\r\nThat\'s his key to understand\r\nSo far in a distant land\r\nThere\'s a fight between boy and man\r\n\r\nSee the light through the open door\r\nSit and watch as the young grow old\r\nTrading places in the circle\r\nTurn the glass, spill the sand\r\nThey say that time can make the difference\r\nBut age doesn\'t make you a man\r\nSo far in a distant land\r\nThere\'s a fight between boy and man\r\nSee the light through the open door\r\nSit and watch as the young grow old\r\nSo young but overblown\r\nSo young but overblown\r\nSo young but overblown\r\nTake a look now, see the boy is weakened\r\nWatch him fade, watch him fade away\r\nTake a bow and the boy is defeated\r\nIs this the way, this the way?\r\nSo far in a distant land\r\nThere\'s a fight between boy and man\r\nSee the light through the open door\r\nSit and watch as the young grow old');
INSERT INTO `tracks` (`tra_id`, `tra_title`, `tra_lyrics`) VALUES (13,'To whom it may concern','Oh, I didn\'t mean to yell\r\nBut sometimes I get beside myself\r\nAnd oh, I didn\'t mean to rush you\r\nBut time keeps pushing so much\r\nOh, time keeps pushing so much\r\nYour eyes stare at me in the dark\r\nAnd I hope those eyes\r\nDon\'t steal my freedom\r\nMy freedom\r\nOh, If I didn\'t give it all\r\nWhen I stood you made me crawl\r\nAnd oh, if you never heard the song\r\nThen I could still hide down behind the wall\r\nThen I could still hide down behind the wall\r\nYour eyes stare at me in the dark\r\nAnd I hope those eyes\r\nDon\'t steal my freedom\r\nMy freedom\r\nAnd I hope those eyes\r\nDon\'t steal my freedom\r\nMy freedom\r\nSaid eyes, those eyes\r\nI said don\'t steal my freedom\r\nYour eyes stare at me in the dark\r\nAnd I hope those eyes\r\nDon\'t steal my freedom\r\nMy freedom\r\nOh, my freedom\r\nYour eyes stare at me in the dark\r\nAnd I hope those eyes\r\nDon\'t steal my freedom\r\nMy freedom\r\nOh, my freedom\r\nSaid eyes, those eyes\r\nSaid eyes, those eyes\r\nI said don\'t steal my freedom');
INSERT INTO `tracks` (`tra_id`, `tra_title`, `tra_lyrics`) VALUES (14,'Bullets','Walking around I hear the earth seeking relief\r\nIm trying to find a reason to live\r\nBut the mindless clutter my path\r\nOh these thorns in my side\r\nI know I have something free\r\nI have something so alive\r\nI think they shoot cause they want it\r\n\r\nI feel forces all around me\r\nCome on raise your head\r\nThose who hide behind the shadows\r\nLive with all thats dead\r\n\r\nLook at melook at me\r\nAt least look at me when you shoot a bullet \r\nthrough my head\r\nThrough my head\r\nThrough my head\r\nThrough my head\r\n\r\nIn my lifetime when Im disgraced\r\nBy jealousy and lies\r\nI laugh aloud cause my life\r\nHas gotten inside someone elses mind\r\n\r\nLook at melook at me\r\nAt least look at me when you shoot a bullet \r\nthrough my head\r\nThrough my head\r\nThrough my head\r\nThrough my head\r\n\r\nHey all I want is whats real\r\nSomething I touch and can feel\r\nIll hold it close and never let it go\r\nSaid whywhy do we live life\r\nWith all this hate inside\r\nIll give it away cause I dont want it no more\r\nPlease help me find a place\r\nSomewhere far away Ill go and youll never see me again');
INSERT INTO `tracks` (`tra_id`, `tra_title`, `tra_lyrics`) VALUES (15,'Freedom Fighter','The mouths of envious\r\nAlways find another door\r\nWhile at the gates of paradise they \r\nbeat us down some more\r\nBut our missions set in stone\r\nCause the writings on the wall\r\nIll scream it from the mountain tops \r\npride comes before a fall\r\n\r\nSo many thoughts to share\r\nAll this energy to give\r\nUnlike those who hide the truth \r\nI tell it like it is\r\nIf the truth will set you free\r\nI feel sorry for your soul\r\nCant you hear the ringing cause \r\nfor you the bell tolls\r\n\r\nIm just a freedom fighter\r\nNo remorse\r\nRaging on in holy war\r\nSoon therell come a day\r\nWhen youre face to face with me\r\nFace to face with me\r\n\r\nCant you hear us coming? \r\nPeople marching all around\r\nCant you see were coming? \r\nClose your eyes its over now\r\nCant you hear us coming? \r\nThe fight has only just begun\r\nCant you see were coming?\r\n\r\nIm just a freedom fighter\r\nNo remorse\r\nRaging on in holy war\r\nSoon therell come a day\r\nWhen youre face to face with me\r\nFace to face with me');
INSERT INTO `tracks` (`tra_id`, `tra_title`, `tra_lyrics`) VALUES (16,'Who\'s got my back?','Runhide\r\nAll that was sacred to us\r\nSacred to us\r\nSee the signs\r\nThe covenant has been broken\r\nBy mankind\r\nLeaving us with no shoulder\r\nwith no shoulder\r\nTo rest our head on\r\nTo rest our head on\r\nTo rest our head on\r\n\r\nWhos got my back now?\r\nWhen all we have left is deceptive\r\nSo disconnected\r\nSo what is the truth now?\r\n\r\nTheres still time\r\nAll that has been devastated\r\nCan be recreated\r\nRealize\r\nWe pick up the broken pieces\r\nOf our lives\r\nGiving ourselves to each other\r\nourselves to each other\r\nTo rest our head on\r\nTo rest our head on\r\nTo rest our head on\r\n\r\nWhos got my back now?\r\nWhen all we have left is deceptive\r\nSo disconnected\r\nSo what is the truth now?\r\n\r\nTell me the truth now\r\nTell us the truth now\r\n\r\nWhos got my back now?\r\nWhen all we have left is deceptive\r\nSo disconnected\r\nSo what is the truth now? ');
INSERT INTO `tracks` (`tra_id`, `tra_title`, `tra_lyrics`) VALUES (17,'Signs','This is not about age\r\nTime served on the earth \r\ndoesnt mean you grow in mind\r\nThis is not about God\r\nSpiritual insinuations seem \r\nto shock our nation\r\n\r\nCome with me Im fading \r\nunderneath the lights\r\nCome with me\r\nCome with me\r\nCome with me now\r\n\r\nThis is not about race\r\nIts a decision to stop the \r\ndivision in your life\r\nThis is not about sex\r\nWe all know sex sells and \r\nthe whole world is buying\r\n\r\nCome with me Im fading \r\nunderneath the lights\r\nCome with me\r\nCome with me\r\nCome with me now\r\n\r\nCant you see the signs? \r\nSee the signs now\r\n\r\nCant you see them? \r\nSee the signs \r\nYou see them\r\nAll the signs we see them \r\nCant you see them? ');
INSERT INTO `tracks` (`tra_id`, `tra_title`, `tra_lyrics`) VALUES (18,'One last breath','Please come now I think Im falling\r\nIm holding on to all I think is safe\r\nIt seems I found the road to nowhere\r\nAnd Im trying to escape\r\nI yelled back when I heard thunder\r\nBut Im down to one last breath\r\nAnd with it let me say\r\nLet me say\r\n\r\nHold me now\r\nIm six feet from the edge and Im thinking\r\nThat maybe six feet\r\nAint so far down\r\n\r\nIm looking down now that its over\r\nReflecting on all of my mistakes\r\nI thought I found the road to somewhere\r\nSomewhere in His grace\r\nI cried out heaven save me\r\nBut Im down to one last breath\r\nAnd with it let me say\r\nLet me say\r\n\r\nHold me now\r\nIm six feet from the edge and Im thinking\r\nThat maybe six feet\r\nAint so far down\r\n\r\nSad eyes follow me\r\nBut I still believe theres something left for me\r\nSo please come stay with me\r\nCause I still believe theres something left for you and me\r\nFor you and me \r\nFor you and me\r\n\r\nHold me now\r\nIm six feet from the edge and Im thinking');
INSERT INTO `tracks` (`tra_id`, `tra_title`, `tra_lyrics`) VALUES (19,'My sacrifice','Hello my friend we meet again\r\nIts been a while where should \r\nwe beginfeels like forever\r\nWithin my heart are memories\r\nOf perfect love that you gave to me\r\nI remember\r\n\r\nWhen you are with me\r\nIm freeIm carelessI believe\r\nAbove all the others well fly\r\nThis brings tears to my eyes\r\nMy sacrifice\r\n\r\nWeve seen our share of ups and downs\r\nOh how quickly life can turn around in \r\nan instant\r\nIt feels so good to reunite\r\nWithin yourself and within your mind\r\nLets find peace there\r\n\r\nWhen you are with me\r\nIm freeIm carelessI believe\r\nAbove all the others well fly\r\nThis brings tears to my eyes\r\nMy sacrifice\r\n\r\nI just want to say hello again');
INSERT INTO `tracks` (`tra_id`, `tra_title`, `tra_lyrics`) VALUES (20,'Stand here with me','You always reached out to me and \r\nhelped me believe\r\nAll those memories we share\r\nI will cherish every one of them\r\nThe truth of it is theres a right way to live\r\nAnd you showed me\r\nSo now you live on in the words of a song\r\nYoure a melody\r\n\r\nYou stand here with me now\r\n\r\nJust when fear blinded me \r\nyou taught me to dream\r\nIll give you everything I am \r\nand still fall short of \r\nWhat youve done for me\r\nIn this life that I live \r\nI hope I can give love unselfishly\r\nIve learned the world is bigger than me\r\nYoure my daily dose of reality\r\n\r\nYou stand here with me now\r\n\r\nOn and on we sing \r\nOn and on we sing this song\r\n\r\nCause you stand here with me ');
INSERT INTO `tracks` (`tra_id`, `tra_title`, `tra_lyrics`) VALUES (21,'Weathered','I lie awake on a long, dark night\r\nI cant seem to tame my mind\r\nSlings and arrows are killing me inside\r\nMaybe I cant accept the life thats mine\r\nNo I cant accept the life thats mine\r\n\r\nSimple living is my desperate cry\r\nBeen trading love with indifference \r\nyeah it suits me just fine\r\nI try to hold on but Im calloused to the bone\r\nMaybe thats why I feel alone\r\nMaybe thats why I feel so alone\r\n\r\nMeIm rusted and weathered\r\nBarely holding together\r\nIm covered with skin that peels and \r\nit just wont heal\r\n\r\nThe sun shines and I cant avoid the light\r\nI think Im holding on to life too tight\r\nAshes to ashes and dust to dust\r\nSometimes I feel like giving up\r\nSometimes I feel like giving up\r\n\r\nMeIm rusted and weathered\r\nBarely holding together\r\nIm covered with skin that peels \r\nand it just wont heal\r\n\r\nThe day reminds me of you\r\nThe night hides your truth\r\nThe earth is a voice\r\nSpeaking to you\r\nTake all this pride\r\nAnd leave it behind\r\nBecause one day it ends\r\nOne day we die\r\nBelieve what you will\r\nThat is your right\r\nBut I choose to win\r\nSo I choose to fight\r\nTo fight');
INSERT INTO `tracks` (`tra_id`, `tra_title`, `tra_lyrics`) VALUES (22,'Hide','To what do I owe this gift my friend?\r\nMy life, my love, my soul?\r\nIve been dancing with the devil \r\nway too long\r\nAnd its making me grow old\r\nMaking me grow old\r\n\r\nLets leaveoh lets get away\r\nGet lost in time\r\nWhere theres no reason to hide\r\n\r\nLets leaveoh lets get away\r\nRun in fields of time\r\nWhere theres no reason to hide\r\n\r\nWhat are you going to do with \r\nyour gift dear child?\r\nGive life, give love, give soul?\r\nDivided is the one who dances\r\nFor the soul is so exposed\r\nSo exposed\r\n\r\nLets leaveoh lets get away\r\nGet lost in time\r\nWhere theres no reason to hide\r\n\r\nLets leaveoh lets get away\r\nRun in fields of time\r\nWhere theres no reason to hide\r\n\r\nThere is no reason to hide\r\n\r\nNo reason to hide');
INSERT INTO `tracks` (`tra_id`, `tra_title`, `tra_lyrics`) VALUES (23,'Don\'t stop dancing','At times life is wicked and I just cant \r\nsee the light\r\nA silver lining sometimes isnt enough \r\nTo make some wrongs seem right\r\nWhatever life brings\r\nIve been through everything\r\nAnd now Im on my knees again\r\n\r\nBut I know I must go on\r\nAlthough I hurt I must be strong\r\nBecause inside I know that many \r\nfeel this way\r\n\r\nChildren dont stop dancing\r\nBelieve you can fly\r\nAwayaway\r\n\r\nAt times lifes unfair and you know \r\nits plain to see\r\nHey God I know Im just a dot in \r\nthis world\r\nHave you forgot about me?\r\nWhatever life brings\r\nIve been through everything\r\nAnd now Im on my knees again\r\n\r\nBut I know I must go on\r\nAlthough I hurt I must be strong\r\nBecause inside I know that many \r\nfeel this way\r\n\r\nAm I hiding in the shadows?\r\nForget the pain and forget the sorrows\r\n\r\nBut I know I must go on\r\nAlthough I hurt I must be strong\r\nBecause inside I know that many \r\nfeel this way\r\n\r\nChildren dont stop dancing\r\nBelieve you can fly\r\nAwayaway\r\n\r\nAm I hiding in the shadows? \r\nAre we hiding in the shadows? ');
INSERT INTO `tracks` (`tra_id`, `tra_title`, `tra_lyrics`) VALUES (24,'Lullaby','Hush my love now dont you cry\r\nEverything will be all right\r\nClose your eyes and drift in dream\r\nRest in peaceful sleep\r\n\r\nIf theres one thing I hope \r\nI showed you\r\nHope I showed you\r\n\r\nJust give love to all\r\n\r\nOh my lovein my arms tight\r\nEvery day you give me life\r\nAs I drift off to your world\r\nWill rest in peaceful sleep\r\n\r\nI know theres one thing that \r\nyou showed me\r\nThat you showed me\r\n\r\nJust give love to all\r\nLets give love to all');
INSERT INTO `tracks` (`tra_id`, `tra_title`, `tra_lyrics`) VALUES (25,'Torn','Peace is what they tell me\r\nLove am I unholy\r\nLies are what they tell me\r\nDespise you that control me\r\nThe peace is dead in my soul\r\nI have blamed the reason for\r\nMy intentions poor\r\nYes I\'m the one who\r\nThe only one who\r\nWould carry on this far\r\nTorn, I\'m filthy\r\nBorn in my own misery\r\nStole all that you gave me\r\nControl you claim you save me\r\nThe peace is dead in my soul\r\nI have blamed the reason for\r\nMy intentions poor\r\nYes I\'m the one who\r\nThe only one who\r\nWould carry on this far');
INSERT INTO `tracks` (`tra_id`, `tra_title`, `tra_lyrics`) VALUES (26,'Ode','Hang me, watch awhile\r\nLet me see you smile as I die\r\nTake me, as my body burns\r\nLet me see you yearn, while I cry\r\nOne step on your own\r\nAnd you walk all over me\r\nOne head in the clouds\r\nYou won\'t let go\r\nYou\'re too proud\r\nOne light to the blind, and they see\r\nOne touch on the head, we believe\r\nAdore me as I drift away\r\nLet me hear you say I\'m fine\r\nYou cry as my body dies\r\nAll that you despised is gone away\r\nOne step on your own\r\nAnd you walk all over me\r\nOne head in the clouds\r\nYou won\'t let go, you\'re too proud\r\nOne light to the blind, and they see\r\nOne touch on the head, we believe');
INSERT INTO `tracks` (`tra_id`, `tra_title`, `tra_lyrics`) VALUES (27,'My own prison','A court is in session, a verdict is in\r\nNo appeal on the docket today\r\nJust my own sin\r\nThe walls are cold and pale\r\nThe cage made of steel\r\nScreams fill the room\r\nAlone I drop and kneel\r\nSilence now the sound\r\nMy breath the only motion around\r\nDemons cluttering around\r\nMy face showing no emotion\r\nShackled by my sentence\r\nExpecting no return\r\nHere there is no penance\r\nMy skin begins to burn\r\nSo I held my head up high\r\nHiding hate that burns inside\r\nWhich only fuels their selfish pride\r\nWe\'re all held captive\r\nOut from the sun\r\nA sun that shines on only some\r\nWe the meek are all in one\r\nI hear a thunder in the distance\r\nSee a vision of a cross\r\nI feel the pain that was given\r\nOn that sad day of loss\r\nA lion roars in the darkness\r\nOnly he holds the key\r\nA light to free me from my burden\r\nAnd grant me life eternally\r\nShould have been dead\r\nOn a Sunday morning\r\nBanging my head\r\nNo time for mourning\r\nAin\'t got no time\r\nSo I held my head up high\r\nHiding hate that burns inside\r\nWhich only fuels their selfish pride\r\nWe\'re all held captive\r\nOut from the sun\r\nA sun that shines on only some\r\nWe the meek are all in one\r\nI cry out to God\r\nSeeking only his decision\r\nGabriel stands and confirms\r\nI\'ve created my own prison');
INSERT INTO `tracks` (`tra_id`, `tra_title`, `tra_lyrics`) VALUES (28,'Pity for a dime','An artificial season\r\nCovered by summer rain\r\nLosing all my reason\r\nCause there\'s nothing left to blame\r\nShadows paint the sidewalk\r\nA living picture in a frame\r\nSee the sea of people\r\nAll their faces look the same\r\nSo I sat down for awhile\r\nForcing a smile\r\nIn a state of self-denial\r\nIs it worthwhile\r\nSell my pity for a dime\r\nJust one dime\r\nSell my pity for a dime\r\nJust one dime\r\nPlain talk can be the easy way\r\nSigns of losing my faith\r\nSo I sat down for awhile\r\nForcing a smile\r\nIn a state of self-denial\r\nIs it worthwhile\r\nSell my pity for a dime\r\nJust one dime\r\nSell my pity for a dime\r\nJust one dime');
INSERT INTO `tracks` (`tra_id`, `tra_title`, `tra_lyrics`) VALUES (29,'In America','Only in America\r\nWe\'re slaves to be free\r\nOnly in America we kill the unborn\r\nTo make ends meet\r\nOnly in America\r\nSexuality is democracy\r\nOnly in America we stamp our god\r\n\"In God We Trust\"\r\nWhat is right or wrong\r\nI don\'t know who to believe in\r\nMy soul sings a different song\r\nIn America\r\nChurch bell\'s ringing\r\nPass the plate around\r\nThe choir is singing\r\nAs their leader falls to the ground\r\nPlease mister prophet man\r\nTell me which way to go\r\nI gave my last dollar\r\nCan I still come to your show\r\nWhat is right or wrong\r\nI don\'t know who to believe in\r\nMy soul sings a different song\r\nIn America\r\nI am right and you are wrong\r\nI am right and you are wrong\r\nI am right and you are wrong\r\nNo one\'s right and no one\'s wrong\r\nIn America');
INSERT INTO `tracks` (`tra_id`, `tra_title`, `tra_lyrics`) VALUES (30,'Illusion','The sun rises to another day\r\nMy constitution keeps changing\r\n\'Til it slips away\r\nSo I lie awake and stare\r\nMy mind thinking, just wandering\r\nIs anybody there?\r\nShould I stay or go\r\nShould I sleep or stay awake\r\nAm I really happy or is it all\r\nJust an illusion\r\nSitting in my room now\r\nHiding thoughts\r\nJust hoping one day I\'ll get out\r\nI hear a voice call my name\r\nBreaking trance, so silent\r\nSo I can stay the same\r\nShould I stay or go\r\nShould I sleep or stay awake\r\nAm I really happy or is it all\r\nJust an illusion\r\nWait now, many things left unsaid\r\nThis life remains the same\r\nBut I change\r\nI try to fool myself in believing\r\nThings are going to get better\r\nBut life goes on\r\nShould I stay or go\r\nShould I sleep or stay awake\r\nAm I really happy or is it all\r\nJust an illusion');
INSERT INTO `tracks` (`tra_id`, `tra_title`, `tra_lyrics`) VALUES (31,'Unforgiven','I kept up\r\nWith the prophecy you spoke\r\nI kept up with the message inside\r\nLost sight of the irony\r\nOf twisted faith\r\nLost sight of my soul and its void\r\nThink I\'m unforgiven to this world\r\nTook a chance at deceiving myself\r\nTo share in the consequence of lies\r\nChildish with my\r\nReasoning and pride\r\nGodless to the extent that I died\r\nThink I\'m unforgiven to this world\r\nThink I\'m unforgiven\r\nStep inside the light and see the fear\r\nOf God burn inside of me\r\nThe gold was put to flame\r\nTo kill, to burn, to mold its purity');
INSERT INTO `tracks` (`tra_id`, `tra_title`, `tra_lyrics`) VALUES (32,'Sister','Caught up in the middle\r\nHad no choice, had no choice\r\nBirthright forgotten, so silent\r\nNo voice\r\nI see you\r\nYou know who\r\nLittle girl, little girl\r\nNow realize little girl\r\nOverlooked little girl\r\nBottled up and empty holding back\r\nAt loss you\'re forgotten\r\nGetting back, get back\r\nExpectations of another\r\nLove given to the younger\r\nBroken father, broken brother\r\nEmptiness feeds the hunger\r\nI see you\r\nYou know who\r\nLittle sister, little sister\r\nNow realize little sister\r\nOverlooked little girl\r\nChange, change, change');
INSERT INTO `tracks` (`tra_id`, `tra_title`, `tra_lyrics`) VALUES (33,'What\'s this life for?','Hurray for a child\r\nThat makes it through\r\nIf there\'s any way\r\nBecause the answer lies in you\r\nThey\'re laid to rest\r\nBefore they know just what to do\r\nTheir souls are lost\r\nBecause they could never find\r\nWhat\'s this life for\r\nI see your soul, it\'s kind of gray\r\nI see your heart, you look away\r\nYou see my wrist, I know your pain\r\nI know your purpose on your plane\r\nDon\'t say a last prayer\r\nBecause you could never find\r\nWhat\'s this life for\r\nBut they ain\'t here anymore\r\nDon\'t have to settle the score\r\nCause we all live\r\nUnder the reign of one king');
INSERT INTO `tracks` (`tra_id`, `tra_title`, `tra_lyrics`) VALUES (34,'One','Affirmative may be justified\r\nTake from one give to another\r\nThe goal is to be unified\r\nTake my hand be my brother\r\nThe payment silenced the masses\r\nSanctified by oppression\r\nUnity took a back seat\r\nSliding further in regression\r\nOne\r\nThe only way is one\r\nI feel angry I feel helpless\r\nWant to change the world\r\nI feel violent I feel alone\r\nDon\'t try and change my mind\r\nSociety blind by color\r\nWhy hold down one to raise another\r\nDiscrimination now on both sides\r\nSeeds of hate blossom further\r\nThe world is heading for mutiny\r\nWhen all we want is unity\r\nWe may rise and fall, but in the end\r\nWe meet our fate together\r\nOne\r\nThe only way is one\r\nI feel angry I feel helpless\r\nWant to change the world\r\nI feel violent I feel alone\r\nDon\'t try and change my mind');
INSERT INTO `tracks` (`tra_id`, `tra_title`, `tra_lyrics`) VALUES (35,'Bound & tied','Tongue-tied, restless, and wanting\r\nLooks like you might bite, you might bite\r\nBreathing in, breathing out,\r\nyou\'re weakened\r\nThe poison\'s hit your mind, your mind.\r\nTime\'s ticking and its got ya thinking\',\r\nYou\'re happy with your life, your life\r\nYou\'re jaded, slated and singled out\r\nby all those chains that bind, that bind\r\nTake a jet plane my way lately\r\nCause now you are mine,\r\nyou are mine\r\nThis airplane\'s going my way\r\nCause now you\'re bound and tied\r\nYou\'re bound and tied\r\nYou\'re bound and tied\r\nNow sit and reflect on all the fame\r\nTime to dim your light, your light\r\nZooming in, zooming out,\r\nyou\'re questioning\r\nFor that there is no crime, no crime\r\nYou\'re jaded,\r\nslated and singled out,\r\nby all those chains they bind, they bind\r\nTake a jet plane my way lately\r\nCause now you are mine, you are mine\r\nThis airplane\'s going my way\r\nCause now you\'re bound and tied\r\nYou\'re bound and tied\r\nYou\'re bound and tied\r\nAnd we fly, we fly, we fly\r\nAnd we fly, we fly, we fly\r\nAnd we fly, and we fly...away, away\r\nBound and tied,\r\nbound and tied\r\nYou\'re Bound and Tied\r\nBound and tied,\r\nbound and tied\r\nYou\'re bound and tied\r\nBound and tied,\r\nbound and tied\r\nYou\'re bound and tied\r\nYou\'re bound and tied');

*/
?>

  </body>
</html>
