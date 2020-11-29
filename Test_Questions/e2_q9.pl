#!/usr/bin/env perl
use Modern::Perl;

my $str = "Title";
my @array = ("test", "test2", "test3");

passArray(\@array, $str);

sub passArray{
    my $arrayRef = $_[0];
    my $passedStr   = $_[1];

    my @passedArray = @$arrayRef;

    say $passedStr;
    say "@passedArray";
}