# Copyright (C) 2022-2024 Foswiki Contributors
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

package Foswiki::Contrib::Stringifier::Plugins::EBOOK;

use strict;
use warnings;

use Foswiki::Func();
use Foswiki::Contrib::Stringifier::Base ();
our @ISA = qw( Foswiki::Contrib::Stringifier::Base );
use File::Temp ();

if (__PACKAGE__->_programExists("ebook-convert") ) {
    __PACKAGE__->register_handler( ".azw", ".azw3", ".azw4", ".cbz", ".cbr", ".cbc", ".chm", ".djvu", ".epub", ".fb2", ".fbz", ".htmlz", ".lit", ".lrf", ".mobi", ".prc", ".pdb", ".pml", ".rb", ".snb", ".tcr", ".txtz")
}

sub stringForFile {
    my ($this, $filename) = @_;

    my $cmd = $Foswiki::cfg{StringifierContrib}{Ebook2txtCmd} || 'ebook-convert %FILENAME|F% %TMPFILE|F%';
    my $tmpFile = File::Temp->new(SUFFIX =>".txt");
    my ($output, $exit, $error) = Foswiki::Sandbox->sysCommand($cmd, FILENAME => $filename, TMPFILE => $tmpFile->filename);

    if ($exit) {
      print STDERR "ERROR: $error\n";
      return "";
    }

    my $text = Foswiki::Func::readFile($tmpFile);

    $text = $this->decode($text);
    $text =~ s/^\s+//;
    $text =~ s/\s+$//;

    return $text;
}

1;

