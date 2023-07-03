#!perl

use strict;
use Getopt::Long;
use MaterialsScript qw(:all);
#!/usr/bin/perl
my $pos = Documents->New("Data2.txt");
my $path = "C:/Users/dell001/Documents/Materials Studio Projects/ChargeDensity/Gr0-3_Files/Documents/X3";
$pos ->close;
##############################################
 open D, "+>$path./data3/Data2.txt"or die $!;;;
 print D "File_path    coordinate(ai)       E_total(eV)              E_top_layer_Gr(eV)        E_bottom_layer_Gr(eV)        E_ad(eV)            E_ad/per_atom(eV/atom)            E_ad/per_area(eV/ai*2) \n";
# close D;
#Write the header of the extracted information
##############################################

my $lattice_a = 4.92422;
my $lattice_b = 4.92422;
my $lattice_angle = 119.99497;
my $area = $lattice_a * $lattice_b * sin($lattice_angle/180*3.14159265358979);
my $total_atoms = 16;
my $total_file_unmber = 48;
my $slide_dostance = 4.26438;
my $per_slide_dostance = $slide_dostance/$total_file_unmber;

#print "$area";
for(my $i= 0;$i<= $total_file_unmber;$i= $i +1)
{
  print D "$i          ";
   my $coordinate = $i * $per_slide_dostance;
  print D "$coordinate          ";

#########################################
#get the Final energy, E from _______.castep from layrer1_2
   my @arr1_2;
   my @data1_2;
   my $path12 = "$path/twolayer/Gr-Gr3A$i CASTEP GeomOpt/Gr-Gr3A$i.castep";
   
   
   open WEN12, "$path12."or die $!;;;
                       
   while(<WEN12>)
   {
   
   if(/^.{0}Dispersion corrected final energy/){
       @arr1_2= $_;;
      }
   }
   #print "@arr1_2[$#arr1_2]";
   my $data_Etotal1_2 = @arr1_2[$#arr1_2];
   my $Etotal1_2;
   my $str = $_;
   my @array = split /\s+/, $data_Etotal1_2;  
    my $unmber = $#array;
    
    for(my $ins= 0;$ins<= $unmber;$ins= $ins +1)
    {    
    if ((@array[$ins]=~/-\d+\.\d+/)||(@array[$ins]=~/\d+\.\d+/))
    {    
    $Etotal1_2 = @array[$ins] ;
    }
    } 
   #print "$Etotal1_2";
   print D "$Etotal1_2          ";
   close WEN12;
########################################

#########################################
#get the Final energy, E from _______.castep from layrer2
   my @arr2;
   my @data2;
   my $path2 = "$path/onelayer/1Gr-Gr3A0 CASTEP GeomOpt/1Gr-Gr3A0.castep";
   open WEN2, "$path2."or die $!;;;
                       
   while(<WEN2>)
   {
   
   if(/^.{0}Dispersion corrected final energy/){
       @arr2= $_;;
      }
   }
   #print "@arr2[$#arr2]";
   my $data_Etotal2 = @arr2[$#arr2];
   my $Etotal2;
   my $str = $_;
   my @array = split /\s+/, $data_Etotal2;  
    my $unmber = $#array;
    
    for(my $ins= 0;$ins<= $unmber;$ins= $ins +1)
    {    
    if ((@array[$ins]=~/-\d+\.\d+/)||(@array[$ins]=~/\d+\.\d+/))
    {    
    $Etotal2 = @array[$ins] ;
    }
    } 
   #print "$Etotal2";
   print D "$Etotal2          ";
   close WEN2;
########################################

#########################################
#get the Final energy, E from _______.castep from layrer1_2
   my @arr1;
   my @data1;
   my $path1 = "$path/anotherlayer/Gr-Gr3A CASTEP GeomOpt/Gr-Gr3A.castep";
   open WEN1, "$path1."or die $!;;;
                       
   while(<WEN1>)
   {
   
   if(/^.{0}Dispersion corrected final energy/){
       @arr1= $_;;
      }
   }
   #print "@arr1[$#arr1]";
   my $data_Etotal1 = @arr1[$#arr1];
   my $Etotal1;
   my $str = $_;
   my @array = split /\s+/, $data_Etotal1;  
    my $unmber = $#array;
    
    for(my $ins= 0;$ins<= $unmber;$ins= $ins +1)
    {    
    if ((@array[$ins]=~/-\d+\.\d+/)||(@array[$ins]=~/\d+\.\d+/))
    {    
    $Etotal1 = @array[$ins] ;
    }
    } 
   #print "$Etotal1";
   print D "$Etotal1            ";
   close WEN1;
   
       my $Ead = $Etotal1_2 - $Etotal2 - $Etotal1;
       my $E_atoms = $Ead / $total_atoms;
       my $E_average = $Ead/ $area;
       print D "$Ead          ";
       print D "$E_atoms          ";
       print D "$E_average          ";
       
   print D "\n";
########################################


}