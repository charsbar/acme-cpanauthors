package Acme::CPANAuthors::Utils::Kwalitee;

use strict;
use warnings;
use LWP::UserAgent;
use JSON ();

my $ua;

sub _uri { "http://api.cpanauthors.org/kwalitee/" . shift }

sub _ua {
  my $class = shift;
  $ua = $_[0] if @_;
  $ua ||= LWP::UserAgent->new;
  $ua;
}

sub fetch {
  my ($class, $id) = @_;

  return unless $id;

  my $res = $class->_ua->get(_uri(lc $id));
  return unless $res->is_success;

  my $json = eval { JSON::decode_json($res->content) };
  if ($@) {
    warn $@;
    return;
  }
  return $json;
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
