#!/usr/bin/env perl
use Modern::Perl;
use Data::Dumper;

my @outstandingComedySeries;
push @outstandingComedySeries, 'Outstanding Comedy Series';
push @outstandingComedySeries, 'Curb Your Enthusiasm';
push @outstandingComedySeries, 'Dead To Me';
push @outstandingComedySeries, 'Insecure';
push @outstandingComedySeries, 'Schitt\'s Creek';
push @outstandingComedySeries, 'The Good Place';
push @outstandingComedySeries, 'The Kominsky Method';
push @outstandingComedySeries, 'The Marvelous Mrs. Maisel';
push @outstandingComedySeries, 'What We Do In The Shadows';
#say "@outstandingComedySeries";

my @leadActorComedySeries;
push @leadActorComedySeries, 'Outstanding Lead Actor In A Comedy Series';
push @leadActorComedySeries, 'Don Cheadle, Black Monday';
push @leadActorComedySeries, 'Anthony Anderson, black-ish';
push @leadActorComedySeries, 'Ramy Youssef, Ramy';
push @leadActorComedySeries, 'Eugene Levy, Schitt\'s Creek';
push @leadActorComedySeries, 'Ted Danson, The Good Place';
push @leadActorComedySeries, 'Michael Douglas, The Kominsky Method';
#say "@leadActorComedySeries";

my @leadActressComedySeries;
push @leadActressComedySeries, 'Outstanding Lead Actress In A Comedy Series';
push @leadActressComedySeries, 'Tracee Ellis Ross, black-ish';
push @leadActressComedySeries, 'Linda Cardellini, Dead To Me';
push @leadActressComedySeries, 'Christina Applegate, Dead To Me';
push @leadActressComedySeries, 'Issa Rae, Insecure';
push @leadActressComedySeries, 'Catherine O\'Hara, Schitt\'s Creek';
push @leadActressComedySeries, 'Rachel Brosnahan, The Marvelous Mrs. Maisel';
#say "@leadActressComedySeries";

my @contemporaryHairstyling;
push @contemporaryHairstyling, 'Outstanding Contemporary Hairstyling';
push @contemporaryHairstyling, 'black-ish';
push @contemporaryHairstyling, 'Grace And Frankie';
push @contemporaryHairstyling, 'Schitt\'s Creek';
push @contemporaryHairstyling, 'The Handmaid\'s Tale';
push @contemporaryHairstyling, 'The Politician';
push @contemporaryHairstyling, 'This Is Us';
#say "@contemporaryHairstyling";

my @animatedProgram;
push @animatedProgram, 'Outstanding Animated Program';
push @animatedProgram, 'Big Mouth';
push @animatedProgram, 'Bob\'s Burgers';
push @animatedProgram, 'BoJack Horseman';
push @animatedProgram, 'Rick And Morty';
push @animatedProgram, 'The Simpsons';
#say "@animatedProgram";

my @structuredRealityProgram;
push @structuredRealityProgram, 'Outstanding Structured Reality Program';
push @structuredRealityProgram, 'A Very Brady Renovation';
push @structuredRealityProgram, 'Antiques Roadshow';
push @structuredRealityProgram, 'Love Is Blind';
push @structuredRealityProgram, 'Queer Eye';
push @structuredRealityProgram, 'Shark Tank';
#say "@structuredRealityProgram";

my @varietyTalkSeries;
push @varietyTalkSeries, 'Outstanding Variety Talk Series';
push @varietyTalkSeries, 'Full Frontal With Samantha Bee';
push @varietyTalkSeries, 'Jimmy Kimmel Live!';
push @varietyTalkSeries, 'Last Week Tonight With John Oliver';
push @varietyTalkSeries, 'The Daily Show With Trevor Noah';
push @varietyTalkSeries, 'The Late Show With Stephen Colbert';
#say "@varietyTalkSeries";

my @nominees = ([@outstandingComedySeries], [@leadActorComedySeries],
                [@leadActressComedySeries], [@contemporaryHairstyling],
                [@animatedProgram], [@structuredRealityProgram], [@varietyTalkSeries]);

#print Dumper \@nominees;

my @choices;

say "Welcome to the 72nd Emmy Awards!\n";
say "==============================================================================\n";

foreach my $row (@nominees){
    my $lastIndex = $#$row;
    my $categoryName = $$row[0];
    print "The nominees for $categoryName are:\n\n";
    for my $index (1..$lastIndex){
        printf "    [%d] %s\n", $index, $$row[$index]; 
    }
    printf "    [%d] %s\n", $lastIndex+1, "Write In\n";
    print "Please enter your choice for $categoryName now: ";
    my $selection;
    my $item;
    while (chomp($selection = <>)){
        if($selection >= 1 && $selection <= $lastIndex){
            last;
        }

        #write in
        if($selection == $lastIndex+1){
            print 'Please enter your write-in candidate: ';
            chomp($item = <>);
            last;
        }
        say "I'm sorry, but $selection is not a valid option.";
        print "Please enter your choice for $categoryName now: ";
    }

    #if they didn't write in, they must have selected
    #fromt he list, so set it to the item.
    if(!defined $item){
        $item = $$row[$selection];
    }
    say "Thank you for selecting $item as $categoryName.";
    
    push @choices, $item;

    #when I don't have all the choices, print the bar.
    if(!($#nominees == $#choices)){
        say "\n==============================================================================\n";
    }
    
}
say "\nThank you for voting. Here is a summary of your votes:\n";
#because of the structure of the program
#choice index should coincide with nominee index
for my $index (0..$#choices){
    printf "%s :\n    %s\n\n", $nominees[$index][0], $choices[$index];
}

