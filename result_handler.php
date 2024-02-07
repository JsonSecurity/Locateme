<?php
header('Content-Type: text/html');
{
  $lat = $_POST['Lat'];
  $lon = $_POST['Lon'];

  $data = $lat.":".$lon;

  $f = fopen('logs/result.txt', 'a');
  fwrite($f, $data);
  fclose($f);
}
?>
