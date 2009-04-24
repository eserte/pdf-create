#!/usr/bin/perl -w
#
# 01-simple.t
#
# simple test page
#

BEGIN { unshift @INC, "lib", "../lib" }
use strict;
use PDF::Create;

print "1..1\n";

my $pdfname = $0;
$pdfname =~ s/\.t/\.pdf/;

my $pdf = new PDF::Create('filename' => "$pdfname",
		  	  'Version'  => 1.2,
			  'PageMode' => 'UseOutlines',
			  'Author'   => 'Markus Baertschi',
			  'Title'    => 'Parabolic WiFi Antenna');

my $root = $pdf->new_page('MediaBox' => $pdf->get_page_size('A4'));

# Prepare 2 fonts
my $f1 = $pdf->font('Subtype'  => 'Type1',
   	            'Encoding' => 'WinAnsiEncoding',
	            'BaseFont' => 'Helvetica');
my $f2 = $pdf->font('Subtype'  => 'Type1',
   	            'Encoding' => 'WinAnsiEncoding',
	            'BaseFont' => 'Helvetica-Bold');

# Add a page which inherits its attributes from $root
my $page = $root->new_page;

# Write the title
$page->stringc($f2, 25, 300, 770, 'Parabolic WiFi Reflector Template');
$page->stringc($f1, 12, 300, 740, 'Markus Baertschi (markus@markus.org)');

# General parameters
my $dy=310; # y offset from page origin
my $ay=280; # y amplitude
my $dx=100; # x offset from page origin
my $p=100; # distance from back to focal point

$page->stringl($f2, 10, 100, 710, 'Introduction');
$page->stringl($f1, 10, 100, 700, 'This template allows you to build a simple, but effective WiFi range extender. The reflector described');
$page->stringl($f1, 10, 100, 690, 'here will concentrate the signal of your access point in one direction. THe range in this direction will');
$page->stringl($f1, 10, 100, 680, 'be much better at the expense of the range in all other directions.');

# Write instructions
$page->stringl($f2, 10, 100, 660, 'Instructions:');
$page->stringl($f1, 10, 100, 650, '- Make square or rectangular reflector from metallic material (Tin foil, etc)');
$page->stringl($f1, 10, 100, 640, '- Bend reflector to parabolic shape');
$page->stringl($f1, 10, 100, 630, '- Fix reflector with the antenna at the focal point');

# Write the labels
$page->stringl($f1, 12, $dx+$p+10, 460, 'Parabola (The reflector must be shaped like this)');
$page->stringl($f1, 10, $dx+$p+30, $ay-10, 'Focal Point (Antenna goes here)');

# Draw the focal point
my $l=30; # Length of cross
$page->line($dx+$p-$l,$dy,$dx+$p+$l,$dy);
$page->line($dx+$p,$dy-$l,$dx+$p,$dy+$l);
$page->newpath;
$page->set_width(0.5);
$page->setrgbcolorstroke(0,0,0);
$page->moveto($dx+$p-$l/2,$dy);
$page->curveto($dx+$p-$l/2,$dy+$l/2*0.55, $dx+$p-$l/2*0.55,$dy+$l/2, $dx+$p,$dy+$l/2);
$page->curveto($dx+$p+$l/2*0.55,$dy+$l/2, $dx+$p+$l/2,$dy+$l/2*0.55, $dx+$p+$l/2,$dy);
$page->curveto($dx+$p+$l/2,$dy-$l/2*0.55, $dx+$p+$l/2*0.55,$dy-$l/2, $dx+$p,$dy-$l/2);
$page->curveto($dx+$p-$l/2*0.55,$dy-$l/2, $dx+$p-$l/2,$dy-$l/2*0.55, $dx+$p-$l/2,$dy);
$page->stroke;


$page->newpath;
$page->set_width(2);
$page->setrgbcolorstroke(0.1,0.2,1);
for (my $y=-$ay; $y<=$ay; $y=$y+2) {
  my $x=$y*$y/(4*$p);
  $page->lineto($x+$dx,$y+$dy);
}
$page->stroke;


my $ay=50; # y amplitude
my $dy=100; # y offset from page origin
my $dx=300; # x offset from page origin
my $p=10; # distance from back to focal point
my $i=0;
$page->newpath;
$page->set_width(1);
$page->setrgbcolorstroke(0.1,0.2,1);
for (my $y=-$ay; $y<=$ay; $y=$y+2) {
  my $x=$y*$y/(4*$p);
  $page->lineto($x+$dx+$i,$y+$dy);
  $i++;$i++;
}
$page->stroke;
$page->newpath;
$i=0;
for (my $y=-$ay; $y<=$ay; $y=$y+2) {
  my $x=$y*$y/(4*$p);
  $page->lineto($x+$dx+$i,$y+$dy+$ay*2);
  $i++;$i++;
}
$page->stroke;
$page->line($dx+$ay+12,$dy-$ay,$dx+$ay+12,$dy+$ay);
$page->line($dx+$ay-10,$dy-$ay+30,$dx+$ay-10,$dy+$ay+30);
$page->line($dx+$ay*3+12,$dy+$ay,$dx+$ay*3+12,$dy+$ay*3);
$page->set_width(3);
$page->line($dx+$ay*2,$dy,$dx+$ay*2,$dy+$ay*2);


# Wrap up the PDF and close the file
$pdf->close;

print "ok 1 # test $0 ended\n";

