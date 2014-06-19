package IBM::Schema::SWCM::TOrderSystem;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("t_order_system");
__PACKAGE__->add_columns(
  "order_system_id",
  {
    data_type => "SMALLINT",
    default_value => undef,
    is_nullable => 0,
    size => 5,
  },
  "order_system_code",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 20,
  },
  "order_system_desc",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 50,
  },
  "order_system_created",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
  "order_system_last_modified",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
);
__PACKAGE__->set_primary_key("order_system_id");
__PACKAGE__->add_unique_constraint("UC_ORDER_SYSTEM", ["order_system_code"]);
__PACKAGE__->has_many(
  "t_draft_licenses",
  "IBM::Schema::SWCM::TDraftLicense",
  { "foreign.dr_lic_order_system_id" => "self.order_system_id" },
);
__PACKAGE__->has_many(
  "t_draft_maintenances",
  "IBM::Schema::SWCM::TDraftMaintenance",
  { "foreign.dr_maint_order_system_id" => "self.order_system_id" },
);
__PACKAGE__->has_many(
  "t_licenses",
  "IBM::Schema::SWCM::TLicense",
  { "foreign.lic_order_system_id" => "self.order_system_id" },
);
__PACKAGE__->has_many(
  "t_maintenances",
  "IBM::Schema::SWCM::TMaintenance",
  { "foreign.maint_order_system_id" => "self.order_system_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-04-27 14:56:11
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:PfoTGog8ZhiW+D/P5zFdqQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
