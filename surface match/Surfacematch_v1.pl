#!perl
#Surfacematch_v1, Author: Yangyang Lu at SWJTU,19/4/2019, 2366488430@qq.com
#This is perl script for matching the surface for Crystal plane to make layers in the Materials Studio. 
#
# step 1 bulid a new folder in the in the Materials Studio project
# step 2 put this file and the file you want to find the surface with the crystal surface you have Known 
# step 3 change the name at  my $filename = "____"with your crystal structure filename
# step 4 set the max Miller index in my $SearchAreaA = __, my $SearchAreaB = __, my $SearchAreaC = __;
# step 5 set the a, b and angle of the crystal surface you have Known at my $a = __; my $b = __; my $angle = __;
# step 6 ste the max supercell you can accept
# step 7 run it ,then you will get the result at SurfacemathReault.txt 

use strict;
use Getopt::Long;
use MaterialsScript qw(:all);

my $filename = "SiO2_quartz";
my $doc = $Documents{"$filename.xsd"};
my $pos = Documents->New("SurfacemathReault.txt");
my $lattice = $doc->SymmetryDefinition;
my $FT;
my @num_atom; 
my @element;
my $ele;
my $num;
my $testif;
my $surfaceDoc;

my $Mismatchdegree = 0.05;
my $Mismatchangle =2;
my $SearchAreaA = 2;
my $SearchAreaB = 2;
my $SearchAreaC = 2;

my $a = 3.791348;
my $b = 4.791348;
my $angle = 90;

my $supercellA = 5;
my $supercellB = 5;


my $a1;
my $a2;
my $a3;

my $b1;
my $b2;
my $c1;
my $c2;
my $d1;
my $d2;



 
for($a1 = -$SearchAreaA; $a1 <= $SearchAreaA; $a1 = $a1 + 1 ){
  for( $a2 = -$SearchAreaB; $a2 <= $SearchAreaB; $a2 = $a2 + 1 ){
    for( $a3 = -$SearchAreaC; $a3 <= $SearchAreaC; $a3 = $a3 + 1 ){
         if(($a1 != 0)||($a2 != 0)||($a3 != 0)){
           Tools->SurfaceBuilder->CleaveSurface->DefineCleave($doc,
                                                   MillerIndex(H => $a1,
                                                               K => $a2,
                                                               L => $a3));
           Tools->SurfaceBuilder->ChangeSettings(Settings(ResetSurfaceOrientation => "Yes"));
           Tools->SurfaceBuilder->CleaveSurface->SetThickness(15.0, "Angstrom");
           my $surfaceDoc = Tools->SurfaceBuilder->CleaveSurface->Cleave;

           my $lattice = $surfaceDoc->Lattice2D;
           my $lattice = $surfaceDoc->SymmetryDefinition;
           if(abs($lattice->AngleTheta - $angle) <= $Mismatchangle){

#au-bv 
 for($b1 = 1; $b1 <= $supercellA; $b1 = $b1 + 1 ){
          for( $b2 = 1; $b2 <= $supercellB; $b2 = $b2 + 1 ){
             $d1 = ($a*$b1)/($lattice->LengthU);
             $d2 = ($b*$b2)/($lattice->LengthV);
             if(($d1 >= 1)&&($d2 >= 1)){
               
                 for($c1 = 1; $c1 <= $d1 + 1; $c1 = $c1 + 1 ){
                 for( $c2 = 1; $c2 <= $d2 + 1; $c2 = $c2 + 1 ){
                    if(((abs((($a*$b1)-(($lattice->LengthU)*$c1))/(($a*$b1)+(($lattice->LengthU)*$c1)))) < ($Mismatchdegree))&&((abs((($b*$b2)-(($lattice->LengthV)*$c2))/(($b*$b2)+(($lattice->LengthV)*$c2)))) < ($Mismatchdegree))){
                      
                        $pos->Append(sprintf "Surface(%i %i %i)\n",$a1, $a2, $a3);
                        $pos->Append(sprintf "a-U,b-V \n");
                        $pos->Append(sprintf "%i U,%i V \n",$c1, $c2);
                        $pos->Append(sprintf "Lattice parameters\n");
                        $pos->Append(sprintf "U = %.2f V = %.2f \n",$lattice->LengthU, $lattice->LengthV);
                        $pos->Append(sprintf "Angle = %.2f\n",$lattice->AngleTheta);
                        $pos->Append(sprintf "%i a,%i b \n",$b1, $b2);
                        $pos->Append(sprintf "\n");
                     }

                  }
                 }
               }
               elsif(($d1 >= 1)&&($d2 < 1)){
               for($c1 = 1; $c1 <= $d1 + 1; $c1 = $c1 + 1 ){
                    if(((abs((($a*$b1)-(($lattice->LengthU)*$c1))/(($a*$b1)+(($lattice->LengthU)*$c1))) < ($Mismatchdegree))&&((abs((($b*$b2)-(($lattice->LengthV)))/(($b*$b2)+($lattice->LengthV)))) < ($Mismatchdegree)))){
                     
                        $pos->Append(sprintf "Surface(%i %i %i)\n",$a1, $a2, $a3);
                        $pos->Append(sprintf "a-U,b-V \n");
                        $pos->Append(sprintf "%i U,1 V \n",$c1);
                        $pos->Append(sprintf "Lattice parameters\n");
                        $pos->Append(sprintf "U = %.2f V = %.2f \n",$lattice->LengthU, $lattice->LengthV);
                        $pos->Append(sprintf "Angle = %.2f\n",$lattice->AngleTheta);
                        $pos->Append(sprintf "%i a,%i b \n",$b1, $b2);
                        $pos->Append(sprintf "\n");

                    }

               }

               }
               
               
             elsif(($d1 < 1)&&($d2 >= 1)){

                 for( $c2 = 1; $c2 <= $d2 + 1; $c2 = $c2 + 1 ){
                    if(((abs((($a*$b1)-(($lattice->LengthU)))/(($a*$b1)+($lattice->LengthU)))) < ($Mismatchdegree))&&((abs((($b*$b2)-(($lattice->LengthV)*$c2))/(($b*$b2)+((($lattice->LengthV)*$c2)))) < ($Mismatchdegree)))){
                      

                        $pos->Append(sprintf "Surface(%i %i %i)\n",$a1, $a2, $a3);
                        $pos->Append(sprintf "a-U,b-V \n");
                        $pos->Append(sprintf "1 U,%i V \n",$c2);
                        $pos->Append(sprintf "Lattice parameters\n");
                        $pos->Append(sprintf "U = %.2f V = %.2f \n",$lattice->LengthU, $lattice->LengthV);
                        $pos->Append(sprintf "Angle = %.2f\n",$lattice->AngleTheta);
                        $pos->Append(sprintf "%i a,%i b \n",$b1, $b2);
                        $pos->Append(sprintf "\n");

                    }

                 }
               }
               
               elsif(($d1 < 1)&&($d2 < 1)){
               
                  if(((abs((($a*$b1)-(($lattice->LengthU)))/(($a*$b1)+($lattice->LengthU)))) < ($Mismatchdegree))&&((abs((($b*$b2)-(($lattice->LengthV)))/(($b*$b2)+($lattice->LengthV)))) < ($Mismatchdegree))){
                      

                        $pos->Append(sprintf "Surface(%i %i %i)\n",$a1, $a2, $a3);
                        $pos->Append(sprintf "a-U,b-V \n");
                        $pos->Append(sprintf "1 U,1 V \n");
                        $pos->Append(sprintf "Lattice parameters\n");
                        $pos->Append(sprintf "U = %.2f V = %.2f \n",$lattice->LengthU, $lattice->LengthV);
                        $pos->Append(sprintf "Angle = %.2f\n",$lattice->AngleTheta);
                        $pos->Append(sprintf "%i a,%i b \n",$b1, $b2);
                        $pos->Append(sprintf "\n");

                      
                    }

                }
             

             }
          }

#aV-bu
for($b1 = 1; $b1 <= $supercellA; $b1 = $b1 + 1 ){
          for( $b2 = 1; $b2 <= $supercellB; $b2 = $b2 + 1 ){
             $d1 = ($a*$b1)/($lattice->LengthV);
             $d2 = ($b*$b2)/($lattice->LengthU);
             if(($d1 >= 1)&&($d2 >= 1)){
    
                 for($c1 = 1; $c1 <= $d1 + 1; $c1 = $c1 + 1 ){
                 for( $c2 = 1; $c2 <= $d2 + 1; $c2 = $c2 + 1 ){
                 if(((abs((($b*$b2)-(($lattice->LengthU)*$c1))/(($b*$b2)+(($lattice->LengthU)*$c1)))) < ($Mismatchdegree))&&((abs((($a*$b1)-(($lattice->LengthV)*$c2))/(($a*$b1)+(($lattice->LengthV)*$c2)))) < ($Mismatchdegree))){
                  
                      
                        $pos->Append(sprintf "Surface(%i %i %i)\n",$a1, $a2, $a3);
                        $pos->Append(sprintf "a-V,b-U \n");
                        $pos->Append(sprintf "%i V,%i U \n",$c1, $c2);
                        $pos->Append(sprintf "Lattice parameters\n");
                        $pos->Append(sprintf "U = %.2f V = %.2f \n",$lattice->LengthU, $lattice->LengthV);
                        $pos->Append(sprintf "Angle = %.2f\n",$lattice->AngleTheta);
                        $pos->Append(sprintf "%i a,%i b \n",$b1, $b2);
                        $pos->Append(sprintf "\n");
                      
                    }

                 }
                 }
               }
               elsif(($d1 >= 1)&&($d2 < 1)){
               for($c1 = 1; $c1 <= $d1 + 1; $c1 = $c1 + 1 ){
                     if(((abs((($b*$b2)-(($lattice->LengthU)*$c1))/(($b*$b2)+(($lattice->LengthU)*$c1))) < ($Mismatchdegree))&&((abs((($a*$b1)-(($lattice->LengthV)))/(($a*$b1)+($lattice->LengthV)))) < ($Mismatchdegree)))){
                     
                        $pos->Append(sprintf "Surface(%i %i %i)\n",$a1, $a2, $a3);
                        $pos->Append(sprintf "a-V,b-U \n");
                        $pos->Append(sprintf "%i V,1 U \n",$c1);
                        $pos->Append(sprintf "Lattice parameters\n");
                        $pos->Append(sprintf "U = %.2f V = %.2f \n",$lattice->LengthU, $lattice->LengthV);
                        $pos->Append(sprintf "Angle = %.2f\n",$lattice->AngleTheta);
                        $pos->Append(sprintf "%i a,%i b \n",$b1, $b2);
                        $pos->Append(sprintf "\n");

                      
                    }

               

               }
               }
               
             elsif(($d1 < 1)&&($d2 >= 1)){

                 for( $c2 = 1; $c2 <= $d2 + 1; $c2 = $c2 + 1 ){
                  if(((abs((($b*$b2)-(($lattice->LengthU)))/(($b*$b2)+($lattice->LengthU)))) < ($Mismatchdegree))&&((abs((($a*$b1)-(($lattice->LengthV)*$c2))/(($a*$b1)+((($lattice->LengthV)*$c2)))))) < ($Mismatchdegree)){
                      

                        $pos->Append(sprintf "Surface(%i %i %i)\n",$a1, $a2, $a3);
                        $pos->Append(sprintf "a-V,b-U \n");
                        $pos->Append(sprintf "1 V,%i U \n",$c2);
                        $pos->Append(sprintf "Lattice parameters\n");
                        $pos->Append(sprintf "U = %.2f V = %.2f \n",$lattice->LengthU, $lattice->LengthV);
                        $pos->Append(sprintf "Angle = %.2f\n",$lattice->AngleTheta);
                        $pos->Append(sprintf "%i a,%i b \n",$b1, $b2);
                        $pos->Append(sprintf "\n");

                      
                    }

                 }
               }
               
               elsif(($d1 < 1)&&($d2 < 1)){
                   if(((abs((($b*$b2)-(($lattice->LengthU)))/(($b*$b2)+($lattice->LengthU)))) < ($Mismatchdegree))&&((abs((($a*$b1)-(($lattice->LengthV)))/(($a*$b1)+($lattice->LengthV)))) < ($Mismatchdegree))){
                      

                        $pos->Append(sprintf "Surface(%i %i %i)\n",$a1, $a2, $a3);
                        $pos->Append(sprintf "a-V,b-U \n");
                        $pos->Append(sprintf "1 V,1 U \n");
                        $pos->Append(sprintf "Lattice parameters\n");
                        $pos->Append(sprintf "U = %.2f V = %.2f \n",$lattice->LengthU, $lattice->LengthV);
                        $pos->Append(sprintf "Angle = %.2f\n",$lattice->AngleTheta);
                        $pos->Append(sprintf "%i a,%i b \n",$b1, $b2);
                        $pos->Append(sprintf "\n");

                      
                  }

                }
             

             }
             }
             
             
           }  
           
            $surfaceDoc->Delete;
            
            
          
         }

      }
   }
 }






