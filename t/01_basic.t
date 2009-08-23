use strict;
use warnings;
use lib 't/lib';
use Test::More qw(no_plan);
use Acme::CPANAuthors;

my $authors = Acme::CPANAuthors->new('Test');

my $count = $authors->count;
ok $count;

my @ids = $authors->id;
ok scalar @ids;

my $ishigaki = $authors->id('ISHIGAKI');
ok $ishigaki;

my @names = $authors->name;
ok scalar @names;

my $name = $authors->name('ISHIGAKI');
ok $name =~ /Ishigaki/i;
