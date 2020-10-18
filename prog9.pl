#!/usr/bin/env perl
use Modern::Perl;

my $pageToGrab = "http://boxofficemojo.com/weekend/chart/";
my $command = "/usr/bin/lynx -dump -width=900 $pageToGrab";

my $allData = `$command`;
my $regex = '^\s*(?<rank>\d+|-)\s*(?<LW>\S+)\s*(?:\[\S+\])?\s*(?<title>.*?|[\s\S]+?)\s*\$(?<wkGross>\S+)\s*(?<wkGrossChng>-\S+\%|\+\S+\%|-)\s*(?<screens>\S+)\s*(?<wkScreenChng>\+\S+|-\S+|-)\s*\$(?<perScr>\S+)\s*\$(?<cumeGross>\S+)\s*(?<weeks>\S+)\s*(?:\[\d+\])?(?<studio>.*?)\s+(?:false|true)';

#for each movie, create a movieData array and then push it into the movieDataArray
#an easier to read way might be object literals like in JS or structs like in C, but I do not have that knowledge yet
my @movieDataArray;
while($allData =~ /$regex/gm){
    my @movieData;
    push @movieData, $+{rank};
    push @movieData, $+{LW};
    push @movieData, $+{title};
    push @movieData, $+{wkGross};
    push @movieData, $+{wkGrossChng};
    push @movieData, $+{screens};
    push @movieData, $+{wkScreenChng};
    push @movieData, $+{perScr};
    push @movieData, $+{cumeGross};
    push @movieData, $+{weeks};
    push @movieData, $+{studio};
    #I push the reference because if I push just the array, it will append all data to the movieDataArray,
    #which is not the behavior I want. Pushing a reference creates an array of references to an array (a 2D array).
    push @movieDataArray, \@movieData;
}

my @debutMovies;
my @rankChangeMovies;
say "Data scraped from http://boxofficemojo.com/weekend/chart/";
printf("%-2s  %-2s  %-35s  %-13s  %-11s\n", '##', '##', 'Movie Title', 'Weekend', 'Cume');
foreach my $row (@movieDataArray) {
    my $rank = $$row[0];
    my $lwRank = $$row[1];

    #replace \n with nothing and trim to 35 chars
    my $title = $$row[2];
    $title =~ s/\n//g;
    $title = substr($title, 0, 35);

    my $wkGross = $$row[3];
    my $cumeGross = $$row[8];
    
    #if weeks is 1, add it to debut movies
    my $weeks = $$row[9];
    if($weeks == 1){
        push @debutMovies, $row;
    }

    if($lwRank ne '-'){
        push @rankChangeMovies, $row;
    }

    printf("%-2s  %-2s  %-35s  \$%-13s \$%-11s\n", $rank, $lwRank, $title, $wkGross, $cumeGross);
}


#I could probably make a subroutine that changes behavior to shorten this code
#but subroutines are just past the allowed lecture #10

#the first movie is assumed the worst and best debut
my $bestDebut = $debutMovies[0][2];
my $bestDebutRank = $debutMovies[0][0];
my $bestDebutAmount = $debutMovies[0][3];
my $worstDebut = $debutMovies[0][2];
my $worstDebutRank = $debutMovies[0][0];
my $worstDebutAmount = $debutMovies[0][3];
#get rid of commas, I could make this cleaner by stripping all numbers of commas but I'm lazy.
$bestDebutAmount =~ s/,//g;
$worstDebutAmount =~ s/,//g;
foreach my $row (@debutMovies){
    my $debutAmount = @$row[3];
    #strip commas
    $debutAmount =~ s/,//g;

    #if amount is greater than best, I have a new best.
    if($debutAmount > $bestDebutAmount){
        $bestDebut = @$row[2];
        $bestDebutRank = @$row[0];
        $bestDebutAmount = @$row[3];
        #strip commas
        $bestDebutAmount =~ s/,//g;
    }

    #if amount is less than worst, I have a new worst.
    if($debutAmount < $worstDebutAmount){
        $worstDebut = @$row[2];
        $worstDebutRank = @$row[0];
        $worstDebutAmount = @$row[3];
        #strip commas
        $worstDebutAmount =~ s/,//g;
    }
}

#making sure the bestDebut does not have newlines
$bestDebut =~ s/\n//g;
printf("\n\nBiggest Debut: %s (%d)\n", $bestDebut, $bestDebutRank);
#making sure the worstDebut does not have newlines
$worstDebut =~ s/\n//g;
printf("Weakest Debut: %s (%d)\n", $worstDebut, $worstDebutRank);

#grab relevant title and rankDifference info and create a new array
my @titleGainArray;
foreach my $row (@rankChangeMovies){
    my @titleGainData;
    my $title = $$row[2];
    my $currentRank = $$row[0];
    my $lastRank = $$row[1];
    my $rankDifference = $lastRank - $currentRank;

    push @titleGainData, $title;
    push @titleGainData, $rankDifference;
    push @titleGainArray, \@titleGainData;
}

#the first movie is assumed the best and worst gains/losses
my $biggestGainAmount = $titleGainArray[0][1];
my $biggestLossAmount = $titleGainArray[0][1];
#first I am just looking for the biggestGain and Loss numbers.
foreach my $row (@titleGainArray){
    my $amount = $$row[1];
    if($amount < $biggestLossAmount){
        $biggestLossAmount = $amount;
    }
    if($amount > $biggestGainAmount){
        $biggestGainAmount = $amount;
    }
}

#I now print the movies that match the biggest gains and losses
my $biggestGainString = 'Biggest Gain: ';
my $biggestLossString = 'Biggest Losses: ';
foreach my $row (@titleGainArray){
    my $title = $$row[0];
    my $amount = $$row[1];
    #check title for newlines
    $title =~ s/\n//g;
    #build the strings
    if($biggestGainAmount == $amount){
        $biggestGainString .= sprintf("%s, ", $title);
    }
    if($biggestLossAmount == $amount){
        $biggestLossString .= sprintf("%s, ", $title);
    }
}
#get rid of the space and comma at end of strings (always the last two characters in this case).
$biggestGainString = substr($biggestGainString, 0, -2);
$biggestLossString = substr($biggestLossString, 0, -2);
#get rid of any non digit characters in the amounts
$biggestGainAmount =~ s/\D//g;
$biggestLossAmount =~ s/\D//g;
printf("%s (%d places)\n", $biggestGainString, $biggestGainAmount);
printf("%s (%d places)", $biggestLossString, $biggestLossAmount);

