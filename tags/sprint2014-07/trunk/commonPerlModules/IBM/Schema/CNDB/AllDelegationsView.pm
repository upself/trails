package IBM::Schema::CNDB::AllDelegationsView;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("ALL_DELEGATIONS_VIEW");
__PACKAGE__->add_columns(
  "delegation_id",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
  "granularity",
  { data_type => "VARCHAR", is_nullable => 0, size => 16 },
  "customer_id",
  { data_type => "BIGINT", is_nullable => 1, size => 19 },
  "customer_number_id",
  { data_type => "BIGINT", is_nullable => 1, size => 19 },
  "delegated_role",
  { data_type => "VARCHAR", is_nullable => 0, size => 64 },
  "delegated_tool",
  { data_type => "VARCHAR", is_nullable => 0, size => 64 },
  "actual_start_date",
  { data_type => "DATE", is_nullable => 0, size => 10 },
  "actual_end_date",
  { data_type => "DATE", is_nullable => 0, size => 10 },
  "delegator_role",
  { data_type => "VARCHAR", is_nullable => 0, size => 255 },
  "delegator_serial",
  { data_type => "VARCHAR", is_nullable => 0, size => 255 },
  "delegator_full_name",
  { data_type => "VARCHAR", is_nullable => 0, size => 255 },
  "delegator_remote_user",
  { data_type => "VARCHAR", is_nullable => 0, size => 255 },
  "delegator_notes_mail",
  { data_type => "VARCHAR", is_nullable => 0, size => 255 },
  "delegate_role",
  { data_type => "VARCHAR", is_nullable => 0, size => 255 },
  "delegate_serial",
  { data_type => "VARCHAR", is_nullable => 0, size => 255 },
  "delegate_full_name",
  { data_type => "VARCHAR", is_nullable => 0, size => 255 },
  "delegate_remote_user",
  { data_type => "VARCHAR", is_nullable => 0, size => 255 },
  "delegate_notes_mail",
  { data_type => "VARCHAR", is_nullable => 0, size => 255 },
  "days_left",
  { data_type => "INTEGER", is_nullable => 1, size => 10 },
);


# Created by DBIx::Class::Schema::Loader v0.04003 @ 2007-12-12 17:12:28
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Ea8lxLU5CcCJ9wmFkDLQaA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
