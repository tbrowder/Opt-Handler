use Abbreviations;

unit class Opt::Handler:ver<0.0.1>:auth<cpan:TBROWDER>;

has @.modes;
has @.options;

has %.modes;
has %.options;

class opt {
    has $.name;
    has %.aliases;
    has $.help;
    has $.type; # per Getopt::Long

    my %typs = set <s i r f c p d a>
    # s - Str
    # i - Int
    # r - Rat
    # f - Num
    # c - Complex     (i+5i)
    # p - IO::Path    (foo/text)
    # d - DateTime    (2019-12-30T01:23:45-0700)
    # a - Date        (2019-12-30)
}

submethod TWEAK {
}

method usage {
    print "Usage: {$*PROGRAM.basename} ";
    print %.modes.keys.sort.join(' | ');
    say " [options..][--help]";
}

method help {
}

method debug {
}

method modes() {
    %.modes;
}

method options() {
    %.options;
}

=begin comment
# moving to its own module Abbreviations with exported multi "abbreviations"
sub get-abbrevs(@w, :$clean-dups --> Hash) is export {
    # Given a list of words, determine the shortest unique abbreviation
    # for each subset of words with the same intial character. The results
    # must be the same number of characters for each initial character. 
    # Return a hash of the input words as keys whose value is
    # a space-separated string
    # of their unique abbreviations, if any.
    
    # Get the max number of characters needed.
    # If the number of characters in a word is equal or less,
    # then it has no abbreviation.
    # NOTE: Use the ':$clean-dups' option to ensure there are
    # no duplicate words if needed.
    if $clean-dups {
        my %w;
        %w{$_} = 1 for @w;
        @w = %w.keys.sort;
    }

    my $achars = auto-abbreviation @w.join(' ');
    my %w;
    for @w -> $w {
        %w{$w} = '';
        my $nc = $w.chars;
        if $nc <= $achars {
           # no abbreviation
           next;
        }
        my $len = $achars;
        while $len < $nc {
            my $a = $w.substr(0, $len);
            %w{$w} ~= " $a";
            ++$len
        }
    }
    %w;
}

sub auto-abbreviation(Str $string --> UInt) is export {
    # Given a string consisting of words, return the minimum number
    # of characters to abbreviate the set.
    # WARNING: Inf is returned if there are duplicate words in the string,
    # so the user is warned to avoid that or catch the error exception.
    # 
    # Source: http://rosettacode.org/?
    return Nil unless my @words = $string.words;
    return $_ if @words>>.substr(0, $_).Set == @words for 1 .. @words>>.chars.max;
    return Inf;
}
# moving to its own module Abbreviations with exported multi "abbreviations"
=end comment

# a private method?
method !handle-args() {
}

=begin pod

=head1 NAME

Opt::Handler - Provides easy, semi-automated CLI argument handling

=head1 SYNOPSIS

=begin code :lang<raku>

use Opt::Handler;

# Describe the execution modes of the program. Modes are mutually
# exclusive, i.e., only one can be used at a time.
my @modes = [
    # The first word of each line is the option specification as used and described
    # in Getopt::Long. The rest of the text on the line is the help description of
    # the option.
    "init Initialize the framistan",
    "build Build the framework",
    "inspect:s Inspect building X",
];

my @options = [
    # Each line desribes an option in the same manner as the mode lines.
    # An option usually modifies a mode.
    # If not added explicitly, two options are alway added automatically: help and debug.
    "verbose Add one level of verbosity",
];

# Parse the @*ARGS list and capture all up until a '--' is found, if any.
# Any args remaining remaining stay in @*ARGS but are still available.
# If there any errors, a neat exception is thrown.
my $opt = Opt::Handler.new: :@modes, :@options;

# At this point, all recoghized and captured options and modes are listed
# as key/values in hashes $opt.modes and $opt.options.

#==========================================================
# Now start handling your modes and options with your code.
#==========================================================

# You may want to extract multi-use options explicitly
# before handling the modes for convenience:
my $debug = $opt.options<debug>;

for $opt.modes.keys {
    my $value = $opt{$_};
    when /init/ {
        # you check aplicable options
        my $oval = $opt.options<some-opt>;
        #
        # you provide the handler
        handle-init $value, $oval, :$debug;
    }
    # ...
    default {
        die "FATAL: Unhandled mode '$_'";
    }
}

=end code

=head1 DESCRIPTION

Opt::Handler is ...

=head1 AUTHOR

Tom Browder <tom.browder@gmail.com>

=head1 COPYRIGHT AND LICENSE

Copyright 2020 Tom Browder

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod
