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

any '*' => sub {
  my $self = shift;
  $self->rendered(404);
  $self->render('oops');
}
app->start;

__DATA__
@@ main.html.ep
% layout 'skeleton';
% title 'Super Cool Blog!';
<p>For now, there is nothing here!!! It's the main page!!!</p>

@@ about.html.ep
% layout 'skeleton';
% title 'About';
<p>This page is all about me. I'm a Computer Science major at UNO and I really enjoy programming.</p>
<p>My favorite thing to do in my free time is play video games or work on my own coding projects. In addition, I like to practice the piano from time to time.</p>
<p>I recently returned from a year long study abroad in Japan, unfortunately it was only 6 months thanks to the covid-19 pandemic.</p>

@@ links.html.ep
% layout 'skeleton';
% title 'Links';
<p>Wow! It's the links page!!!</p>

@@ oops.html.ep
% layout 'skeleton';
% title '404 Error';
<p>404! Not Found!</p>

@@ layouts/skeleton.html.ep
<!DOCTYPE html>
<html>
  <head>
    <title><%= $title%></title>
    <meta charset="utf-8">
  </head>
  <body>
    <a href="<%= url_for('/')%>">Home</a>
    <a href="<%= url_for('/about')%>">About</a>
    <a href="<%= url_for('/links')%>">Links</a>
    <%= content %>
  </body>
</html>