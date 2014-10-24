package IBM::Schema::TRAILS::Customer;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("customer");
__PACKAGE__->add_columns(
  "customer_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "customer_type_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "pod_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "industry_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "account_number",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "customer_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 64,
  },
  "contact_dpe_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 1, size => 19 },
  "contact_fa_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 1, size => 19 },
  "contact_hw_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 1, size => 19 },
  "contact_sw_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 1, size => 19 },
  "contact_focal_asset_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 1, size => 19 },
  "contact_transition_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 1, size => 19 },
  "asset_tools_billing_code",
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
    is_nullable => 0,
    size => 32,
  },
  "hw_interlock",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 3 },
  "sw_interlock",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 3 },
  "inv_interlock",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 3 },
  "sw_license_mgmt",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 3 },
  "sw_support",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 3 },
  "hw_support",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 3 },
  "transition_status",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 16,
  },
  "transition_exit_date",
  { data_type => "DATE", default_value => undef, is_nullable => 1, size => 10 },
  "country_code_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 1, size => 19 },
  "scan_validity",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => 10,
  },
  "sw_tracking",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 3 },
  "sw_compliance_mgmt",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 3 },
  "sw_financial_responsibility",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 16,
  },
  "sw_financial_mgmt",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 3 },
  "creation_date_time",
  {
    data_type => "TIMESTAMP",
    default_value => "CURRENT TIMESTAMP",
    is_nullable => 0,
    size => 26,
  },
  "update_date_time",
  {
    data_type => "TIMESTAMP",
    default_value => "CURRENT TIMESTAMP",
    is_nullable => 0,
    size => 26,
  },
);
__PACKAGE__->set_primary_key("customer_id");
__PACKAGE__->add_unique_constraint(
  "IF12CUSTOMER",
  [
    "customer_id",
    "customer_type_id",
    "customer_name",
    "country_code_id",
    "account_number",
  ],
);
__PACKAGE__->add_unique_constraint("IF16CUSTOMER", ["customer_id", "status", "account_number"]);
__PACKAGE__->add_unique_constraint("IF15CUSTOMER", ["account_number"]);
__PACKAGE__->add_unique_constraint(
  "IF13CUSTOMER",
  ["account_number", "customer_id", "scan_validity"],
);
__PACKAGE__->add_unique_constraint(
  "IF17CUSTOMER",
  [
    "status",
    "customer_type_id",
    "country_code_id",
    "industry_id",
    "customer_id",
    "account_number",
    "customer_name",
  ],
);
__PACKAGE__->add_unique_constraint("IF14CUSTOMER", ["customer_id", "scan_validity"]);
__PACKAGE__->add_unique_constraint(
  "IF11CUSTOMER",
  [
    "customer_name",
    "account_number",
    "status",
    "sw_license_mgmt",
    "customer_id",
  ],
);
__PACKAGE__->has_many(
  "account_pool_master_accounts",
  "IBM::Schema::TRAILS::AccountPool",
  { "foreign.master_account_id" => "self.customer_id" },
);
__PACKAGE__->has_many(
  "account_pool_member_accounts",
  "IBM::Schema::TRAILS::AccountPool",
  { "foreign.member_account_id" => "self.customer_id" },
);
__PACKAGE__->has_many(
  "bank_account_inclusions",
  "IBM::Schema::TRAILS::BankAccountInclusion",
  { "foreign.customer_id" => "self.customer_id" },
);
__PACKAGE__->has_many(
  "contact_accounts",
  "IBM::Schema::TRAILS::ContactAccount",
  { "foreign.customer_id" => "self.customer_id" },
);
__PACKAGE__->belongs_to(
  "contact_fa",
  "IBM::Schema::TRAILS::Contact",
  { contact_id => "contact_fa_id" },
);
__PACKAGE__->belongs_to(
  "contact_dpe",
  "IBM::Schema::TRAILS::Contact",
  { contact_id => "contact_dpe_id" },
);
__PACKAGE__->belongs_to(
  "contact_focal_asset",
  "IBM::Schema::TRAILS::Contact",
  { contact_id => "contact_focal_asset_id" },
);
__PACKAGE__->belongs_to(
  "industry",
  "IBM::Schema::TRAILS::Industry",
  { industry_id => "industry_id" },
);
__PACKAGE__->belongs_to(
  "contact_hw",
  "IBM::Schema::TRAILS::Contact",
  { contact_id => "contact_hw_id" },
);
__PACKAGE__->belongs_to(
  "contact_sw",
  "IBM::Schema::TRAILS::Contact",
  { contact_id => "contact_sw_id" },
);
__PACKAGE__->belongs_to(
  "country_code",
  "IBM::Schema::TRAILS::CountryCode",
  { id => "country_code_id" },
);
__PACKAGE__->belongs_to(
  "contact_transition",
  "IBM::Schema::TRAILS::Contact",
  { contact_id => "contact_transition_id" },
);
__PACKAGE__->belongs_to("pod", "IBM::Schema::TRAILS::Pod", { pod_id => "pod_id" });
__PACKAGE__->belongs_to(
  "customer_type",
  "IBM::Schema::TRAILS::CustomerType",
  { customer_type_id => "customer_type_id" },
);
__PACKAGE__->has_many(
  "customer_bluegroups",
  "IBM::Schema::TRAILS::CustomerBluegroup",
  { "foreign.customer_id" => "self.customer_id" },
);
__PACKAGE__->has_many(
  "customer_numbers",
  "IBM::Schema::TRAILS::CustomerNumber",
  { "foreign.customer_id" => "self.customer_id" },
);
__PACKAGE__->has_many(
  "hardwares",
  "IBM::Schema::TRAILS::Hardware",
  { "foreign.customer_id" => "self.customer_id" },
);
__PACKAGE__->has_many(
  "hardware_lpars",
  "IBM::Schema::TRAILS::HardwareLpar",
  { "foreign.customer_id" => "self.customer_id" },
);
__PACKAGE__->has_many(
  "licenses",
  "IBM::Schema::TRAILS::License",
  { "foreign.customer_id" => "self.customer_id" },
);
__PACKAGE__->has_many(
  "manual_queues",
  "IBM::Schema::TRAILS::ManualQueue",
  { "foreign.customer_id" => "self.customer_id" },
);
__PACKAGE__->has_many(
  "outsource_profiles",
  "IBM::Schema::TRAILS::OutsourceProfile",
  { "foreign.customer_id" => "self.customer_id" },
);
__PACKAGE__->has_many(
  "recon_customers",
  "IBM::Schema::TRAILS::ReconCustomer",
  { "foreign.customer_id" => "self.customer_id" },
);
__PACKAGE__->has_many(
  "recon_customer_logs",
  "IBM::Schema::TRAILS::ReconCustomerLog",
  { "foreign.customer_id" => "self.customer_id" },
);
__PACKAGE__->has_many(
  "recon_hardwares",
  "IBM::Schema::TRAILS::ReconHardware",
  { "foreign.customer_id" => "self.customer_id" },
);
__PACKAGE__->has_many(
  "recon_hs_composites",
  "IBM::Schema::TRAILS::ReconHsComposite",
  { "foreign.customer_id" => "self.customer_id" },
);
__PACKAGE__->has_many(
  "recon_hw_lpars",
  "IBM::Schema::TRAILS::ReconHwLpar",
  { "foreign.customer_id" => "self.customer_id" },
);
__PACKAGE__->has_many(
  "recon_installed_sws",
  "IBM::Schema::TRAILS::ReconInstalledSw",
  { "foreign.customer_id" => "self.customer_id" },
);
__PACKAGE__->has_many(
  "recon_licenses",
  "IBM::Schema::TRAILS::ReconLicense",
  { "foreign.customer_id" => "self.customer_id" },
);
__PACKAGE__->has_many(
  "recon_sw_lpars",
  "IBM::Schema::TRAILS::ReconSwLpar",
  { "foreign.customer_id" => "self.customer_id" },
);
__PACKAGE__->has_many(
  "software_lpars",
  "IBM::Schema::TRAILS::SoftwareLpar",
  { "foreign.customer_id" => "self.customer_id" },
);
__PACKAGE__->has_many(
  "swasset_queues",
  "IBM::Schema::TRAILS::SwassetQueue",
  { "foreign.customer_id" => "self.customer_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-06-02 17:23:20
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:28G39bzwynIFCJynpqC2vg

# derive version directly from CVS revision.  As good a method as any.
our $VERSION  = '0.' . (split(/ /, q$Revision: 1.10 $))[1];
our $REVISION = '$Id: Customer.pm,v 1.10 2009/06/02 22:04:31 cweyl Exp $';
 
use Moose;

has full_cndb_entry => (is => 'ro', lazy_build => 1);

sub _build_full_cndb_entry {
    my $self = shift @_;

    return $self
        ->result_source
        ->schema
        ->cndb
        ->resultset('Customer')
        #->search({ account_number => $self->account_number })
        ->search({ customer_id => $self->customer_id })
        ->first
        ;
}

__PACKAGE__->meta->make_immutable(inline_constructor => 0);
no Moose;

1;
