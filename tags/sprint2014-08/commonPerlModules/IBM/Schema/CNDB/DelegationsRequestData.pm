package IBM::Schema::CNDB::DelegationsRequestData;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("DELEGATIONS_REQUEST_DATA");
__PACKAGE__->add_columns(
  "delegations_request_data_id",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
  "parent_request_number_id",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
  "granularity",
  { data_type => "VARCHAR", is_nullable => 0, size => 16 },
  "customer_id",
  { data_type => "BIGINT", is_nullable => 1, size => 19 },
  "customer_number_id",
  { data_type => "BIGINT", is_nullable => 1, size => 19 },
  "delegated_tool_id",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
  "delegated_role_id",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
  "requestor_id",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
  "delegate_email",
  { data_type => "VARCHAR", is_nullable => 0, size => 256 },
  "justification",
  { data_type => "VARCHAR", is_nullable => 0, size => 256 },
  "submit_date",
  { data_type => "DATE", is_nullable => 0, size => 10 },
  "requested_start_date",
  { data_type => "DATE", is_nullable => 0, size => 10 },
  "requested_end_date",
  { data_type => "DATE", is_nullable => 0, size => 10 },
);
__PACKAGE__->set_primary_key("delegations_request_data_id");
__PACKAGE__->belongs_to(
  "requestor",
  "IBM::Schema::CNDB::Contact",
  { contact_id => "requestor_id" },
);
__PACKAGE__->belongs_to(
  "delegated_role",
  "IBM::Schema::CNDB::DelegatedRole",
  { delegated_role_id => "delegated_role_id" },
);
__PACKAGE__->belongs_to(
  "customer_number",
  "IBM::Schema::CNDB::CustomerNumber",
  { customer_number_id => "customer_number_id" },
);
__PACKAGE__->belongs_to(
  "parent_request_number",
  "IBM::Schema::CNDB::RequestNumber",
  { request_number_id => "parent_request_number_id" },
);
__PACKAGE__->belongs_to(
  "delegated_tool",
  "IBM::Schema::CNDB::DelegatedTool",
  { delegated_tool_id => "delegated_tool_id" },
);
__PACKAGE__->belongs_to(
  "customer",
  "IBM::Schema::CNDB::Customer",
  { customer_id => "customer_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04003 @ 2007-12-12 17:12:41
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:nCMQIB6O3Gao9GbvSD062w


# You can replace this text with custom content, and it will be preserved on regeneration
1;
