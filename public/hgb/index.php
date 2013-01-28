<!-- (c) copyright 2004, HIOX INDIA 		    -->
<!-- This  is  a free tool provided by hioxidia.com -->
<!-- Please get in touch with us for using          -->
<!-- this product in a commercial site.             -->

<html>
<head>
</head>
<?php

$file = "gb.txt";
$open = fopen($file, "r");
$size = filesize($file);
$count = fread($open, $size);

include 'coc.php';

include 'header.txt';
?>

<script language=javascript>

function checkMailId(mailids)
{
var arr = new Array('.com','.net','.org','.biz','.coop','.info','.museum','.name','.pro'
,'.edu','.gov','.int','.mil','.ac','.ad','.ae','.af','.ag','.ai','.al',
'.am','.an','.ao','.aq','.ar','.as','.at','.au','.aw','.az','.ba','.bb',
'.bd','.be','.bf','.bg','.bh','.bi','.bj','.bm','.bn','.bo','.br','.bs',
'.bt','.bv','.bw','.by','.bz','.ca','.cc','.cd','.cf','.cg','.ch','.ci',
'.ck','.cl','.cm','.cn','.co','.cr','.cu','.cv','.cx','.cy','.cz','.de',
'.dj','.dk','.dm','.do','.dz','.ec','.ee','.eg','.eh','.er','.es','.et',
'.fi','.fj','.fk','.fm','.fo','.fr','.ga','.gd','.ge','.gf','.gg','.gh',
'.gi','.gl','.gm','.gn','.gp','.gq','.gr','.gs','.gt','.gu','.gv','.gy',
'.hk','.hm','.hn','.hr','.ht','.hu','.id','.ie','.il','.im','.in','.io',
'.iq','.ir','.is','.it','.je','.jm','.jo','.jp','.ke','.kg','.kh','.ki',
'.km','.kn','.kp','.kr','.kw','.ky','.kz','.la','.lb','.lc','.li','.lk',
'.lr','.ls','.lt','.lu','.lv','.ly','.ma','.mc','.md','.mg','.mh','.mk',
'.ml','.mm','.mn','.mo','.mp','.mq','.mr','.ms','.mt','.mu','.mv','.mw',
'.mx','.my','.mz','.na','.nc','.ne','.nf','.ng','.ni','.nl','.no','.np',
'.nr','.nu','.nz','.om','.pa','.pe','.pf','.pg','.ph','.pk','.pl','.pm',
'.pn','.pr','.ps','.pt','.pw','.py','.qa','.re','.ro','.rw','.ru','.sa',
'.sb','.sc','.sd','.se','.sg','.sh','.si','.sj','.sk','.sl','.sm','.sn',
'.so','.sr','.st','.sv','.sy','.sz','.tc','.td','.tf','.tg','.th','.tj',
'.tk','.tm','.tn','.to','.tp','.tr','.tt','.tv','.tw','.tz','.ua','.ug',
'.uk','.um','.us','.uy','.uz','.va','.vc','.ve','.vg','.vi','.vn','.vu',
'.ws','.wf','.ye','.yt','.yu','.za','.zm','.zw');
var mai = mailids;
var val = true;

var dot = mai.lastIndexOf(".");
var ext = mai.substring(dot,mai.length);
var at = mai.indexOf("@");

if(dot > 5 && at >1){
for(var i=0; i<arr.length; i++){
if(ext == arr[i]){val = true;break;}else{val = false;}}if(val == false){
alert("Your maild "+mai+" is not corrrrect");
return false;}}else{alert("Your maild "+mai+" is not correct");
return false;}return true;}

function check()
{
var tex = document.ssa.comment.value;
var len = tex.length;
var rem = 300-len;

if(len >= 300)
{
	tex = tex.substring(0,300);
	document.ssa.comment.value =tex;
	return false;
}

if(rem<0)
rem=0;

document.ssa.rem.value =rem;
}
</script>

<table cellpadding=4 cellspacing=0 border=0 align=center>
    <tr><td><br>Name *:</td><td><br>
    <form name=ssa action="added.php" METHOD="POST" onSubmit="return checkMailId(ssa.from.value)">
    <input type="text" name="name" size=20 maxlength="20"> [20]</td></tr>
    <tr><td>Email *:</td><td><input type="text" name="from" size=27 maxlength="50"> [50]</td></tr>
    <tr><td>WebSite:</td><td><input type="text" name="webs" size=27 maxlength="50"> [50]</td></tr>
     <tr><td colspan=2><br>Please add your comments/suggestions *: [300]<br>
        <textarea name="comment" rows=11 cols=55 wrap=physical onkeyup="check()"></textarea><br>
	  Words left - <input type="text" name="rem" size=3 readonly value=300> 
  </td></tr>
    <tr><td colspan=2 align=right><input type="submit" value="   Add   "></td></tr>
    </form>
  </table>

<br>
</td>
</tr>

<tr height=15% align=center><td align=center background="images/bg2.gif" style="font-size: 13px;">
<br>
<b><a href="lookgb.php"><font color=blue>Look in to My Guest Book</font></a></b> || 
<a href="admin.php"><font color=red>Admin Login</font></a><br>
<br>
<br>
<div align=right><font style="font-size: 12px;" > &copy; copyright 
<a href="http://www.hscripts.com" style="text-decoration: none; color: #dadada;">hscripts.com</a></font></div>

</td>
</tr>
</table>

</body>
</html>
