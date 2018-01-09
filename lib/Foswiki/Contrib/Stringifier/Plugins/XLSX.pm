# Copyright (C) 2009-2018 Foswiki Contributors
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

package Foswiki::Contrib::Stringifier::Plugins::XLSX;

use strict;
use warnings;

use Foswiki::Contrib::Stringifier::Base ();
our @ISA = qw( Foswiki::Contrib::Stringifier::Base );

my $xlsx2csv = $Foswiki::cfg{StringifierContrib}{xlsx2csv} || 'xlsx2csv';

if (defined($Foswiki::cfg{StringifierContrib}{Excel2Indexer})
  && ($Foswiki::cfg{StringifierContrib}{Excel2Indexer} eq 'xlsx2csv'))
{
  if (__PACKAGE__->_programExists($xlsx2csv)) {
    __PACKAGE__->register_handler("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", ".xlsx");
  }
}

sub stringForFile {
    my ($self, $filename) = @_;
    
    my $cmd = $xlsx2csv . ' -i -d tab %FILENAME|F%';
    my ($text, $exit) = Foswiki::Sandbox->sysCommand($cmd, FILENAME => $filename);

    return '' unless $exit == 0;

    $text = $self->decode($text);
    $text =~ s/^\s+|\s+$//g;

    return $text;
}

1;
