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

package Foswiki::Contrib::Stringifier::Plugins::HTML_links;

use strict;
use warnings;

use Foswiki::Contrib::Stringifier::Base ();
our @ISA = qw( Foswiki::Contrib::Stringifier::Base );

if (defined($Foswiki::cfg{StringifierContrib}{HtmlIndexer}) 
  && $Foswiki::cfg{StringifierContrib}{HtmlIndexer} eq 'links'
  && __PACKAGE__->_programExists("links"))
{
  __PACKAGE__->register_handler("text/html", ".html");
}

sub stringForFile {
    my ($this, $filename) = @_;
    
    # check it is a text file
    return '' unless ( -e $filename );

    my $cmd = $Foswiki::cfg{StringifierContrib}{LinksCmd} || 'links -dump %FILENAME|F%';

    my ($text, $exit, $error) = Foswiki::Sandbox->sysCommand($cmd, FILENAME => $filename);

    if ($exit) {
      print STDERR "ERROR: $error\n";
      return "";
    }

    $text = $this->decode($text);
    $text =~ s/<\?xml.*?\?>\s*//g;
    $text =~ s/^\s+//;
    $text =~ s/\s+$//;

    return $text;
}

1;
