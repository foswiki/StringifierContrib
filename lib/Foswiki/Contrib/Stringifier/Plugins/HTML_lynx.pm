# Copyright (C) 2009-2018 Foswiki Contributors
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

package Foswiki::Contrib::Stringifier::Plugins::HTML_lynx;

use strict;
use warnings;

use Foswiki::Contrib::Stringifier::Base ();
our @ISA = qw( Foswiki::Contrib::Stringifier::Base );

my $lynxCmd = $Foswiki::cfg{StringifierContrib}{lynxCmd} || 'lynx';

if (defined($Foswiki::cfg{StringifierContrib}{HtmlIndexer}) && $Foswiki::cfg{StringifierContrib}{HtmlIndexer} eq 'lynx'
  && __PACKAGE__->_programExists($lynxCmd))
{
  __PACKAGE__->register_handler("text/html", ".html");
}

sub stringForFile {
    my ($self, $filename) = @_;
    
    # check it is a text file
    return '' unless ( -e $filename );

    my $cmd = $lynxCmd;
    $cmd .= " -dump %FILENAME|F%" unless $cmd =~ /%FILENAME\|F%/; 

    my ($text, $exit) = Foswiki::Sandbox->sysCommand($cmd, FILENAME => $filename);

    $text = $self->decode($text);
    $text =~ s/<\?xml.*?\?>\s*//g;
    $text =~ s/^\s+|\s+$//g;

    return $text;
}

1;
