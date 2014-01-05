#!perl

use 5.006;
use strict;
use warnings;
#use Test::More tests => 1;
#use Test::More tests => 0;
use Test::More;

my $moduledir = "lib/Games/Sudoku/Trainer";
#ok(-d $exampdir, "directory $exampdir exists") or BAIL_OUT('Dir examples not found');
#plan( skip_all => "No tests here" );
foreach my $filename (glob("$moduledir/\*.pm")) {
#diag ("\n $filename");
	open (my $IN, '<', $filename)  or  die  "cannot open $filename: $!";
	my $sourc;
	my $found = 0;
	while ($sourc = <$IN>) {
		next unless $sourc =~ /use\s+?feature.*?say/;
#diag ("line '$sourc'");
###		$found = 1;
#		if ($sourc =~ /^\s*?use\s+?feature.*?say/) {$found = 1; last};
#		if ($sourc =~ /[^#]*?use\s+?feature.*?say/) {$found = 1; last};
		if ($sourc =~ /^[^#]*?use\s+?feature.*?say/) {$found = 1; last};

#		if ($sourc =~ /^\s*?use\s+?feature.*?say/) {
###		if ($sourc =~ /#\s*?use\s+?feature.*?say/) {
#		if ($sourc =~ /\s*?use\s+?feature.*?say/) {
###diag ("found in line '$sourc'");
###$found = 0; last};
#           BAIL_OUT("Active \"feature 'say'\" found in $filename");
#        }
	}
#	diag 'found is ', $found;
#	isnt ($found, 1, "feature 'say' active in $filename");
	diag ("feature 'say' active in $filename")  if $found;
	close $IN  or  die  "cannot close $filename: $!";
}
plan( skip_all => "No tests here" );

