package IBM::Schema::CNDB::SwLicense;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("SW_LICENSE");
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
  "ms_wizard",
  { data_type => "VARCHAR", is_nullable => 1, size => 1 },
  "sig_bank",
  { data_type => "VARCHAR", is_nullable => 1, size => 1 },
  "usf_south_asset",
  { data_type => "VARCHAR", is_nullable => 1, size => 1 },
  "trails",
  { data_type => "VARCHAR", is_nullable => 1, size => 1 },
  "sims",
  { data_type => "VARCHAR", is_nullable => 1, size => 1 },
  "soft_audit",
  { data_type => "VARCHAR", is_nullable => 1, size => 1 },
  "msls",
  { data_type => "VARCHAR", is_nullable => 1, size => 1 },
  "ews",
  { data_type => "VARCHAR", is_nullable => 1, size => 1 },
  "other",
  { data_type => "VARCHAR", is_nullable => 1, size => 256 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->belongs_to("a", "IBM::Schema::CNDB::AccountStat", { id => "as_id" });


# Created by DBIx::Class::Schema::Loader v0.04003 @ 2007-12-12 17:12:49
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:DeB/3bosrt1CGe4/jXpaOg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
