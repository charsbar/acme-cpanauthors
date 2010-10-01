use strict;
use warnings;
use lib 't/lib';
use Test::More 'no_plan';
use Acme::CPANAuthors;

local $ENV{ACME_CPANAUTHORS_HOME} = 't/data';

my $authors = Acme::CPANAuthors->new('TestExtra');

my $avatar_url = $authors->avatar_url('AADLER');
ok $avatar_url;
