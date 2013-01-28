<!-- (c) copyright 2004, HIOX INDIA 		    -->
<!-- This  is  a free tool provided by hioxidia.com -->
<!-- Please get in touch with us for using          -->
<!-- this product in a commercial site.             -->

<?php

$file1 = "color.txt";
$open1 = fopen($file1, "r");
$size1 = filesize($file1);
$count1 = fread($open1, $size1);
$pos1 = strpos($count1, '"', 9);
$pos2 = strpos($count1, '"', $pos1+1);
$length = $pos2-$pos1;
$bxcolor = substr($count1,$pos1+1,$length-1);
//echo($bxcolor);
$pos1 = strpos($count1, '"',$pos2+1);
$pos2 = strpos($count1, '"', $pos1+1);
$length = $pos2-$pos1;
$bdcolor = substr($count1,$pos1+1,$length-1);
//echo($bdcolor);
$pos1 = strpos($count1, '"',$pos2+1);
$pos2 = strpos($count1, '"', $pos1+1);
$length = $pos2-$pos1;
$fontcol = substr($count1,$pos1+1,$length-1);
//echo($fontcol);
$pos1 = strpos($count1, '"',$pos2+1);
$pos2 = strpos($count1, '"', $pos1+1);
$length = $pos2-$pos1;
$oddmess = substr($count1,$pos1+1,$length-1);
//echo($fontcol);
$pos1 = strpos($count1, '"',$pos2+1);
$pos2 = strpos($count1, '"', $pos1+1);
$length = $pos2-$pos1;
$evenmess = substr($count1,$pos1+1,$length-1);
//echo($fontcol);


?>