<?php

/*
  ALTER TABLE  `study` ADD  `bodyPart_num` TINYINT NULL DEFAULT NULL COMMENT  '部位数' AFTER  `study_desc` ,
  ADD  `bodyPart_Desc` VARCHAR( 128 ) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT  '部位描述' AFTER  `bodyPart_num` ,
  ADD INDEX (  `bodyPart_Desc` ) ;
 */


//$pdo = 'mysql:dbname=rimagpacs;host=rdsvy2qjemy32yb.mysql.rds.aliyuncs.com';
//$user = 'rimag';
//$password = 'bitrms9527';
// 二附院: JXXYSFYXRMYYCT
// 天坛普华: BJCWTTPHYYCT

require_once 'function.php';
//include_once 'CodeConvert.php';
date_default_timezone_set("Asia/Shanghai"); 

if(count($argv)==1) {
    //exit("bodyPart.php hospid yyyy-mm-dd type\n");
    exit("bodyPart.php hospid yyyy-mm-dd AET\n");
}

if(!$bodyCode=getCodeConvert($argv[1])) {
    exit("hospid error\n");
}
if(!$startDate = DateTime::createFromFormat('Y-m-j', $argv[2])){
    exit("date format error\n");
}
//print_r($bodyCode);
//echo $startDate->format('Y-m-d');

//$Connection = makeConnection();
//$BodyArray = updateBodypart($Connection, $AETTitle, $Modality, $startDate, $bodyCode['JXXYSFYXRMYYCT']);
//processStudy($BodyArray);
//var_dump($bodyCode);



if(!empty($argv[3])){
	$AET = $argv[3];	
	foreach ($bodyCode as $Key => $value) {
		if($AET == $Key){
		//	print_r($value);exit;
	    		$Connection = makeConnection();
	    		$BodyArray = updateBodypart($Connection, $Key, $value['type'], $startDate, $value);
	   		processStudy($BodyArray);
			exit;
	}
  }
}

foreach ($bodyCode as $Key => $value) {
    print_r($value);
    $Connection = makeConnection();
    $BodyArray = updateBodypart($Connection, $Key, $bodyCode[$Key]['type'], $startDate, $value);
    //exit;
    processStudy($BodyArray);
    //print_r($BodyArray);
    //echo PHP_EOL . "=====" . PHP_EOL;
}
