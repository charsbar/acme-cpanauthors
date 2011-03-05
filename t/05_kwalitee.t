use strict;
use warnings;
use lib 't/lib';
use Test::More qw(no_plan);
use Acme::CPANAuthors;

SKIP: {
  my $kwalitee = Acme::CPANAuthors->kwalitee('ISHIGAKI');
  unless ($kwalitee) {
    skip "API server seems down; sorry for the inconvenience", 3;
  }
  ok ref $kwalitee eq 'HASH' && %$kwalitee;
  ok $kwalitee->{info},          "has info";
  ok $kwalitee->{distributions}, "has distributions";
}
