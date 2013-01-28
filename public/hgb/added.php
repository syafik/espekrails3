<!-- (c) copyright 2004, HIOX INDIA 		    -->
<!-- This  is  a free tool provided by hioxidia.com -->
<!-- Please get in touch with us for using          -->
<!-- this product in a commercial site.             -->

<html>
<head>
</head>

<?php

$file = "gb.txt";
$open = fopen($file, "a");

include 'coc.php';
?>

<body style="font-family: Arial,Verdana,san-serif; margin: 0px;" bgcolor=<?php echo($bdcolor);?>>
<table align=center width=80% height=100% cellpadding=0 cellspacing=0 border=1 bgcolor="<?php echo($bxcolor);?>">
<tr height=10% align=center>
<td height=10% align=center>
<font color=#223356><b>Welcome Guest</b></font>
</td>
</tr>

<tr height=70% align=center>
<td height=70%  align=left style="border-width: 10px;">
<div style="padding-left:20px; font-family: Arial,Verdana,san-serif;">

<?php
echo("<font color=$fontcol>");

$name = $_POST['name'];

$from = $_POST['from'];
$comment= $_POST['comment'];

$comment = ereg_replace("\n", "<br>", $comment);
$comment = ereg_replace("\r", "", $comment);
$comment = ereg_replace("\t", "&nbsp;", $comment);

$date = date("l dS of F Y h:i:s A");

if($name != "" || $comment != "")
{

fwrite($open, "\n");
fwrite($open, "<br>");
fwrite($open, $date);
fwrite($open, "<br>");
fwrite($open, "<br>");
fwrite($open, $name);
fwrite($open, "<br>");
fwrite($open, $from);
fwrite($open, "<br>");
fwrite($open, "<br>");
fwrite($open, $comment);
fwrite($open, "<br><br>");
fwrite($open, "--&&*&&*&&*&&*&&*&&*&&*&&*&&*&&*&&*&&*&&*&&*&&*&&*&&*&&*&&*&&*&&*&&--");


echo("<div align=center><br><font color=green>Thanks for your signature. It has been added in my guest book</font><br></div><br><br>");

echo($date);
echo("<br><br>");
echo($name);
echo("<br>");
echo($from);
echo("<br><br><font color=$fontcol>");
echo($comment);
echo("<br></font>");
echo("</font>");
}
else
{
echo("please add a proper entry");
}

?>
</div>
</td>
</tr>

<tr height=20% align=center>
<td height=20% align=center valign=top >
<br>
<a href="lookgb.php"><font color=#332266>Look in to My Guest Book</font></a><br>
<br>
</td>
</tr>
</table>

<table width=60% align=center>
<tr>
<td>
<div align=right><font size=-1>Tool provided by <a href="http://www.hscripts.com">hscripts.com</a></font></div>
</td>
</tr>
</table>

</body>
</html>
