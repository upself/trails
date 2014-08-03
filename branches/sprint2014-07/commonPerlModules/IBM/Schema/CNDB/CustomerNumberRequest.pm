package IBM::Schema::CNDB::CustomerNumberRequest;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("CUSTOMER_NUMBER_REQUEST");
__PACKAGE__->add_columns(
  "cust_num_request_id",
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
  "cust_num_request_data_id",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
  "request_number_id",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
);
__PACKAGE__->set_primary_key("cust_num_request_id");
__PACKAGE__->belongs_to(
  "request_number",
  "IBM::Schema::CNDB::RequestNumber",
  { request_number_id => "request_number_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04003 @ 2007-12-12 17:12:38
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:J1EavPywz0eKNW9O4+3jlQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
