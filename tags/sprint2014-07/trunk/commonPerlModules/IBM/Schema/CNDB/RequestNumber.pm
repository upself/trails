package IBM::Schema::CNDB::RequestNumber;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("REQUEST_NUMBER");
__PACKAGE__->add_columns(
  "request_number_id",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
  "comment",
  { data_type => "VARCHAR", is_nullable => 1, size => 255 },
  "creation_date",
  { data_type => "TIMESTAMP", is_nullable => 0, size => 26 },
  "parent_request_number_id",
  { data_type => "BIGINT", is_nullable => 1, size => 19 },
);
__PACKAGE__->set_primary_key("request_number_id");
__PACKAGE__->has_many(
  "access_requests",
  "IBM::Schema::CNDB::AccessRequest",
  { "foreign.request_number_id" => "self.request_number_id" },
);
__PACKAGE__->has_many(
  "customers",
  "IBM::Schema::CNDB::Customer",
  { "foreign.parent_request_number_id" => "self.request_number_id" },
);
__PACKAGE__->has_many(
  "customer_numbers",
  "IBM::Schema::CNDB::CustomerNumber",
  { "foreign.parent_request_number_id" => "self.request_number_id" },
);
__PACKAGE__->has_many(
  "customer_number_requests",
  "IBM::Schema::CNDB::CustomerNumberRequest",
  { "foreign.request_number_id" => "self.request_number_id" },
);
__PACKAGE__->has_many(
  "customer_requests",
  "IBM::Schema::CNDB::CustomerRequest",
  { "foreign.request_number_id" => "self.request_number_id" },
);
__PACKAGE__->has_many(
  "delegations",
  "IBM::Schema::CNDB::Delegation",
  { "foreign.parent_request_number_id" => "self.request_number_id" },
);
__PACKAGE__->has_many(
  "delegations_requests",
  "IBM::Schema::CNDB::DelegationsRequest",
  { "foreign.parent_request_number_id" => "self.request_number_id" },
);
__PACKAGE__->has_many(
  "delegations_request_datas",
  "IBM::Schema::CNDB::DelegationsRequestData",
  { "foreign.parent_request_number_id" => "self.request_number_id" },
);
__PACKAGE__->belongs_to(
  "parent_request_number",
  "IBM::Schema::CNDB::RequestNumber",
  { request_number_id => "parent_request_number_id" },
);
__PACKAGE__->has_many(
  "request_numbers",
  "IBM::Schema::CNDB::RequestNumber",
  { "foreign.parent_request_number_id" => "self.request_number_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04003 @ 2007-12-12 17:12:47
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:flRNn7a4b1a/XKi4ceW/Hw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
