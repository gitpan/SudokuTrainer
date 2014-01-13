use strict;
use warnings;

# check whether there is a sub for each supported strategy
# for this purpose feed SudokuTrainer with an unsolvable puzzle
# this forces SudokuTrainer to try all supported strategies

use Test::More tests => 1;

my $trainer = 'script/sudokutrainer.pl';
-e $trainer  or  die "Kann $trainer nicht finden";

# CPAN Authors FAQ
use Tk;
my $mw = eval { MainWindow->new };
if (!$mw) { plan( skip_all => "Tk needs a graphical monitor" ); }
use Config;
my $path_to_perl = $Config{perlpath};

my $testfile = 'no_solution.sudo';
open (my $EXAMP, '>', $testfile)  or  die "Cannot open $testfile: $!";
print $EXAMP <<'END';   # has 17 preset values
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

#my $result = (`perl $trainer --test $testfile`)[-1];
my $result = (`$path_to_perl $trainer --test $testfile`)[-1];
chomp $result if defined $result;
# 9*9 - 17 = 64
is($result, 'missing 64', 'all strategies have code');

unlink $testfile or die "Cannot unlink $testfile: $!";

