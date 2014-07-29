package IBM::Schema::SWCM::TContractType;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("t_contract_type");
__PACKAGE__->add_columns(
  "con_type_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "con_type_code",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "con_type_desc",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 50,
  },
  "con_ext_src_id",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 20,
  },
  "con_ext_src_code",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "con_type_created",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
  "con_type_last_modified",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
);
__PACKAGE__->set_primary_key("con_type_id");
__PACKAGE__->add_unique_constraint("UC_CON_TYPE_CODE", ["con_type_code"]);
__PACKAGE__->has_many(
  "t_contracts",
  "IBM::Schema::SWCM::TContract",
  { "foreign.con_con_type_id" => "self.con_type_id" },
);
__PACKAGE__->has_many(
  "t_draft_contracts",
  "IBM::Schema::SWCM::TDraftContract",
  { "foreign.dr_con_con_type_id" => "self.con_type_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-04-27 14:56:10
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:a2nmtz3yomAFyoQNL2PqKA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
