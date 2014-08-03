package IBM::Schema::CNDB::DelegatedRole;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("DELEGATED_ROLE");
__PACKAGE__->add_columns(
  "delegated_role_id",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
  "label",
  { data_type => "VARCHAR", is_nullable => 0, size => 64 },
  "granularity",
  { data_type => "VARCHAR", is_nullable => 0, size => 16 },
  "description",
  { data_type => "VARCHAR", is_nullable => 1, size => 256 },
  "current_state",
  { data_type => "VARCHAR", is_nullable => 0, size => 16 },
  "record_time",
  { data_type => "TIMESTAMP", is_nullable => 0, size => 26 },
);
__PACKAGE__->set_primary_key("delegated_role_id");
__PACKAGE__->has_many(
  "delegations",
  "IBM::Schema::CNDB::Delegation",
  { "foreign.delegated_role_id" => "self.delegated_role_id" },
);
__PACKAGE__->has_many(
  "delegations_request_datas",
  "IBM::Schema::CNDB::DelegationsRequestData",
  { "foreign.delegated_role_id" => "self.delegated_role_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04003 @ 2007-12-12 17:12:40
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:HNGzbMcnI01M+ZR/gDxzmw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
