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

package Foswiki::Contrib::Stringifier::Base;

use strict;
use warnings;

use Encode      ();
use File::Which ();

use Module::Pluggable (
    require     => 1,
    search_path => [qw/Foswiki::Contrib::Stringifier::Plugins/]
);

__PACKAGE__->plugins;

{
    my %mime_handlers;
    my %extension_handlers;

    sub register_handler {
        my ( $package, @specs ) = @_;

        for my $spec (@specs) {
            if ( $spec =~ m{/} ) {
                $mime_handlers{$spec} = $package;
            }
            else {
                $extension_handlers{$spec} = $package;
            }
        }
    }

    sub handler_for {
        my ( $this, $filename, $mime ) = @_;

        if ( exists $mime_handlers{$mime} ) { return $mime_handlers{$mime} }
        $filename = lc($filename);
        for my $spec ( keys %extension_handlers ) {
            if ( $filename =~ /$spec$/ ) { return $extension_handlers{$spec} }
        }
        return;
    }

    # Returns 1, if the program can be called.
    # This is as service method that a sub calss can use to decise,
    # if it wants to register or not.
    sub _programExists {
        my ( $this, $program ) = @_;

        # work around a bug in old File::Which that doesn't like absolute paths
        return $program if -f $program;

        my $path = File::Which::which($program);
        return defined $path;
    }
}

sub new {
    my ($handler) = @_;
    my $this = bless {}, $handler;

    return $this;
}

sub decode {
    my ( $this, $string, $charSet ) = @_;

    $charSet ||= $Foswiki::cfg{Site}{CharSet} || 'utf-8';
    return Encode::decode( $charSet, $string );
}

sub encode {
    my ( $this, $string, $charSet ) = @_;

    $charSet ||= $Foswiki::cfg{Site}{CharSet} || 'utf-8';
    return Encode::encode( $charSet, $string );
}

1;
