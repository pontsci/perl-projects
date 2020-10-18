#!/usr/bin/env perl
use Modern::Perl;

print "Please enter a binary number up to 30 digits: ";

chomp(my $binaryInput = <>);

#With binary, it gets larger going from right to left
#the binary number 101 is 5 because
#(4 + 0 + 1) which is actually (2^2 + 0 + 2^0)
#If I want to loop through this, and not
#have to think about the left most digit actually being the largest
#exponent, I can reverse the string, so that I can loop
#from the start, 0, and use the index as the exponent.

my $binaryInputReversed = reverse $binaryInput;

#from the beginning, to the end
#remembering that this is reversed
#I start with 2^0 and go up.
my $total = 0;
my $digit = '';
for my $index (0..(length $binaryInputReversed)-1){
    #I get the single digit I want
    $digit = substr $binaryInputReversed, $index, 1;

    #I determine whether it is 0 or 1
    if($digit eq '1'){
        #if the digit is 1, I do 2 to the index
        #and add it to the total
        $total += 2 ** $index;
    }
}
say $total;