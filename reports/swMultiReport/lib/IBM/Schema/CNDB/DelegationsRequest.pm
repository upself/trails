package IBM::Schema::CNDB::DelegationsRequest;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("DELEGATIONS_REQUEST");
__PACKAGE__->add_columns(
  "delegations_request_id",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
  "record_time",
  { data_type => "TIMESTAMP", is_nullable => 0, size => 26 },
  "parent_request_number_id",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
  "request_state",
  { data_type => "VARCHAR", is_nullable => 1, size => 256 },
  "approver_role",
  { data_type => "VARCHAR", is_nullable => 0, size => 32 },
  "approver_email",
  { data_type => "VARCHAR", is_nullable => 0, size => 256 },
  "requestor_id",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
  "approval_status",
  { data_type => "VARCHAR", is_nullable => 1, size => 256 },
  "approver_comment",
  { data_type => "VARCHAR", is_nullable => 1, size => 256 },
  "status",
  { data_type => "VARCHAR", is_nullable => 1, size => 16 },
);
__PACKAGE__->set_primary_key("delegations_request_id");
__PACKAGE__->belongs_to(
  "parent_request_number",
  "IBM::Schema::CNDB::RequestNumber",
  { request_number_id => "parent_request_number_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04003 @ 2007-12-12 17:12:41
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:tt7CXD7/8kxQgeREoUL7ZQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
