package IBM::Schema::CNDB::HwAsset;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("HW_ASSET");
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
  "eesm",
  { data_type => "VARCHAR", is_nullable => 1, size => 1 },
  "mldb",
  { data_type => "VARCHAR", is_nullable => 1, size => 1 },
  "cams",
  { data_type => "VARCHAR", is_nullable => 1, size => 1 },
  "atp",
  { data_type => "VARCHAR", is_nullable => 1, size => 1 },
  "epct",
  { data_type => "VARCHAR", is_nullable => 1, size => 1 },
  "cndb",
  { data_type => "VARCHAR", is_nullable => 1, size => 1 },
  "enos",
  { data_type => "VARCHAR", is_nullable => 1, size => 1 },
  "jac",
  { data_type => "VARCHAR", is_nullable => 1, size => 1 },
  "asset_depot",
  { data_type => "VARCHAR", is_nullable => 1, size => 1 },
  "argis",
  { data_type => "VARCHAR", is_nullable => 1, size => 1 },
  "cadam",
  { data_type => "VARCHAR", is_nullable => 1, size => 1 },
  "peregrine",
  { data_type => "VARCHAR", is_nullable => 1, size => 1 },
  "remedy",
  { data_type => "VARCHAR", is_nullable => 1, size => 1 },
  "dpu",
  { data_type => "VARCHAR", is_nullable => 1, size => 1 },
  "amdb",
  { data_type => "VARCHAR", is_nullable => 1, size => 1 },
  "usf_server_db",
  { data_type => "VARCHAR", is_nullable => 1, size => 1 },
  "nsdb",
  { data_type => "VARCHAR", is_nullable => 1, size => 1 },
  "idd",
  { data_type => "VARCHAR", is_nullable => 1, size => 1 },
  "art",
  { data_type => "VARCHAR", is_nullable => 1, size => 1 },
  "failer",
  { data_type => "VARCHAR", is_nullable => 1, size => 1 },
  "hardb",
  { data_type => "VARCHAR", is_nullable => 1, size => 1 },
  "manage_now",
  { data_type => "VARCHAR", is_nullable => 1, size => 1 },
  "request_now",
  { data_type => "VARCHAR", is_nullable => 1, size => 1 },
  "passport",
  { data_type => "VARCHAR", is_nullable => 1, size => 1 },
  "other",
  { data_type => "VARCHAR", is_nullable => 1, size => 256 },
  "nw_ibm",
  { data_type => "INTEGER", is_nullable => 1, size => 10 },
  "nw_cust",
  { data_type => "INTEGER", is_nullable => 1, size => 10 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->belongs_to("a", "IBM::Schema::CNDB::AccountStat", { id => "as_id" });


# Created by DBIx::Class::Schema::Loader v0.04003 @ 2007-12-12 17:12:43
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Xm3RIM5xLCbgOKSpYsU3xw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
