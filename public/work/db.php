<?php
$dbuser = 'pgsql';
if (!isset($user_dbname)) $user_dbname = 'instun';

function dbConnect() {
    global $dbuser, $user_dbname;
    $dbcnx = pg_connect("dbname=$user_dbname user=$dbuser");
    return $dbcnx;
}
?>
