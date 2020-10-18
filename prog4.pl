#!/usr/bin/env perl
use Modern::Perl;
print "Enter in a 7 character phrase: ";
chomp (my $phrase = <>);

if(length $phrase != 7){
    say "ERROR: That is not a 7-character input.";
}
else
{
    #Uppercase the phrase for easy comparing
    $phrase = uc $phrase;
    my $beginning = substr $phrase, 0, 3;
    #the middle char doesn't matter, but I save it anyway for easy viewing
    my $middle = substr $phrase, 3, 1;
    my $end = substr $phrase, 4, 3;
    
    my $endReversed = "";
    #index goes to the length - 1, so I can grab each char, this allows variable length
    for my $index (0..length($end)-1){
        #the char at index
        my $char = substr $end, $index, 1;
        #concat char to the beginning, reversing the string
        $endReversed = $char.$endReversed;
    }

    #if my reversed string is eq to beginning, then palindrome.
    if($endReversed eq $beginning){
        say "PALINDROME";
    }
    else
    {
        say "NOT";
    }
}