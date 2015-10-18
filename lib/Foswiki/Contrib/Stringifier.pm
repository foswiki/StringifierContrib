# Plugin for Foswiki - The Free and Open Source Wiki, http://foswiki.org/
#
# Copyright (C) 2009-2015 Foswiki Contributors
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

  return $mimeType;
}



sub stringFor {
  my ($class, $filename) = @_;

  return unless -r $filename;
  my $mime = _getMimeType($filename);

  #print STDERR "no mime for $filename\n" unless $mime;
  return unless $mime;

  my $impl = $class->handler_for($filename, $mime);

  #print STDERR "file $filename is a $mime ... using ".($impl||'undef')."\n";
  return unless $impl;

  my $plugin = $impl->new();

  return $plugin->stringForFile($filename);
}



1;

