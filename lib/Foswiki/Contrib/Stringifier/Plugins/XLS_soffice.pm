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

package Foswiki::Contrib::Stringifier::Plugins::XLS_soffice;

use strict;
use warnings;

use Foswiki::Contrib::Stringifier::Base ();
our @ISA = qw( Foswiki::Contrib::Stringifier::Base );

use Foswiki::Func ();
use File::Temp ();
use File::Basename qw(basename);

my $soffice = $Foswiki::cfg{StringifierContrib}{sofficeCmd} || '/usr/bin/soffice';

if (defined($Foswiki::cfg{StringifierContrib}{ExcelIndexer}) && 
    ($Foswiki::cfg{StringifierContrib}{ExcelIndexer} eq 'soffice')) {
    if (__PACKAGE__->_programExists($soffice)) {
        __PACKAGE__->register_handler("application/excel", ".xls");
    }
}
if (defined($Foswiki::cfg{StringifierContrib}{Excel2Indexer}) && 
    ($Foswiki::cfg{StringifierContrib}{Excel2Indexer} eq 'soffice')) {
    if (__PACKAGE__->_programExists($soffice)) {
        __PACKAGE__->register_handler("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", ".xlsx");
    }
}

sub stringForFile {
    my ($self, $file) = @_;
    my $tmpDir = File::Temp->newdir();
    
    my $cmd = $soffice . ' --convert-to html --invisible --headless --minimized --outdir %OUTDIR|F% %FILENAME|F%';

    my ($data, $exit) = Foswiki::Sandbox->sysCommand(
        $cmd,
        OUTDIR => $tmpDir->dirname,
        FILENAME  => $file,
    );

    return '' unless ($exit == 0);

    my $tmpFile = $tmpDir->dirname . '/' . basename($file, ".xls", ".xlsx") . '.html';

    return Foswiki::Contrib::Stringifier->stringFor($tmpFile, "text/html");
}

1;

