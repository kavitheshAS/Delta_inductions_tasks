<?php

$dbhost = "mysql";
$dbuser = "root";
$dbpass = "rootpassword";
$dbname = "mydb";

if(!$con = mysqli_connect($dbhost,$dbuser,$dbpass,$dbname))
{

	die("failed to connect!");
}
?>
