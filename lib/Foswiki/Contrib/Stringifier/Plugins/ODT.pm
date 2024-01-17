# Copyright (C) 2011-2024 Foswiki Contributors
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

package Foswiki::Contrib::Stringifier::Plugins::ODT;

use strict;
use warnings;

use Foswiki::Contrib::Stringifier::Base ();
our @ISA = qw( Foswiki::Contrib::Stringifier::Base );

if (__PACKAGE__->_programExists("odt2txt")) {
  __PACKAGE__->register_handler("application/vnd.oasis.opendocument.chart", "odc");
  __PACKAGE__->register_handler("application/vnd.oasis.opendocument.database", "odb");
  __PACKAGE__->register_handler("application/vnd.oasis.opendocument.formula", "odf");
  __PACKAGE__->register_handler("application/vnd.oasis.opendocument.graphics", "odg");
  __PACKAGE__->register_handler("application/vnd.oasis.opendocument.graphics-template", "otg");
  __PACKAGE__->register_handler("application/vnd.oasis.opendocument.image", "odi");
  __PACKAGE__->register_handler("application/vnd.oasis.opendocument.presentation", "odp");
  __PACKAGE__->register_handler("application/vnd.oasis.opendocument.presentation-template", "otp");
  __PACKAGE__->register_handler("application/vnd.oasis.opendocument.spreadsheet", "ods");
  __PACKAGE__->register_handler("application/vnd.oasis.opendocument.spreadsheet-template", "ots");
  __PACKAGE__->register_handler("application/vnd.oasis.opendocument.text-master", "odm");
  __PACKAGE__->register_handler("application/vnd.oasis.opendocument.text", ".odt");
  __PACKAGE__->register_handler("application/vnd.oasis.opendocument.text-template", "ott");
  __PACKAGE__->register_handler("application/vnd.oasis.opendocument.text-web", "oth");
  __PACKAGE__->register_handler("application/vnd.sun.xml.calc", "sxc");
  __PACKAGE__->register_handler("application/vnd.sun.xml.calc.template", "stc");
  __PACKAGE__->register_handler("application/vnd.sun.xml.impress", "sxi");
  __PACKAGE__->register_handler("application/vnd.sun.xml.impress.template", "sti");
  __PACKAGE__->register_handler("application/vnd.sun.xml.writer", "sxw");
  __PACKAGE__->register_handler("application/vnd.sun.xml.writer.template", "stw");
}

sub stringForFile {
    my ($this, $filename) = @_;
    
    my $cmd = $Foswiki::cfg{StringifierContrib}{Odt2txtCmd} || 'odt2txt --encoding=UTF-8 %FILENAME|F%';
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
