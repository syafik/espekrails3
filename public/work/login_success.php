<?php
session_start();
include("db.php");
$link_id = dbConnect();
$nokp = $_SESSION['nokp'];
$result = pg_query($link_id, "SELECT token FROM wireless WHERE ic_number = '$nokp'");
$data = pg_fetch_array($result);
$count = pg_num_rows($result);
$token = $data["token"];
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>e-Token Wireless</title>
</head>

<body>
<table width="85%" border="0" align="center">
  <tr>
    <td><table width="100%" border="0">
      <tr>
	<td><table width="100%" align="center" border="0" cellpadding="0" cellspacing="0">
	  <tbody>
	    <tr>
	      <th width="85%" height="20" bordercolor="#000000" bgcolor="#9b6191"><img src="TokenWireless_Banner copy.jpg" width="100%" height="143" /></th>
	    </tr>
	    <tr>
	      <th height="20" bordercolor="#000000" bgcolor="#9b6191"><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">PERMOHONAN eTOKEN WIRELESS</font></th>
	      </tr>
	  </tbody>
	</table>
	  <table width="100%" align="center" bgcolor="#eeeeee" border="0" cellpadding="3" cellspacing="1">

  <tr>
    <td align="center"><table width="50%" border="0" align="center">
      <tr>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
      </tr>
      <tr>
        <td width="40%"><div align="right"><strong><font size="2" face="Verdana, Arial, Helvetica, sans-serif">eSPEK Login ID </font></strong></div></td>
        <td width="2%"><strong><font color="#000000" size="2" face="Verdana, Arial, Helvetica, sans-serif">:</font></strong></td>
        <td width="58%"><font color="#000000" size="2" face="Verdana, Arial, Helvetica, sans-serif"><?php echo " ". $_SESSION['uid'];?></font><font size="2" face="Verdana, Arial, Helvetica, sans-serif">&nbsp;</font></td>
      </tr>
      <tr>
        <td><div align="right"><strong><font size="2" face="Verdana, Arial, Helvetica, sans-serif">No. KP</font></strong></div></td>
        <td><strong><font color="#000000" size="2" face="Verdana, Arial, Helvetica, sans-serif">:</font></strong></td>
        <td><font color="#000000" size="2" face="Verdana, Arial, Helvetica, sans-serif"><?php echo " ". $_SESSION['password'];?></font><font size="2" face="Verdana, Arial, Helvetica, sans-serif">&nbsp;</font></td>
      </tr>
      <tr>
        <td><div align="right"><strong><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Wireless Token</font></strong></div></td>
        <td><strong><font color="#000000" size="2" face="Verdana, Arial, Helvetica, sans-serif">:</font></strong></td>
        <td><font color="#000000" size="2" face="Verdana, Arial, Helvetica, sans-serif"><?php echo " ". $token;?></font><font size="2" face="Verdana, Arial, Helvetica, sans-serif">&nbsp;</font></td>
      </tr>

    </table></td>
  </tr>
  <tr>
    <td align="center"><font color="#000000" size="2" face="Verdana, Arial, Helvetica, sans-serif"><?php echo "<p><a href=\"logout.php\">Log Keluar</a></p>";?>&nbsp;&nbsp;</font></td>
  </tr>
  <tr>
    <td height="68" align="center">&nbsp;
      <script language="javascript">
function printpage()
 {
  window.print();
 }
</script>
</head>

<body>
<input type="button" value="Cetak" onclick="printpage();"></td>
  </tr>
	  </table>
	  </td>
      </tr>
    </table></td>
  </tr>
</table>
</body>
</html>
