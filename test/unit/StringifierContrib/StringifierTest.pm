package StringifierTest;
use FoswikiFnTestCase;
our @ISA = qw( FoswikiFnTestCase );

use strict;
use utf8;
use Encode ();

sub encode {
  my ($this, $string) = @_;

  $string = Encode::encode($Foswiki::cfg{Site}{CharSet}, $string) unless $Foswiki::UNICODE;

  return $string;
}

1;
