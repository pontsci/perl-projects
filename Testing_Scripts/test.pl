#!/usr/bin/env perl
 use Modern::Perl;
 my $x = "Helxlxlxlxlxlxlxlxlxlxlxlo";
 print "Original: $x\n\n";
 $x =~ /H(.*)l/; # greedy, greedy!
 print "Greedy: $1\n\n";
 $x =~ /H(.*?)l/; # non-greedy
 print "Non-greedy: $1\n\n";