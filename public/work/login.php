<?php
session_start(); 
include("db.php");
$link_id = dbConnect();
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>eToken Wireless</title>


<style type="text/css">
<!--
.style3 {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 10px;
}
.style11 {font-family: Georgia, "Times New Roman", Times, serif}
.style13 {color: #990000}
-->
</style></head>

<body >
<table width="100%" align="center" border="0" cellpadding="0" cellspacing="0">
  <tbody>
    <tr>
      <th width="100%" height="20" bordercolor="#000000"><object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,19,0" width="1002" height="143">
        <param name="movie" value="flashbanner" />
        <param name="quality" value="high" />
        <embed src="flashbanner.swf" quality="high" pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash" width="1002" height="143"></embed>
      </object></th>
    </tr>
  </tbody>
</table>
<table width="100%" height="100" border="0">
<form name="login_form" method="post" action="checklogin.php" onsubmit="return Login(this);">
  <tr>
    <td><table width="100%" border="0">
      <tr>
	<td colspan="4"><div align="center"><strong></strong></div></td>
	</tr>
	
      <tr>
	<td colspan="4"><span class="style5"><div align="center"><em><strong> Sila log in untuk memohon token wireless bagi kegunaan di Institut Tanah Dan Ukur Negara.  </span></strong></em></div></td>
	</tr>
	
      <tr>
	<td colspan="4"><div align="center">
	  <table width="100%" border="0" cellpadding="0" cellspacing="0">
	    <tbody>
	      <tr>
		<td></td>
	      </tr>
	    </tbody>
	  </table>
	</div>
	
	  <div>
	    <table>
	      <tbody>
		<tr>
		  <td width="1200"><span class="style3"><div align="center">Sudahkah anda mempunyai akaun eSPEK? 
		  <u><strong><br><a href="http://espek.instun.gov.my/user/register">Daftarlah Sekarang!</a></strong></u></br></div><br><div align="center">Log In eSPEK diperlukan untuk mengakses sistem eToken Wireless ini.</br></div></span></td>
		</tr>
		
	      </tbody>
	    </table>
	  </div>
	  
      <tr>
	<td colspan="4">&nbsp;</td>
	</tr>
      <tr>
	<td width="21%">&nbsp;</td>
	<td width="13%"><b><div align="right" class="style3">ESPEK LOGIN ID : </div></b></td>
	<td width="29%"><table width="99%" border="1">
          <input type="text" name="uid" maxlength="40" size="40">
          </td>  
	</table></td>
	<td width="37%">&nbsp;</td>
	</tr>
      <tr>
	<td>&nbsp;</td>
	<td><b><div align="right"><span class="style3">NO KP : </span></div></b></td>
	<td><table width="99%" border="1">
	<input type="text" name="password" maxlength="12" size="40">
	</td>
	</table></td>
	<td>&nbsp;</td>
      </tr>
            <tr width=100%>
              <td width=25%>&nbsp;</td>
              <th width=2%></th>
              <td align=left width=15%>
                <input type="submit" value="Mohon eToken Wireless">
              </td>
            </tr>
				
    </table>
  </tr>
  <tr> 
  		<td align = center width=215%><span class="style11"><br>
        <span class="style3">©Hakcipta Terpelihara  2010 | BAHAGIAN TEKNOLOGI MAKLUMAT, INSTUN<br >
  Sebarang masalah sila hubungi| 05-4542825</span>  <br /></td></tr>
</table>
</form>
</body>
</html>
