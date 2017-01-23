# Copyright (C) 2009-2017 Foswiki Contributors
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

package Foswiki::Contrib::Stringifier::Plugins::DOC_soffice;

use strict;
use warnings;

use Foswiki::Contrib::Stringifier::Base ();
our @ISA = qw( Foswiki::Contrib::Stringifier::Base );

use Foswiki::Func ();
use File::Temp ();
use File::Basename qw(basename);

my $soffice = $Foswiki::cfg{StringifierContrib}{sofficeCmd} || '/usr/bin/soffice';

if (defined($Foswiki::cfg{StringifierContrib}{WordIndexer}) && 
    ($Foswiki::cfg{StringifierContrib}{WordIndexer} eq 'soffice')) {
    if (__PACKAGE__->_programExists($soffice)) {
        __PACKAGE__->register_handler("application/word", ".doc", "text/docx", ".docx");
    }
}

sub stringForFile {
    my ($self, $file) = @_;
    my $tmpDir = File::Temp->newdir();
    
    my $cmd = $soffice . ' --convert-to txt:Text --invisible --headless --minimized --outdir %OUTDIR|F% %FILENAME|F%';

    my ($data, $exit) = Foswiki::Sandbox->sysCommand(
        $cmd,
        OUTDIR => $tmpDir->dirname,
        FILENAME  => $file,
    );

    return '' unless ($exit == 0);

    my $txtFile = $tmpDir->dirname . '/' . basename($file, ".docx", ".doc") . '.txt';

    my $text = Foswiki::Func::readFile($txtFile);

    $text = $self->decode($text);
    $text =~ s/^\s+|\s+$//g;

    return $text;
}

1;

