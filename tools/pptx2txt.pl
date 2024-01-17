#!/usr/bin/env perl

use strict;
use warnings;

use Archive::Zip qw( :ERROR_CODES );
use XML::Twig;
my @text;

my $file = $ARGV[0];

die "Not able to read .pptx  file $file!\n" unless -f $file && -r $file;

my $zip = Archive::Zip->new();
$zip->read($file) == AZ_OK or die "Unable to open Office file\n";

my @slides = $zip->membersMatching("ppt/slides/slide.+\.xml");

my $twig = XML::Twig->new(
  keep_encoding =>1,
  keep_spaces => 1,
  twig_handlers => {
    "a:t" => sub {
      print $_->text()."\n";
    }
  }
);

for my $i (1 .. scalar @slides) {

  my $content = $zip->contents("ppt/slides/slide${i}.xml");
  $twig->parse($content);
}
