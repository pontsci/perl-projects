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
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
    <title><%= $title%></title>
    <meta charset="utf-8">
  </head>
  <body>
    <a href="<%= url_for('/')%>">Home</a>
    <a href="<%= url_for('/about')%>">About</a>
    <a href="<%= url_for('/links')%>">Links</a>
    <%= content %>
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
  </body>
</html>