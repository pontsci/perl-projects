#!/usr/bin/env perl
use Modern::Perl;

print "Enter first number: ";
my $num1 = <>;

print "Enter second number: ";
my $num2 = <>;

print "Enter third number: ";
my $num3 = <>;

chomp $num1;
chomp $num2;
chomp $num3;

print "ADD:", ($num1 + $num2 + $num3), "\n";
printf "AVG:%.3f\n", (($num1 + $num2 + $num3)/3);
print "PRD:", ($num1 * $num2 * $num3), "\n",;

my $largest = $num1;

if($num2 > $largest){
    $largest = $num2;
}
if($num3 > $largest){
    $largest = $num3;
}

print "LRG:", $largest, "\n";

my $smallest = $num1;

if($num2 < $smallest){
    $smallest = $num2;
}
if($num3 < $smallest){
    $smallest = $num3;
}

print "SML:", $smallest, "\n";