#!/usr/bin/env perl
use Modern::Perl;
use experimental 'smartmatch';
use Net::hostent;

my $argvLength = @ARGV;

#exit if no args
if ( $argvLength == 0 ) {
    printf "usage: %s log1 [log2 ...]\n", $0;
    exit(0);
}

#get the file names
my @fileNames;
foreach my $arg (@ARGV) {
    push @fileNames, $arg;
}

#declare hashes
my %hostsToNames;
my %hostnames;
my %domains;
my %dates;
my %hours;
my %statuses;
my %urls;
my %fileTypes;
my %useragents;
my %browserFamilies;
my %referrers;
my %referrerDomains;
my %operatingSystems;

#for stroing bytes total
my $bytesTotal = 0;

#the regex
my $regex =
'(?<IP>\d+\.\d+\.\d+\.\d+)\s+-+\s+-+\s+\[(?<date>\d+\/\w{3}\/\d{4}):(?<hour>\d{2}):\d{2}:\d{2} -\d{4}\] "\S+\s+(?<URL>\S+).*?"\s+(?<status>\d{3})\s+(?<bytes>\d+)\s+"(?<referrer>\S+?)"\s+"(?<useragent>.*?)"';

#iteration counting
my $count = 0;
#line by line, add to the values within all the hashes with the given input
while (<ARGV>) {
    #for iteration counting prints, comment out $count++ and uncomment the printf line
    $count++;
    #printf( "Iteration: %d\n", ++$count );

    #perform the regex on the line
    $_ =~ /$regex/g;

    #sum up the bytes
    $bytesTotal += $+{bytes};

    #the host is the IP
    my $host = $+{IP};

    # $name will be where we store the name; we initialize it to the ip address
    my $name = $host;

    #if I haven't seen this host, create an entry for it containing its name
    if ( !defined $hostsToNames{$host} ) {
        # Now we set $name to the hostname if the lookup (gethost) succeeds
        if ( my $h = gethost($host) ) {
            $name = $h->name();
        }
        $hostsToNames{$host} = "$name";
        $hostnames{$name}++;
    }
    else {
        #if I have seen this host before, get its name
        #printf( "Seen! %s has a name of: %s\n", $host, $hostsToNames{$host} );
        $hostnames{ $hostsToNames{$host} }++;
    }

    #names are the same so there is no host name
    if ( $hostsToNames{$host} eq $host ) {
        $domains{"DOTTED QUAD OR OTHER"}++;
    }
    else {
    #split up the string on "." then put together the last two items to create the domain
        my @nameSplit        = split( /\./, $hostsToNames{$host} );
        my $firstPartDomain  = $nameSplit[ $#nameSplit - 1 ];
        my $secondPartDomain = $nameSplit[$#nameSplit];
        my $domainString     = $firstPartDomain . "." . $secondPartDomain;
        $domains{$domainString}++;
    }

    #setup dates hash
    my $date = $+{date};
    $dates{$date}++;

    #setup hours hash
    my $hour = $+{hour};
    $hours{$hour}++;

    #setup statuses hash
    my $status = $+{status};
    $statuses{$status}++;

    #setup urls hash
    my $url = $+{URL};
    $urls{$url}++;

    #setup fileTypes hash
    my $fileType  = $+{URL};
    my @typeArray = split( /\./, $fileType );

    #I did some experimenting on using regex vs traditional comparisons. I haven't found a difference so far.
    if ( @typeArray == 1 ) {
        $fileTypes{"Other"}++;
    }
    else {
        if ( $typeArray[$#typeArray] eq "cgi" ) {
            $fileTypes{"CGI Program (cgi)"}++;
        }
        elsif ( $typeArray[$#typeArray] =~ /(jpg|jpeg|gif|ico|png)/ ) {
            $fileTypes{"Image (jpg,jpeg,gif,ico,png)"}++;
        }
        elsif ( $typeArray[$#typeArray] eq "css" ) {
            $fileTypes{"Style Sheet (CSS)"}++;
        }
        elsif ($typeArray[$#typeArray] eq "html"
            || $typeArray[$#typeArray] eq "htm" )
        {
            $fileTypes{"Web Pages (htm,html)"}++;
        }
        else {
            $fileTypes{"Other"}++;
        }
    }

    #setup useragents hash (browsers)
    my $useragent = $+{useragent};
    if ( $useragent eq "-" ) {
        $useragents{"NO BROWSER ID"}++;
    }
    else {
        $useragents{$useragent}++;
    }

    #setup browserFamilies hash, with some given when experimentation
    given ( lc $useragent ) {
        when (/chrome/) {
            $browserFamilies{"Chrome"}++;
        }
        when (/firefox/) {
            $browserFamilies{"Firefox"}++;
        }
        when (/msie/) {
            $browserFamilies{"MSIE"}++;
        }
        when (/opera/) {
            $browserFamilies{"Opera"}++;
        }
        when (/safari/) {
            $browserFamilies{"Safari"}++;
        }
        default {
            $browserFamilies{"Unknown"}++;
        }
    }

    #setup referrers hash
    my $referrer = $+{referrer};
    if ( $referrer eq "-" ) {
        $referrers{"NO REFERER"}++;
    }
    else {
        $referrers{$referrer}++;
    }

    #setup referrerDomains hash
    if ( $referrer eq "-" ) {
        $referrerDomains{"NONE"}++;
    }
    else {
        #first section out what I need, should leave no trailing file paths
        $referrer =~ /\/\/([^\/]*)/;
        my $sectionedReferrer = $1;

        #split the sectioned referrer on dots to get the last two elements
        my @splitReferrer = split( /\./, $sectionedReferrer );

        #concat them
        my $firstPartReferrer  = $splitReferrer[ $#splitReferrer - 1 ];
        my $secondPartReferrer = $splitReferrer[$#splitReferrer];
        my $referrerDomain     = $firstPartReferrer . "." . $secondPartReferrer;
        $referrerDomains{$referrerDomain}++;
    }

    #setup operatingSystems hash, more given when experimentation
    my $operatingSystem = $+{useragent};
    given ( lc $operatingSystem ) {
        when (/linux/) {
            $operatingSystems{"Linux"}++;
        }
        when (/windows/) {
            $operatingSystems{"Windows"}++;
        }
        when ( /macintosh/ || /mac/ ) {
            $operatingSystems{"Macintosh"}++;
        }
        default {
            $operatingSystems{"Other"}++;
        }
    }
}

#write it to the file
#could this be cleaned up? for sure. I could probably
#loop through an array of hashes...
open( RESULT, "> mgfleming.results" );
say RESULT ("Web Server Log Analyzer\n");
printf RESULT ( "Process %d entries from %d files.\n", $count, $argvLength );
printf RESULT ("Processed the following logfiles:\n");
foreach my $file (@fileNames) {
    print RESULT ("$file ");
}
printf RESULT ("\n\n");
my $hostnamePrint = getHashString( \%hostnames, "HOSTNAMES" );
say RESULT "$hostnamePrint\n\n";
my $domainPrint = getHashString( \%domains, "DOMAINS" );
say RESULT "$domainPrint\n\n";
my $datesPrint = getHashString( \%dates, "DATES" );
say RESULT "$datesPrint\n\n";
my $hoursPrint = getHashString( \%hours, "HOURS" );
say RESULT "$hoursPrint\n\n";
my $statusPrint = getHashString( \%statuses, "STATUS CODES" );
say RESULT "$statusPrint\n\n";
my $urlPrint = getHashString( \%urls, "URLS" );
say RESULT "$urlPrint\n\n";
my $fileTypePrint = getHashString( \%fileTypes, "FILE TYPES" );
say RESULT "$fileTypePrint\n\n";
my $useragentPrint = getHashString( \%useragents, "BROWSERS" );
say RESULT "$useragentPrint\n\n";
my $browserFamilyPrint = getHashString( \%browserFamilies, "BROWSER FAMILIES" );
say RESULT "$browserFamilyPrint\n\n";
my $referrerPrint = getHashString( \%referrers, "REFERRERS" );
say RESULT "$referrerPrint\n\n";
my $referrerDomainPrint =
  getHashString( \%referrerDomains, "REFERRERS' DOMAINS" );
say RESULT "$referrerDomainPrint\n\n";
my $operatingSystemsPrint =
  getHashString( \%operatingSystems, "OPERATING SYSTEMS" );
say RESULT "$operatingSystemsPrint\n\n";
printf RESULT ( "Total bytes served    = %d\n\n", $bytesTotal );
close(RESULT);

#given a hash and its title, build a string for it and return it
sub getHashString {
    my $hashRef = $_[0];
    my $title   = $_[1];

    my %hash = %$hashRef;
    my @keys = keys(%hash);

    my $totalHits = getTotalHits(%hash);
    my $hashString;

    #sort here
    @keys = sort { $a cmp $b } @keys;

    $hashString .= sprintf(
"==============================================================================\n$title\n==============================================================================\n\n"
    );
    $hashString .= sprintf("  Hits  %%-age   Resource\n");
    $hashString .= sprintf("  ----  -----   --------\n");
    foreach my $key (@keys) {

        #format the hits
        $hashString .= sprintf( "  %4s", $hash{$key} );

        #format the percentage
        my $percentage = sprintf( "%.2f", $hash{$key} / $totalHits * 100 );
        $hashString .= sprintf( "  %5s", $percentage );

        #format the resource
        $hashString .= sprintf( "   %s\n", $key );
    }

    #format total entries
    $hashString .= sprintf(" -----\n");
    $hashString .= sprintf( "   %d entries displayed", $totalHits );
    return $hashString;
}

#given a hash, return total number of hits
sub getTotalHits {
    my %hash = @_;
    my @keys = keys(%hash);
    my $sum  = 0;
    foreach my $key (@keys) {
        $sum += $hash{$key};
    }
    return $sum;
}
