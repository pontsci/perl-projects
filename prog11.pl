#!/usr/bin/env perl
use Modern::Perl;
use experimental 'smartmatch';

my $argvLength = @ARGV;
if($argvLength == 0){
    printf "usage: %s log1 [log2 ...]\n", $0;
    exit(0);
}

my %dates;
my %hours;
my %statuses;
my %urls;

my %useragents;
my %browserFamilies;
my %operatingSystems;
my $regex = '(?<IP>\d+\.\d+\.\d+\.\d+)\s+-+\s+-+\s+\[(?<date>\d+\/\w{3}\/\d{4}):(?<hour>\d{2}):\d{2}:\d{2} -\d{4}\] "\S+\s+(?<URL>\S+).*?"\s+(?<status>\d{3})\s+(?<bytes>\d+)\s+"(?<referer>\S+?)"\s+"(?<useragent>.*?)"';
while(<ARGV>){
    $_ =~ /$regex/g;

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

    #setup useragents hash
    my $useragent = $+{useragent};
    if($useragent eq "-"){
        $useragents{"NO BROWSER ID"}++;
    }
    else
    {
        $useragents{$useragent}++;
    }

    #setup browserFamilies hash
    given(lc $useragent){
        when(/chrome/){
            $browserFamilies{"Chrome"}++;
        }
        when(/firefox/){
            $browserFamilies{"Firefox"}++;
        }
        when(/msie/){
            $browserFamilies{"MSIE"}++; 
        }
        when(/opera/){
            $browserFamilies{"Opera"}++;
        }
        when(/safari/){
            $browserFamilies{"Safari"}++;
        }
        default{
            $browserFamilies{"Unknown"}++;
        }
    }

    #setup operatingSystems hash
    my $operatingSystem = $+{useragent};
    given(lc $operatingSystem){
        when(/linux/){
            $operatingSystems{"Linux"}++;
        }
        when(/windows/){
            $operatingSystems{"Windows"}++;
        }
        when(/macintosh/ || /mac/){
            $operatingSystems{"Macintosh"}++;
        }
        default{
            $operatingSystems{"Other"}++;
        }
    }
}
#print it
my $datesPrint = getHashString(\%dates, "DATES");
say "$datesPrint\n\n";
my $hoursPrint = getHashString(\%hours, "HOURS");
say "$hoursPrint\n\n";
my $statusPrint = getHashString(\%statuses, "STATUS CODES");
say "$statusPrint\n\n";
my $urlPrint = getHashString(\%urls, "URLS");
say "$urlPrint\n\n";
my $useragentPrint = getHashString(\%useragents, "BROWSERS");
say "$useragentPrint\n\n";
my $browserFamilyPrint = getHashString(\%browserFamilies, "BROWSER FAMILIES");
say "$browserFamilyPrint\n\n";
my $operatingSystemsPrint = getHashString(\%operatingSystems, "OPERATING SYSTEMS");
say "$operatingSystemsPrint\n\n";

#write it
open(RESULT, "> output.results");
my $datesPrint = getHashString(\%dates, "DATES");
say RESULT "$datesPrint\n\n";
my $hoursPrint = getHashString(\%hours, "HOURS");
say RESULT "$hoursPrint\n\n";
my $statusPrint = getHashString(\%statuses, "STATUS CODES");
say RESULT "$statusPrint\n\n";
my $urlPrint = getHashString(\%urls, "URLS");
say RESULT "$urlPrint\n\n";
my $useragentPrint = getHashString(\%useragents, "BROWSERS");
say RESULT "$useragentPrint\n\n";
my $browserFamilyPrint = getHashString(\%browserFamilies, "BROWSER FAMILIES");
say RESULT "$browserFamilyPrint\n\n";
my $operatingSystemsPrint = getHashString(\%operatingSystems, "OPERATING SYSTEMS");
say RESULT "$operatingSystemsPrint\n\n";

#given a hash and its title, build a string for it and return it
sub getHashString{
    my $hashRef = $_[0];
    my $title = $_[1];

    my %hash = %$hashRef;
    my @keys = keys(%hash);

    my $totalHits = getTotalHits(%hash);
    my $hashString;

    #sort here, is there a better way than this if? probably.
    if($title eq "DATES" || $title eq "HOURS" || $title eq "STATUS CODES" || $title eq "URLS" || $title eq "BROWSERS" || $title eq "BROWSER FAMILIES" || $title eq "OPERATING SYSTEMS"){
        @keys = sort {$a cmp $b} @keys;
    }

    $hashString .= sprintf("==============================================================================\n$title\n==============================================================================\n\n");
    $hashString .= sprintf("  Hits  %%-age   Resource\n");
    $hashString .= sprintf("  ----  -----   --------\n");
    foreach my $key (@keys){
        #format the hits
        $hashString .= sprintf("  %4s", $hash{$key});

        #format the percentage
        my $percentage = sprintf("%.2f", $hash{$key}/$totalHits*100);
        $hashString .= sprintf("  %5s", $percentage);

        #format the resource
        $hashString .= sprintf("   %s\n", $key);
    }
    #format total entries
    $hashString .= sprintf(" -----\n");
    $hashString .= sprintf("   %d entries displayed", $totalHits);
    return $hashString;
}

#given a hash, return total number of hits
sub getTotalHits{
    my %hash = @_;
    my @keys = keys(%hash);
    my $sum = 0;
    foreach my $key (@keys){
        $sum += $hash{$key};
    }
    return $sum;
}