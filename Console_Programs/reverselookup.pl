#!/usr/bin/env perl
use Modern::Perl;
# We need the Net::hostent library so we can actually do reverse lookups
use Net::hostent;
# Two test addresses to see how it works. The first address should resolve
# to Odin.ist.unomaha.edu and the second ip address does not reverse.
my @ipaddresses = qw/ 137.48.187.123 199.200.9.44 /;
for my $host ( @ipaddresses ) {
 # $name will be where we store the name; we initialize it to the ip address
 my $name = $host;
 # Now we set $name to the hostname if the lookup (gethost) succeeds
 if ( my $h = gethost($host) ) {
 $name = $h->name();
 }
 print "$host has a hostname of $name\n\n";
}