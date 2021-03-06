# Copyright (C) 2009 TWIKI.NET (http://www.twiki.net)
# Copyright (C) 2009-2018 Foswiki Contributors
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version. For
# more details read LICENSE in the root of this distribution.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#
# For licensing info read LICENSE file in the Foswiki root.

package Foswiki::Contrib::Stringifier::Plugins::PPTX;

use strict;
use warnings;

use Foswiki::Contrib::Stringifier::Base ();
our @ISA = qw( Foswiki::Contrib::Stringifier::Base );

my $pptx2txt = $Foswiki::cfg{StringifierContrib}{pptx2txtCmd} || 'pptx2txt.pl';

if ( (!defined($Foswiki::cfg{StringifierContrib}{PowerpointIndexer}) || $Foswiki::cfg{StringifierContrib}{PowerpointIndexer} eq 'script')
  && (__PACKAGE__->_programExists($pptx2txt)))
{
  __PACKAGE__->register_handler("text/pptx", ".pptx");
}

sub stringForFile {
    my ($self, $filename) = @_;
    
    my $cmd = $pptx2txt . ' %FILENAME|F% -';

    my ($text, $exit, $error) = Foswiki::Sandbox->sysCommand($cmd, FILENAME => $filename);

    if ($exit) {
      print STDERR "ERROR: $pptx2txt returned with code $exit - $error\n";
      return "";
    }

    $text = $self->decode($text);
    $text =~ s/^\s+|\s+$//g;

    return $text;
}

1;
