NAME
====

Opt::Handler - Provides easy, semi-automated CLI argument handling

SYNOPSIS
========

```raku
use Opt::Handler;

# Describe the execution modes of the program. Modes are mutually
# exclusive, i.e., only one can be used at a time.
my @modes = [
    # The first word of each line is the option configuration as used and described
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

# At this point, all captured options and modes are listed
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
```

DESCRIPTION
===========

Opt::Handler is ...

AUTHOR
======

Tom Browder <tom.browder@gmail.com>

COPYRIGHT AND LICENSE
=====================

Copyright 2020 Tom Browder

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

