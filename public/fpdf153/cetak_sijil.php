<?php
define('FPDF_FONTPATH','./font/');
require('fpdf.php');
require('fpdf_js.php');

class PDF_AutoPrint extends PDF_Javascript
{
function AutoPrint($dialog=false)
{
    //Embed some JavaScript to show the print dialog or start printing immediately
    $param=($dialog ? 'true' : 'false');
    $script="print($param);";
    $this->IncludeJS($script);
}
}

class PDF extends PDF_AutoPrint {

var $DisplayPreferences='';

function DisplayPreferences($preferences) {
    $this->DisplayPreferences.=$preferences;
}

function _putcatalog()
{
    parent::_putcatalog();
    if(is_int(strpos($this->DisplayPreferences,'FullScreen')))
        $this->_out('/PageMode /FullScreen');
    if($this->DisplayPreferences) {
        $this->_out('/ViewerPreferences<<');
        if(is_int(strpos($this->DisplayPreferences,'HideMenubar')))
            $this->_out('/HideMenubar true');
        if(is_int(strpos($this->DisplayPreferences,'HideToolbar')))
            $this->_out('/HideToolbar true');
        if(is_int(strpos($this->DisplayPreferences,'HideWindowUI')))
            $this->_out('/HideWindowUI true');
        if(is_int(strpos($this->DisplayPreferences,'DisplayDocTitle')))
            $this->_out('/DisplayDocTitle true');
        if(is_int(strpos($this->DisplayPreferences,'CenterWindow')))
            $this->_out('/CenterWindow true');
        if(is_int(strpos($this->DisplayPreferences,'FitWindow')))
            $this->_out('/FitWindow true');
        $this->_out('>>');
    }
}
}

pg_connect("host=localhost port=5432 dbname=instun_test user=pgsql password=genpass");

$bulan_arr = array( 
				"01" => "JANUARI",
				"02" => "FEBUARI",
				"03" => "MAC",
				"04" => "APRIL",
				"05" => "MEI",
				"06" => "JUN",
				"07" => "JULAI",
				"08" => "OGOS",
				"09" => "SEPTEMBER",
				"10" => "OCTOBER",
				"11" => "NOVEMBER",
				"12" => "DISEMBER"
				);

//########SENARAI PESERTA FROM DB RES
$name_arr = array();
$ic_arr = array();
$nosiri_arr = array();
for($j=0 ; $j < sizeof($course_application_ids) ; $j++){ 
	$sql = "SELECT name,ic_number,ca.no_sijil FROM profiles p INNER JOIN course_applications ca ON ca.profile_id=p.id 
	        INNER JOIN vw_detailed_peserta v ON ca.id=v.course_application_id
			WHERE ca.id='$course_application_ids[$j]'";
	$res = pg_exec($sql);
	$dat = pg_fetch_object($res);
	$name_arr[] = strtoupper($dat->name);
	$ic_arr[] = $dat->ic_number;
	$nosiri_arr[] = sprintf("%04d",$dat->no_sijil);
}	

// START GENERATE PDF 
$pdf=new PDF('P','mm','A4');
$pdf->AddFont('marigold','','marigold.php');
$pdf->AddFont('marigold','I','marigoldi.php');
$pdf->AddFont('fontsijil','','fontsijil.php');
$pdf->AddFont('fontsijil','I','fontsijil.php');
$pdf->AddFont('euclid','','euclid.php');
$pdf->AddFont('euclid','I','euclidbi.php');
$pdf->AddFont('euclid','B','euclidb.php');
$pdf->AddFont('euclid','BI','euclidbi.php');
//$pdf->SetMargins(float left, float top [, float right]) 
$pdf->SetMargins(50, 0, 20); 
$pdf->SetAutoPageBreak(F,0);
$pdf->SetDisplayMode("fullpage","single");
$pdf->AutoPrint('false');
$pdf->DisplayPreferences('HideMenubar,HideToolbar,CenterWindow,FitWindow');

$DESIGNMODE = 0;

// TAJUK UTAMA
$FONT_TYPE_MAIN_TAJUK = "fontsijil";
$FONT_STYLE_MAIN_TAJUK = "";
$FONT_MAIN_TAJUK_SIZE = 60 ;

// TAJUK KECIL
$FONT_TYPE_TAJUK = "fontsijil";
$FONT_STYLE_TAJUK = "";
$FONT_TAJUK_SIZE = 24 ;
$CELL_SPACING_TAJUK = 10 ;

// DETAIL 
$FONT_TYPE_DETAIL = "times";
$FONT_STYLE_DETAIL = "I";
$FONT_DETAIL_SIZE = 20;
$FONT_DETAIL_IC_SIZE = $FONT_DETAIL_SIZE-5;
$CELL_SPACING_CONTENT = 5 ; //Spacing kat detail

$FONT_TT_SIZE = 12 ; 
$FONT_TT_STYLE = "";
$CELL_SPACING_TT = 4 ;

if($FONT_TYPE_DETAIL == "times" || $FONT_TYPE_DETAIL == "euclid" ) {
	$FONT_DETAIL_SIZE = $FONT_DETAIL_SIZE-5 ;
	$FONT_TT_SIZE = $FONT_TT_SIZE-5;
}	

// TEST SERIAL NUMBER

//$course_tempoh = preg_replace(" /-/ ", " HINGGA ",$course_tempoh);
list($dr,$ke) = split("-",$course_tempoh);
list($d,$m,$y) = split("/",$ke);
$mm = $bulan_arr[$m];

$course_tempoh = $dr . "HINGGA" . $d . " " . $mm . " " . $y;

$kursus = $course_name;
$tempat = "INSTITUT TANAH DAN UKUR NEGARA\nKEMENTERIAN SUMBER ASLI DAN ALAM SEKITAR\nBEHRANG, 20987 TANJONG MALIM\nPERAK DARUL RIDZUAN";
$name = "1234567890 1234567890 1234567890 1234567890";
$jawatan1 = " KETUA SETIAUSAHA ";
$jabatan1 = " KEMENTERIAN SUMBER ASLI DAN ALAM SEKITAR ";
$jawatan2 = " PENGARAH ";
$jabatan2 = " INSTITUT TANAH DAN UKUR NEGARA ";
if(strlen($name) > 43) $FONT_DETAIL_SIZE = $FONT_DETAIL_SIZE-5;

for($i=0; $i<sizeof($course_application_ids); $i++){
$pdf->AddPage();

if($DESIGNMODE == 1){  // debug MODE
$pdf->Image("../images/sijil.jpg", 0, 0, 210, 297);
    $pdf->SetFont('Times','',10);
    for($x=0;$x<210;$x+=10){
        $pdf->text($x,10,"|$x ");
    }
    for($y=0 ; $y<297.0 ; $y+=10){
        $pdf->text(0,$y,"- $y ");
        //Line(float x1, float y1, float x2, float y2)
        $pdf->Line(10,$y,210,$y);
    }    
}

// SERIAL NUMBER

$depts = array('T','UK','TM');
$pdf->SetY(20.0);
$pdf->SetFont('arial','B',15);
$pdf->SetFont($_REQUEST['fontstyle_nosiri'],'B',$_REQUEST['fontsize_nosiri']);
$pdf->Cell(0,5,"TM"."$nosiri_arr[$i]"."08",0,1,'R');

$pdf->SetY(55.0);
$pdf->SetFont($FONT_TYPE_MAIN_TAJUK,'',$FONT_MAIN_TAJUK_SIZE);
$pdf->Cell(0,5," Sijil Penyertaan ",0,1,'C');


//############NAMA PESERTA
$pdf->SetY(81.0);
$pdf->SetFont($FONT_TYPE_TAJUK,'',$FONT_TAJUK_SIZE);
$pdf->Cell(0,$CELL_SPACING_TAJUK,"Dengan ini disahkan",0,1,'C');
//$pdf->SetFont($FONT_TYPE_DETAIL,$FONT_STYLE_DETAIL,$FONT_DETAIL_SIZE);
$pdf->SetFont($_REQUEST['fontstyle_nama'],$FONT_STYLE_DETAIL,$_REQUEST['fontsize_nama']);
$pdf->MultiCell(0,$CELL_SPACING_CONTENT,"$name_arr[$i]",0,'C');
$pdf->SetFont($FONT_TYPE_DETAIL,$FONT_STYLE_DETAIL,$FONT_DETAIL_IC_SIZE);
$pdf->Cell(0,5,"$ic_arr[$i]",0,1,'C');

///////NAMA KURSUS
$pdf->SetY(102.0);
$pdf->SetFont($FONT_TYPE_TAJUK,'',$FONT_TAJUK_SIZE);
$pdf->Cell(0,$CELL_SPACING_TAJUK,"telah menghadiri",0,1,'C');
$pdf->SetFont($FONT_TYPE_DETAIL,$FONT_STYLE_DETAIL,$FONT_DETAIL_SIZE);
$pdf->MultiCell(0,$CELL_SPACING_CONTENT," $kursus ",0,'C');

$Y = $pdf->GetY();
//$pdf->SetY($Y+0.5);
$pdf->SetY(131);
$pdf->SetFont($FONT_TYPE_TAJUK,'',$FONT_TAJUK_SIZE);
$pdf->Cell(0,$CELL_SPACING_TAJUK," untuk ",0,1,'C');
$pdf->SetFont($FONT_TYPE_DETAIL,$FONT_STYLE_DETAIL,$FONT_DETAIL_SIZE);
$pdf->MultiCell(0,$CELL_SPACING_CONTENT,"PEGAWAI DAN KAKITANGAN INSTUNE TANJUNG MALIM DEKAT BEHRANG",0,'C');

$Y = $pdf->GetY();
//$pdf->SetY($Y+0.5);
$pdf->SetY(153);
$pdf->SetFont($FONT_TYPE_TAJUK,'',$FONT_TAJUK_SIZE);
$pdf->SetFontSize($FONT_TAJUK_SIZE);
$pdf->Cell(0,$CELL_SPACING_TAJUK," pada ",0,1,'C');
$pdf->SetFont($FONT_TYPE_DETAIL,$FONT_STYLE_DETAIL,$FONT_DETAIL_SIZE);
$pdf->MultiCell(0,$CELL_SPACING_CONTENT,"$course_tempoh",0,'C');

$Y = $pdf->GetY();
//$pdf->SetY($Y+0.5);
$pdf->SetY(168);
$pdf->SetFont($FONT_TYPE_TAJUK,'',32);
$pdf->SetFontSize($FONT_TAJUK_SIZE);
$pdf->Cell(0,$CELL_SPACING_TAJUK," bertempat ",0,1,'C');
$pdf->SetFont($FONT_TYPE_DETAIL,$FONT_STYLE_DETAIL,$FONT_DETAIL_SIZE);
$pdf->MultiCell(0,$CELL_SPACING_CONTENT,"INSTITUT TANAH DAN UKUR NEGARA\nKEMENTERIAN SUMBER ASLI DAN ALAM SEKITAR\nBEHRANG, 20987 TANJONG MALIM\nPERAK DARUL RIDZUAN",0,'C');

$pdf->SetFontSize($FONT_TT_SIZE);
//Image(string file, float x, float y [, float w [, float h [, string type [, mixed link]]]])
$Y = $pdf->GetY();
$pdf->Image("../images/tt11.jpg", 138, 215, 30, 8);

$pdf->SetY(224.8);
$pdf->Cell(60);
$pdf->Cell(0,$CELL_SPACING_TT," $jawatan1 ",0,1,'C');
$pdf->Cell(60);
$pdf->Cell(0,$CELL_SPACING_TT," $jabatan1 ",0,1,'C');
$pdf->Ln(14);
$pdf->Image("../images/tt22.jpg", 138, 240, 30, 8);
$pdf->Cell(60);
$pdf->Cell(0,$CELL_SPACING_TT," $jawatan2 ",0,1,'C');
$pdf->Cell(60);
$pdf->Cell(0,$CELL_SPACING_TT," $jabatan2 ",0,1,'C');


} // end for

$pdf->Output("../pdf_certificate/$course_name.pdf","F");
$pdf->Output("","I");

?>

