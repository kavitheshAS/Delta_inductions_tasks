<?php
// Assuming the script is named index1.php for the first instance, index2.php for the second, and index3.php for the third
$instanceId = substr(__FILE__, -6, 1); // Extracts the last digit from the filename

echo "Mess: " . $_SERVER['SERVER_NAME'] . PHP_EOL;
echo "Instance ID: " . $instanceId . PHP_EOL;
