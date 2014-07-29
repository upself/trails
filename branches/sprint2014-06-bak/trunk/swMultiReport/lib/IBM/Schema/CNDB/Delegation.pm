package IBM::Schema::CNDB::Delegation;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("DELEGATION");
__PACKAGE__->add_columns(
  "delegation_id",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
  "record_time",
  { data_type => "TIMESTAMP", is_nullable => 0, size => 26 },
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
  "delegator_id",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
  "delegate_email",
  { data_type => "VARCHAR", is_nullable => 0, size => 256 },
  "submit_date",
  { data_type => "DATE", is_nullable => 0, size => 10 },
  "requested_start_date",
  { data_type => "DATE", is_nullable => 0, size => 10 },
  "actual_start_date",
  { data_type => "DATE", is_nullable => 0, size => 10 },
  "actual_end_date",
  { data_type => "DATE", is_nullable => 0, size => 10 },
  "requested_end_date",
  { data_type => "DATE", is_nullable => 0, size => 10 },
  "justification",
  { data_type => "VARCHAR", is_nullable => 0, size => 256 },
);
__PACKAGE__->set_primary_key("delegation_id");
__PACKAGE__->belongs_to(
  "delegator",
  "IBM::Schema::CNDB::Contact",
  { contact_id => "delegator_id" },
);
__PACKAGE__->belongs_to(
  "customer_number",
  "IBM::Schema::CNDB::CustomerNumber",
  { customer_number_id => "customer_number_id" },
);
__PACKAGE__->belongs_to(
  "delegated_role",
  "IBM::Schema::CNDB::DelegatedRole",
  { delegated_role_id => "delegated_role_id" },
);
__PACKAGE__->belongs_to(
  "delegated_tool",
  "IBM::Schema::CNDB::DelegatedTool",
  { delegated_tool_id => "delegated_tool_id" },
);
__PACKAGE__->belongs_to(
  "parent_request_number",
  "IBM::Schema::CNDB::RequestNumber",
  { request_number_id => "parent_request_number_id" },
);
__PACKAGE__->belongs_to(
  "customer",
  "IBM::Schema::CNDB::Customer",
  { customer_id => "customer_id" },
);
__PACKAGE__->has_many(
  "delegation_notifications",
  "IBM::Schema::CNDB::DelegationNotification",
  { "foreign.delegation_id" => "self.delegation_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04003 @ 2007-12-12 17:12:40
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:uzc7p3RceJnFeFkZnEC1Eg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
