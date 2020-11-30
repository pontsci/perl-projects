#!/usr/bin/env perl
use Modern::Perl;
use Mojolicious::Lite;
#a simple Mojolicious app

get '/' => {
  text => 'Hello World from my first Mojolicious app!'
};

app->start;