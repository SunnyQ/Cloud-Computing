<?php
require 'vendor/slim/slim/Slim/Slim.php';
use Slim\Slim;
\Slim\Slim::registerAutoloader();

$file = $_GET['fn'];
$count = $_GET['cn'];
shell_exec("/var/www/$file.sh $count");
$output = shell_exec("cat /tmp/out2");
shell_exec("rm /tmp/out2");
header('Content-Type', 'application/json');
  
echo json_encode($output);
exit;
