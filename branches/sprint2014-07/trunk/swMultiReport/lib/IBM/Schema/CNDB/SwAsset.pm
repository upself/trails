package IBM::Schema::CNDB::SwAsset;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("SW_ASSET");
__PACKAGE__->add_columns(
  "id",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
  "as_id",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
  "current",
  { data_type => "VARCHAR", is_nullable => 0, size => 1 },
  "remote_user",
  { data_type => "VARCHAR", is_nullable => 0, size => 32 },
  "record_time",
  { data_type => "TIMESTAMP", is_nullable => 0, size => 26 },
  "mf_ibm",
  { data_type => "INTEGER", is_nullable => 0, size => 10 },
  "mf_cust",
  { data_type => "INTEGER", is_nullable => 0, size => 10 },
  "mr_ibm",
  { data_type => "INTEGER", is_nullable => 0, size => 10 },
  "mr_cust",
  { data_type => "INTEGER", is_nullable => 0, size => 10 },
  "ws_ibm",
  { data_type => "INTEGER", is_nullable => 0, size => 10 },
  "ws_cust",
  { data_type => "INTEGER", is_nullable => 0, size => 10 },
  "sv_ibm",
  { data_type => "INTEGER", is_nullable => 0, size => 10 },
  "sv_cust",
  { data_type => "INTEGER", is_nullable => 0, size => 10 },
  "pen",
  { data_type => "VARCHAR", is_nullable => 1, size => 1 },
  "spreadsheet",
  { data_type => "VARCHAR", is_nullable => 1, size => 1 },
  "access_db",
  { data_type => "VARCHAR", is_nullable => 1, size => 1 },
  "tcm",
  { data_type => "VARCHAR", is_nullable => 1, size => 1 },
  "tlm",
  { data_type => "VARCHAR", is_nullable => 1, size => 1 },
  "sms",
  { data_type => "VARCHAR", is_nullable => 1, size => 1 },
  "altiris",
  { data_type => "VARCHAR", is_nullable => 1, size => 1 },
  "marimba",
  { data_type => "VARCHAR", is_nullable => 1, size => 1 },
  "usf_south_asset",
  { data_type => "VARCHAR", is_nullable => 1, size => 1 },
  "sig_bank",
  { data_type => "VARCHAR", is_nullable => 1, size => 1 },
  "softreq",
  { data_type => "VARCHAR", is_nullable => 1, size => 1 },
  "cams",
  { data_type => "VARCHAR", is_nullable => 1, size => 1 },
  "netcensus",
  { data_type => "VARCHAR", is_nullable => 1, size => 1 },
  "sims",
  { data_type => "VARCHAR", is_nullable => 1, size => 1 },
  "soft_audit",
  { data_type => "VARCHAR", is_nullable => 1, size => 256 },
  "other",
  { data_type => "VARCHAR", is_nullable => 1, size => 256 },
  "nw_ibm",
  { data_type => "INTEGER", is_nullable => 1, size => 10 },
  "nw_cust",
  { data_type => "INTEGER", is_nullable => 1, size => 10 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->belongs_to("a", "IBM::Schema::CNDB::AccountStat", { id => "as_id" });


# Created by DBIx::Class::Schema::Loader v0.04003 @ 2007-12-12 17:12:49
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:bviMnQv3fy4epf+mEJL4vA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
