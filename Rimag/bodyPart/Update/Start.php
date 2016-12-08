<?php

include ("Mysql.php");

date_default_timezone_set("Asia/Shanghai");

if(count($argv)==1) {
	
	exit("执行格式 ==> php Start.php 8 2017-01-01 AET \"-\"\n");
}


if(! $bodyCode = _HID($argv[1])) {

	exit("医院ID错误!\n");
}


if(! $startDate = DateTime::createFromFormat('Y-m-j', $argv[2])){

	exit("日期格式错误!\n");
}


if($argv[3] == null) {

	exit("请在第三项加AET!\n");
} 


if($argv[4] == null) {

	exit("请在第四项加分隔符!\n");

} else {

	$_Date = $argv[2];
	$AET = $argv[3];
	$AK = $argv[4];
	_Update($_Date, $AET, $AK);
}

$link = null;

?>
