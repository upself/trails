package IBM::Schema::SWCM::TContractTransferability;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("t_contract_transferability");
__PACKAGE__->add_columns(
  "contract_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "transf_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
);
__PACKAGE__->set_primary_key("contract_id", "transf_id");
__PACKAGE__->belongs_to(
  "contract",
  "IBM::Schema::SWCM::TContract",
  { contract_id => "contract_id" },
);
__PACKAGE__->belongs_to(
  "transf",
  "IBM::Schema::SWCM::TTransferability",
  { transf_id => "transf_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-04-27 14:56:10
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:VG+KqEZber//T7TN6sL7/Q


# You can replace this text with custom content, and it will be preserved on regeneration
1;
