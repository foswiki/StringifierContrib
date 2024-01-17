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

package Foswiki::Contrib::Stringifier::Plugins::Text;

use strict;
use warnings;

use Foswiki::Func ();
use Foswiki::Contrib::Stringifier::Base ();
our @ISA = qw( Foswiki::Contrib::Stringifier::Base );

__PACKAGE__->register_handler("text/plain", "text/xml", ".xml", ".txt", ".css", ".js", ".log", ".csv");

sub stringForFile {
    my ( $this, $file ) = @_;

    return '' unless -e $file;

    my $text = Foswiki::Func::readFile($file);

    $text =~ s/^\?//; # remove bom
    $text = $this->decode($text);
    $text =~ s/^\s+//;
    $text =~ s/\s+$//;
    
    return $text;
}
1;
