<?php
include("db.php");
$link_id = dbConnect();
	if ($uid != '' && $password != '') {
		$uid=$_POST['uid'];
		$password=$_POST['password'];

		$result = pg_query($link_id, "SELECT name, ic_number, security_token, profile_id FROM users WHERE login = '$uid' AND ic_number = '$password'");
		$data = pg_fetch_array($result);
		$count = pg_num_rows($result);
		$pid = $data["profile_id"];
		$token = $data["security_token"];

		$result2 = pg_query($link_id, "SELECT name, mobile, ic_number, opis, email FROM profiles WHERE id = '$pid'");
		$data2 = pg_fetch_array($result2);
		$nama = $data2["name"];
		$nokp = $data2["ic_number"];
		$mobile = $data2["mobile"];
		$email = $data2["email"];
		$jabatan = $data2["opis"];

		if($count==1){
			session_register("nama");
			session_register("nokp");
			session_register("mobile");
			session_register("email");
			session_register("jabatan");
			session_register("uid");
			session_register("password");
			session_register("token");
			header("location:mohon.php");
		}
		else {
			header("location:index.php");
		}
	}
	                else {
                        header("location:index.php");
                }

?>
