#!/usr/bin/env perl
use Modern::Perl;

my $argvLength = @ARGV;
if($argvLength == 0){
    printf "usage: %s log1 [log2 ...]\n", $0;
    exit(0);
}

my %hours = ();
my $regex = '(?<IP>\d+\.\d+\.\d+\.\d+)\s+-+\s+-+\s+\[(?<date>\d+\/\w{3}\/\d{4}):(?<hour>\d{2}):\d{2}:\d{2} -\d{4}\] "\S+\s+(?<URL>\S+).*?"\s+(?<status>\d{3})\s+(?<bytes>\d+)\s+"(?<referer>\S+?)"\s+"(?<useragent>.*?)"';
while(<ARGV>){
    $_ =~ /$regex/g;
    my $hour = $+{hour};
    $hours{$hour} += 1;
}
my $hoursPrint = getHashString(\%hours, "HOURS");
#say $hoursPrint;

#given a hash and its title, build a string for it
sub getHashString{
    my $hashRef = $_[0];
    my $title = $_[1];
    my %hash = %$hashRef;
    my @keys = keys(%hash);
    if($title eq "HOURS"){
        @keys = sort {$a cmp $b} @keys;
    }
    #sort here
    print("==============================================================================\n$title\n==============================================================================\n");
    foreach my $key (@keys){
        printf("%s:%s\n", $key, $hash{$key});
    }
    return 0;
}

# while(<ARGV>){
#     my $line = <ARGV>;
#     print $line;
# }
