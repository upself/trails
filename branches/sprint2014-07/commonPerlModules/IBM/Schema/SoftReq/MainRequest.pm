package IBM::Schema::SoftReq::MainRequest;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("main_request");
__PACKAGE__->add_columns(
  "note_uuid",
  { data_type => "VARCHAR", default_value => "", is_nullable => 0, size => 32 },
  "sequence_num",
  { data_type => "INT", default_value => "", is_nullable => 0, size => 11 },
  "stamp",
  {
    data_type => "TIMESTAMP",
    default_value => "CURRENT_TIMESTAMP",
    is_nullable => 0,
    size => 14,
  },
  "source",
  { data_type => "ENUM", default_value => "", is_nullable => 0, size => 4 },
  "original_form",
  { data_type => "ENUM", default_value => "", is_nullable => 0, size => 5 },
  "work_request_num",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "dpe_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "order_assign_delay_comments",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 1,
    size => 65535,
  },
  "order_assign_delay_reason",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 1,
    size => 65535,
  },
  "date_submitted",
  {
    data_type => "DATETIME",
    default_value => undef,
    is_nullable => 1,
    size => 19,
  },
  "date_assigned",
  {
    data_type => "DATETIME",
    default_value => undef,
    is_nullable => 1,
    size => 19,
  },
  "date_esam_reviewed",
  {
    data_type => "DATETIME",
    default_value => undef,
    is_nullable => 1,
    size => 19,
  },
  "date_submitted_for_approval",
  {
    data_type => "DATETIME",
    default_value => undef,
    is_nullable => 1,
    size => 19,
  },
  "date_order_team_assigned",
  {
    data_type => "DATETIME",
    default_value => undef,
    is_nullable => 1,
    size => 19,
  },
  "date_returned_to_asset_mgmt",
  {
    data_type => "DATETIME",
    default_value => undef,
    is_nullable => 1,
    size => 19,
  },
  "date_on_hold",
  {
    data_type => "DATETIME",
    default_value => undef,
    is_nullable => 1,
    size => 19,
  },
  "date_closed",
  {
    data_type => "DATETIME",
    default_value => undef,
    is_nullable => 1,
    size => 19,
  },
  "account_number",
  { data_type => "INT", default_value => undef, is_nullable => 1, size => 11 },
  "is_pool_account",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 16,
  },
  "status",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 64,
  },
  "other_status",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 64,
  },
  "activity",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 1,
    size => 65535,
  },
  "doc_id",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 64,
  },
  "pod",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 64,
  },
  "software_type",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 32,
  },
  "os_available",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 64,
  },
  "os_geo",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 64,
  },
  "sw_asset_email",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 128,
  },
  "request_area",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 16,
  },
  "request_type",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 128,
  },
  "docs_to_remove",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 1,
    size => 65535,
  },
  "removed_products",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 1,
    size => 65535,
  },
  "main_unid",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 128,
  },
  "full_note",
  {
    data_type => "LONGTEXT",
    default_value => undef,
    is_nullable => 1,
    size => 4294967295,
  },
  "order_system",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 128,
  },
  "approver1",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 128,
  },
  "approver2",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 128,
  },
  "xml_doc",
  {
    data_type => "LONGTEXT",
    default_value => undef,
    is_nullable => 1,
    size => 4294967295,
  },
);
__PACKAGE__->set_primary_key("note_uuid");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-08-27 13:48:29
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:mjC/uwdWnP5b4gjbn8JpGA

use strict;
use warnings;

use JSON::Any;

# our JSON inflate/deflate magic
__PACKAGE__->inflate_column(
    'full_note',
    {
        inflate => sub { JSON::Any->jsonToObj(shift @_) },
        deflate => sub { JSON::Any->objToJson(shift @_) },
    }
);

my $simple = {
    inflate => sub { [ split /\n/, shift @_ ] },
    deflate => sub { join "\n",  @{shift @_}  },
};

__PACKAGE__->inflate_column('activity',         $simple);
__PACKAGE__->inflate_column('docs_to_remove',   $simple);
__PACKAGE__->inflate_column('removed_products', $simple);

###########################################################################
# keys, constraints

sub sqlt_deploy_hook {
    my ( $self, $sqlt_table ) = @_;

    #my @fields = qw/
    #  pod account_number account_name work_request_no source renewal_status
    #  dpe_name parent_uuid
    #  /;
    #
    #for my $field (@fields) {
    #
    #    # create index
    #    $sqlt_table->add_index( name => "idx_$field", fields => [$field] );
    #}

    # force myisam...
    $sqlt_table->extra( 'mysql_table_type' => 'MyISAM');
}
     


###########################################################################
# Relations...


__PACKAGE__->has_many(
    'software_requests',
    'IBM::Schema::SoftReq::SoftwareRequest',
    { 'foreign.main_unid' => 'self.main_unid' },
    { join_type => 'left'                     },
);

1;

__END__

#############################################################################
#    This is the documentation AND manpage of this module.  Document it     #
#                       it well, and wisely!                                #
#############################################################################


=head1 NAME
 
IBM::Schema::SoftReq::MainRequest - main request SoftReq documents
 

=head1 DESCRIPTION

This table contains a row for each non-deleted main request document in
SoftReq.  Specifically, these rows correspond to documents with the following
forms:

    * NEWMF
    * NEW
    * EDIT
    * req

=head1 COLUMNS 

todo...


=head1 CONSTRAINTS

todo...

 
=head1 RELATIONSHIPS
 

=head2 software_requests

A 'has_many' relationship to IBM::Schema::SoftReq::SoftwareRequests; this
relation will return the resultset of software requests corresponding to this
main request.
 
=head1 AUTHOR
 
Chris Weyl <cweyl@us.ibm.com>
 
 
=head1 LICENCE AND COPYRIGHT
 
Copyright (c) 2007, 2008 IBM. All rights reserved.
 
This is for IBM Internal Use ONLY.
 

