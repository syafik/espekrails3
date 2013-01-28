<?php

$k=0;

if($k==1){
require('../font/makefont/makefont.php');

MakeFont('C:\rubyworkspace\instun\public\fpdf153\font\euclidbi.ttf','C:\rubyworkspace\instun\public\fpdf153\font\euclidbi.afm');
}else{

define('FPDF_FONTPATH','./');
require('../fpdf.php');

$pdf=new FPDF();
$pdf->AddFont('marigold','','marigold.php');
$pdf->AddFont('fontsijil','','fontsijil.php');
$pdf->AddFont('euclid','','euclid.php');
$pdf->AddFont('euclidb','','euclidb.php');
$pdf->AddFont('euclidbi','','euclidbi.php');
$pdf->AddPage();
$pdf->SetFont('fontsijil','',24);
$pdf->Cell(0,10,'ABCDEFGHIJKLMNOPQRSTUVWXYZ!',0,1);
$pdf->Cell(0,10,'abcdefghijklmnopqrstuvwxyz!',0,1);
$pdf->Cell(0,10,'1234567890 !',0,1);

$pdf->SetFont('fontsijil','',24);
$pdf->Cell(0,10,'ABCDEFGHIJKLMNOPQRSTUVWXYZ!',0,1);
$pdf->Cell(0,10,'abcdefghijklmnopqrstuvwxyz!',0,1);
$pdf->Cell(0,10,'1234567890 !',0,1);
$pdf->SetFont('fontsijil','',72);
$pdf->Cell(0,10,'Sijil Penyertaan',0,1,'C');


$pdf->Output();
}
?>