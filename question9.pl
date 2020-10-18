#!/usr/bin/env perl
use Modern::Perl;

my @games = ("FFXIV", "Deep Rock Galactic", "World of Warcraft", "Minecraft", "Flappy Bird");
my @filteredGames;

for my $game (@games){
    if(length($game) >= 17){
        push @filteredGames, $game;
    }
}

say("@filteredGames");