#!/usr/bin/env perl
use Modern::Perl;
use Mojolicious::Lite; #a simple Mojolicious app
get '/' => sub {
  my $self = shift;
  $self->render('main');
};

get '/about' => sub {
  my $self = shift;
  $self->render('about');
};

get '/links' => sub {
  my $self = shift;
  $self->render('links');
};
app->start;

__DATA__
@@ main.html.ep
% layout 'skeleton';
% title 'Super Cool Blog!';
<p>For now, there is nothing here!!! It's the main page!!!</p>

@@ about.html.ep
% layout 'skeleton';
% title 'About';
<p>This is a boring about page!</p>

@@ links.html.ep
% layout 'skeleton';
% title 'Links';
<p>Wow! It's the links page!!!</p>

@@ about.html.ep
% layout 'skeleton';
% title 'About';
<p>This is a boring about page!</p>

@@ layouts/skeleton.html.ep
<!DOCTYPE html>
<html>
  <head>
    <title><%= $title%></title>
    <meta charset="utf-8">
  </head>
  <body>
    <%= content %>
  </body>
</html>