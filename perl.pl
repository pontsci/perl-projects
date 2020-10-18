#!/usr/bin/env perl
use Modern::Perl;

print 'Enter a greeting: ';
my $greeting = <>;
chomp $greeting;
print $greeting;
print "This follows the greeting.\n";