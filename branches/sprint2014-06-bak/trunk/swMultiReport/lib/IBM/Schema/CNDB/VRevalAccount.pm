package IBM::Schema::CNDB::VRevalAccount;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("V_REVAL_ACCOUNT");
__PACKAGE__->add_columns(
  "id",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
  "customer_id",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
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
  "account_number",
  { data_type => "INTEGER", is_nullable => 1, size => 10 },
  "account_name",
  { data_type => "VARCHAR", is_nullable => 1, size => 64 },
  "status",
  { data_type => "VARCHAR", is_nullable => 1, size => 8 },
  "account_type",
  { data_type => "VARCHAR", is_nullable => 1, size => 64 },
  "industry",
  { data_type => "VARCHAR", is_nullable => 1, size => 64 },
  "sector",
  { data_type => "VARCHAR", is_nullable => 1, size => 32 },
  "dpe_email",
  { data_type => "VARCHAR", is_nullable => 1, size => 64 },
  "dpe_name",
  { data_type => "VARCHAR", is_nullable => 1, size => 64 },
  "fa_email",
  { data_type => "VARCHAR", is_nullable => 1, size => 64 },
  "fa_name",
  { data_type => "VARCHAR", is_nullable => 1, size => 64 },
  "contract_status",
  { data_type => "VARCHAR", is_nullable => 1, size => 32 },
  "contract_end_date",
  { data_type => "VARCHAR", is_nullable => 1, size => 10 },
  "comment",
  { data_type => "VARCHAR", is_nullable => 1, size => 256 },
  "owner",
  { data_type => "VARCHAR", is_nullable => 1, size => 64 },
  "delegate_remote_user",
  { data_type => "VARCHAR", is_nullable => 1, size => 255 },
);


# Created by DBIx::Class::Schema::Loader v0.04003 @ 2007-12-12 17:12:50
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:3rKF5/qHFTDLhthB/R7Zug


# You can replace this text with custom content, and it will be preserved on regeneration
1;
