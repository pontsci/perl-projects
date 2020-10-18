#!/usr/bin/env perl
use Modern::Perl;

print "Enter a five-digit number: ";
chomp(my $number = <>);



if($number < 10000 || $number > 99999){
    say "ERROR: Your number must be in the range 10000 and 99999"
}
#This wasn't explicitly stated to check for
#but I am only supposed to let the user
#enter a non-negative integer,
#I don't think we've done anything with 
#type casting, so this is my check for decimals
#and for 5 digits.
elsif(length $number != 5)
{
    say "ERROR: Your number is not 5 digits."
}
else
{
    my $fifthDigit = chop($number);
    my $fourthDigit = chop($number);
    my $thirdDigit = chop($number);
    my $secondDigit = chop($number);
    my $firstDigit = $number;

    printf("%d   %d   %d   %d   %d\n", $firstDigit, $secondDigit, $thirdDigit, $fourthDigit, $fifthDigit);
}
    



