use strict;
use warnings;
use lib 't/lib';
use Test::More qw(no_plan);
use Acme::CPANAuthors;

{
  my @found = Acme::CPANAuthors->look_for('ISHIGAKI');
  ok( @found, 'found by ID' );
  ok(( grep { $_->{category} eq 'Test' } @found ), 'found Test ID');
}

{
  my @found = Acme::CPANAuthors->look_for('ishi');
  ok( @found, 'found by part of an ID' );
}

{
  my @found = Acme::CPANAuthors->look_for('Kenichi Ishigaki');
  ok( @found, 'found by full name' );
}

{
  my @found = Acme::CPANAuthors->look_for('Kenichi');
  ok( @found, 'found by part of a name' );
}

{
  my @found = Acme::CPANAuthors->look_for(qr/Ken/);
  ok( @found, 'found by regexp' );
}
