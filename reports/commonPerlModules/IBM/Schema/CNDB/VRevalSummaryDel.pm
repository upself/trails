package IBM::Schema::CNDB::VRevalSummaryDel;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("V_REVAL_SUMMARY_DEL");
__PACKAGE__->add_columns(
  "id",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
  "reval_state",
  { data_type => "VARCHAR", is_nullable => 1, size => 16 },
  "remote_role",
  { data_type => "VARCHAR", is_nullable => 1, size => 8 },
  "effective_user",
  { data_type => "VARCHAR", is_nullable => 1, size => 255 },
  "remote_queue",
  { data_type => "VARCHAR", is_nullable => 1, size => 64 },
  "owner",
  { data_type => "VARCHAR", is_nullable => 1, size => 64 },
  "account",
  { data_type => "INTEGER", is_nullable => 0, size => 10 },
  "customer_number",
  { data_type => "INTEGER", is_nullable => 0, size => 10 },
  "account_delegate_remote_user",
  { data_type => "VARCHAR", is_nullable => 1, size => 255 },
  "cpo_delegate_remote_user",
  { data_type => "VARCHAR", is_nullable => 0, size => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.04003 @ 2007-12-12 17:12:51
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:A4dWmxHMm/y/wvvvBBvUWg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
