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
      <th height="20" bordercolor="#000000" bgcolor="#9b6191"><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">UPLOAD eTOKEN WIRELESS FILE</font></th>
    </tr>
  </tbody>
</table>
<br />
  <table width="85%" align="center" bgcolor="#eeeeee" border="0" cellpadding="3" cellspacing="1">
<form enctype="multipart/form-data" name="upload_form" method="post" action="checkupload.php">
    <tbody>
      <tr bgcolor="#000000">
	<td colspan="3" align="center" bgcolor="#9b6191"><strong><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">UPLOAD TOKEN WIRELESS || <a href="list.php">SENARAI TOKEN WIRELESS</a></font></strong></td>
      </tr>
      <tr>
	<td colspan="3" align="right">&nbsp;</td>
      </tr>
    <tr>
<td colspan="3" align="center"><p>
  <input type="hidden" name="MAX_FILE_SIZE" value="100000" />
  <strong><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Pilih fail untuk upload</font></strong>: 
  <input name="filename" type="file" />
  </p>
  <p><br />
      <input type="submit" value="Upload eToken " />
  </p></td>
    </tr>
    </tr>
</table>
</form>
</body>
</html>
