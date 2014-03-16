use strict;
use warnings;
use feature qw( say );

package
    Games::Sudoku::Trainer::Found_info;

use version; our $VERSION = qv('0.02');    # PBP

my @pending;    # all Found_info objects waiting for processing

# constructor for Found_info objects
#   the new object is added to @pending
#
sub new {
    my $class     = shift;
    my $found_ref = shift;

    #TODO: future enhancement: replace array by named properties
    #    my @props_values = @_;   # property values

    #    my %props;
    #    @props{qw/stratname action clues results/} = (@props_values);
    #say "props ", %props;
    #    my $self = \%props;
    my $self = $found_ref;
    bless $self, $class;

    push @pending, $self;
    return;
}

# getter for Found_info objects
#   return the oldest pending Found_info object for processing
#
sub oldest {

    return shift @pending;
##	my $found_ref = shift @pending;
##	return $found_ref;
}

1;
