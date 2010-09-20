use strict;
use warnings;
use lib 't/lib';
use Test::More qw(no_plan);
use Acme::CPANAuthors;

{
  my $kwalitee = Acme::CPANAuthors->kwalitee('ISHIGAKI');
  ok ref $kwalitee eq 'HASH' && %$kwalitee;
  ok $kwalitee->{info},          "has info";
  ok $kwalitee->{distributions}, "has distributions";
}
