use strict;
use warnings;
use lib 't/lib';
use Test::More;
use Acme::CPANAuthors;
use Parse::CPAN::Authors;

BEGIN {
  if ( $Parse::CPAN::Authors::VERSION == 2.26 ) {
    plan skip_all => 'Parse::CPAN::Authors 2.26 breaks this test';
  }

  local $@;
  eval { Acme::CPANAuthors::Utils::_cpan_authors_file() };
  if ($@) {
    plan skip_all => $@;
    exit;
  }
}

plan 'no_plan';

my $authors = Acme::CPANAuthors->new('Test');

my $avatar_url = $authors->avatar_url('ISHIGAKI');
ok $avatar_url;
