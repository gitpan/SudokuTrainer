use strict;
use warnings;
use Test::More;
use Cwd;

diag ('current work dir is ', getcwd());
diag ('@INC is ', "\n" . join("\n", @INC));
plan( skip_all => "No tests here" );

