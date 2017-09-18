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

package Foswiki::Contrib::Stringifier::Plugins::PPT;

use strict;
use warnings;

use Foswiki::Contrib::Stringifier::Base ();
our @ISA = qw( Foswiki::Contrib::Stringifier::Base );
use Foswiki::Contrib::Stringifier  ();
use File::Temp ();

my $ppthtml = $Foswiki::cfg{StringifierContrib}{ppthtmlCmd} || 'ppthtml';

if ((!defined($Foswiki::cfg{StringifierContrib}{PowerpointIndexer}) || $Foswiki::cfg{StringifierContrib}{PowerpointIndexer} eq 'script')
  && __PACKAGE__->_programExists($ppthtml))
{
  __PACKAGE__->register_handler("text/ppt", ".ppt");
}

sub stringForFile {
    my ($self, $filename) = @_;
    
    # First I convert PPT to HTML
    my $cmd = $ppthtml . ' %FILENAME|F%';
    my ($output, $exit, $error) = Foswiki::Sandbox->sysCommand($cmd, FILENAME => $filename);

    if ($exit) {
      print STDERR "EROR: $ppthtml - $error\n";
      return "";
    }

    # put the html into a temporary file
    my $tmpFile = File::Temp->new(SUFFIX=>".html");
    binmode($tmpFile, ":utf8");
    print $tmpFile $output;

    return Foswiki::Contrib::Stringifier->stringFor($tmpFile->filename, "text/html");
}

1;
