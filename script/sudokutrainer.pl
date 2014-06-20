#!/usr/bin/perl
use strict;
use warnings;
#use feature qw( say );

package main;

use version; our $VERSION = qv('0.03');    # PBP

=begin ignore

BEGIN {
    use Games::Sudoku::Trainer::Cell;
    use Games::Sudoku::Trainer::Unit;
    use Games::Sudoku::Trainer::Const_structs;
    use Games::Sudoku::Trainer::Priorities;
    use Games::Sudoku::Trainer::Found_info;
    use Games::Sudoku::Trainer::Strategies;
    use Games::Sudoku::Trainer::Pause;
    use Games::Sudoku::Trainer::GUI;
    use Games::Sudoku::Trainer::GUIhist;
    use Games::Sudoku::Trainer::Write_puzzle;
    use Games::Sudoku::Trainer::Check_pause;
    use Games::Sudoku::Trainer::Run;
}
Games::Sudoku::Trainer::Const_structs::define_objects();

push( @units, @rows[ 1 .. 9 ], @cols[ 1 .. 9 ], @blocks[ 1 .. 9 ] );
@lines = @units[ 0 .. 17 ];

Games::Sudoku::Trainer::Const_structs::define_crossRowCol();
Games::Sudoku::Trainer::Const_structs::define_crossLineBlock();

=end ignore

=cut

use Games::Sudoku::Trainer::Run;
main::init_all();

Tk::MainLoop();

