#!/usr/bin/env perl
use Modern::Perl;

my $str = "Ahhh!";
my $regex = 'A(?<capture>\w+?)';
$str =~ /$regex/;
say "$+{capture}";