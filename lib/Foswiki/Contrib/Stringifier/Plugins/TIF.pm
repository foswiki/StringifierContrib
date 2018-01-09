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

package Foswiki::Contrib::Stringifier::Plugins::TIF;

use strict;
use warnings;

use Foswiki::Contrib::Stringifier::Base ();
our @ISA = qw( Foswiki::Contrib::Stringifier::Base );

my $tesseractCmd = $Foswiki::cfg{StringifierContrib}{tesseractCmd} || 'tesseract';

if (__PACKAGE__->_programExists($tesseractCmd)) {
  __PACKAGE__->register_handler("image/tiff", ".tif", ".tiff");
}

sub stringForFile {
    my ($self, $filename) = @_;
    
    # check it is a text file
    return '' unless ( -e $filename );

    my $cmd = $tesseractCmd;
    $cmd .= " %FILENAME|F% -" unless $cmd =~ /%FILENAME\|F%/; 

    my ($text, $exit) = Foswiki::Sandbox->sysCommand($cmd, FILENAME => $filename);

    return $self->decode($text);
}

1;

