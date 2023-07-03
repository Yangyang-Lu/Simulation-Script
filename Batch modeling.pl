#!perl

use strict;
use Getopt::Long;
use MaterialsScript qw(:all);

my $filename = "Gr-Gr";
my $originDoc = $Documents{"$filename.xsd"};
my $point = 48;

my $point_a = 0.000140;
my $point_b = 4.923977;
#my $point_c;
my $point_d = 2.132494;
my $point_e = 1.231005;
#my $point_f;

my $distance_1 = ($point_d-$point_a)/$point;
my $distance_2 = ($point_e-$point_b)/$point;
#my $distance_3 = ($point_f-$point_c)/$point;





my $lattice = $originDoc->SymmetryDefinition;
my $FT;
my @num_atom; 
my @element;
my $ele;
my $num;
my $testif;
my $FT1;
my $FT2;
my $FT3;
for(my $i =1;$i<=$point;$i=$i+1)
{
my $doc=$originDoc->SaveAs($filename.$i." .xsd" )||die "cannot open the xsd file: $!\n";

my $atoms = $doc->UnitCell->Atoms;
my @sortedAt = sort {$a->AtomicNumber <=> $b->AtomicNumber} @$atoms;

my $count_el=0;
my $count_atom = 0;
   $element[0]=$sortedAt[0]->ElementSymbol;
my $atom_num = $sortedAt[0]->AtomicNumber;
foreach my $atom (@sortedAt) {
  if ($atom->AtomicNumber == $atom_num) {
    $count_atom=$count_atom+1;
  } else {
    $num_atom[$count_el] = $count_atom;
    $count_atom = 1;
    $count_el = $count_el+1;
    $element[$count_el]=$atom->ElementSymbol;
    $atom_num = $atom->AtomicNumber;
  }
}
$num_atom[$count_el] = $count_atom;

my @MoveAtomIndex = ("9","10","11","12","13","14","15","16");

foreach my $atoms (@sortedAt) {

 map { if ($atoms->ServerAtomIndex eq $_) {

# move atoms  
#$atoms->Fix("X");

$atoms->XYZ = Point(X => $atoms->XYZ -> X + $distance_1*$i, Y => $atoms->XYZ -> Y + $distance_2*$i, Z => $atoms->XYZ -> Z );

}} @MoveAtomIndex;

}
      
$doc->Close;


}
 close all;

