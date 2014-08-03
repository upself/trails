package IBM::Schema::CNDB::DelegatedTool;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("DELEGATED_TOOL");
__PACKAGE__->add_columns(
  "delegated_tool_id",
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
__PACKAGE__->set_primary_key("delegated_tool_id");
__PACKAGE__->has_many(
  "delegations",
  "IBM::Schema::CNDB::Delegation",
  { "foreign.delegated_tool_id" => "self.delegated_tool_id" },
);
__PACKAGE__->has_many(
  "delegations_request_datas",
  "IBM::Schema::CNDB::DelegationsRequestData",
  { "foreign.delegated_tool_id" => "self.delegated_tool_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04003 @ 2007-12-12 17:12:40
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:0/GT7cd2T1nM87K2hIS8cQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
