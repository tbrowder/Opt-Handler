[![Actions Status](https://github.com/tbrowder/Opt-Handler/workflows/test/badge.svg)](https://github.com/tbrowder/Opt-Handler/actions)

WARNING - THIS MODULE IS IN DRAFT STATE 
----------------------------------------

PLEASE FILE ISSUES FOR FEATURE REQUESTS AND BUGS
------------------------------------------------

NAME
====

Opt::Handler - Provides easy, semi-automated CLI argument handling

UNIQUE FEATURES
===============

Define one or two lists of valid modes and options as input, instantiate the `Opt::Handler` with the lists as input and get:

  * All defined modes and options in one easy-to-access hash

  * Automatically generated `help`

  * Automatically generated `debug` option

  * Automatic error checking

  * Easier to use than Raku native option handling




SYNOPSIS
========

    use Opt::Handler;

Describe the execution *modes* of your CLI program. Modes are mutually exclusive options, i.e., only one can be used at a time. (A commonly provided option, `help`, is considered a mode in the context of this module.)

The first word of each line is the option specification as used and described in module [**Getopt::Long**](https://github.com/leont/getopt-long6). The rest of the text on the line is the description to be used with the automatically-provided `help` mode.

    my @modes = [
        # option spec    help text
        "init            Initialize the framistan",
        "build           Build the framework",
        "inspect:s       Inspect building X",
    ];

Describe the *options* of your CLI program. An option usually modifies a mode or otherwise affects program execution.

Each line describes an option in the same manner as the mode lines. If not added explicitly, one option is always added automatically: `debug`.

    my @options = [
        # option spec    help text
        "verbose         Add one level of verbosity",
    ];

We are now ready to instantiate our easy option handler in the following step. It will parse the `@*ARGS` array and capture all up until a `--` is found, if any. Any arguments remaining remaining stay in `@*ARGS` but are still available. If there any errors, an exception is thrown.

    my $opt = Opt::Handler.new: :@modes, :@options;

At this point, all recognized and captured modes and options are listed as key/values in hashes `$opt.modes` and `$opt.options`. Note each mode and option are considered together to extract unique abbreviations which will be shown with the `help` option.

Now start handling your modes and options with your code. You may want to extract multi-use options explicitly before handling the modes for convenience as shown in the following example.

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

DESCRIPTION
===========

**Opt::Handler** provides an easy way to start a *CLI* (Command Line Interface) program by hiding lots of boiler-plate code behind the scenes in a wrapper around Raku module [**Getopt::Long**](https://github.com/leont/getopt-long6).

It should be useful for those who aren't handy with the native CLI support already in Raku (which has improved greatly in the years since it was first released) but is still a little too tedious to set up for those with years of experience with building CLI tools in `Perl`.

AUTHOR
======

Tom Browder <tom.browder@gmail.com>

CREDITS
=======

  * Leon Timmermans (aka @Leont) for inspiration from his Raku module [**Getopt::Long**](https://github.com/leont/getopt-long6).

COPYRIGHT AND LICENSE
=====================

Copyright &#x00A9; 2020 Tom Browder

This library is free software; you can redistribute it or modify it under the Artistic License 2.0.

