package IBM::Schema::CNDB::Sector;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("SECTOR");
__PACKAGE__->add_columns(
  "sector_id",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
  "sector_name",
  { data_type => "VARCHAR", is_nullable => 0, size => 255 },
);
__PACKAGE__->set_primary_key("sector_id");
__PACKAGE__->has_many(
  "industries",
  "IBM::Schema::CNDB::Industry",
  { "foreign.sector_id" => "self.sector_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04003 @ 2007-12-12 17:12:48
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:LrQxe3RQv6mJKFc3SS793A


# You can replace this text with custom content, and it will be preserved on regeneration
1;
