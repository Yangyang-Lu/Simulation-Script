#!perl

use strict;
use Getopt::Long;
use MaterialsScript qw(:all);
my $i;
my $total =61;
my $pos = Documents->New("POSCAR.txt");

for($i=1;$i<=$total;$i=$i+1){
my $filename = "$i";
my $doc = $Documents{"$filename.xsd"};


my $FT;
my @num_atom; 
my @element;
my $ele;
my $num;
my $testif;
my $FT1;
my $FT2;
my $FT3;


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

#foreach $ele (@element) {
   #$pos->Append(sprintf "$ele ");
#}
#$pos->Append(sprintf "\n");
my $totalatomnum = 0;
foreach $num (@num_atom) {
   $totalatomnum =$totalatomnum + $num;
   #$pos->Append(sprintf "$num ");
}
$pos->Append(sprintf "$totalatomnum\n");
$pos->Append(sprintf "Frame $i  \n");

foreach my $atom (@sortedAt) {




$pos->Append(sprintf "%s %f %f %f \n", $atom->ElementSymbol, $atom->XYZ->X, $atom->XYZ->Y, $atom->XYZ->Z);
}

$doc->close;

}



