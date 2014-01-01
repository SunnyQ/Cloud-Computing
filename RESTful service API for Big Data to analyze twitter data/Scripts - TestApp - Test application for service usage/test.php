<html>
<?php
//header('Content-Type: text/plain');
$fn=$_GET["fn"];
$cn=$_GET["cn"];
$url="http://192.168.109.100/slim/?fn=$fn&cn=$cn";
$ch = curl_init();
curl_setopt($ch, CURLOPT_URL,$url);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
$content = curl_exec($ch);
curl_close ($ch);
$content = str_replace(array('"', "'"), '', $content);
$data = explode('\n', $content);
echo "<center>";
echo "<table border=\"5\" cellpadding=\"10\">"; 
for ($i=0; $i < count($data)-1; $i++) 
 { 
  echo "<tr>"; 
	$temp = explode('\t',$data[$i]);
        for ($j=0; $j<2; $j++) 
        { 
        echo "<td>$temp[$j]</td>"; 
        } 
    echo "</tr>"; 
    } 
         
    echo "</table>";  
echo "</center>";
?>

</html>
