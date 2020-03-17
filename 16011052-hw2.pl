use strict;
use warnings;
use GD::Simple;

sub init_dot_matrix { #line1 , line2, dot_matrix
    my ($i, $j, $idx);
    for($i = 0; $i < length($_[0]) + 1 ; $i++){ 
        for($j = 0; $j < length($_[1]) + 1; $j++){
            $_[2][$i][$j] = 0;
        } 
    }
    $idx = 1;
    foreach $i (split('', $_[0])){
         $_[2][0][$idx++] = $i;
    }
    $idx = 1;
    foreach $j (split('', $_[1])){
        $_[2][$idx++][0] = $j;
    }
    
}

sub print_dot_matrix { # w, h, dot_matrix
    my ($i, $j);
    for($i = 0; $i < $_[0]+1; $i++) {
        for($j = 0; $j < $_[1]+1; $j++){ 
            print "$_[2][$i][$j] ";  
        }
        print "\n";
    }
}

sub show_dot_matrix {
    my $coeff  = 2400 / $_[0]; 
    my $img = GD::Simple->new(($_[0] + 1) * $coeff, ($_[1] + 1) * $coeff); 
    $img->bgcolor('white');
    $img->fgcolor('black');
    $img->font("c:\\windows\\fonts\\Coprgtb.ttf");
    $img->fontsize($coeff/1.5);

    my ($i, $j);
    for($i = 1; $i < $_[0] + 1; $i++){
        $img->moveTo($coeff/3, $i * $coeff + $coeff);
        $img->string($_[2][0][$i]);
    }
    for($i = 1; $i < $_[1] + 1; $i++){
        $img->moveTo($i * $coeff+ $coeff / 3, $coeff);
        $img->string($_[2][$i][0]);
    }
    $img->bgcolor('black');
    $img->fgcolor('white');
    for($i = 1; $i < $_[0] + 1; $i++){
        for($j = 1; $j < $_[1] + 1; $j++){
            if($_[2][$i][$j] eq 1){
                $img->rectangle($coeff*$i, $coeff*$j, $coeff*$i+$coeff, $coeff*$j+$coeff);
            }
        }
    }
    my $filename = $_[3]."_".$_[0]."x".$_[1]."_".int(rand(100)).'.png';
    open my $out, '>', $filename or die;
    binmode $out;
    print $out $img->png;
    close($out);
    system($filename);
}

sub fill_dot_matrix {  # w, h, dot_matrix
    my ($i, $j);
    for($i = 1; $i < $_[0]+1; $i++) {
        for($j = 1; $j < $_[1]+1; $j++){ 
            if ($_[2][$i][0] eq $_[2][0][$j]){
                $_[2][$i][$j] = 1;
            } else {
                $_[2][$i][$j] = 0;
            }  
        }
    }
}
sub compute_noise {
    
}
open(INPUT_FILE, "<", "input.txt") or die "Can't open input.txt file";
open(OUTPUT_FILE, ">", "output.txt") or die "Can't open output.txt file";

my $line1;
my $line2;

do{
    $line1 = <INPUT_FILE>;
    $line2 = <INPUT_FILE>;
    if(length($line1) > 1 || length($line2) > 1){
        chomp($line1);
        chomp($line2);
        my @dot_matrix;
        init_dot_matrix($line1, $line2, \@dot_matrix);
        #print_dot_matrix(length($line1), length($line2), \@dot_matrix);
        fill_dot_matrix(length($line1), length($line2), \@dot_matrix);
        #print_dot_matrix(length($line1), length($line2), \@dot_matrix);
        show_dot_matrix(length($line1), length($line2), \@dot_matrix, "dot_matrix");
    }
}while($line1 && $line2);