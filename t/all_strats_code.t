use strict;
use warnings;

# führe Testläufe für alle Dateien von '../Trainer/examples' durch.

use Test::More tests => 1;

my $trainer = 'script/sudokutrainer.pl';
-e $trainer  or  die "Kann $trainer nicht finden";

my $testfile = 'no_solution.sudo';
open (my $EXAMP, '>', $testfile)  or  die "Cannot open $testfile: $!";
print $EXAMP <<'END';
1-- --- --6
-2- --- -7-
--3 --- 8--

--- 4-9 ---
--- -5- ---
--- 1-6 ---

--2 --- 7--
-3- --- -8-
4-- --- --9
END

close ($EXAMP) or die "Cannot close $testfile: $!";

	my $result = (`perl $trainer --test $testfile`)[-1];
	chomp $result if defined $result;
    is($result, 'missing 64', 'all strategies have code');

unlink $testfile or die "Cannot unlink $testfile: $!";

