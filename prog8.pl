#!/usr/bin/env perl
use Modern::Perl;

my @capture = `last`;

if(@ARGV != 1){
    say "Usage: lastsummary login";
    exit 1;
}

#get the name
my $name = $ARGV[0];

#trim the name to 8 chars
my $shortName = substr($name, 0, 8);

#filter the capture to newArray
my @newArray;
for my $entry (@capture){
    if($entry =~ m/\b$shortName\b/){
        push @newArray, $entry;
    }
}

#initialize variables
my $sumDays = 0;
my $sumHours = 0;
my $sumMinutes = 0;
for my $entry (@newArray){
    #start with data that may or may not be there
    if($entry =~ m/\((\d+)\+/){
        #extract the data into days
        $sumDays += $1;
    }
    #continue on data guaranteed to be in this entry
    if($entry =~ m/\((\d\d):(\d\d)\)/){
        #extract from backreference and add the data into hours and days
        $sumHours += $1;
        $sumMinutes += $2;
        #sum them
        if($sumMinutes >= 60){
            $sumHours++;
            $sumMinutes -= 60;
        }
    }
}

print "Here is a list of the logins for $name:";
if(@newArray != 0){
    print "\n\n";
    for my $entry (@newArray){
        print "  $entry\n";
    }
}
print "\nHere is a summary of the time spent on the system for $name:\n\n";
say "$name";

my $entryCount = @newArray;
say "$entryCount";

#if there are 0 days, don't calc them, else calc them.
if($sumDays == 0){
    printf("%02d:%02d", $sumHours, $sumMinutes);
}else{
    $sumHours += $sumDays * 24;
    printf("%02d:%02d", $sumHours, $sumMinutes);
}