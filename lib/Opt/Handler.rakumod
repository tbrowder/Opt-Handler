use Abbreviations;

unit class Opt::Handler:ver<0.0.3>:auth<cpan:TBROWDER>;

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

# a private method?
method !handle-args() {
}

=begin pod

=head2 WARNING - THIS MODULE IS IN DRAFT STATE 
=head2 PLEASE FILE ISSUES FOR FEATURE REQUESTS AND BUGS

=head1 NAME

Opt::Handler - Provides easy, semi-automated CLI argument handling

=head1 MARQUIS FEATURES

Define one or two lists of valid modes and options as input, instantiate the C<Opt::Handler>
with the lists as input and get:

=item All defined modes and options in one easy-to-access hash
=item All modes and options have all valid abbreviations auto-generated and show in help
=item Automatically generated C<help>
=item Automatically generated C<debug> option
=item Automatic error checking

And it's easier to set up and use than Raku native option handling.

=head1 

=head1 SYNOPSIS

=begin code 
use Opt::Handler;
=end code 

Describe the execution I<modes> of your CLI program. Modes are mutually
exclusive options, i.e., only one can be used at a time.
(A commonly provided option, C<help>, is considered a mode
in the context of this module.)

The first word of each line is the option specification as used and described
in module L<B<Getopt::Long>|https://github.com/leont/getopt-long6>. 
The rest of the text on the line is the description to be used with the
automatically-provided  C<help> mode.

=begin code 
my @modes = [
    # option spec    help text
    "init            Initialize the framistan",
    "build           Build the framework",
    "inspect:s       Inspect building X",
];
=end code 

Describe the I<options> of your CLI program.
An option usually modifies a mode or otherwise affects program execution.

Each line describes an option in the same manner as the mode lines.
If not added explicitly, one option is always added automatically: C<debug>.

=begin code 
my @options = [
    # option spec    help text
    "verbose         Add one level of verbosity",
];
=end code 

A very helpful feature is the automatic generation of valid and unique
abbreviations (aliases) over the combined set of your modes and options.
For example, given the modes and options above the C<help> mode should
show something like the following:

=head4 Progam execution with no arguments

=begin code
$ my-program
Usage: my-program init | build | inspect | help [options]
   or: my-program ini  | b     | ins     | h    [options]
=end code 

=head4 Program execution with help

=begin code
$ my-program -h
Usage: my-program <mode> [options]
    Modes:
      ini|init            Initialize the framistan
      b  |build           Build the framework
      ins|inspect [X]     Inspect [building X]
      h  |help

    Options:
      v  |verbose           Add one level of verbosity
      d  |debug             For development
=end code

We are now ready to instantiate our easy option handler in the 
following step.
It will parse the C<@*ARGS> array and capture all up until a C<--> is found, if any.
Any arguments remaining remaining stay in C<@*ARGS> but are still available.
If there any errors, an exception is thrown.

=begin code 
my $opt = Opt::Handler.new: :@modes, :@options;
=end code 

At this point, all recognized and captured modes and options are listed
as key/values in hashes C<$opt.modes> and C<$opt.options>.
Note each mode and option are considered together to extract
unique abbreviations which will be shown with the C<help> option
as demonstrated in the examples above.

Now start adding your own code to handle your modes and options.
You may want to extract multi-use options explicitly
before handling the modes for convenience as shown in the following example.

=begin code 
my $debug = $opt.options<debug>; # for convenience only
for $opt.modes.keys {
    my $value = $opt{$_};
    when /init/ {
        # you check aplicable options
        my $oval = $opt.options<some-opt>;

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

B<Opt::Handler> provides an easy way to start a I<CLI> (Command Line
Interface) program by hiding lots of boiler-plate code behind the
scenes in a wrapper around Raku module L<B<Getopt::Long>|https://github.com/leont/getopt-long6>.

It should be useful for those who aren't handy with the native CLI
support already in Raku (which has improved greatly in the years since
it was first released) but is still a little too tedious to set up for
those with years of experience with building CLI tools in C<Perl>.

=head1 AUTHOR

Tom Browder <tom.browder@gmail.com>

=head1 CREDITS

=item Leon Timmermans (aka @Leont) for inspiration from his Raku module L<B<Getopt::Long>|https://github.com/leont/getopt-long6>.

=head1 COPYRIGHT AND LICENSE

Copyright  &#x00A9; 2020 Tom Browder

This library is free software; you can redistribute it or modify it under the Artistic License 2.0.

=end pod
