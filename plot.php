<?php
//$pdo = new PDO('mysql:host=140.112.57.110;dbname=solar_schema;port=3306','rpi','a09876543');

$dsn = "mysql:host=140.112.57.110;dbname=solar_schema";
$db = new PDO($dsn,"rpi","a09876543");

$old_path = getcwd();
chdir('/home/pi/tempsensor');
shell_exec('Rscript temp120png.r');
chdir($old_path);


//$stmt = $pdo->prepare("select * from solar_data");
//$stmt->bindValue(':id',1,PDO::PARAM_INT);
//$stmt->execute();
//$rows = $stmt->fetchAll(PDO::FETCH_ASSOC);

foreach($db->query("SELECT * FROM solar_data2 order by time desc limit 2;") as $a){print_r($a);}
//$rows = $pdo->query("select w from solar_data limit 1");
//foreach( $db->query( "select * from solar_data limit 1" ) as $b){print_r($b);}
?>
