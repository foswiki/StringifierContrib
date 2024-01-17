#!/usr/bin/env perl
use strict;
use warnings;
use Spreadsheet::XLSX();
use Encode();

my $file = $ARGV[0];

unless ($file) {
  print STDERR "usage: xlsx2txt <file>\n";
  exit 1;
}

unless (-e $file) {
  print STDERR "file not found: $file\n";
  exit 1;
}

my $text = '';

my $book = Spreadsheet::XLSX->new($file);

if ($book) {
  foreach my $sheet (@{$book->{Worksheet}}) {
    $text .= sprintf("%s\n", $sheet->{Name});
    $sheet->{MaxRow} ||= $sheet->{MinRow};

    foreach my $row ($sheet->{MinRow} .. $sheet->{MaxRow}) {
      $sheet->{MaxCol} ||= $sheet->{MinCol};

      foreach my $col ($sheet->{MinCol} .. $sheet->{MaxCol}) {
	my $cell = $sheet->{Cells}[$row][$col];
	if ($cell) {
	  $text .= sprintf("%s\t", $cell->{Val});
	}
      }
      $text .= "\n";
    }
    $text .= "\n";
  }
}

print $text;
