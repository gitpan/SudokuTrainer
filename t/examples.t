use strict;
use warnings;

# führe Testläufe für alle Dateien von '../Trainer/examples' durch.

use Test::More;

my $trainer = 'script/sudokutrainer.pl';
-e $trainer  or  die "Kann $trainer nicht finden";
my $dirname = 'lib/Games/Sudoku/Trainer/examples';
#?? -e $dirname  or  die "Kann $dirname nicht finden";

my @files = allfilenames($dirname);
@files = grep {/.sudo$/} @files;
@files = grep {-f "$dirname/$_"} @files;
plan tests => scalar @files;

while (my $testfile = shift @files) {
	my $relpath = "$dirname/$testfile";
	next if -d $relpath;
	my $result = (`perl $trainer --test $relpath`)[-1];
	chomp $result if defined $result;
    is($result, 'found all', $testfile);

}

# return all file names of a directory (exept '.' and '..')
#
sub allfilenames {
	my ($dirname) = @_;

   -d $dirname  or  die "Kann $dirname nicht finden";
	my $PUZZLEDIR;
	opendir $PUZZLEDIR, $dirname;
	my @files = readdir $PUZZLEDIR;
	closedir $PUZZLEDIR;
	undef $PUZZLEDIR;

	@files = grep {$_ ne '.'  and  $_ ne '..'} @files;
	return @files;
}

