<?php


define('FPDF_FONTPATH','./fpdf153/font/');
require('./fpdf153/fpdf.php');

$pdf=new FPDF('P','mm','A4');
$pdf->AddFont('marigold','','marigold.php');
$pdf->AddFont('marigold','I','marigoldi.php');
$pdf->AddFont('fontsijil','','fontsijil.php');
$pdf->AddFont('euclid','','euclid.php');
$pdf->AddFont('euclid','I','euclidbi.php');
$pdf->AddFont('euclid','B','euclidb.php');
$pdf->AddFont('euclid','BI','euclidbi.php');
//$pdf->SetMargins(float left, float top [, float right]) 
$pdf->SetMargins(50, 0, 20); 
$pdf->SetAutoPageBreak(F,0);
$pdf->SetDisplayMode("fullpage","single");

$MODE = 0;

$FONT_TYPE_DETAIL = "times";
$FONT_STYLE_DETAIL = "I";
$FONT_DETAIL_SIZE = 18;
$CELL_SPACING_CONTENT = 7 ; //Spacing kat detail

$FONT_TYPE_MAIN_TAJUK = "fontsijil";
$FONT_STYLE_MAIN_TAJUK = "";
$FONT_MAIN_TAJUK_SIZE = 60 ;

$FONT_TYPE_TAJUK = "fontsijil";
$FONT_STYLE_TAJUK = "";
$FONT_TAJUK_SIZE = 24 ;
$CELL_SPACING_TAJUK = 10 ;

$FONT_TT_SIZE = 12 ; 
$FONT_TT_STYLE = "";
$CELL_SPACING_TT = 4 ;

$kursus = "KURSUS PENGENDALIAN DAN PENGUNAAN TELESKOP ASTRONOMI UNTUK RUKYAH";
$tempat = "INSTITUT TANAH DAN UKUR NEGARA\nKEMENTERIAN SUMBER ASLI DAN ALAM SEKITAR\nBEHRANG, 20987 TANJONG MALIM\nPERAK DARUL RIDZUAN";
$name = "1234567890 1234567890 1234567890 1234567890";
$jawatan1 = " KETUA SETIAUSAHA ";
$jabatan1 = " KEMENTERIAN SUMBER ASLI DAN ALAM SEKITAR ";
$jawatan2 = " PENGARAH ";
$jabatan2 = " INSTITUT TANAH DAN UKUR NEGARA ";
if(strlen($name) > 43) $FONT_DETAIL_SIZE = $FONT_DETAIL_SIZE-5;

$pdf->AddPage();

if($MODE == 1){  // debug MODE
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


$pdf->SetY(60.0);
$pdf->SetFont($FONT_TYPE_MAIN_TAJUK,'',$FONT_MAIN_TAJUK_SIZE);
$pdf->Cell(0,5," Sijil Penyertaan ",0,1,'C');

$pdf->SetY(86.0);
$pdf->SetFont($FONT_TYPE_TAJUK,'',$FONT_TAJUK_SIZE);
$pdf->Cell(0,$CELL_SPACING_TAJUK,"Dengan ini disahkan",0,1,'C');
$pdf->SetFont($FONT_TYPE_DETAIL,$FONT_STYLE_DETAIL,$FONT_DETAIL_SIZE);
$pdf->MultiCell(0,$CELL_SPACING_CONTENT,"$name",0,'C');
$pdf->Cell(0,5,"888888-88-88",0,1,'C');

$pdf->SetY(110.0);
$pdf->SetFont($FONT_TYPE_TAJUK,'',$FONT_TAJUK_SIZE);
$pdf->Cell(0,$CELL_SPACING_TAJUK,"Telah menghadiri Kursus",0,1,'C');
$pdf->SetFont($FONT_TYPE_DETAIL,$FONT_STYLE_DETAIL,$FONT_DETAIL_SIZE);
$pdf->MultiCell(0,$CELL_SPACING_CONTENT," $kursus ",0,'C');

$Y = $pdf->GetY();
$pdf->SetY($Y+0.5);
$pdf->SetFont($FONT_TYPE_TAJUK,'',$FONT_TAJUK_SIZE);
$pdf->Cell(0,$CELL_SPACING_TAJUK," untuk ",0,1,'C');
$pdf->SetFont($FONT_TYPE_DETAIL,$FONT_STYLE_DETAIL,$FONT_DETAIL_SIZE);
$pdf->MultiCell(0,$CELL_SPACING_CONTENT,"PEGAWAI DAN KAKITANGAN INSTUNE TANJUNG MALIM DEKAT BEHRANG",0,'C');

$Y = $pdf->GetY();
$pdf->SetY($Y+0.5);
$pdf->SetFont($FONT_TYPE_TAJUK,'',$FONT_TAJUK_SIZE);
$pdf->SetFontSize($FONT_TAJUK_SIZE);
$pdf->Cell(0,$CELL_SPACING_TAJUK," pada ",0,1,'C');
$pdf->SetFont($FONT_TYPE_DETAIL,$FONT_STYLE_DETAIL,$FONT_DETAIL_SIZE);
$pdf->MultiCell(0,$CELL_SPACING_CONTENT,"20 HINGGA 31 FEBRUARY 2006",0,'C');

$Y = $pdf->GetY();
$pdf->SetY($Y+0.5);
$pdf->SetFont($FONT_TYPE_TAJUK,'',32);
$pdf->SetFontSize($FONT_TAJUK_SIZE);
$pdf->Cell(0,$CELL_SPACING_TAJUK," bertempat ",0,1,'C');
$pdf->SetFont($FONT_TYPE_DETAIL,$FONT_STYLE_DETAIL,$FONT_DETAIL_SIZE);
$pdf->MultiCell(0,$CELL_SPACING_CONTENT,"INSTITUT TANAH DAN UKUR NEGARA\nKEMENTERIAN SUMBER ASLI DAN ALAM SEKITAR\nBEHRANG, 20987 TANJONG MALIM\nPERAK DARUL RIDZUAN",0,'C');

$pdf->SetFontSize($FONT_TT_SIZE);
//Image(string file, float x, float y [, float w [, float h [, string type [, mixed link]]]])
$pdf->Ln(10);
$pdf->Image("./images/tt1.jpg", 140, 240, 30, 8);
$pdf->Cell(60);
$pdf->Cell(0,$CELL_SPACING_TT," $jawatan1 ",0,1,'C');
$pdf->Cell(60);
$pdf->Cell(0,$CELL_SPACING_TT," $jabatan1 ",0,1,'C');
$pdf->Ln(15);
$pdf->Image("./images/tt1.jpg", 140, 260, 30, 8);
$pdf->Cell(60);
$pdf->Cell(0,$CELL_SPACING_TT," $jawatan2 ",0,1,'C');
$pdf->Cell(60);
$pdf->Cell(0,$CELL_SPACING_TT," $jabatan2 ",0,1,'C');


$pdf->Output('./sijil/test.pdf','I');

?>