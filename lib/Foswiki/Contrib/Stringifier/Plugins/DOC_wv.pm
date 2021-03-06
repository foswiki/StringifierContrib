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

package Foswiki::Contrib::Stringifier::Plugins::DOC_wv;

use strict;
use warnings;

use Foswiki::Contrib::Stringifier::Base ();
use Foswiki::Contrib::Stringifier ();

our @ISA = qw( Foswiki::Contrib::Stringifier::Base );
use File::Temp ();

my $wvText = $Foswiki::cfg{StringifierContrib}{wvTextCmd} || 'wvText';

if (defined($Foswiki::cfg{StringifierContrib}{WordIndexer}) &&
    ($Foswiki::cfg{StringifierContrib}{WordIndexer} eq 'wv')) {
    # Only if wv exists, I register myself.
    if (__PACKAGE__->_programExists($wvText)){
        __PACKAGE__->register_handler("application/word", ".doc");
    }
}


sub stringForFile {
    my ($self, $file) = @_;

    my $tmpFile = File::Temp->new(SURFIX => ".txt");
    
    my $cmd = $wvText . ' %FILENAME|F% %TMPFILE|F%';
    my ($output, $exit) = Foswiki::Sandbox->sysCommand($cmd, FILENAME => $file, TMPFILE => $tmpFile->filename);
    
    return '' unless ($exit == 0);

    my $in;
    open($in, $tmpFile) or return "";
    local $/ = undef;    # set to read to EOF
    my $text = <$in>;
    close($in);

    $text = $self->decode($text);
    $text =~ s/^\s+|\s+$//g;

    return $text;
}

1;
