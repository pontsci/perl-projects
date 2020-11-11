#!/usr/bin/envperl
use Modern::Perl;

my @array = ("Test1", "Test2", "Test3", "Test4",);
my $str = "Test5";

testSub($str, @array);

sub testSub{
    say $_[2].$_[0];
}
