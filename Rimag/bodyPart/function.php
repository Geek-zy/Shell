<?php

//require_once 'bodyCodeConvert.php';
$dcmDump_path = "/home/setup/dcm4che/dcm4che-3/bin/dcmdump";

$API_URL="http://web.rimag.com.cn/Interfaces/BodyCode/getTagBodycodeByHospitalId/hospitalId/";

function getCodeConvert($hospID){
    global $API_URL;
    $myCode = json_decode(file_get_contents($API_URL.$hospID),TRUE);
    return (array) $myCode;
}

function makeConnection() {
    $pdo = 'mysql:dbname=dcm3_jiangxi_pacs;host=rm-bp173b3q9rjsdpxro.mysql.rds.aliyuncs.com';
    $user = 'dcm3_jiangxi';
    $password = '5iwole@123';
    
//    $pdo = 'mysql:dbname=pacsdb;host=192.168.0.8';  //dcm2.jiangxi
//    $user = 'pacs';
//    $password = 'pacs';
    try {
        $pdo = new PDO($pdo, $user, $password);
        $pdo->exec("set names utf8");
    } catch (PDOException $e) {
        echo 'Connection failed: ' . $e->getMessage();
    }
    return $pdo;
}

function updateBodypart($pdo, $AETTitle, $Modality, $startDate, $CodeArray) {
    //include_once 'CodeConvert.php';
    print_r($CodeArray);
    global $dcmDump_path, $Debug;
    $endDate = clone $startDate;
    $endDate = $endDate->modify('+1 day');

    $startDate = $startDate->format("Y-m-d");
    $endDate = $endDate->format("Y-m-d");


    $query_bak = "select study_iuid, study.pk as study_pk, study.mods_in_study as mod_in,
            files.filepath as filepath, study.study_datetime as datetime 
            from study
            INNER JOIN series ON series.study_fk = study.pk
            INNER JOIN patient ON study.patient_fk = patient.pk
            INNER JOIN instance ON instance.series_fk = series.pk
            INNER JOIN files ON files.instance_fk = instance.pk
            where study.mods_in_study LIKE '%$Modality%'
            and series.src_aet = '$AETTitle'
            and study.created_time>='$startDate'
            and study.created_time<'$endDate'
            and instance.inst_no=1
            and series.series_desc<>'DOSE REPORT'
            and series.series_desc<>'DOSE RECORD'
            and series.series_desc<>'SCREEN SAVE'
                ";

    $query = "
	   	select study_iuid,study.pk as study_pk,study.mods_in_study as mod_in,
	   	files.filepath as filepath,study.study_datetime as datetime 
		from study
		INNER JOIN series ON series.study_fk= study.pk
		INNER JOIN patient ON study.patient_fk= patient.pk
		INNER JOIN instance ON instance.series_fk= series.pk
		INNER JOIN files ON files.instance_fk= instance.pk
		where study.mods_in_study LIKE '%$Modality%'
		and series.src_aet= '$AETTitle'
		and study.created_time>= '$startDate'
		and study.created_time< '$endDate'
		and series.series_desc<> 'DOSE REPORT'
		and series.series_desc<> 'DOSE RECORD'
		and series.series_desc<> 'SCREEN SAVE'
		GROUP BY `series` .`pk`
		    ";

    //echo $query . PHP_EOL;
    $stmt = $pdo->prepare($query);
    $stmt->execute();
    $result = $stmt->fetchAll(PDO::FETCH_CLASS);

    $Study_Array = array();
    $tempBody = array();
    $tempStudypk = null;
    $pdo = null;


    foreach ($result as $Key => $value) {
        $filePath = "/usr/local/dcm4chee/server/default/archive/" . $value->filepath;

        $tagRequiredArray = $CodeArray['tag'];
        $tagRequired = $CodeArray['tag'][0];
        $Command = "$dcmDump_path $filePath | grep $tagRequired |awk 'BEGIN{RS=\"]\";FS=\"[\"}NF>1{print \$NF}'|cut -d \" \" -f 2-";
        //echo $Command . PHP_EOL;
        $tagBody = trim(exec($Command));
        //echo $tagBody . PHP_EOL;
        if (array_key_exists($tagBody, $CodeArray['bodycode'])) {
            $tagBody = $CodeArray['bodycode'][$tagBody];
        }
        echo $tagBody . "\n";

        if ($tempStudypk === $value->study_pk) {
            if (!in_array($tagBody, $tempBody) && $tagBody != "")
                array_push($tempBody, $tagBody);
        }
        else {
	  if ($Modality != "MR") {
            unset($tempBody);
            unset($tempStudypk);
            $tempStudypk = $value->study_pk;
            $tempBody = array();
            array_push($tempBody, $tagBody);
		}
	  else {
		$tempBody = explode("+",$tagBody);
		}
        }
        $Study_Array[$value->study_pk]['UUID'] = $value->study_iuid;
        $Study_Array[$value->study_pk]['bodyPart'] = $tempBody;
        $Study_Array[$value->study_pk]['datetime'] = $value->datetime;
	// print_r($tempBody);
    }

    return $Study_Array;
}

function processStudy($Study_Array) {
    $pdo = makeConnection();
    foreach ($Study_Array as $Key => $value) {
        $bodyPart_num = count($value['bodyPart']);
        $bodyPart_Desc = implode("--", $value['bodyPart']);
        $updateQuery = "update study set bodyPart_num=$bodyPart_num, bodyPart_Desc =\"$bodyPart_Desc\" where study.pk=$Key";
        //echo $updateQuery . PHP_EOL;
        $stmt = $pdo->prepare($updateQuery);
        $stmt->execute();
    }
    $pdo = null;
}
