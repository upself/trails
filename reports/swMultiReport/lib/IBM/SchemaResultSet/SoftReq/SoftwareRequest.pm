#############################################################################
#
# Custom resultset searches for SoftwareRequest
#
# Author:   Chris Weyl (Global Asset Tools Team), <cweyl@us.ibm.com>
# Company:  IBM
# Created:  03/03/2009 04:41:25 PM EST
# Revision: $Id: SoftwareRequest.pm,v 1.4 2009/04/02 21:50:54 cweyl Exp $
#
# Detailed documentation, including the CVS commit log, can be found at the
# end of this file.
#
# Copyright (c) 2009 IBM <cweyl@us.ibm.com>
#
# This library is for IBM Internal Use only!
# 
#############################################################################

package IBM::SchemaResultSet::SoftReq::SoftwareRequest;

use strict;
use warnings;

use base 'DBIx::Class::ResultSet';

use English qw{ -no_match_vars };  # Avoids regex performance penalty

# derive version directly from CVS revision.  As good a method as any.
our $VERSION  = '0.' . (split(/ /, q$Revision: 1.4 $))[1];
our $REVISION = '$Id: SoftwareRequest.pm,v 1.4 2009/04/02 21:50:54 cweyl Exp $';

sub swcm_export_rs {
    my $self = shift @_;

    ### here...

    # do our search
    my $rs = $self->search({
            -and => [

                # either a SRMF, or a SR form with certain criteria
                -or => [
                    { original_form => 'SRMF' },
                    {
                        original_form  => 'SR',
                        renewal_status => { '!=' => 'Renewed' },
                        add_remove     => { '!=' => 'Remove'  },
                    },
                ],

                # either active, or complete with certain criteria
                -or => [
                    { software_status => 'Active'                 },
                    { software_status => { like => '%Complete%' } },
                    {   
                        -and => [
                            { work_request_num => { '!=' => q{} } },
                            { software_status  => q{}             },
                        ],
                    },
                ],

                # must contain an account number
                { account_number => { '!=' => undef } },

                # must contain an originalpocode
                { original_po_code => { '!=' => undef } },
            ],
        });

    ### there...

    return $rs;
}

# table.col =>  sub to check
my %ENTITY_ID = (
    'swcm_lic_ext_src_id.ext_src_id' 
        => sub { $_[0] =~ /^SR_/ },
    'me.note_uuid'
        => sub { length $_[0] == 32 },
    'me.work_request_num'
        => sub { $_[0] =~ /^D/ && length $_[0] < 12 },
);

sub search_by_swcm_entity_id {
    my $self = shift @_;
    my @ids  = @_;

    return unless @ids;

    my @wheres;

    for my $entity_id (@ids) {

        # make sure it's "clean"
        
        ENTITY_TYPE_LOOP:
        for my $type (keys %ENTITY_ID) {

            if ($ENTITY_ID{$type}->($entity_id)) {

                push @wheres, { $type => $entity_id };
                last ENTITY_TYPE_LOOP;
            }
        }
    }

    # need at least one to proceed; FIXME throw_exception() here?
    return undef unless @wheres;

    # now, generate our resultset
    my $rs = $self->search(
        { -or => \@wheres }, 
        { 
            # note it's the name of the relation, not the table
            'join'          => [ 'swcm_lic_ext_src_id'             ],
            include_columns => [ 'swcm_lic_ext_src_id.ext_src_id'  ],
            order_by        => [ 'work_request_num', 'me.note_uuid' ],
        }
    );

    return $rs;
}

1;

__END__

# $Log: SoftwareRequest.pm,v $
# Revision 1.4  2009/04/02 21:50:54  cweyl
# - add a bit to look up our corresponding sigbank software entry (if we have a
#   software_id)
#
# Revision 1.3  2009/03/10 17:39:51  cweyl
# - add a comment
#
# Revision 1.2  2009/03/06 00:54:36  cweyl
# - 2.12
# - add swcm/trails bits
#
# Revision 1.1  2009/03/04 00:20:02  cweyl
# - 2.11
# - regen, breaking our Result and ResultSet classes out explicitly (it's not
#   optimally done, but given the way I initially organized it there's not much
#   choice.  At least not w/o rewriting a bunch of different things)
# - update MANIFEST
# - add custom resultset IBM::SchemaResultSet::SoftReq::SoftwareRequest
# - add some tests for the resultset bits
#

=head1 NAME

IBM::Schema::SoftReq::ResultSet::SoftwareRequest - Custom searches

=head1 SYNOPSIS

    my $sreq = IBM::Schema::SoftReq->connect(...);
    my $swcm_rs = $sreq->resultset('SoftwareRequest')->swcm_export;

    # ...etc

=head1 DESCRIPTION

This is a custom L<DBIx::Class::ResultSet> for
L<IBM::Schema::SoftReq::SoftwareRequest>.  We provide a number of custom
searches against SoftReq data.


=head1 SUBROUTINES/METHODS

=over 4

=item B<swcm_export_rs>

This generates a resultset containing all the documents in software_request
currently eligable for export.

=item B<search_by_swcm_entity_id(<id>, [id, ...])>

Given a SwCM entity id, search for our corresponding SoftwareRequests.  For
our purposes, as SwCM entity id is one or more of:

=over 4 

=item SoftReq work_request_num

=item lic_ext_src_id (e.g. 'SR_...')

=item a SR/SRMF note UUID (not docUNID!)

=back

=back

=head1 SEE ALSO

L<DBIx::Class::ResultSet>, L<IBM::Schema::SoftReq>, 
L<IBM::Schema::SoftReq::SoftwareRequest>. 


=head1 AUTHOR

Chris Weyl  <cweyl@us.ibm.com>

$Id: SoftwareRequest.pm,v 1.4 2009/04/02 21:50:54 cweyl Exp $

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2009 IBM. All rights reserved.

This library is for IBM Internal Use only.

=cut
