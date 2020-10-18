#!/usr/bin/env perl
use Modern::Perl;

my $name = "Mason Fleming";
my $netID = "mgfleming";
my $major = "Computer Science";
my $restaurantA = "Spezia's";
my $restaurantB = "Brother Sebastian's Steakhouse and Winery";
my $favoritePlace = "Henry Doorly Zoo";
my $lastSong = "Hey Ya! (Outkast's synthwave/80s remix)";
my $studyCity = "Hamamatsu";
my $studyCountry = "Japan";
# I can concat variables and strings like normal
my $studyLocation = $studyCity.', '.$studyCountry;

say $name;
# I can build strings with . or ,
print $netID."\n";
# I can choose to use parenthesis if I want, as well as single quotes
# if I don't want the string to be interpreted
say ('My Major is ', $major);
# I can use printf, similar to C
printf "%s / %s\n", $restaurantA, $restaurantB;
# I can use q and delimeter of my choosing for uninterpreted single quotes
print q!The !, $favoritePlace, "\n";
# I can use qq and a delimeter of my choosing for interpreted double quotes
print qq-$lastSong\n-;
# I could use double quotes here, but I can also use single and just
# concat my strings with ,
say 'I recently studied abroad in ', $studyLocation, '.';