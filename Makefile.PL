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
    'Class::Accessor::Fast'  => 0,
    'CPAN::DistnameInfo'     => 0,
    'Exporter'               => 0,
    'File::Spec'             => 0,
    'Gravatar::URL'          => 0,
    'IO::File'               => 0,
    'IO::Uncompress::Gunzip' => '2.008', # core in 5.10
    'JSON'                   => 0,
    'LWP::UserAgent'         => 0,
    'Module::Find'           => 0,
    'Test::More'             => '0.47',
    'Test::UseAllModules'    => '0.09',
    'Try::Tiny'              => 0,
    'version'                => '0.74',  # core in 5.10
  },
  ($ExtUtils::MakeMaker::VERSION >= 6.31
    ? (LICENSE => 'perl')
    : ()
  ),
);
