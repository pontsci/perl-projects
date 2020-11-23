#!/usr/bin/env perl
use Modern::Perl;
use Mojolicious::Lite;
#a simple Mojolicious app

get '/' => {
  text => 'Hello World from my first Mojolicious app!'
};

get '/echo/:string' => {string=>'nothing'} => sub {
  my $self = shift;
  my $str = $self->param('string');
  my $output = sprintf("You said $str");
  $self->render(text => "$output");
};

get '/daypart/:hour' => {hour=>0} => sub
{
  my $self = shift;
  my $hour = $self->param('hour');
  my $output;
  if($hour >= 5 && $hour <= 11){
    $output = "Good morning!";
  }
  elsif($hour >= 12 && $hour <= 16 )
  {
    $output = "Good afternoon!";
  }
  elsif($hour >= 17 && $hour <= 21)
  {
    $output = "Good evening!";
  }else{
    $output = "Good night!";
  }
  $self->render(text => "$output");
};


app->start;