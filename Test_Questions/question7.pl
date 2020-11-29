#!/usr/bin/env perl
use Modern::Perl;

my @nums = ();

print "Enter a number: ";
while(chomp(my $input = <>)){
    last if($input eq 'stop');
    push @nums, $input;
    print "Enter a number: ";
}

my @numsCubed = map { $_ ** 3 } @nums;

say("@numsCubed");