package IBM::Schema::CNDB::Contact;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("CONTACT");
__PACKAGE__->add_columns(
  "contact_id",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
  "role",
  { data_type => "VARCHAR", is_nullable => 0, size => 255 },
  "serial",
  { data_type => "VARCHAR", is_nullable => 0, size => 255 },
  "full_name",
  { data_type => "VARCHAR", is_nullable => 0, size => 255 },
  "remote_user",
  { data_type => "VARCHAR", is_nullable => 0, size => 255 },
  "notes_mail",
  { data_type => "VARCHAR", is_nullable => 0, size => 255 },
);
__PACKAGE__->set_primary_key("contact_id");
__PACKAGE__->has_many(
  "customers",
  "IBM::Schema::CNDB::Customer",
  { "foreign.contact_dpe_id" => "self.contact_id" },
);
__PACKAGE__->has_many(
  "customer_numbers",
  "IBM::Schema::CNDB::CustomerNumber",
  { "foreign.contact_dock_id" => "self.contact_id" },
);
__PACKAGE__->has_many(
  "delegations",
  "IBM::Schema::CNDB::Delegation",
  { "foreign.delegator_id" => "self.contact_id" },
);
__PACKAGE__->has_many(
  "delegations_request_datas",
  "IBM::Schema::CNDB::DelegationsRequestData",
  { "foreign.requestor_id" => "self.contact_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04003 @ 2007-12-12 17:12:37
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ZOe91HqPbuj7GjTFGYFtLQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
