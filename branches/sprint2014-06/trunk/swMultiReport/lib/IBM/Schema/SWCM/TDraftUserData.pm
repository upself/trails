package IBM::Schema::SWCM::TDraftUserData;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("t_draft_user_data");
__PACKAGE__->add_columns(
  "dr_user_data_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "dr_user_data_field1",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 30,
  },
  "dr_user_data_field2",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 254,
  },
  "dr_user_data_field3",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 30,
  },
  "dr_user_data_field4",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 254,
  },
  "dr_user_data_field5",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 30,
  },
  "dr_user_data_field6",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 254,
  },
);
__PACKAGE__->set_primary_key("dr_user_data_id");
__PACKAGE__->has_many(
  "t_draft_contracts",
  "IBM::Schema::SWCM::TDraftContract",
  { "foreign.dr_con_dr_user_data_id" => "self.dr_user_data_id" },
);
__PACKAGE__->has_many(
  "t_draft_licenses",
  "IBM::Schema::SWCM::TDraftLicense",
  { "foreign.dr_lic_dr_user_data_id" => "self.dr_user_data_id" },
);
__PACKAGE__->has_many(
  "t_draft_maintenances",
  "IBM::Schema::SWCM::TDraftMaintenance",
  { "foreign.dr_maint_dr_user_data_id" => "self.dr_user_data_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-04-27 14:56:11
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:NjdECekJ4nHci7eQgYoI7Q


# You can replace this text with custom content, and it will be preserved on regeneration
1;
