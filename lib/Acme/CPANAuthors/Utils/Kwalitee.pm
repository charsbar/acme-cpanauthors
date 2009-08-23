package Acme::CPANAuthors::Utils::Kwalitee;

use strict;
use warnings;
use Web::Scraper;
use URI;

sub _uri { URI->new( "http://cpants.perl.org/author/" . shift ) }

sub fetch {
  my ($class, $id) = @_;

  return unless $id;

  my $rule = scraper {
    process 'table#info>tr' =>
      'infos[]' => scraper { process 'td' => 'texts[]' => 'TEXT'; };
    process 'table#grid>tr' =>
      'grids[]' => scraper {
        process 'td' => 'texts[]'   => 'TEXT';
        process 'td' => 'titles[]'  => '@title';
        process 'td' => 'classes[]' => '@class';
      };
  };

  sleep 1; # intentional delay not to access too frequently

  my $scraped = $rule->scrape( _uri( $id ) );

  my $info;
  foreach my $row ( @{ $scraped->{infos} } ) {
    my ( $key, $value ) = @{ $row->{texts} };
    $key =~ tr/ /_/;
    $info->{$key} = $value;
  }

  my $dist;
  shift @{ $scraped->{grids} };  # cut off the header
  foreach my $row ( @{ $scraped->{grids} } ) {
    my ( $package, $kwalitee ) = @{ $row->{texts} };
    my @titles  = grep { defined } @{ $row->{titles} };
    my @classes = grep { defined } @{ $row->{classes} };

    my %details; @details{@titles} = @classes;
    $dist->{$package} = { kwalitee => $kwalitee, details => \%details };
  }

  return { info => $info, distributions => $dist };
}

1;

__END__

=head1 NAME

Acme::CPANAuthors::Utils::Kwalitee

=head1 SYNOPSIS

    use Acme::CPANAuthors::Utils::Kwalitee;

    my $info = Acme::CPANAuthors::Utils::Kwalitee->fetch('ISHIGAKI');

    # then, $info will have keys/values like this
    # (though this may change without notices)

    {
      info => {
        Average_Kwalitee => "144.333",
        CPANTS_Game_Kwalitee => "98.833",
        Email => "ishigaki\@cpan.org",
        Liga => "5 or more",
        Rank => 47,
      },
      distributions => {
        "Acme-CPANAuthors" => {
          details  => { "use_strict" => "ok", ... },
          kwalitee => "144.000",
        },
        ...
      },
    }

=head1 DESCRIPTION

This is mainly to create some local kwalitee rankings for you :)

=head1 METHODS

=head2 fetch

returns kwalitee information for the author of the id.
This information is scraped from http://cpants.perl.org/.

=head1 AUTHOR

Kenichi Ishigaki, E<lt>ishigaki at cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2007 by Kenichi Ishigaki.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
