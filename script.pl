#!perl
#use strict;


my $arr;

open WEN, "C:/Users/dell001/Documents/Materials Studio Projects/Si-H2O/Si_Files/Documents/Si(100)-SiO2(001)/H2O/H2O-1/Layerforrelaxation CASTEP GeomOpt/Layerforrelaxation CASTEP GeomOpt/Layerforrelaxation CASTEP Energy/Layerforrelaxation.cst_esp"or die $!;;


while($line=<WEN>){

          print $line;

       }

 
close WEN;


#read the Final energy, E  

