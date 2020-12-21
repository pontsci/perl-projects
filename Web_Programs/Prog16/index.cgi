#!/usr/bin/env perl
use Modern::Perl;
use Mojolicious::Lite; #a simple Mojolicious app
use DBI;




get '/' => sub {
  my $self = shift;
  $self->render('main');
};

any '/search' => sub {
  my $self = shift;
  my $dbh = DBI->connect("dbi:SQLite:dbname=courses.db");
  my $selection = $self->param('selection');
  my $selectionDays = $self->param('selectionDays');
  
  #the array of hashes
  my @data;

  #the extra functionality searches by the days of the week attribute
  #I tried to acount for all combinations, I know I could write
  #a separate script that runs a select distinct query 
  #to get a list of all possible dow values, but I feel that is
  #a little outside the scope of this assignment
  my $query;
  if($selection eq 'All' && $selectionDays eq 'All'){
    $query = "SELECT * FROM courses";
  }else{
    $query = "SELECT * FROM courses";
    $query .= " WHERE";
    if($selectionDays ne 'All' && $selection ne 'All'){
      $query .= " dow='$selectionDays' AND dept='$selection'";
    }else{
      if($selection ne 'All'){
      $query .= " dept='$selection'";
      }
      if($selectionDays ne 'All'){
      $query .= " dow='$selectionDays'";
      }
    }
  }
  my $qh = $dbh->prepare($query);
  $qh->execute();
  $qh->bind_columns(\my($id,$dept,$course,$name,$section,$time,$dow,$room,$instructor));
  my $dataCount = 0;
  while($qh->fetch()){
    my $record = {dept => $dept, course => $course, section => $section,
    title => $name, days => $dow, time => $time, room => $room, instructor => $instructor};
    push @data, $record;
    $dataCount++;
  }
  $qh->finish;
  $dbh->disconnect;

  $self->stash(courses => \@data);
  $self->stash(count => $dataCount);
  $self->render('search');
};

#a test route for visualization
# get '/search' => sub {
#   my $self = shift;

#   $self->render('search');
# };

any '*' => sub {
  my $self = shift;
  $self->rendered(404);
  $self->render('oops');
};
app->start;

__DATA__
@@ main.html.ep
% layout 'skeleton', title => 'UNO Class Search', headerText => 'UNO Class Search!';
<div class="container-md">
  <p>Use the form below to search for classes for the 2020 Spring semester in the college of IS&T.</p>
  <form action="<%= url_for('/search')%>" method="post">
  <div class="row">
    <div class="col-2 mb-3">
      <label for="departmentSelect" class="form-label">Department</label>
    </div>
    <div class="col-auto mb-3">
      <select id="departmentSelect" class="form-select" name="selection" aria-label="Department">
      <option selected value="All">All</option>
      <option value="BIOI">BIOI</option>
      <option value="CIST">CIST</option>
      <option value="CSCI">CSCI</option>
      <option value="CSTE">CSTE</option>
      <option value="IASC">IASC</option>
      <option value="ISQA">ISQA</option>
      <option value="ITIN">ITIN</option>
      </select>
    </div>
  </div>
  <div class="row">
    <div class="col-2 mb-3">
      <label for="daysSelect" class="form-label">Days of the Week</label>
    </div>
    <div class="col-auto mb-3">
      <select id=daysSelect class="form-select" name="selectionDays" aria-label="Days">
      <option selected value="All">All</option>
      <option value="TBA">TBA</option>
      <option value="M">Monday</option>
      <option value="T">Tuesday</option>
      <option value="W">Wednesday</option>
      <option value="R">Thursday</option>
      <option value="F">Friday</option>
      <option value="MW">Monday/Wednesday</option>
      <option value="TR">Tuesday/Thursday</option>
      <option value="TRF">Tuesday/Thursday/Friday</option>
      </select>
    </div>
  </div>
  <div class="row">
    <div class="col-auto mb-3">
      <button type="submit" class="btn btn-primary">Search!</button>
      <input type="reset" class="btn btn-danger" value="Reset">
    </div>
  </div>
  </form>
</div>

  


@@ search.html.ep
% layout 'skeleton', title => 'Search Results', headerText => 'Search Results!';
<div class="container">
  <p class="text-success">There are <%=$count%> classes available:</p>
  <br/>
  <table class="table table-hover">
  <thead>
    <tr>
    <th scope="col">Dept</th>
    <th scope="col">Course</th>
    <th scope="col">Sect</th>
    <th scope="col">Title</th>
    <th scope="col">Days</th>
    <th scope="col">Time</th>
    <th scope="col">Room</th>
    <th scope="col">Instructor</th>
    </tr>
  </thead>
  <tbody>
    %for my $record (@$courses){
      <tr>
      <td scope="row"><%=$$record{dept}%></td>
      <td><%=$$record{course}%></td>
      <td><%=$$record{section}%></td>
      <td><%=$$record{title}%></td>
      <td><%=$$record{days}%></td>
      <td><%=$$record{time}%></td>
      <td><%=$$record{room}%></td>
      <td><%=$$record{instructor}%></td>
      </tr>
    %}
  </tbody>
  </table>
  <a class="btn btn-primary" href="<%= url_for('/')%>">New Search</a>
</div>

@@ oops.html.ep
% layout 'skeleton', title => '404 Error', headerText => '404!';
<p class="container">404! Not Found!</p>

@@ layouts/skeleton.html.ep
<!DOCTYPE html>
<html>
  <head>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-giJF6kkoqNQ00vy+HMDP7azOuL0xtbfIcaT9wjKHr8RbDVddVHyTfAAsrekwKmP1" crossorigin="anonymous">
    <title><%= $title%></title>
    <meta charset="utf-8">
  </head>
  <body>
    <div class="container mb-5">
    <h2><%= $headerText%></h2>
      
    </div>
    <%= content %>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js" integrity="sha384-q2kxQ16AaE6UbzuKqyBE9/u/KzioAlnx2maXQHiDX9d4/zp8Ok3f+M7DPm+Ib6IU" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta1/dist/js/bootstrap.min.js" integrity="sha384-pQQkAEnwaBkjpqZ8RU1fF1AKtTcHJwFl3pblpTlHXybJjHpMYo79HY3hIi4NKxyj" crossorigin="anonymous"></script>
  </body>
</html>