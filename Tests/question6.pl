#!/usr/bin/env perl
use Modern::Perl;

my $sum = 0;
for my $num (1..9999){
    if($num % 2 == 0){
        $sum += $num;
    }
}

say $sum;