package IBM::Schema::SWCM::TContractNature;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("t_contract_nature");
__PACKAGE__->add_columns(
  "contract_nature_id",
  {
    data_type => "SMALLINT",
    default_value => undef,
    is_nullable => 0,
    size => 5,
  },
  "contract_nature_code",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 20,
  },
  "contract_nature_desc",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 150,
  },
  "contract_nature_created",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
  "contract_nature_last_modified",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
);
__PACKAGE__->set_primary_key("contract_nature_id");
__PACKAGE__->add_unique_constraint("UC_CONTRACT_NATURE", ["contract_nature_code"]);
__PACKAGE__->has_many(
  "t_contracts",
  "IBM::Schema::SWCM::TContract",
  { "foreign.con_con_nature_id" => "self.contract_nature_id" },
);
__PACKAGE__->has_many(
  "t_draft_contracts",
  "IBM::Schema::SWCM::TDraftContract",
  { "foreign.dr_con_con_nature_id" => "self.contract_nature_id" },
);
__PACKAGE__->has_many(
  "t_draft_maintenances",
  "IBM::Schema::SWCM::TDraftMaintenance",
  { "foreign.dr_maint_con_nature_id" => "self.contract_nature_id" },
);
__PACKAGE__->has_many(
  "t_maintenances",
  "IBM::Schema::SWCM::TMaintenance",
  { "foreign.maint_con_nature_id" => "self.contract_nature_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-04-27 14:56:10
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Tu8b5+LqgA5XMjB/pVYO4A


# You can replace this text with custom content, and it will be preserved on regeneration
1;
