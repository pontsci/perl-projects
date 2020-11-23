#!/usr/bin/envperl
use Modern::Perl;

my $str = "This is a test file";
open( TEST, "> q12.txt" );
say TEST $str;
close(TEST);

my $readStr;
open( TEST, "< q12.txt" );
$readStr = <TEST>;
my @array = split( /\s/, $readStr );
foreach my $word (@array) {
    say $word;
}
close(TEST);
