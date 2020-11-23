#!/usr/bin/env perl
use Modern::Perl;

print "Enter base: ";
chomp(my $num = <>);
print "Enter exponent: ";
chomp(my $exponent = <>);

say $num ** $exponent;