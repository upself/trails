package IBM::Schema::SoftReq::SoftwareRequest;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("software_request");
__PACKAGE__->add_columns(
  "note_uuid",
  { data_type => "VARCHAR", default_value => "", is_nullable => 0, size => 128 },
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
  { data_type => "ENUM", default_value => "", is_nullable => 0, size => 4 },
  "parent_uuid",
  { data_type => "VARCHAR", default_value => "", is_nullable => 0, size => 129 },
  "account_number",
  { data_type => "INT", default_value => undef, is_nullable => 1, size => 11 },
  "sector",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "docunid",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 40,
  },
  "misc1",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 1,
    size => 65535,
  },
  "misc2",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 1,
    size => 65535,
  },
  "misc3",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 1,
    size => 65535,
  },
  "misc4",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 1,
    size => 65535,
  },
  "misc5",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 1,
    size => 65535,
  },
  "misc6",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 1,
    size => 65535,
  },
  "request_area",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 64,
  },
  "request_area_d",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 64,
  },
  "account_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "account_type",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "add_remove",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "annual_fee_discount",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "assigned_to",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "bond_approval_date",
  {
    data_type => "DATETIME",
    default_value => undef,
    is_nullable => 1,
    size => 19,
  },
  "bond_cart_date",
  {
    data_type => "DATETIME",
    default_value => undef,
    is_nullable => 1,
    size => 19,
  },
  "comments",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 1,
    size => 65535,
  },
  "country_code",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "cpu_dependent",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "cpu_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "create_date",
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
  "date_closed",
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
  "date_received",
  {
    data_type => "DATETIME",
    default_value => undef,
    is_nullable => 1,
    size => 19,
  },
  "date_submitted",
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
  "dpe_approval_date",
  {
    data_type => "DATETIME",
    default_value => undef,
    is_nullable => 1,
    size => 19,
  },
  "dpe_approver",
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
  "end_user",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "enduser_address",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "enduser_email",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "enduser_phone",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "environment",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "facility_code",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "host_id",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "import_reference_number",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "install_comment",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "is_order_team_doc",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "license_lpid",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "license_maint_status",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "license_owner",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "license_total_cost",
  {
    data_type => "DECIMAL",
    default_value => undef,
    is_nullable => 1,
    size => 10,
  },
  "license_unit_cost",
  {
    data_type => "DECIMAL",
    default_value => undef,
    is_nullable => 1,
    size => 10,
  },
  "lpar_acct",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "lpar_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "maint_effective_date",
  {
    data_type => "DATETIME",
    default_value => undef,
    is_nullable => 1,
    size => 19,
  },
  "maint_prod_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "maint_prod_number",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "maint_prod_q",
  { data_type => "INT", default_value => undef, is_nullable => 1, size => 11 },
  "maint_review_date",
  {
    data_type => "DATETIME",
    default_value => undef,
    is_nullable => 1,
    size => 19,
  },
  "maint_start_date",
  {
    data_type => "DATETIME",
    default_value => undef,
    is_nullable => 1,
    size => 19,
  },
  "manufacturer_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "model",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "monthly_fee_discount",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "neg_con_invoice_date",
  {
    data_type => "DATETIME",
    default_value => undef,
    is_nullable => 1,
    size => 19,
  },
  "num_licenses",
  { data_type => "INT", default_value => undef, is_nullable => 1, size => 11 },
  "num_procs",
  {
    data_type => "DECIMAL",
    default_value => undef,
    is_nullable => 1,
    size => 10,
  },
  "one_time_charge_discount",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "order_assignee",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "order_date",
  {
    data_type => "DATETIME",
    default_value => undef,
    is_nullable => 1,
    size => 19,
  },
  "order_team",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "ordered_by",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "original_po",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "original_po_code",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "outlook_comments",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "platform",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "pod",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "ppa_contract_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "ppa_contract_number",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "prior_po",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "product_common_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "product_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "product_num",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "product_type",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "product_version",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "quantity",
  { data_type => "INT", default_value => undef, is_nullable => 1, size => 11 },
  "quantity_available",
  { data_type => "INT", default_value => undef, is_nullable => 1, size => 11 },
  "quantity_excessed",
  { data_type => "INT", default_value => undef, is_nullable => 1, size => 11 },
  "quantity_installed",
  { data_type => "INT", default_value => undef, is_nullable => 1, size => 11 },
  "quote_num",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "renewal_product_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "renewal_product_number",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "renewal_quantity",
  { data_type => "INT", default_value => undef, is_nullable => 1, size => 11 },
  "renewal_status",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "renewal_total_cost",
  {
    data_type => "DECIMAL",
    default_value => undef,
    is_nullable => 1,
    size => 10,
  },
  "req_cat_num",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "req_dept",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "request_type",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "requestor",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "rsuputlevel",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "serial_num",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "software_designation",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "software_status",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "software_type",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 64,
  },
  "status",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "subsystem",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "tech_support_group",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "total_maint_cost",
  {
    data_type => "DECIMAL",
    default_value => undef,
    is_nullable => 1,
    size => 10,
  },
  "total_media_cost",
  {
    data_type => "DECIMAL",
    default_value => undef,
    is_nullable => 1,
    size => 10,
  },
  "total_other_cost",
  {
    data_type => "DECIMAL",
    default_value => undef,
    is_nullable => 1,
    size => 10,
  },
  "type",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "unlimited_license",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "vendor_contact",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "vendor_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "vendor_phone",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "work_request_num",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "work_scope",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "zone_hlq",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "does_expire",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "expiration_date",
  {
    data_type => "DATETIME",
    default_value => undef,
    is_nullable => 1,
    size => 19,
  },
  "finance_received_date",
  {
    data_type => "DATETIME",
    default_value => undef,
    is_nullable => 1,
    size => 19,
  },
  "total_costs_current_year",
  {
    data_type => "DECIMAL",
    default_value => undef,
    is_nullable => 1,
    size => 10,
  },
  "total_costs_future_year",
  {
    data_type => "DECIMAL",
    default_value => undef,
    is_nullable => 1,
    size => 10,
  },
  "agreement_type",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "bond_cart_num",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "customer_number",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "license_source",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "license_type",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "po_date",
  {
    data_type => "DATETIME",
    default_value => undef,
    is_nullable => 1,
    size => 19,
  },
  "po_number",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "full_note",
  {
    data_type => "LONGTEXT",
    default_value => "",
    is_nullable => 0,
    size => 4294967295,
  },
  "stash",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 1,
    size => 65535,
  },
  "software_id",
  { data_type => "INT", default_value => undef, is_nullable => 1, size => 11 },
  "created_date",
  { data_type => "DATETIME", default_value => "", is_nullable => 0, size => 19 },
  "modified_date",
  { data_type => "DATETIME", default_value => "", is_nullable => 0, size => 19 },
  "revised_date",
  { data_type => "DATETIME", default_value => "", is_nullable => 0, size => 19 },
  "main_unid",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 128,
  },
  "pooled_license",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 10,
  },
  "original_manufacturer_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "payment_confirmed_by",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 128,
  },
  "payment_confirmation_date",
  { data_type => "DATE", default_value => undef, is_nullable => 1, size => 10 },
  "receipt_confirmation_action_date",
  { data_type => "DATE", default_value => undef, is_nullable => 1, size => 10 },
  "media_required",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 10,
  },
  "annual_fee_list",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 10,
  },
  "asc_product_id",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 20,
  },
  "renewal_softreq_num",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 16,
  },
  "xml_doc",
  {
    data_type => "LONGTEXT",
    default_value => undef,
    is_nullable => 1,
    size => 4294967295,
  },
  "html_doc",
  {
    data_type => "LONGTEXT",
    default_value => undef,
    is_nullable => 1,
    size => 4294967295,
  },
);
__PACKAGE__->set_primary_key("note_uuid");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-08-27 13:48:29
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:NmxcwHv1hq0Ml7y8LHLwBA

# derive version directly from CVS revision.  As good a method as any.
our $VERSION  = '0.' . (split(/ /, q$Revision: 1.29 $))[1];
our $REVISION = '$Id: SoftwareRequest.pm,v 1.29 2009/08/27 18:32:41 cweyl Exp $';

# make sure we use our custom resultset methods
#__PACKAGE__->resultset_class('IBM::SchemaResultSet::SoftReq::SoftwareRequest');

use Moose;

use DateTime::Format::DominoXML;

use JSON::Any;
use JSON::XS;
use Text::Iconv;


# This is a schema representing notes from a Domino database.  We keep key
# fields broken out into actual columns (for immediately apparent reasons),
# then store the rest in one large TEXT column via JSON.
#
# Note that you can find the bulk of these fields in the META table, along
# with what form/field/description they map to.

my $json  = JSON::XS->new->utf8(1);
my $iconv = Text::Iconv->new('latin1', 'utf8');

# our JSON inflate/deflate magic
my $flate_subs = {
    deflate => sub { $json->encode(shift) },
    inflate => sub { 
        my ($str, $row) = @_;

        do { warn 'full_note is null'; return {}; } if not defined $str;
        
        my $ret;
        eval { $ret = $json->decode($str) };
        if ($@) {
            warn $row->note_uuid . " * json utf8ness failed; attempting latin1 => utf8 ($@)";
            $str = $iconv->convert($str);
            local $@;
            eval { $ret = $json->decode($str) };
            if ($@) {
                warn "failed latin1 conversion; returning {}";
                return {};
            }
        }
        return defined $ret ? $ret : {};
    },

    # JSON::Any
    #inflate => sub { JSON::Any->jsonToObj(shift) },
    #deflate => sub { JSON::Any->objToJson(shift) },

    # JSON::XS specific calls
    #inflate => sub { decode_json(shift) },
    #deflate => sub { encode_json(shift) },
};

__PACKAGE__->inflate_column('full_note', $flate_subs);
__PACKAGE__->inflate_column('stash',     $flate_subs);

###########################################################################
# helper subs (row-level!)

sub customer {
    my $self = shift @_;

    # don't bother if we don't even have an account number
    return unless $self->account_number;

    #return $self
    #    ->schema
    #    ->cndb
    #    ->resultset('Customer')
    #    ->search({ account_number => $self->account_number})
    #    ->first
    #    ;
        
    return $self
        ->result_source
        ->schema
        ->cndb_customer_rs
        ->search({ account_number => $self->account_number})
        ->first
        ;
}

###########################################################################
# keys, constraints

#__PACKAGE__->source_info({ _engine => 'MyISAM' });
#__PACKAGE__->add_unique_constraint("SR_NAME_U", ["softreq_num"]);

# create indicies on db deploy
sub sqlt_deploy_hook {
    my ( $self, $sqlt_table ) = @_;

    my @fields = qw/
      pod account_number account_name work_request_no source renewal_status
      dpe_name parent_uuid
      /;

    for my $field (@fields) {

        # create index
        $sqlt_table->add_index( name => "idx_$field", fields => [$field] );
    }

    # force myisam...
    $sqlt_table->extra( 'mysql_table_type' => 'MyISAM');
}


#############################################################################
#    This is the documentation AND manpage of this module.  Document it     #
#                       it well, and wisely!                                #
#############################################################################


=head1 NAME
 
IBM::Schema::SoftReq::SoftwareRequest - software requests from SoftReq 
 

=head1 DESCRIPTION

This table contains the non-deleted software requests from both the MF and
Distributed SoftReq Domino databases.

Specifically, we contain the documents using the following forms in the
SoftReq databases:

    * SR
    * SRMF
    

=head1 COLUMNS 

todo...


=head1 CONSTRAINTS

todo...

 
=head1 RELATIONSHIPS
 
None.  This table does not relationally map to other table's data, just
describes what that data means and how it maps to and from the domino
databases.

=cut 


###########################################################################
# Relations...

=head3 main_request

Returns the row corresponding to our main request, if one exists.

=cut

# relate to our parent doc
__PACKAGE__->belongs_to(
    'main_request',
    'IBM::Schema::SoftReq::MainRequest',
    { 'foreign.main_unid' => 'self.main_unid' },
    { join_type => 'left'                     },
);

# and to the lpar doc, if it exists
__PACKAGE__->belongs_to(
    'lpar',
    'IBM::Schema::SoftReq::Lpar',
    { 
        'foreign.customer_number' => 'self.customer_number',
        'foreign.cpu_serial' => 'self.serial_num',
        'foreign.lpar_name' => 'self.lpar_name',
    },
    { join_type => 'left' },
);

__PACKAGE__->might_have(
    'swcm_lic_ext_src_id',
    'IBM::Schema::SoftReq::SwcmLicExtSrcIds',
    { 'foreign.note_uuid' => 'self.note_uuid' },
    { join_type => 'left'                     },
);

__PACKAGE__->might_have(
    'swcm_cpu_ext_src_id',
    'IBM::Schema::SoftReq::SwcmCpuExtSrcIds',
    { 
        'foreign.sr_source'     => 'self.source', 
        'foreign.sr_serial_num' => 'self.serial_num',
    },
    { join_type => 'left' },
);

###########################################################################
# fields stored directly


=head1 ROW ACCESSORS/METHODS

docs todo...

=head2 INFLATING COLUMNS 

=head3 DateTime 

All columns of some date/datetime type will be automagically inflated into
DateTime objects; and deflated when set and stored.

=head3 full_note

This column is neato.  It's a JSON-encoded representation of the generated
%doc that IBM::Domino::DXL::Parse creates, and can be used to access the raw
values of a given document, as well as values that may have not made it into
their own column yet.

A couple conventions.

Keys in CAPS are items pulled from the note iteself.

Keys in lowercase are meta-items; e.g. from the noteinfo element or some other
place.


=head2 LAZY

=over 4

=item id -> note_id

=cut

###########################################################################
# lazy accessors

sub id { $_[0]->note_id }

=head2 ADDITIONAL ATTRIBUTES

These are attributes we generate on calling; they cannot be set.  We generate
them from information in full_note and expect that the next time we revise the
database schema we'll migrate from generating these from full_note to actually
storing them in the table directly.

=head3 noteinfo_created

The document creation date, as recorded in the noteinfo header.

=cut

# FIXME this should probably be ditched
has noteinfo_created => ( 
    is         => 'ro',
    isa        => 'DateTime',
    lazy_build => 1,
);

sub _build_noteinfo_created {
    my $self = shift @_;

    return DateTime::Format::DominoXML->build($self->full_note->{created});
}

sub is_swcm_exportable {
    my $self = shift @_;

    my $rs = $self
        ->result_source
        ->schema
        ->resultset('SoftwareRequest')
        ->swcm_export_rs
        ->search(
            { note_uuid => $self->note_uuid }, 
            { 'select'  => [ 'note_uuid' ]  },
        )
        ;

    # If we have a row, then we're in the resultset that is exported to SwCM
    return $rs->count;
}

# we return the row in SwCM if it exists, or undef if it doesn't
sub is_in_swcm {
    my $self = shift @_;

    return $self
        ->result_source
        ->schema
        ->swcm
        ->resultset('Lics2trails4')
        ->search(
            { 
                lic_ext_src_code => 'SOFTREQ', 
                lic_ext_src_id   => $self->swcm_lic_ext_src_id->ext_src_id,
            }
         )
         ->first
         ;
}
    
# we return the row in TRAILS/BRAVO if it exists, or undef if it doesn't
sub is_in_trails {
    my $self = shift @_;

    return $self
        ->result_source
        ->schema
        ->bravo
        ->resultset('License')
        ->search({ 
            ext_src_id => $self->swcm_lic_ext_src_id->ext_src_id,
            status     => 'ACTIVE',
        })
        ->first
        ;
}
    
sub sigbank_entry {
    my $self = shift @_;

    return unless $self->software_id;

    return $self
        ->result_source
        ->schema
        ->bravo
        ->resultset('Software')
        ->search({ software_id => $self->software_id, status => 'ACTIVE' })
        # should only ever be one row
        ->first
        ;
}

###########################################################################
# complex bits

=head2 COMPLEX BITS (MF/DIST DIFFERENCES)

Calculate some fields, answering differently depending on if we're a mainframe
or a distributed doc.  We really shouldn't have to do this, but right now it's
better than playing with the table schema again.

=head2 maint_start

Maintenance start date.

=cut

sub maint_start {
    my $self = shift;

    # mainframe
    return $self->maint_start_date if $self->source eq 'MF';

    # distributed
    return $self->maint_effective_date;
}


=head2 maint_end

Maintenance end date.

=cut

sub maint_end {
    my $self = shift @_;

    # mainframe
    return $self->maint_review_date if $self->source eq 'MF';

    # distributed
    return $self->expiration_date;
}

=head2 agreement_type_code

A mashup of the two fields:  returns the value of license_type iff source 
is MF, agreement_type iff Dist.

=cut

sub agreement_type_code {
    my $self = shift @_;

    # this is correct for both mainframe and distributed, as this is one of
    # those funky "variable" fields from the adhoc process
    my $agt = $self->agreement_type || return '  ';

    my $len = length $agt;
    
    return $agt    if $len == 2;
    return "$agt " if $len == 1;
    return substr($agt, 0, 2);
}

###########################################################################
# swcm bits 

# not too swcm-specific, but probably bears sorting through

sub is_ibm_owned {
    my $self = shift @_;

    my $atype = $self->agreement_type;
    
    return 1 if not defined $atype;
    return 0 if ($atype eq 'CI') || ($atype eq 'CU');
    return 1;
}

sub license_quantity {
    my $self = shift @_;

    if ($self->original_form eq 'SR') {

        # yeah, I know... but you know, whatever :)
        no warnings 'numeric';

        my $nl  = $self->num_licenses || 0;
        my $q   = $self->quantity     || 0;
        my $mpq = $self->maint_prod_q || 0;

        return $nl  > 0 ? $nl
             : $q   > 0 ? $q
             : $mpq > 0 ? $mpq
             :            0
             ;

        #return $self->num_licenses > 0 ? $self->num_licenses
        #     : $self->quantity     > 0 ? $self->quantity
        #     : $self->maint_prod_q > 0 ? $self->maint_prod_q
        #     :                           0
        #     ;
    }

    return 1;

    # we're a SRMF
    # if ($self->software_type eq 'IBM') {
    #    
    #    my $msu = $self->full_note->{licensedMSU};
    #    $msu = defined $msu ? int $msu : 0;
    #    return $msu > 0 ? $msu : 1;
    #}
    #
    #my $mipcount = $self->full_note->{mipcount};
    #$mipcount = defined $mipcount ? int $mipcount : 0;
    #return $mipcount > 0 ? $mipcount : 1;
}

sub product_number {
    my $self = shift @_;

    my $mpn = $self->maint_prod_number || q{};
    my $pn  = $self->product_num       || 'UNDEFINED';

    # if we have mpn and we're a distributed form..
    return $mpn if ($self->original_form eq 'SR') && ($mpn ne q{});
    # else pn (or unknown, for that matter)
    return $pn;
}

###########################################################################
# swcm-specific 

=head2 SWCM-SPECIFIC METHODS

We need these for SWCM, but probably never anything else.

=head3 swcm_lic_cap_id

Determine the correct license capacity id to report. For a code => id mapping,
see the "Capacity types" sheet in the SwCM_massload.xls spreadsheet.

=cut

sub swcm_lic_cap_id {
    my $self = shift @_;

    if (uc $self->source eq 'DIST') {
    
        my $lic_type = lc $self->license_type || return 41;
        
        # distributed codes
        return 43 if $lic_type eq 'per server';         # code 13
        return  3 if $lic_type eq 'per processor';      # code 2
        return  1 if $lic_type eq 'per user';           # code 0
        return  3 if $lic_type eq 'per capacity unit';  # code 2
        return 47 if $lic_type eq 'per value unit';     # code 17
        return 41 if $lic_type eq 'tmp';                # code 11

        return 41; # fallback
    }

    # if we're not DIST, we're MF
    my $agt_type = uc $self->agreement_type || return 60;  # code 34

    ## MF codes
    # NOTE -- always 60 (34) for MF as of 4 Dec 2008 (ckw)
    #return 3 if $agt_type eq 'CPU';                 # code 2
    #return 1 if $agt_type eq 'SEATS';               # code 0
    #return 6 if $agt_type eq 'MIPS';                # code 5
    
    return 60;  # code 34
}

=head3 swcm_lic_ext_src_id

Calculate the value of this row's lic_ext_src_id.

=cut

# View: SWCMDonnie; First col:  
#   @If(@Length(@Text(WorkRequestNo)) = 8;
#       "SR_" + @Text(WorkRequestNo) + "_" + @Text(@Right(@Text(docUNID); 8)); 
#       "SR_" + @Text(WorkRequestNo) + "_" + @Text(@Right(@Text(docUNID);10))
#   )

sub OLD_swcm_lic_ext_src_id {
    my $self = shift @_;

    my $wreq_no = $self->work_request_num;
    my $unid    = $self->docunid || $self->note_uuid;

    $wreq_no = q{} if not defined $wreq_no;

    return "SR_$wreq_no" . '_' . substr($unid,  -8)
        if length($wreq_no) == 8;
        
    return "SR_$wreq_no" . '_' . substr($unid, -10);
}

=head3 swcm_lic_minor_code_id

Calculate the lic_minor_code_id from the userMinor field.  This is only
present in SOME MF docs, so coverage isn't exactly going to be spectacular.

=cut

{
    my %_lic_minor_code_id = (

        # minor => swcm id
        810 => 1,
        819 => 2,
        512 => 3,
        818 => 4,
    );

    sub swcm_lic_minor_code_id {
        my $self = shift @_;

        my $uminor = $self->full_note->{USERMINOR};

        return $_lic_minor_code_id{$uminor}
            if defined $uminor && exists $_lic_minor_code_id{$uminor};
        
        return 3; # 0592
        
        return defined $uminor ? $_lic_minor_code_id{$uminor} : '0592';
        return $_lic_minor_code_id{$uminor};    # either the code or undef
    }    
}

=head3 swcm_lic_cost_curr_code

The currency code for the license, returned in the SWCM code.  Note we
currently use $self->full_note->{CURRENCYVALUATOR} for this.

=cut
{
    my %_lic_cost_curr_code = (
        'US Dollars'              => 'USD',  
        'Canadian Dollars'        => 'CAD',
        'British Pounds Sterling' => 'GBP',
        'Pesos'                   => 'MXN', # note we're assuming MEXICAN peso
    );

    sub swcm_lic_cost_curr_code {
        my $self = shift @_;

        my $c = $self->full_note->{CURRENCYVALUATOR};
        
        return 'USD' unless defined $c && exists $_lic_cost_curr_code{$c};
        return $_lic_cost_curr_code{$c};
    }
}

=head3 swcm_lic_cost

Cost of the license, as SWCM understands it.

FIXME -- note this is NOT complete yet!

=cut

sub swcm_lic_cost {
    my $self = shift @_;

    # FIXME
    #warn 'swcm_lic_cost() not implemented yet';
    return;
}

=head3 swcm_po_date

This is really just the same thing as the po_date column, but some extra
goodness wrapped around it so TT doesn't behave...  Oddly.

=cut

sub swcm_po_date {
    my $self = shift @_;

    my $po_date = $self->po_date;

    return undef if not defined $po_date;
    return $po_date->strftime('%F');
}

=head3 swcm_cus_name

From the CNDB: "customer_name / account_type"

If we cannot find a related customer record from account_number, we return:
"CNDB Entry Not Found / unknown"

=cut

sub swcm_cus_name {
    my $self = shift @_;
    my $cust = $self->customer;

    # sanity check
    return "CNDB Entry Not Found / unknown"
        unless defined $cust;

    return $cust->customer_name . ' / ' . $cust->customer_type_name;
}
    
=head3 swcm_lic_start_date 

Start date of this SR, from SWCM's perspective.

=cut

sub swcm_lic_start_date {
    my $self = shift @_;

    # first we try date_closed
    return $self->date_closed->strftime('%F')
        if $self->date_closed;
    
    # then we try the document creation date, which should _always_ be there
    return $self->create_date->strftime('%F')
        if $self->create_date;
        
    # then we try the document creation date, which should _always_ be there
    return $self->noteinfo_created->strftime('%F'); 
}       

=head3 swcm_maint_start_date

=cut

sub swcm_maint_start_date {
    my $self = shift @_;

    return $self->maint_start->strftime('%F')
        if $self->maint_start;

    return '2999-12-31';
}

=head3 swcm_cpu_ext_src_id_OLD

This is the legacy method for generating the SwCM cpu_ext_src_id; we don't
actually use it anymore but it's here for old-time's sake :-)

=cut

sub swcm_cpu_ext_src_id_OLD {
    my $self = shift @_;

    my $serial =    $self->serial_num || q{};
    my $source = uc $self->source;

    return "$source/$serial";
}

=head3 swcm_maint_end_date

Maintenance end date.

=cut

sub swcm_maint_end_date {
    my $self = shift @_;

    return $self->maint_end->strftime('%F')
        if $self->maint_end;

    return;
}

###########################################################################
# "complex" accessors

# find and return a s/w name: product_common_name if it exists, else
# product_name
sub prod_name {
    my $self = shift @_;

    my $pcn = $self->product_common_name;

    return $pcn if defined $pcn && $pcn ne q{};
    return $self->product_name;
}

no Moose;
__PACKAGE__->meta->make_immutable(inline_constructor => 0);

1;

__END__

=head1 AUTHOR
 
Chris Weyl <cweyl@us.ibm.com>
 
 
=head1 LICENCE AND COPYRIGHT
 
Copyright (c) 2007, 2008 IBM. All rights reserved.
 
This is for IBM Internal Use ONLY.
 
=cut
