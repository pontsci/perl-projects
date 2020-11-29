#!/usr/bin/env perl
use Modern::Perl;

my $test = "Test 1";
$test =~ /(?:\w+|\w+ \d)/;
say $1;