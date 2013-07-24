<?php

	/**
	 * Wrappers, functions and code for database needs
	 */

	/**
	 * Wrapper to run a query, process any errors
	 * @param  string 	$query 	Query
	 * @return object 		query resource or boolean
	 */
	function resourceForQuery($query) {
		$result = mysql_query($query) or trigger_error(mysql_error() . " " . $query);

		return $result;
	}


	/**
	 * See if the company has permissions over the given childID (which can be a category, item...)
	 * @param  string 		$query 	Query
	 * @return boolean 		query boolean
	 */
	function checkPermission($companyID, $childID, $childType) {

		if ($childType == "carte") {
			$result = resourceForQuery(
				"SELECT `carte`.`id` 
				FROM `carte` 
				INNER JOIN `carteParent` ON `carte`.`id`= `carteParent`.`childID` 
				WHERE 1
					AND `carteParent`.`childID`=$childID 
					AND `carteParent`.`parentID`=$companyID
				");
		} elseif ($childType == "carteCategory") {
			$result = resourceForQuery(
				"SELECT `carte`.`id` 
				FROM `carte` 
				INNER JOIN `carteParent` ON `carte`.`id`= `carteParent`.`childID` 
				INNER JOIN `carteCategoryParent` ON `carte`.`id`= `carteCategoryParent`.`parentID` 
				WHERE 1
					AND `carteCategoryParent`.`childID`=$childID 
					AND `carteParent`.`parentID`=$companyID
				");
		} elseif ($childType == "carteItem") {
			$result = resourceForQuery(
				"SELECT `carte`.`id` 
				FROM `carte` 
				INNER JOIN `carteParent` ON `carte`.`id`= `carteParent`.`childID` 
				INNER JOIN `carteCategoryParent` ON `carte`.`id`= `carteCategoryParent`.`parentID` 
				INNER JOIN `carteItemParent` ON `carteCategoryParent`.`childID`= `carteItemParent`.`parentID` 
				WHERE 1 
					AND `carteItemParent`.`childID`=$childID 
					AND `carteParent`.`parentID`=$companyID
				");
		} elseif ($childType == "carteItemOption") {
			$result = resourceForQuery(
				"SELECT `carte`.`id` 
				FROM `carte` 
				INNER JOIN `carteParent` ON `carte`.`id`= `carteParent`.`childID` 
				INNER JOIN `carteCategoryParent` ON `carte`.`id`= `carteCategoryParent`.`parentID` 
				INNER JOIN `carteItemParent` ON `carteCategoryParent`.`childID`= `carteItemParent`.`parentID` 
				INNER JOIN `carteItemOptions` ON `carteItemOptions`.`itemID`=`carteItemParent`.`childID` 
				WHERE 1
					AND `carteItemOptions`.`id`=$childID 
					AND `carteParent`.`parentID`=$companyID
				");
		} elseif ($childType == "carteItemOptionItem") {
			$result = resourceForQuery(
				"SELECT `carte`.`id` 
				FROM `carte` 
				INNER JOIN `carteParent` ON `carte`.`id`= `carteParent`.`childID` 
				INNER JOIN `carteCategoryParent` ON `carte`.`id`= `carteCategoryParent`.`parentID` 
				INNER JOIN `carteItemParent` ON `carteCategoryParent`.`childID`= `carteItemParent`.`parentID` 
				INNER JOIN `carteItemOptions` ON `carteItemOptions`.`itemID`=`carteItemParent`.`childID` 
				INNER JOIN `carteItemOptionsItem` ON `carteItemOptionsItem`.`optionID`=`carteItemOptions`.`id` 
				WHERE 1 
					AND `carteItemOptionsItem`.`id`=$childID 
					AND `carteParent`.`parentID`=$companyID
				");
		}

		if (mysql_num_rows($result) >= 1) {
			return true;
		} else {
			return false;
		}

	}

	function getTableUniqueID($tableID) {
		// Obtain the unique id from our log
		$result = resourceForQuery("SELECT `id` FROM `tableUnique` WHERE `tableID`=$tableID ORDER BY `id` DESC");
		
		if (mysql_num_rows($result) > 0) {
			return mysql_result($result, 0, "id");
		} else {
			return false;
		}
	}

	function getTableNumber($tableID) {
		// Obtain the unique id from our log
		$result = resourceForQuery("SELECT `number` FROM `table` WHERE `id`=$tableID ORDER BY `id` DESC");
		
		if (mysql_num_rows($result) > 0) {
			return mysql_result($result, 0, "number");
		} else {
			return false;
		}
	}

	function getCompanyID($mapID) {
		// Obtain the unique id from our log
		$result = resourceForQuery("SELECT `companyID` FROM `tableMap` WHERE `id`=$mapID");

		if (mysql_num_rows($result) > 0) {
			return mysql_result($result, 0, "companyID");
		} else {
			return false;
		}
	}

	function getMapID($companyID) {
		// Obtain the unique id from our log
		$result = resourceForQuery("SELECT `id` FROM `tableMap` WHERE `companyID`=$companyID");

		if (mysql_num_rows($result) > 0) {
			return mysql_result($result, 0, "id");
		} else {
			return false;
		}
	}

	function companyHasTable($companyID, $tableID) {
		$mapID = getMapID($companyID);

		$result = resourceForQuery("SELECT * FROM `tableMap` INNER JOIN `table` ON `tableMap`.`id` = `table`.`mapID` WHERE `tableMap`.`companyID`=$companyID AND `table`.`id`=$tableID");

		if (mysql_num_rows($result) > 0) {
			return true;
		} else {
			return false;
		}
	}

	function companyHasOrder($companyID, $orderID) {

		$result = resourceForQuery("SELECT * FROM `order` WHERE `companyID`=$companyID AND `id`=$orderID");

		if (mysql_num_rows($result) > 0) {
			return true;
		} else {
			return false;
		}
	}

	function timeZone() {
		$now = new \DateTime();
		$mins = $now->getOffset() / 60;
		$sgn = ($mins < 0 ? -1 : 1);
		$mins = abs($mins);
		$hrs = floor($mins / 60);
		$mins -= $hrs * 60;
		$offset = sprintf('%+d:%02d', $hrs*$sgn, $mins);

		return $offset;
	}

    function getAttribute($attr) {

    	if (isset($attr)) {

    		// If it is an array, we can parse all its elements
    		if (is_array($attr)) {
    			$attribute = array_map("getAttribute", $attr);
    		// Else, we can parse the string
    		} elseif(is_string($attr)) {
    			$attribute = trim(htmlentities(utf8_decode($attr)));
    		}
    		
	    	if (function_exists("http_response_code") && is_null($attribute)) {
	    		http_response_code(409);
	    	} else {
	    		return $attribute;
	    	}

		} else {
			die(FALSE);
		}
    }

?>