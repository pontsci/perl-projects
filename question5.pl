#!/usr/bin/env perl
use Modern::Perl;

use experimental 'smartmatch';
print("Enter a number between 1 and 4: ");
chomp(my $input = <>);

given ($input){
    when (1){say("You picked 1! Good choice.");
            break;
    }
    when (2){say("You picked 2! That's an ok choice.");
            break;
    }
    when (3){say("You picked 3! Nice...");
            break;
    }
    when (4){say("You picked 4! Ridiculous.");
            break;
    }
    default {say("You didn't answer correctly...");}
}
