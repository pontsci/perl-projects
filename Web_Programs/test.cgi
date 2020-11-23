#!/usr/bin/env perl
use Modern::Perl;
use Mojolicious::Lite;

any '/' => {
  text => 'Hello World'
};

get '/latin' => {
  text => 'Salve, munde!'
};

app->start;
