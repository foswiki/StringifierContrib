# Plugin for Foswiki - The Free and Open Source Wiki, http://foswiki.org/
#
# Copyright (C) 2009-2024 Foswiki Contributors
#
# For licensing info read LICENSE file in the Foswiki root.
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details, published at
# http://www.gnu.org/copyleft/gpl.html

package Foswiki::Contrib::Stringifier;

use strict;
use warnings;

use Foswiki::Func ();
use Foswiki::Contrib::Stringifier::Base;
our @ISA = qw( Foswiki::Contrib::Stringifier::Base );

our $types;
sub _getMimeType {
  my $fileName = shift;

  my $mimeType;

  if ($fileName && $fileName =~ /\.([^.]+)$/) {
    my $suffix = $1;

    unless ($types) {
      $types = Foswiki::Func::readFile($Foswiki::cfg{MimeTypesFileName});
    }

    if ($types =~ /^([^#]\S*).*?\s$suffix(?:\s|$)/im) {
      $mimeType = $1;
    }
  }

  print STDERR "Stringifier - getMimeType($fileName) = ".($mimeType//'undef')."\n" if $Foswiki::cfg{StringifierContrib}{Debug};


  return $mimeType;
}

sub canStringify {
  my ($this, $fileName) = @_;

  my $mime = _getMimeType($fileName);
  unless ($mime) {
    if ($fileName =~ /\.(.*?)$/) {
      $mime = $1;
    }
  }

  return $mime && $this->handler_for($fileName, $mime) ? 1:0;
} 

sub stringFor {
  my ($this, $fileName, $mime, $debug) = @_;

  $debug //= $Foswiki::cfg{StringifierContrib}{Debug};

  return unless -r $fileName;
  $mime = _getMimeType($fileName) unless defined $mime;

  unless ($mime) {
    if ($fileName =~ /\.(.*?)$/) {
      $mime = $1;
    }
  }

  if ($debug) {
    print STDERR "Stringifier - no mime for $fileName\n" unless $mime;
  }
  return unless $mime;

  my $impl = $this->handler_for($fileName, $mime);

  if ($debug) {
    print STDERR "file $fileName is a $mime ... using ".($impl||'undef')."\n";
  }
  return unless $impl;

  my $plugin = $impl->new();

  return $plugin->stringForFile($fileName);
}

1;

