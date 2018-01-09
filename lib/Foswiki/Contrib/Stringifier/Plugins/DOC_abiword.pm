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

package Foswiki::Contrib::Stringifier::Plugins::DOC_abiword;

use strict;
use warnings;

use Foswiki::Contrib::Stringifier::Base ();
our @ISA = qw( Foswiki::Contrib::Stringifier::Base );
use File::Temp ();

my $abiword = $Foswiki::cfg{StringifierContrib}{abiwordCmd} || 'abiword';

#only load abiword if the user has selected it in configure - Sven & Andrew have had no success with it
if (defined($Foswiki::cfg{StringifierContrib}{WordIndexer}) && 
    ($Foswiki::cfg{StringifierContrib}{WordIndexer} eq 'abiword')) {
# Only if abiword exists, I register myself.
    if (__PACKAGE__->_programExists($abiword)){
        __PACKAGE__->register_handler("application/word", ".doc");
    }
}

sub stringForFile {
    my ($self, $file) = @_;
    my $tmpFile = File::Temp->new(SUFFIX =>".txt");
    
    my $cmd = $abiword . ' --to=%TMPFILE|F% %FILENAME|F%';
    my ($output, $exit, $error) = Foswiki::Sandbox->sysCommand($cmd, TMPFILE => $tmpFile->filename, FILENAME => $file);

    if ($exit) {
      print STDERR "ERROR: $abiword returned with code $exit - $error\n";
      return "";
    }

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
