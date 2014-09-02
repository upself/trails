package IBM::Schema::CNDB::RevalCustomerNumber;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("REVAL_CUSTOMER_NUMBER");
__PACKAGE__->add_columns(
  "id",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
  "customer_number_id",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
  "reval_account_id",
  { data_type => "BIGINT", is_nullable => 1, size => 19 },
  "current",
  { data_type => "INTEGER", is_nullable => 1, size => 10 },
  "reval_state",
  { data_type => "VARCHAR", is_nullable => 1, size => 16 },
  "remote_user",
  { data_type => "VARCHAR", is_nullable => 1, size => 64 },
  "remote_role",
  { data_type => "VARCHAR", is_nullable => 1, size => 8 },
  "review",
  { data_type => "VARCHAR", is_nullable => 1, size => 16 },
  "reviewer",
  { data_type => "VARCHAR", is_nullable => 1, size => 64 },
  "record_time",
  { data_type => "TIMESTAMP", is_nullable => 1, size => 26 },
  "cn_name",
  { data_type => "VARCHAR", is_nullable => 1, size => 16 },
  "lpid",
  { data_type => "VARCHAR", is_nullable => 1, size => 8 },
  "major",
  { data_type => "VARCHAR", is_nullable => 1, size => 4 },
  "cpo_email",
  { data_type => "VARCHAR", is_nullable => 1, size => 64 },
  "cpo_name",
  { data_type => "VARCHAR", is_nullable => 1, size => 64 },
  "cno_email",
  { data_type => "VARCHAR", is_nullable => 1, size => 64 },
  "cno_name",
  { data_type => "VARCHAR", is_nullable => 1, size => 64 },
  "division",
  { data_type => "VARCHAR", is_nullable => 1, size => 4 },
  "state",
  { data_type => "VARCHAR", is_nullable => 1, size => 16 },
  "country",
  { data_type => "VARCHAR", is_nullable => 1, size => 64 },
  "postal_code",
  { data_type => "VARCHAR", is_nullable => 1, size => 16 },
  "address1",
  { data_type => "VARCHAR", is_nullable => 1, size => 64 },
  "address2",
  { data_type => "VARCHAR", is_nullable => 1, size => 64 },
  "city",
  { data_type => "VARCHAR", is_nullable => 1, size => 32 },
  "taxable_status",
  { data_type => "VARCHAR", is_nullable => 1, size => 16 },
  "exemption_reason",
  { data_type => "VARCHAR", is_nullable => 1, size => 32 },
  "charge_to_dept",
  { data_type => "VARCHAR", is_nullable => 1, size => 16 },
  "function",
  { data_type => "VARCHAR", is_nullable => 1, size => 64 },
  "status",
  { data_type => "VARCHAR", is_nullable => 1, size => 8 },
  "clli",
  { data_type => "VARCHAR", is_nullable => 1, size => 8 },
  "comment",
  { data_type => "VARCHAR", is_nullable => 1, size => 256 },
  "owner",
  { data_type => "VARCHAR", is_nullable => 1, size => 64 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->belongs_to(
  "customer_number",
  "IBM::Schema::CNDB::CustomerNumber",
  { customer_number_id => "customer_number_id" },
);
__PACKAGE__->belongs_to(
  "reval_account",
  "IBM::Schema::CNDB::RevalAccount",
  { id => "reval_account_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04003 @ 2007-12-12 17:12:48
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:7lVOhsXBanF+MYBr6gD1qA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
