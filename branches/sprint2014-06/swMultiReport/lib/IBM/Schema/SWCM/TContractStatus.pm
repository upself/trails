package IBM::Schema::SWCM::TContractStatus;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("t_contract_status");
__PACKAGE__->add_columns(
  "contract_status_id",
  {
    data_type => "SMALLINT",
    default_value => undef,
    is_nullable => 0,
    size => 5,
  },
  "contract_status_code",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 20,
  },
  "contract_status_desc",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 50,
  },
  "con_status_created",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
  "con_status_last_modified",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
);
__PACKAGE__->set_primary_key("contract_status_id");
__PACKAGE__->add_unique_constraint("UC_CONTRACT_STATUS", ["contract_status_code"]);
__PACKAGE__->has_many(
  "t_contracts",
  "IBM::Schema::SWCM::TContract",
  { "foreign.con_con_status_id" => "self.contract_status_id" },
);
__PACKAGE__->has_many(
  "t_draft_contracts",
  "IBM::Schema::SWCM::TDraftContract",
  { "foreign.dr_con_con_status_id" => "self.contract_status_id" },
);
__PACKAGE__->has_many(
  "t_draft_maintenances",
  "IBM::Schema::SWCM::TDraftMaintenance",
  { "foreign.dr_maint_con_status_id" => "self.contract_status_id" },
);
__PACKAGE__->has_many(
  "t_maintenances",
  "IBM::Schema::SWCM::TMaintenance",
  { "foreign.maint_con_status_id" => "self.contract_status_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-04-27 14:56:10
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:2yEhjpxD95EREHMYLSrIVw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
