<?php

function _HID($hospID){

	$API_URL="http://web.rimag.com.cn/Interfaces/BodyCode/getTagBodycodeByHospitalId/hospitalId/";
	$myCode = json_decode(file_get_contents($API_URL.$hospID),TRUE);
	return (array) $myCode;
}


function _Mysql() {

    $host = 'mysql:dbname=dcm3_jiangxi_pacs;host=rm-bp173b3q9rjsdpxro.mysql.rds.aliyuncs.com';
    $user = 'dcm3_jiangxi';
    $passwd = '5iwole@123';

	try {
		$link = new PDO($host, $user, $passwd);
		$link->exec("set names utf8");
		//echo "连接成功\n"; 
	}

	catch(PDOException $e) {

		echo "连接失败 ==> ";
		echo $e->getMessage() . "\n";
		exit;
	}

	return $link;
}


function _Select($Start_Date, $AET) {

	$End_Date = date("Y-m-d",strtotime("+1 day",strtotime("$Start_Date")));
	//$End_Date = date("Y-m-d",strtotime("+1 month",strtotime("$Start_Date")));
	/*echo $Start_Date . "\n";
	echo $End_Date . "\n";
	echo $AET;	
	*/

	$pdo = _Mysql();
	$sql = "

	    select study_iuid, bodyPart_Desc, bodyPart_num, study.pk as study_pk,
            study.study_datetime as datetime 
            from study
            INNER JOIN series ON series.study_fk = study.pk
            INNER JOIN patient ON study.patient_fk = patient.pk
            INNER JOIN instance ON instance.series_fk = series.pk
            INNER JOIN files ON files.instance_fk = instance.pk
	    where series.src_aet = '$AET'
            and study.created_time>='$Start_Date'
            and study.created_time<'$End_Date'
            and instance.inst_no=1
            and series.series_desc<>'DOSE REPORT'
            and series.series_desc<>'DOSE RECORD'
            and series.series_desc<>'SCREEN SAVE'
	";
	
	$stmt = $pdo->prepare($sql);
	$stmt->execute();
	$PatientInfo = array();
	//print_r($stmt);

	if(empty($stmt->fetch(PDO::FETCH_ASSOC))) {

		exit;
	}

	$stmt->execute();//将指针指向头
	while ( $row = $stmt->fetch(PDO::FETCH_ASSOC)) {

		array_push($PatientInfo, $row);
	}

	//print_r($PatientInfo);

	return $PatientInfo;
}


function _Update($Date_Time, $AET, $AK) {

	/*echo $Date_Time . "\n";
	echo $AET . "\n";
	echo $AK . "\n";
	*/

	$pdo = _Mysql();
	$_table = _Select($Date_Time, $AET);
	//print_r($_table);

	foreach ($_table as $Key => $value) {

		$Body = explode("$AK", $value['bodyPart_Desc']);
		$Body_Num = count($Body);
		$ID = $value['study_pk'];
		echo "数据库ID ==> " . "$ID" . " | 更新部位数 ==> " . "$Body_Num" . "\n";

		$sql= "update study set bodyPart_num = $Body_Num where study.pk = $ID";
		echo $sql . "\n";
		$stmt = $pdo->prepare($sql);
		$stmt->execute();
		$PatientInfo = array();

	}
}

?>
