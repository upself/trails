package IBM::Schema::SWCM::TDrContractTransferability;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("t_dr_contract_transferability");
__PACKAGE__->add_columns(
  "dr_contract_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "transf_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
);
__PACKAGE__->set_primary_key("dr_contract_id", "transf_id");
__PACKAGE__->belongs_to(
  "transf",
  "IBM::Schema::SWCM::TTransferability",
  { transf_id => "transf_id" },
);
__PACKAGE__->belongs_to(
  "dr_contract",
  "IBM::Schema::SWCM::TDraftContract",
  { dr_contract_id => "dr_contract_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-04-27 14:56:10
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Le4qUgZoh7p+MgY530XmVA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
