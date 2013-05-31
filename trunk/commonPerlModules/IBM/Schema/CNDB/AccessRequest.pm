package IBM::Schema::CNDB::AccessRequest;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("ACCESS_REQUEST");
__PACKAGE__->add_columns(
  "access_request_id",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
  "request_state",
  { data_type => "VARCHAR", is_nullable => 0, size => 255 },
  "approver",
  { data_type => "VARCHAR", is_nullable => 1, size => 255 },
  "requestor",
  { data_type => "VARCHAR", is_nullable => 1, size => 255 },
  "record_time",
  { data_type => "TIMESTAMP", is_nullable => 1, size => 26 },
  "request_status",
  { data_type => "VARCHAR", is_nullable => 0, size => 255 },
  "current_state",
  { data_type => "VARCHAR", is_nullable => 1, size => 255 },
  "request_number_id",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
  "justification",
  { data_type => "VARCHAR", is_nullable => 1, size => 256 },
  "requested_access",
  { data_type => "VARCHAR", is_nullable => 1, size => 64 },
);
__PACKAGE__->set_primary_key("access_request_id");
__PACKAGE__->belongs_to(
  "request_number",
  "IBM::Schema::CNDB::RequestNumber",
  { request_number_id => "request_number_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04003 @ 2007-12-12 17:12:26
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:CgJhxN3uNZM/QSikw731yg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
