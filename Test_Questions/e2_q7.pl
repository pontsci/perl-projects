#!/usr/bin/env perl
use Modern::Perl;


my $str = "hello , hello, HeLlO.. this is a testHello, Hell... hellotest";

$str =~ s/hello/\./gi;
say $str;