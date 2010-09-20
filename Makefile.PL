use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
  NAME           => 'Acme::CPANAuthors',
  AUTHOR         => 'Kenichi Ishigaki <ishigaki@cpan.org>',
  VERSION_FROM   => 'lib/Acme/CPANAuthors.pm',
  ABSTRACT_FROM  => 'lib/Acme/CPANAuthors.pm',
  PREREQ_PM => {
    'Carp'                   => 0,
    'Exporter'               => 0,
    'File::Spec'             => 0,
    'Gravatar::URL'          => 0,
    'Module::Find'           => 0,
    'Parse::CPAN::Authors'   => '2.27',
    'Parse::CPAN::Packages'  => '2.27',
    'Test::More'             => '0.47',
    'Test::UseAllModules'    => '0.09',
    'Try::Tiny'              => 0,
    'URI'                    => 0,
    'Web::Scraper'           => '0.21',
  },
  ($ExtUtils::MakeMaker::VERSION >= 6.31
    ? (LICENSE => 'perl')
    : ()
  ),
);
