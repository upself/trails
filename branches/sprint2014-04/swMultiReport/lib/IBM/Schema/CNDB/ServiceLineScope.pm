package IBM::Schema::CNDB::ServiceLineScope;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("SERVICE_LINE_SCOPE");
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
  "hw_asset",
  { data_type => "VARCHAR", is_nullable => 1, size => 1 },
  "sw_asset",
  { data_type => "VARCHAR", is_nullable => 1, size => 1 },
  "sw_license",
  { data_type => "VARCHAR", is_nullable => 1, size => 1 },
  "inventory",
  { data_type => "VARCHAR", is_nullable => 1, size => 1 },
  "order",
  { data_type => "VARCHAR", is_nullable => 1, size => 1 },
  "financial",
  { data_type => "VARCHAR", is_nullable => 1, size => 1 },
  "logistics",
  { data_type => "VARCHAR", is_nullable => 1, size => 1 },
  "contact_cra",
  { data_type => "VARCHAR", is_nullable => 1, size => 64 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->belongs_to("a", "IBM::Schema::CNDB::AccountStat", { id => "as_id" });


# Created by DBIx::Class::Schema::Loader v0.04003 @ 2007-12-12 17:12:49
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ucRwpUHGFuFIrnOr0IGmpQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
