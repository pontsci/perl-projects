#!/usr/bin/env perl
use Modern::Perl;
use Mojolicious::Lite; #a simple Mojolicious app
get '/' => sub {
  my $self = shift;
  open(ENTRIES, "< entries.txt");

  #the array to hold all the posts
  my @posts;
  #for all lines
  while(my $line = <ENTRIES>){
    #split it up
    my ($timestamp, $ptitle, $blogentry) = split(/\|/, $line);
    #the post "object"
    my %post;
    if($timestamp && $ptitle && $blogentry){
      $post{"timestamp"} = localtime($timestamp);
      $post{"ptitle"} = $ptitle;
      chomp($blogentry);
      $post{"blogentry"} = $blogentry;
    }
    #build the list of posts
    push(@posts, \%post);
  }
  #close it up
  close(ENTRIES);

  #stash the posts
  $self->stash(postsarray => \@posts);
  $self->render('main');
};

get '/about' => sub {
  my $self = shift;
  $self->render('about');
};

get '/links' => sub {
  my $self = shift;
  my %links;
  open( LINKS, "< links.txt" );
  #for all lines
  while(my $line = <LINKS>){
    #split the data up into name and link
    my ($name, $link) = split(/\|/, $line);
    #make an entry in the hash for the name=>link, if they were set
    if($name && $link){
      $links{$name} = "$link";
    }
  }
  #close it up
  close(LINKS);

  #stash the hash
  $self->stash(linkhash => \%links);
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
<div class="container row-8">
  <h3 class="text-primary">Posts</h3>
  <hr/>
% foreach my $post (@$postsarray){
    <article class="mb-5">
      <h5><%=%$post{"ptitle"}%></h5>
      <p><small class="text-muted">Posted on <%=%$post{"timestamp"}%></small></p>
      <p><%==%$post{"blogentry"}%></p>
    </article>
% }
</div>

@@ about.html.ep
% layout 'skeleton';
% title 'About';
<article class="container row-8">
  <p>My name is Mason Fleming, I'm a Computer Science major at UNO and I really enjoy programming.
  My favorite thing to do in my free time is play video games or work on my own coding projects. In addition, I like to practice the piano from time to time.
  I recently returned from a year long study abroad in Japan, unfortunately it was only 6 months thanks to the covid-19 pandemic.</p>
  <hr/>
  <iframe src="https://drive.google.com/file/d/1BEbu4k7QeMK5R2ahRbSDRSWRutpPb5hB/preview" width="640" height="480" alt="japansunset" title="japansunset"></iframe>
  <hr/>
  <p>Other hobbies I enjoy are playing many different board games with my family. Other times, I'll DM for my DnD group, although Covid has made that 
  a lot more difficult; we're currently transition to an online session. I'll be graduating in May 2021, finally...</p>
</article>

@@ links.html.ep
% layout 'skeleton';
% title 'Links';
<div class="container row-8">
  <h3 class="text-secondary">Links to Sites</h3>
  <hr/>
  <ul>
  % foreach my $key(sort keys(%$linkhash)){
  <li>
  <a href="<%=%$linkhash{$key}%>" target="_blank"><%= $key%></a>
  </li>
  %}
  </ul>
</div>

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
    <div class="container mb-5">
    <img src="https://www.amd.com/system/files/2018-11/10788-ryzen-chip-left-angle-960x548.png" alt="cpu" title="cpu">
      <h1>The Blog</h1>
      <p>This is my super cool blog!</p>
      <a href="<%= url_for('/')%>">Home</a>
      <a href="<%= url_for('/links')%>">Links</a>
      <a href="<%= url_for('/about')%>">About</a>
    </div>
    <%= content %>
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
  </body>
</html>