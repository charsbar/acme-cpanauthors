use strict;
use warnings;
use lib 't/lib';
use Test::More 'no_plan';
use Acme::CPANAuthors::Test;

my %authors = Acme::CPANAuthors::Test->authors;

ok (scalar keys %authors == 1 );

# note that this requires parentheses
ok (Acme::CPANAuthors::Test->authors->{ISHIGAKI} eq 'Kenichi Ishigaki');

foreach my $name ( keys %{ Acme::CPANAuthors::Test->authors } ) {
  # and this doesn't.
  ok $authors{$name} eq Acme::CPANAuthors::Test->authors->{$name};
}
