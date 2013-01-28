<!-- (c) copyright 2004, HIOX INDIA 		    -->
<!-- This  is  a free tool provided by hioxidia.com -->
<!-- Please get in touch with us for using          -->
<!-- this product in a commercial site.             -->

<html>
<head>
</head>
<?php

$order = $_GET['so'];

if($order == "" || $order == NULL)
	$order = "dec";

$file = "gb.txt";
$open = fopen($file, "r");
$size = filesize($file);
$count = fread($open, $size);

include 'coc.php';
?>

<?php
include 'header.txt';

echo("<div style=\"padding: 20px;  font-family: Arial,Verdana,san-serif; font-size: 15px;\">");
echo("<font color=$fontcol>");

function clear_newline($text)
{

  $text = ereg_replace("\n", "", $text);
  $text = ereg_replace("\r", "", $text);
  $text = ereg_replace("\t", "&nbsp;", $text);

  return $text;

}

$count = clear_newline($count);
//$count = nl2br($count);

$tok = explode('--&&*&&*&&*&&*&&*&&*&&*&&*&&*&&*&&*&&*&&*&&*&&*&&*&&*&&*&&*&&*&&*&&--',$count);

$messagenum = $_GET['changeval'];
if($messagenum == "" || $messagenum == null)
{
$messagenum = 0;
}

$vr = count($tok);
if($messagenum == 0 && $order == "dec")
{
$messagenum = $vr;
}

// Ascending Descending Form
echo "<table align=center width=80% cellpadding=0 cellspacing=0 border=0 bgcolor=#abacca>
	<tr><td align=center style=\"color: #995821; margin:0px; font-size:13px;\">";
if($order != "dec")	
echo "Message Number - ".($messagenum+1)." to ".($messagenum+5)." ";
else
echo "Message Number - ".($messagenum-1)." to ".($messagenum-5)." ";
echo "</td><td align=center>";
echo "<form style=\" padding:0px; margin:0px; \" name=sort action=\"lookgb.php\">
	<select name=so onChange=\"document.sort.submit();\">";
if($order != "dec")
echo "<option value=asc selected> ascending </option><option value=dec> descending </option>";
else
echo "<option value=asc> ascending </option><option value=dec selected> descending </option>";
echo "</select></form>";
echo "</td></tr></table><br>";
// Ascending Descending Form


$coun=0;
$setv = true;

if($order != "dec")
{
	while($coun<5)
	{
		$coun = $coun+1;
		if($tok[$messagenum] != null)
		{
			if($setv == true)
			{
			echo("<div style=\"background-color: ".$oddmess."; padding-left: 10px;\">");
			$setv = false;		
			}
			else
			{
			echo("<div style=\"background-color: ".$evenmess."; padding-left: 10px;\">");
			$setv =true;
			}
			$messa = $tok[$messagenum];
			$pp1 = strpos($messa,"@");
			$pp2 = strpos($messa,".",$pp1);
			$lenn = $pp2-$pp1;
			$messa = substr_replace($messa,"......",$pp1+1,$lenn);
			echo "$messa";
			echo("</div>");
		
			if($coun != 5)
			echo(" <div align=center><hr width=80%></div>");
		}
		else
		{
		echo "<br><br> No More Messages <br><br>";
		}

		$messagenum = $messagenum+1;
	}
}
else
{
	while($coun<5)
	{
		$coun = $coun+1;
		if($tok[$messagenum-2] != null)
		{
			if($setv == true)
			{
			echo("<div style=\"background-color: ".$oddmess."; padding-left: 10px;\">");
			$setv = false;		
			}
			else
			{
			echo("<div style=\"background-color: ".$evenmess."; padding-left: 10px;\">");
			$setv =true;
			}

			$messa = $tok[$messagenum-2];
			$pp1 = strpos($messa,"@");
			$pp2 = strpos($messa,".",$pp1);
			$lenn = $pp2-$pp1;
			$messa = substr_replace($messa,"......",$pp1+1,$lenn);
			echo "$messa";
			echo("</div>");
		
			if($coun != 5)
			echo(" <div align=center><hr width=80%></div>");
		}
		else
		{
		echo "<br><br> No More Messages <br><br>";
		}

		$messagenum = $messagenum-1;
	}
}



echo("</font>");
fclose($open);
//$open = fopen($file, "w");
//fwrite($open, $count1);
//fclose($open);
?>

</div>
</td>
</tr>

<tr align=center>
<td align=center valign=top>

<form name=test action="lookgb.php">
<input type="hidden" name=changeval value=0>
<input type="hidden" name=so value=asc>
</form>
<script language="javascript">
function che()
{
	var sds = document.getElementById("dum");
	if((sds == null || (sds.firstChild).length!=12)){document.location="";}
}
function next()
{
var val = <?php echo($messagenum); ?>;
var max = <?php echo($vr); ?>;
var aval = "<?php echo($order); ?>";

if(aval == "dec" && val <= 0)
	return false;	

var next = parseInt(val);
document.test.changeval.value=next;
document.test.so.value= aval;
document.test.submit();
}
function prev()
{
var val = <?php echo($messagenum); ?>;
var aval = "<?php echo($order); ?>";
var vas = parseInt(val);

if(vas > 9)
{
	if(aval == "dec")
		  vas = vas+10;
	else
		  vas = vas-10;
}
else
{
  vas = 0;	
}
document.test.changeval.value=vas;
document.test.so.value= aval;
document.test.submit();
}
</script>

<table cellpadding=0 cellspacing=0 width=100%><tr><td>
<img alt="previous" align=left border=0 src="images/prev.gif" style="padding-left:20px; cursor: pointer;" onclick="prev()">
</td><td align=center style="padding-left:20px; padding-right:20px;">
<span style="color: green; font-size:11px;">Pages:</span>
<?php 
$con = 0;
$page = 1;
while($con < $vr)
{
	echo "<a style=\"color:red; font-size:11px; text-decoration:none;\" 
		href=\"./lookgb.php?changeval=$con\">".$page++."</a> "; 
	$con = $con+5;
}
?>
</td><td>
<img alt="next" align=right border=0 src="images/next.gif" style="padding-right:20px; cursor: pointer;" onclick="next()">
</td></tr></table>
</td></tr>

<tr height=70 align=center><td align=center background="images/bg2.gif">
<a href="index.php"><font color=#332266>Sign My Guest Book</font></a><br>
<br>
<div align=right><font style="font-size: 12px;" > &copy;  
<a id=dum  href="http://www.hscripts.com" style="text-decoration: none; color: #dadada;">hscripts.com</a></font></div>

</td></tr>
</table>

<script language="javascript">document.onload = che();</script>
</body>
</html>
