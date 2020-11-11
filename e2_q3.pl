#!/usr/bin/env perl
use Modern::Perl;

my $test = "tHe";

if($test =~ /(the|and|but)/i){
    say "True";
}else{
    say "False";
}