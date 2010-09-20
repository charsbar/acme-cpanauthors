package Acme::CPANAuthors::Utils;

use strict;
use warnings;
use Carp;
use base qw( Exporter );
use File::Spec;

our $VERSION   = '0.10'; # see RT #43388
our @EXPORT_OK = qw( cpan_authors cpan_packages );

my $CPANFiles = {};

sub clear_cached_cpan_files () { $CPANFiles = {}; }

sub cpan_authors () {
  unless ( $CPANFiles->{authors} ) {
    require Parse::CPAN::Authors;
    $CPANFiles->{authors} =
      Parse::CPAN::Authors->new( _cpan_authors_file() );
  }
  return $CPANFiles->{authors};
}

sub cpan_packages () {
  unless ( $CPANFiles->{packages} ) {
    require Parse::CPAN::Packages;
    $CPANFiles->{packages} =
      Parse::CPAN::Packages->new( _cpan_packages_file() );
  }
  return $CPANFiles->{packages};
}

sub _cpan_authors_file () {
  _cpan_file( authors => '01mailrc.txt.gz' );
}

sub _cpan_packages_file () {
  _cpan_file( modules => '02packages.details.txt.gz' );
}

sub _cpan_file {
  my ($dir, $basename) = @_;

  my $file;

  # see if CPAN is configured
  _require_myconfig_or_config();
  if ( $CPAN::Config && ref $CPAN::Config eq 'HASH' ) {
    my $source_dir = $CPAN::Config->{keep_source_where};
    $file = _catfile( $source_dir, $dir, $basename );
    unless ( -f $file ) {
      require URI::file;
      foreach my $url ( @{ $CPAN::Config->{urllist} || [] } ) {
        next unless $url =~ s{^file://}{/};
        $file = URI::file->new(join '/', $url, $dir, $basename )->file;
        last if -f $file;
      }
    }
    unless ( -f $file ) {
      $file = _catfile( $source_dir, $dir, "$basename.bak" );
    }
    unless ( -f $file ) {
      $file = _catfile( $source_dir, $basename );
    }
  }
  return $file if $file && -f $file;

  # see if CPANPLUS is configured
  eval { require CPANPLUS::Configure };
  unless ($@) {
    # XXX: should also support custom-sources directory?
    my $source_dir = CPANPLUS::Configure->new->get_conf('base');
    my $cpanplus_file = _catfile( $source_dir, $basename );
    if ( -f $cpanplus_file ) {
      $file ||= $cpanplus_file;
      if ( (stat($file))[9] < (stat($cpanplus_file))[9] ) {
        $file = $cpanplus_file;
      }
    }
  }

  croak "$file not found; You might want to configure CPAN first." unless $file && -f $file;

  return $file;
}

sub _require_myconfig_or_config () { # from CPAN::HandleConfig
  return if $INC{'CPAN/MyConfig.pm'};
  local @INC = @INC;

  eval {
    require File::HomeDir;
    die unless $File::HomeDir::VERSION >= 0.52;
  };
  my $home = $@ ? $ENV{HOME} : File::HomeDir->my_data;

  unshift @INC, File::Spec->catdir($home, '.cpan');

  eval { require CPAN::MyConfig };
  if ( $@ and $@ !~ m{Can't locate CPAN/MyConfig\.pm} ) {
    croak "CPAN::MyConfig error: $@";
  }
  unless ( $INC{'CPAN/MyConfig.pm'} ) {
    eval { require CPAN::Config };
    if ( $@ and $@ !~ m{Can't locate CPAN/Config\.pm} ) {
      croak "CPAN::Config error: $@";
    }
  }
}

sub _catfile { File::Spec->canonpath( File::Spec->catfile( @_ ) ); }

1;

__END__

=head1 NAME

Acme::CPANAuthors::Utils

=head1 DESCRIPTION

This may export several utility functions to use internally.

=head1 FUNCTIONS

=head2 cpan_authors (exportable)

returns a (probably cached) Parse::CPAN::Authors object.

=head2 cpan_packages (exportable)

returns a (probably cached) Parse::CPAN::Packages object.

=head2 clear_cached_cpan_files

clears cached Parse::CPAN::Authors/Packages objects.

=head1 AUTHOR

Kenichi Ishigaki, E<lt>ishigaki at cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2007 by Kenichi Ishigaki.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
