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

package Foswiki::Contrib::Stringifier::Plugins::PPT_soffice;

use strict;
use warnings;

use Foswiki::Contrib::Stringifier::Base ();
our @ISA = qw( Foswiki::Contrib::Stringifier::Base );

use Foswiki::Func ();
use File::Temp ();
use File::Basename qw(basename);

if ((!defined($Foswiki::cfg{StringifierContrib}{PowerpointIndexer}) || $Foswiki::cfg{StringifierContrib}{PowerpointIndexer} eq 'soffice')
  && __PACKAGE__->_programExists("soffice"))
{
  __PACKAGE__->register_handler("text/ppt", ".ppt", "text/pptx", ".pptx");
}

sub stringForFile {
    my ($this, $file) = @_;

    my $tmpDir = File::Temp->newdir();
    my $cmd = $Foswiki::cfg{StringifierContrib}{SofficeCmd} || 'soffice --convert-to %FORMAT|S% --invisible --headless --minimized --outdir %OUTDIR|F% %FILENAME|F%';

    my ($data, $exit, $error) = Foswiki::Sandbox->sysCommand(
        $cmd,
        OUTDIR => $tmpDir->dirname,
        FILENAME  => $file,
        FORMAT => "pdf"
    );

    if ($error) {
      print STDERR "ERROR: $error\n";
      return "";
    }

    my $pdfFile = $tmpDir->dirname . '/' . basename($file, ".pptx", ".ppt") . '.pdf';

    my $stringifier = Foswiki::Contrib::Stringifier::Plugins::PDF->new();
    return $stringifier->stringForFile($pdfFile);
}

1;


