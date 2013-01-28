<?php
session_start();
include("db.php");
$link_id = dbConnect();
        $check = "SELECT * from wireless where ic_number is null and token != 'id';";
        $recheck = pg_exec($link_id,$check);
        $dat2 = pg_fetch_array($recheck);
        $id =$dat2[0];

	$nokp = $_SESSION['nokp'];
	$day = date("m/d/Y");
	$today = date("F j, Y, g:i a");
        $check2 = "SELECT * from wireless where ic_number = '$nokp' and created_at like '%$day%'";
        $recheck2 = pg_exec($link_id,$check2);
	$count = pg_num_rows($recheck2);
	if($count==0){
	$update = "UPDATE wireless SET ic_number ='$nokp', created_at='$today' WHERE id = '$id'";
	$run_update = pg_exec($link_id, $update);
	}
header("location:login_success.php");
?>
