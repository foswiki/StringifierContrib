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

use Foswiki::Contrib::Stringifier::Base;
our @ISA = qw( Foswiki::Contrib::Stringifier::Base );
use File::MMagic();

our $mmagic;
sub mmagic {
  $mmagic = File::MMagic->new() unless $mmagic;
  return $mmagic;
}

sub stringFor {
  my ($class, $filename) = @_;

  return unless -r $filename;
  my $mime = mmagic->checktype_filename($filename);
  my $self = $class->handler_for($filename, $mime)->new();

  #print STDERR "file $filename is a $mime ... using $self\n";

  my $text = $self->stringForFile($filename);

  $text = $self->decode($text);

  $text =~ s/^\s+//;
  $text =~ s/\s+$//;

  return $text;
}


1;

