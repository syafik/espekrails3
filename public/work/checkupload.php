<?php
include("db.php");
$link_id = dbConnect();

$file = $filename;
$handle = fopen ($file,"r");
while(($data = fgetcsv($handle, 1000, ",")) !== false)
	{
	list($col1, $col2) = $data;
	$q = "INSERT INTO wireless (token) VALUES ('$col1')";
	$go = pg_exec($link_id,$q);
	}
fclose($handle);
header("location:list.php");
?>
