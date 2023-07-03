#!perl


#!/usr/bin/perl

&find_fileindir("/Users/dell001/Documents/Materials Studio Projects/Untitled_Files/Documents");
sub find_fileindir(){
 local($dir) = @_;
  opendir(DIR,"$dir"|| die "can't open this $dir");
  local @files =readdir(DIR);
  closedir(DIR);
  for $file (@files){
    next if($file=~m/\.$/ || $file =~m/\.\.$/);
    if ($file =~/\.(txt)$/i){
     print "$dir\/$file \n";
    }
    elsif(-d "$dir/$file"){
        find_fileindir("$dir/$file" );
    }
    }
}
