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
    --help                  display this help and exit.

Run 'perldoc -f -X' to list different TESTs.
EOF

my ($or, $null, $tests) = (1, 0, "");

foreach (@ARGV) {
  # current element is stored in $_
  if ($_ =~ /--help|-h/) {
    print $short_usage;
    print $help;
    exit 1;
  } elsif ($_ =~ /--null|-0/) {
    $null = 1;
  } elsif ($_ =~ /--and|-a/) {
    $or = 0;
  } else {
    $tests .= ($or && $tests) ? " || $_ _" : " $_";
  }
}

if (!$tests) {
  print $short_usage;
  exit 1;
}

{
  # change input record separator if needed
  local $/ = "\0" if $null;

  my $path;
  while (<STDIN>) {
    $path = $_;
    chomp; # remove rs
    # file test uses $_ if no argument is given
    print $path if eval "return ($tests)";
  }
}
