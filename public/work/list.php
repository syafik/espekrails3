<?php
session_start();
include("db.php");
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>e-Token Wireless</title>
</head>

<body>
<table width="85%" align="center" border="0" cellpadding="0" cellspacing="0">
  <tbody>
    <tr>
      <th width="85%" height="20" bordercolor="#000000" bgcolor="#9b6191"><img src="TokenWireless_Banner copy.jpg" width="100%" height="143" /></th>
    </tr>
    <tr>
      <th height="20" bordercolor="#000000" bgcolor="#9b6191"><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">SENARAI eTOKEN WIRELESS</font></th>
    </tr>
  </tbody>
</table>
<table width="85%" align="center" bgcolor="#eeeeee" border="0" cellpadding="2" cellspacing="0">
    <tbody>
      <tr bgcolor="#000000">
        <td colspan="5" align="center" bgcolor="#FFFFFF"><strong><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif"><?php echo "<p><a href=\"logout.php\">Log Keluar</a></p>";?></font></strong></td>
      </tr>
      <tr bgcolor="#000000">
	<td colspan="5" align="center" bgcolor="#9b6191"><strong><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif"><a href="upload.php">UPLOAD TOKEN WIRELESS</a> ||SENARAI TOKEN WIRELESS </font></strong></td>
      </tr>
      <tr>
      <td colspan="5" height="15">&nbsp;</td>
      </tr>
<?php

$link_id = dbConnect();
		
          echo "<tr>\n";
          echo "<td width=15%><b>Wireless Token</b></td>\n";
          echo "<td width=10%><b>No.KP</b></td>\n";
          echo "<td width=25%><b>Nama </b></td>\n";
          echo "<td width=30%><b>Jabatan</b></td>\n";
          echo "<td width=20%><b>Tarikh Mohon</b></td>\n";
          echo "</tr>\n";
		

	$result = pg_query($link_id, "SELECT token, ic_number, created_at FROM wireless WHERE token != 'id' order by id");
        while ($dat = pg_fetch_array($result)) {
           	$subj = $dat["token"];
             	$code = $dat["ic_number"];
             	$date = $dat["created_at"];
        	$check = "SELECT * from profiles where ic_number = '$code'";
		$recheck = pg_exec($link_id,$check);
        	$dat2 = pg_fetch_array($recheck);

             echo "<tr>\n";
             echo "<td width=15%>$subj</td>\n";
             echo "<td width=10%>$code</td>\n";
             echo "<td width=25%>$dat2[name]</td>\n";
             echo "<td width=30%>$dat2[opis]</td>\n";
             echo "<td width=20%>$date</td>\n";
             echo "</tr>\n";
        }

?>
<tr>
<td colspan="5"  align="center"><?php echo "<p><a href=\"logout.php\">Log Keluar</a></p>";?></td>
</tr>
<tr>
  <td colspan="5"  align="center"><script language="javascript">
function printpage()
 {
  window.print();
 }
</script>
</head>

<body>

<form>
<input type="button" value="Cetak" onclick="printpage();">
</form></td>
</tr>
</table>
</body>
</html>
