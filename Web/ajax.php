<?php include_once("includes/loginCheck.php"); ?>
<?php
	
// -------------------------------------- MENU --------------------------------------- //
	
	// Add a new vote to the database
	if (isset ($_POST['voteUp'])) {

		$remote = $_SERVER['REMOTE_ADDR'];
		$result = resourceForQuery("SELECT * FROM `votes` WHERE `remote`=INET_ATON('$remote')");
		$insert = false;

		if (mysql_num_rows ($result) == 0) {
			$insert = resourceForQuery("INSERT INTO `votes` (`remote`, `date`) VALUES (INET_ATON('$remote'), NOW())");
		}

		// Get the current number of votes
		$result = resourceForQuery("SELECT COUNT(*) AS `number` FROM `votes`");
		$votes = mysql_result($result, 0, "number");

		$json = array("votes" => $votes);

		// Response code
		if ($insert) {
			$json["response"] = "true";
		} else {
			$json["response"] = "false";
		}

		echo json_encode($json);

	} else

// ----------------------------------------------------------------------------------- //	
	{}

?>