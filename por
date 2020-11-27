#!/usr/bin/env perl
#
# por (1)
#
# Henri Cattoire
#
use strict;
use warnings;
use 5.010;  # so filetest ops can stack

my $short_usage = "Usage: por TEST ...\n";
my $help = <<'EOF';
For each line from standard input, evaluate the specified TESTs under Perl with the line as the argument.

    -0, --null              separate filenames by a null character
    -a, --and               use logical and instead of or.
    --help                  display this help and exit

Run 'perldoc -f -X' to list different TESTs.
EOF

my ($logical_or, $null_terminate, $need_help, $test) = (1, 0, 0, "");

while (my $arg = shift(@ARGV)) {
  if ($arg =~ /--help|-h/) {
    print $short_usage;
    print $help;
    exit 1;
  } elsif ($arg =~ /--null|-0/) {
    $null_terminate = 1;
  } elsif ($arg =~ /--and|-a/) {
    $logical_or = 0;
  } else {
    $test .= ($logical_or && $test) ? " || $arg _" : " $arg";
  }
}

if (!$test) {
  print $short_usage;
  exit 1;
}

{
  # change input record separator if needed
  local $/ = "\0" if $null_terminate;

  my $path;
  while (<>) {
    # line of input is stored in $_
    $path = $_;
    chomp; # remove rs
    # print path if test (uses $_ as arg by default) returned true
    print($path) if eval "return ($test)";
  }
}
