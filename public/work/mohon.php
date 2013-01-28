<?php
session_start();
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
      <th height="20" bordercolor="#000000" bgcolor="#9b6191"><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">PERMOHONAN TOKEN WIRELESS </font></th>
    </tr>
  </tbody>
</table>
<table width="85%" align="center" bgcolor="#eeeeee" border="0" cellpadding="3" cellspacing="1">
<form name="mohon_form" method="post" action="checkmohon.php">
    <div align="center">
      <input name="button" type=button onclick="history.go(-1)" value="Back" />
    </div>

    <tbody>
      <tr bgcolor="#000000">
	<td colspan="3" align="center" bgcolor="#9b6191"><h4><strong><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">MAKLUMAT PEMOHON</font><font color="#FFFFFF" size="2"></font></strong><b><strong><font color="#FFFFFF">
	  <?php if ($_SESSION['nokp'] == "780327085588") {echo " | <a href=\"upload.php\">UPLOAD TOKEN WIRELESS</a>";}?>
	</font></strong></b></h4></td>
      </tr>
      <tr>
        <td colspan="3" align="center"><div align="center"><a href="#" onClick="history.go(-1)"></a>
          <!-- Change the value of -1 to any number of pages you would like to send your visitors back -->
        </div></td>
      </tr>
      <tr>
	<td colspan="3" align="center"><table width="53%" border="0" align="center">
      <tr>
        <td width="47%"><div align="right"><strong><font size="2" face="Verdana, Arial, Helvetica, sans-serif">No. KP </font></strong></div></td>
        <td width="2%"><font face="Verdana, Arial, Helvetica, sans-serif"><strong>:</strong></font></td>
        <td width="51%"><font color="#000000" size="2" face="Verdana, Arial, Helvetica, sans-serif"><b><?php echo " ". $_SESSION['nokp'];?></b></font></td>
      </tr>
      <tr>
        <td><div align="right"><strong><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Nama Penuh </font></strong></div></td>
        <td><font face="Verdana, Arial, Helvetica, sans-serif"><strong>:</strong></font></td>
        <td><font color="#000000" size="2" face="Verdana, Arial, Helvetica, sans-serif"><b><?php echo " ". $_SESSION['nama'];?></b></font></td>
      </tr>
      <tr>
        <td><div align="right"><strong><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Email</font></strong></div></td>
        <td><font face="Verdana, Arial, Helvetica, sans-serif"><strong>:</strong></font></td>
        <td><font color="#000000" size="2" face="Verdana, Arial, Helvetica, sans-serif"><b><?php echo " ". $_SESSION['email'];?></b></font></td>
      </tr>
      <tr>
        <td><div align="right"><strong><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Jabatan</font></strong></div></td>
        <td><font face="Verdana, Arial, Helvetica, sans-serif"><strong>:</strong></font></td>
        <td><font color="#000000" size="2" face="Verdana, Arial, Helvetica, sans-serif"><b><?php echo " ". $_SESSION['jabatan'];?></b></font></td>
      </tr>
      <tr>
        <td><div align="right"><strong><font size="2" face="Verdana, Arial, Helvetica, sans-serif">No. Telefon </font></strong></div></td>
        <td><font face="Verdana, Arial, Helvetica, sans-serif"><strong>:</strong></font></td>
        <td><font color="#000000" size="2" face="Verdana, Arial, Helvetica, sans-serif"><b><?php echo " ". $_SESSION['mobile'];?></b></font></td>
      </tr>
    </table></td>
      </tr>
    <tr>
      <td colspan="3" align="center"><b>
        <input type="submit" value="Jana eToken Wireless">
      </b></td>
    </tr>
    </tr>
</table>
</form>
</body>
</html>
