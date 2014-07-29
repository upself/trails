package IBM::Schema::SWCM::TDraftReason;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("t_draft_reason");
__PACKAGE__->add_columns(
  "draft_reason_id",
  {
    data_type => "SMALLINT",
    default_value => undef,
    is_nullable => 0,
    size => 5,
  },
  "draft_reason_code",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 40,
  },
  "draft_reason_desc",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 150,
  },
  "draft_reason_entity",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 20,
  },
  "draft_reason_created",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
  "draft_reason_last_modified",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
);
__PACKAGE__->set_primary_key("draft_reason_id");
__PACKAGE__->add_unique_constraint(
  "UC_DRAFT_REASON",
  ["draft_reason_code", "draft_reason_entity"],
);
__PACKAGE__->has_many(
  "t_draft_contracts",
  "IBM::Schema::SWCM::TDraftContract",
  { "foreign.dr_con_draft_reason_id" => "self.draft_reason_id" },
);
__PACKAGE__->has_many(
  "t_draft_licenses",
  "IBM::Schema::SWCM::TDraftLicense",
  { "foreign.dr_lic_draft_reason_id" => "self.draft_reason_id" },
);
__PACKAGE__->has_many(
  "t_draft_maintenances",
  "IBM::Schema::SWCM::TDraftMaintenance",
  { "foreign.dr_maint_draft_reason_id" => "self.draft_reason_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-04-27 14:56:11
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:WWMA6JMTf8WJnAr+OY0igQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
