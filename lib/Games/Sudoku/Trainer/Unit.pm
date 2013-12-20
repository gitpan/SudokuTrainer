use strict;
use warnings;
#use feature qw( say );

# basic Sudoku structures
# don't panic - all basic Sudoku structures are constant
package main;
our @cells;     # cell objects
our @rows;      # row objects		(1 .. 9)
our @cols;      # col objects		(1 .. 9)
our @blocks;    # block objects		(1 .. 9)

package Games::Sudoku::Trainer::Unit;

use version; our $VERSION = qv('0.0.1');    # PBP

sub new {                                   # constructor for unit objects
    my $class = shift;

    my $self = {@_};

    # initialize property Cand_cells
    # index: cand. digit
    # value: array of active members with this cand.
    foreach my $cand ( 1 .. 9 ) {
        $self->{Cand_cells}[$cand] = [ @{ $self->{Members} } ];
    }
    return bless( $self, $class );
}

# Standard getters
sub get_Index { return $_[0]->{Index} }    # getter for Index
sub Name      { return $_[0]->{Name} }     # getter for Name

# getter for all Members of a unit (returns a copy of the array)
#
sub get_Members { return @{ $_[0]->{Members} } }

sub get_Member {    # getter for a member
    my $self = shift;
    my $idx  = shift;

    return $self->{Members}->[$idx];
}

sub active_Members {    # return the active members of a unit
    my $self = shift;

    return grep { not $_->Value } $self->get_Members;
}

# getter for a candidate count
#   my $candcount = $unit->get_Cand_count($cand_digit);
#
sub get_Cand_count {
    my $self = shift;
    my ($cand_idx) = @_;

    return scalar @{ $self->{Cand_cells}[$cand_idx] };
}

# remove a cell from property Cand_cells of a unit
#   my $bool = $unit->remove_Cand_cell($cand_digit, $cell);
#   $bool: false if value is already found (no error)
#
sub remove_Cand_cell {
    my $self = shift;
    my ( $cand_idx, $cell ) = @_;

    my $cells_ref = $self->{Cand_cells}[$cand_idx];
    return 0 unless @$cells_ref;    # already empty (no error)

    use List::MoreUtils qw(firstidx);
    my $pos_idx = firstidx { $_ == $cell } @$cells_ref;
    splice( @$cells_ref, $pos_idx, 1 );
    return 1;
}

# return the unit object for a given name
#	$unit = Games::Sudoku::Trainer::Unit->by_name($unit_name);
#
sub by_name {
    my $self = shift;
    my $name = shift;

    my ( $unitchar, $unitnum ) = ( $name =~ /^(\w)(\d)$/ );
    unless ($unitnum) {
        my @trace = caller(0);
        die "3\nInvalid unit name '$name' provided"
          . " by file $trace[1], line $trace[2]\n";
    }
    my ($unitarray_ref) =
      grep( { lc( substr( ref $_->[$unitnum], 0, 1 ) ) eq $unitchar }
        ( \@rows, \@cols, \@blocks ) );
    return $unitarray_ref->[$unitnum];
}

# return the line crossing the given line and passing through the given cell
# the cell needs not belong to the line
#	$cross = $line->crossline($cell);
#
sub crossline {
    my $self = shift;
    my $cell = shift;

    return ref $self eq 'Row'
      ? $cols[ $cell->Col_num ]
      : $rows[ $cell->Row_num ];
}

{

    package Row;

    use base qw/Games::Sudoku::Trainer::Unit/;

    sub new {    # constructor for row objects
        my $class = shift;
        my $idx   = shift;          # row index (1 .. 9)
        my $cell1 = 9 * $idx - 8;
        my @args  = (
            'Index', $idx,
            'Name',  "r$idx",
            'Members',
            [ @cells[ $cell1 .. $cell1 + 8 ] ],    # members are cell objects
        );
        my $self = $class->SUPER::new(@args);
        return $self;                              # blessed in SUPER::new
    }

    # Return the cell objects that lie in the cross section of 2 units
    #		@cross_cells = $unit1->crosssection($unit2);
    #
    sub crosssection {
        my ( $self, $unit2 ) = @_;

        return
            ref $unit2 eq 'Row' ? ()
          : ref $unit2 eq 'Col'
          ? ( Constant_structures::crossRowCol( $self, $unit2 ) )
          : @{ Constant_structures::crossRowBlock( $self, $unit2 ) };
    }
}

{

    package Col;

    use base qw/Games::Sudoku::Trainer::Unit/;

    sub new {    # constructor for col objects
        my $class = shift;
        my $idx   = shift;    # col index (1 .. 9)

        my $cell1   = $idx;
        my $members = [];
        foreach my $i ( 0 .. 8 ) {
            push @$members,
              $cells[ $cell1 + $i * 9 ];    # members are cell objects
        }
        my @args = ( 'Index', $idx, 'Name', "c$idx", 'Members', $members, );
        my $self = $class->SUPER::new(@args);
        return $self;                       # blessed in SUPER::new
    }

    # Return the cell objects that lie in the cross section of 2 units
    #		@cross_cells = $unit1->crosssection($unit2);
    #
    sub crosssection {
        my ( $self, $unit2 ) = @_;

        return
          ref $unit2 eq 'Row'
          ? ( Constant_structures::crossRowCol( $unit2, $self ) )
          : ref $unit2 eq 'Col' ? ()
          :   @{ Constant_structures::crossColBlock( $self, $unit2 ) };
    }
}

{

    package Block;

    use base qw/Games::Sudoku::Trainer::Unit/;

    sub new {    # constructor for block objects
        my $class = shift;
        my $idx   = shift;    # block index (1 .. 9)

        my @indx = ( 1 .. 3, 10 .. 12, 19 .. 21 );
        my $offset;
        $offset = 3 * ( ( $idx - 1 ) % 3 ) + 27 * int( ( $idx - 1 ) / 3 );
        $_ += $offset foreach @indx;
        my @args =
          ( 'Index', $idx, 'Name', "b$idx", 'Members', [ @cells[@indx] ], );
        my $self = $class->SUPER::new(@args);
        return $self;         # blessed in SUPER::new
    }

    # Return the cell objects that lie in the cross section of 2 units
    #		@cross_cells = $unit1->crosssection($unit2);
    #
    sub crosssection {
        my ( $self, $unit2 ) = @_;

        return
          ref $unit2 eq 'Row'
          ? @{ Constant_structures::crossRowBlock( $unit2, $self ) }
          : ref $unit2 eq 'Col'
          ? @{ Constant_structures::crossColBlock( $unit2, $self ) }
          : ();
    }
}

1;
