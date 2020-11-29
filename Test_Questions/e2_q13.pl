#!/usr/bin/envperl
use Modern::Perl;

#the IP
my $host = $+{IP};

# $name will be where we store the name; we initialize it to the ip address
my $name = $host;

if ( !defined $hostsToNames{$host} ) {

    # Now we set $name to the hostname if the lookup (gethost) succeeds
    if ( my $h = gethost($host) ) {
        $name = $h->name();
    }
    $hostsToNames{$host} = "$name";
    $hostnames{$name}++;
}
else {
    $hostnames{ $hostsToNames{$host} }++;
}