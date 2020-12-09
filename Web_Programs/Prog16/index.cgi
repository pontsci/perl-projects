#!/usr/bin/env perl
use Modern::Perl;
use Mojolicious::Lite; #a simple Mojolicious app
use DBI;



get '/' => sub {
  my $self = shift;
  

  $self->render('main');
};

post '/search' => sub {
  my $self = shift;

  $self->render('search');
}

any '*' => sub {
  my $self = shift;
  $self->rendered(404);
  $self->render('oops');
};
app->start;

__DATA__
@@ main.html.ep
% layout 'skeleton';
% title 'UNO Class Search';
% header 'UNO Class Search!';

@@ search.html.ep
% layout 'skeleton';
% title 'Search Results';
% header 'Search Results!';

@@ oops.html.ep
% layout 'skeleton';
% title '404 Error';
% header '404!';
<p class="container">404! Not Found!</p>

@@ layouts/skeleton.html.ep
<!DOCTYPE html>
<html>
  <head>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
    <title><%= $title%></title>
    <meta charset="utf-8">
  </head>
  <body>
    <div class="container mb-5">
    <h2><%= $header%></h2>
      
    </div>
    <%= content %>
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
  </body>
</html>