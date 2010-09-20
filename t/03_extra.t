use strict;
use warnings;
use lib 't/lib';
use Test::More;
use Acme::CPANAuthors;
use Parse::CPAN::Authors;
use Try::Tiny;

BEGIN {
  if ( $Parse::CPAN::Authors::VERSION == 2.26 ) {
    plan skip_all => 'Parse::CPAN::Authors 2.26 breaks this test';
  }

  try   { Acme::CPANAuthors::Utils::_cpan_authors_file() }
  catch { plan skip_all => $_; exit };
}

plan 'no_plan';

my $authors = Acme::CPANAuthors->new('Test');

my $avatar_url = $authors->avatar_url('ISHIGAKI');
ok $avatar_url;
