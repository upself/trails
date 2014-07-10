package IBM::Schema::SWCM::TLoc;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("t_loc");
__PACKAGE__->add_columns(
  "loc_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "loc_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 200,
  },
  "loc_number",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 50,
  },
  "loc_customer_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "loc_supplier_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "loc_loc_status_id",
  {
    data_type => "SMALLINT",
    default_value => undef,
    is_nullable => 0,
    size => 5,
  },
  "loc_contact_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 50,
  },
  "loc_start_date",
  { data_type => "DATE", default_value => undef, is_nullable => 0, size => 10 },
  "loc_end_date",
  { data_type => "DATE", default_value => undef, is_nullable => 0, size => 10 },
  "loc_action_date",
  { data_type => "DATE", default_value => undef, is_nullable => 1, size => 10 },
  "loc_terms",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 2000,
  },
  "loc_created",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 1,
    size => 26,
  },
  "loc_last_modified",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 1,
    size => 26,
  },
  "loc_del_re_id",
  {
    data_type => "SMALLINT",
    default_value => undef,
    is_nullable => 1,
    size => 5,
  },
  "loc_del_re_comment",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 100,
  },
  "loc_user_data_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 1, size => 19 },
  "loc_ext_src_id",
  {
    data_type => "VARCHAR",
    default_value => "'NONE'",
    is_nullable => 0,
    size => 20,
  },
  "loc_ext_src_code",
  {
    data_type => "VARCHAR",
    default_value => "'NONE'",
    is_nullable => 0,
    size => 10,
  },
  "loc_last_modified_by",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 200,
  },
);
__PACKAGE__->set_primary_key("loc_id");
__PACKAGE__->has_many(
  "t_attachments_locs",
  "IBM::Schema::SWCM::TAttachmentsLoc",
  { "foreign.loc_id" => "self.loc_id" },
);
__PACKAGE__->has_many(
  "t_license_locs",
  "IBM::Schema::SWCM::TLicenseLoc",
  { "foreign.loc_id" => "self.loc_id" },
);
__PACKAGE__->belongs_to(
  "loc_loc_status",
  "IBM::Schema::SWCM::TLocStatus",
  { loc_status_id => "loc_loc_status_id" },
);
__PACKAGE__->belongs_to(
  "loc_del_re",
  "IBM::Schema::SWCM::TDeletionReason",
  { del_re_id => "loc_del_re_id" },
);
__PACKAGE__->belongs_to(
  "loc_user_data",
  "IBM::Schema::SWCM::TUserData",
  { user_data_id => "loc_user_data_id" },
);
__PACKAGE__->belongs_to(
  "loc_customer",
  "IBM::Schema::SWCM::TCustomer",
  { customer_id => "loc_customer_id" },
);
__PACKAGE__->belongs_to(
  "loc_supplier",
  "IBM::Schema::SWCM::TSupplier",
  { supplier_id => "loc_supplier_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-04-27 14:56:11
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:31JPm5A3Za7WsSBDLaLGWw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
