#!perl

use 5.006;
use strict;
use warnings;
use Test::More;

# warn when I forgot to deactivate 'use feature' in source code

my $moduledir = "lib/Games/Sudoku/Trainer";
foreach my $filename (glob("$moduledir/\*.pm"), glob("script/\*.pl")) {
	open (my $IN, '<', $filename)  or  die  "cannot open $filename: $!";
	my $sourc;
	my $found = 0;
	while ($sourc = <$IN>) {
		next unless $sourc =~ /use\s+?feature/;
		if ($sourc =~ /^[^#]*?use\s+?feature/) {$found = 1; last};
	}

	diag ("'use feature' left active in $filename")  if $found;
	close $IN  or  die  "cannot close $filename: $!";
}
plan( skip_all => "No tests here" );

