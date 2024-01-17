# Copyright (C) 2009-2024 Foswiki Contributors
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version. For
# more details read LICENSE in the root of this distribution.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#
# For licensing info read LICENSE file in the Foswiki root.

package Foswiki::Contrib::Stringifier::Plugins::XLSX_script;

use strict;
use warnings;

use Foswiki::Contrib::Stringifier::Base ();
our @ISA = qw( Foswiki::Contrib::Stringifier::Base );

if (defined($Foswiki::cfg{StringifierContrib}{Excel2Indexer})
  && ($Foswiki::cfg{StringifierContrib}{Excel2Indexer} eq 'script'))
{
  __PACKAGE__->register_handler("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", ".xlsx", ".xlsm");
}

sub stringForFile {
    my ($this, $filename) = @_;
    
    my $cmd = $Foswiki::cfg{StringifierContrib}{Xlsx2txtCmd} || "$Foswiki::cfg{ToolsDir}/xlsx2txt.pl %FILENAME|F% -";
    my ($text, $exit, $error) = Foswiki::Sandbox->sysCommand($cmd, FILENAME => $filename);
    
    if ($exit) {
      print STDERR "ERROR: $error\n";
      return "";
    }

    $text = $this->decode($text);
    $text =~ s/^\s+//;
    $text =~ s/\s+$//;

    return $text;
}

1;
