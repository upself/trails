#############################################################################
#
# Common bits between BRAVO/TRAILS SystemScheduleStatus.pm
#
# Author:   Chris Weyl (Global Asset Tools Team), <cweyl@us.ibm.com>
# Company:  IBM
# Created:  01/15/2009 08:28:55 PM EST
# Revision: $Id: SystemScheduleStatus.pm,v 1.3 2009/05/11 22:42:55 cweyl Exp $
#
# Detailed documentation, including the CVS commit log, can be found at the
# end of this file.
#
# Copyright (c) 2009 IBM <cweyl@us.ibm.com>
#
# This library is for IBM Internal Use only!
# 
#############################################################################

package IBM::SchemaRoles::TRAILS::SystemScheduleStatus;

use Moose::Role;

use DateTime;

#############################################################################
# version, etc.

# derive version directly from CVS revision.  As good a method as any.
our $VERSION  = '0.' . (split(/ /, q$Revision: 1.3 $))[1];
our $REVISION = '$Id: SystemScheduleStatus.pm,v 1.3 2009/05/11 22:42:55 cweyl Exp $';

#############################################################################
# class functions 

sub _init_from_role {
    my $class = shift @_;

    $class->add_unique_constraint(
        'IF1SYSSCHEDSTATUS' => [ 'name' ],
    );

    return;
}

#############################################################################
# methods

sub mark_finished { 
    my $self    = shift @_;
    my $comment = shift @_ || $self->comments;
    
    # FIXME ought to check to make sure we're in the correct state
    
    $self->update({ 
        status   => 'COMPLETE', 
        end_time => DateTime->now,
        comments => $comment
    });
}

sub mark_error {
    my $self    = shift @_;
    my $comment = shift @_ || $self->comments;
    
    # FIXME ought to check to make sure we're in the correct state

    $self->update({ 
        status   => 'ERROR', 
        end_time => DateTime->now,
        comments => $comment,
    });
}

1;

__END__

# $Log: SystemScheduleStatus.pm,v $
# Revision 1.3  2009/05/11 22:42:55  cweyl
# - 0.003002
# - make our constraint name more friendly to SQLite
#
# Revision 1.2  2009/01/16 21:40:29  cweyl
# - explictly mark our immutable constructors as being !inline
# - add a unique constraint definition to the SystemScheduleStatus role
# - drop a bunch of cruft from BRAVO.pm
# - add additional files to manifest
# - fix tests: skip all pod coverage; don't try to get a dbh if we're running as
#   root
#
# Revision 1.1  2009/01/16 02:37:32  cweyl
# - bump $VERSION to 0.0.5
# - add helper methods for recording status
#

=head1 NAME

IBM::SchemaRoles::TRAILS::SystemScheduleStatus - common methods

=head1 DESCRIPTION

This is a L<Moose> role that provides methods common to both TRAILS and BRAVO.


=head1 SUBROUTINES/METHODS

=head2 mark_finished([$comment])

Takes this record and updates it to mark it as finished.

=head2 mark_error([$comment])

Marks this record as an error.

=head2 _init_from_role() 

A private, class function, adding additional constraints, etc, to the correct
class.

=head1 SEE ALSO

L<IBM::Schema::TRAILS::SystemScheduleStatus>,
L<IBM::Schema::BRAVO::SystemScheduleStatus>

=head1 BUGS AND LIMITATIONS

There are no known bugs in this module.

Please report problems to Chris Weyl <cweyl@us.ibm.com>.

Patches are welcome.

=head1 AUTHOR

Chris Weyl  <cweyl@us.ibm.com>

$Id: SystemScheduleStatus.pm,v 1.3 2009/05/11 22:42:55 cweyl Exp $

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2009 IBM. All rights reserved.

This library is for IBM Internal Use only.

=cut
