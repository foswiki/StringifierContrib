#!/usr/bin/env perl

# docx2txt, a command-line utility to convert Docx documents to text format.
# Copyright (C) 2008-2009 Sandeep Kumar
# Copyright (C) 2009-2024 Foswiki Contributors
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA

#
# This script extracts text from document.xml contained inside .docx file.
# Perl v5.8.2 was used for testing this script.
#
# Author : Sandeep Kumar (shimple0 -AT- Yahoo .DOT. COM)
#
# ChangeLog :
#
#    10/08/2008 - Initial version (v0.1)
#    15/08/2008 - Script takes two arguments [second optional] now and can be
#                 used independently to extract text from docx file. It accepts
#                 docx file directly, instead of xml file.
#    18/08/2008 - Added support for center and right justification of text that
#                 fits in a line 80 characters wide (adjustable).
#    03/09/2008 - Fixed the slip in usage message.
#    12/09/2008 - Slightly changed the script invocation and argument handling
#                 to incorporate some of the shell script functionality here.
#                 Added support to handle embedded urls in docx document.
#    23/09/2008 - Changed #! line to use /usr/bin/env - good suggestion from
#                 Rene Maroufi (info>AT<maroufi>DOT<net) to reduce user work
#                 during installation.
#    31/08/2009 - Added support for handling more escape characters.
#                 Using OS specific null device to redirect stderr.
#                 Saving text file in binary mode.
#    03/09/2009 - Updations based on feedback/suggestions from Sergei Kulakov
#                 (sergei>AT<dewia>DOT<com).
#                 - removal of non-document text in between TOC related tags.
#                 - display of hyperlink alongside linked text user controlled.
#                 - some character conversion updates
#    05/09/2009 - Merged cjustify and rjustify into single subroutine justify.
#                 Added more character conversions.
#                 Organised conversion mappings in tabular form for speedup and
#                 easy maintenance.
#                 Tweaked code to reduce number of passes over document content.
#


#
# Adjust the settings here.
#

use strict;
use warnings;

my $unzip = "/usr/bin/unzip";  # Windows path like "C:\\path\\to\\unzip.exe"
my $nl = "\n";		# Alternative is "\r\n".
my $lindent = "  ";	# Indent nested lists by "\t", " " etc.
my $lwidth = 80;	# Line width, used for short line justification.
my $showHyperLink = "N"; # Show hyperlink alongside linked text.

# ToDo: Better list handling. Currently assumed 8 level nesting.
my @levchar = ('*', '+', 'o', '-', '**', '++', 'oo', '--');

#
# Character conversion tables
#

# Only amp, gt and lt are required for docx escapes, others are used for better
# text experience.
my %escChrs = (	amp => '&', gt => '>', lt => '<',
		acute => '\'', brvbar => '|', copy => '(C)', divide => '/',
		laquo => '<<', macr => '-', nbsp => ' ', raquo => '>>',
		reg => '(R)', shy => '-', times => 'x'
);

my %splchars = (
	"\xC2\xA0" => ' ',		# <nbsp>
	"\xC2\xA6" => '|',		# <brokenbar>
	"\xC2\xA9" => '(C)',		# <copyright>
	"\xC2\xAB" => '<<',		# <laquo>
	"\xC2\xAC" => '-',		# <negate>
	"\xC2\xAE" => '(R)',		# <regd>
	"\xC2\xB1" => '+-',		# <plusminus>
	"\xC2\xBB" => '>>',		# <raquo>

#	"\xC2\xA7" => '',		# <section>
#	"\xC2\xB6" => '',		# <para>

	"\xC3\x97" => 'x',		# <mul>
	"\xC3\xB7" => '/',		# <div>

	"\xE2\x80\x82" => '  ',		# <enspc>
	"\xE2\x80\x83" => '  ',		# <emspc>
	"\xE2\x80\x85" => ' ',		# <qemsp>
	"\xE2\x80\x93" => ' - ',	# <endash>
	"\xE2\x80\x94" => ' -- ',	# <emdash>
	"\xE2\x80\x98" => '`',		# <soq>
	"\xE2\x80\x99" => '\'',		# <scq>
	"\xE2\x80\x9C" => '"',		# <doq>
	"\xE2\x80\x9D" => '"',		# <dcq>
	"\xE2\x80\xA2" => '::',		# <diamond symbol>
	"\xE2\x80\xA6" => '...',	# <ellipsis>

	"\xE2\x84\xA2" => '(TM)',	# <trademark>

	"\xE2\x89\xA0" => '!=',		# <neq>
	"\xE2\x89\xA4" => '<=',		# <leq>
	"\xE2\x89\xA5" => '>=',		# <geq>

	#
	# Currency symbols
	#
	"\xC2\xA2" => 'cent',
	"\xC2\xA3" => 'Pound',
	"\xC2\xA5" => 'Yen',
	"\xE2\x82\xAC" => 'Euro'
);


#
# Check argument(s) sanity.
#

my $usage = <<USAGE;

Usage:	$0 <infile.docx> [outfile.txt|-]

	Use '-' as the outfile name to dump the text on STDOUT.
	Output is saved in infile.txt if second argument is omitted.

USAGE

die $usage if (@ARGV == 0 || @ARGV > 2);

stat($ARGV[0]);
die "Can't read docx file <$ARGV[0]>!\n" if ! (-f _ && -r _);
die "<$ARGV[0]> does not seem to be docx file!\n" if -T _;


#
# Extract needed data from argument docx file.
#

my $nulldevice;
if ($ENV{OS} && $ENV{OS} =~ /^Windows/) {
    $nulldevice = "nul";
} else {
    $nulldevice = "/dev/null";
}

my $content = `$unzip -p '$ARGV[0]' word/document.xml 2>$nulldevice`;
die "Failed to extract required information from <$ARGV[0]>!\n" if ! $content;


#
# Be ready for outputting the extracted text contents.
#

if (@ARGV == 1) {
     $ARGV[1] = $ARGV[0];
     $ARGV[1] .= ".txt" if !($ARGV[1] =~ s/\.docx$/\.txt/);
}

my $txtfile;
open($txtfile, "> $ARGV[1]") || die "Can't create <$ARGV[1]> for output!\n";


#
# Gather information about header, footer, hyperlinks, images, footnotes etc.
#

$_ = `$unzip -p '$ARGV[0]' word/_rels/document.xml.rels 2>$nulldevice`;

my %docurels;
while (/<Relationship Id="(.*?)" Type=".*?\/([^\/]*?)" Target="(.*?)"( .*?)?\/>/g)
{
    $docurels{"$2:$1"} = $3;
}


#
# Subroutines for center and right justification of text in a line.
#

sub justify {
    my $len = length $_[1];

    if ($_[0] eq "center" && $len < ($lwidth - 1)) {
        return ' ' x (($lwidth - $len) / 2) . $_[1];
    } elsif ($_[0] eq "right" && $len < $lwidth) {
        return ' ' x ($lwidth - $len) . $_[1];
    } else {
        return $_[1];
    }
}

#
# Subroutines for dealing with embedded links and images
#

sub hyperlink {
    return $_[1] . (lc $showHyperLink eq "y" ? " [HYPERLINK: $docurels{\"hyperlink:$_[0]\"}]" : "");
}


#
# Text extraction starts.
#

my %tag2chr = (tab => "\t", noBreakHyphen => "-", softHyphen => " - ");

$content =~ s/<?xml .*?\?>(\r)?\n//;

$content =~ s{<w:p [^/>]+?/>|</w:p>|<w:br/>}|$nl|og;

$content =~ s{<w:(tab|noBreakHyphen|softHyphen)/>}|$tag2chr{$1}|og;

my $hr = '-' x 78 . $nl;
$content =~ s|<w:pBdr>.*?</w:pBdr>|$hr|og;

$content =~ s|<w:numPr><w:ilvl w:val="([0-9]+)"/>|$lindent x $1 . "$levchar[$1] "|oge;

#
# Uncomment either of below two lines and comment above line, if dealing
# with more than 8 level nested lists.
#

# $content =~ s|<w:numPr><w:ilvl w:val="([0-9]+)"/>|$lindent x $1 . '* '|oge;
# $content =~ s|<w:numPr><w:ilvl w:val="([0-9]+)"/>|'*' x ($1+1) . ' '|oge;

$content =~ s{<w:caps/>.*?(<w:t>|<w:t [^>]+>)(.*?)</w:t>}/uc $2/oge;

$content =~ s{<w:pPr><w:jc w:val="([^"]*?)"/></w:pPr><w:r><w:t>(.*?)</w:t></w:r>}/justify($1,$2)/oge;

$content =~ s{<w:hyperlink r:id="(.*?)".*?>(.*?)</w:hyperlink>}/hyperlink($1,$2)/oge;

# Remove stuff between TOC related tags.
if ($content =~ m|<w:pStyle w:val="TOCHeading"/>|) {
    $content =~ s|<w:instrText[^>]*>.*?</w:instrText>||og;
}

$content =~ s/<.*?>//og;


#
# Convert non-ASCII characters/character sequences to ASCII characters.
#

$content =~ s/(\xE2..|\xC2.|\xC3.)/($splchars{$1} ? $splchars{$1} : $1)/oge;

#
# Convert docx specific escape chars first.
#
$content =~ s/(&)(amp|gt|lt)(;)/$escChrs{lc $2}/iog;

#
# Another pass for a better text experience, after sequences like "&amp;laquo;"
# are converted to "&laquo;".
#
$content =~ s/((&)([a-z]+)(;))/($escChrs{lc $3} ? $escChrs{lc $3} : $1)/ioge;


#
# Write the extracted and converted text contents to output.
#

binmode $txtfile;    # Ensure no auto-conversion of '\n' to '\r\n' on Windows.
print $txtfile $content;
close $txtfile;

