package IBM::Schema::CNDB::Order;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("ORDER");
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
  "ereq",
  { data_type => "VARCHAR", is_nullable => 1, size => 1 },
  "softreq",
  { data_type => "VARCHAR", is_nullable => 1, size => 1 },
  "cso",
  { data_type => "VARCHAR", is_nullable => 1, size => 1 },
  "wtaas",
  { data_type => "VARCHAR", is_nullable => 1, size => 1 },
  "cndb",
  { data_type => "VARCHAR", is_nullable => 1, size => 1 },
  "capform",
  { data_type => "VARCHAR", is_nullable => 1, size => 1 },
  "sap",
  { data_type => "VARCHAR", is_nullable => 1, size => 1 },
  "enos",
  { data_type => "VARCHAR", is_nullable => 1, size => 1 },
  "aart",
  { data_type => "VARCHAR", is_nullable => 1, size => 1 },
  "westreq",
  { data_type => "VARCHAR", is_nullable => 1, size => 1 },
  "other",
  { data_type => "VARCHAR", is_nullable => 1, size => 256 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->belongs_to("a", "IBM::Schema::CNDB::AccountStat", { id => "as_id" });


# Created by DBIx::Class::Schema::Loader v0.04003 @ 2007-12-12 17:12:45
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:CerEW6Jln5DcQhOVtNm0GA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
