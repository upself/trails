package IBM::Schema::BRAVO::Sector;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("sector");
__PACKAGE__->add_columns(
  "sector_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "sector_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 255,
  },
);
__PACKAGE__->set_primary_key("sector_id", "sector_name");
__PACKAGE__->add_unique_constraint("USECTOR", ["sector_id"]);
__PACKAGE__->has_many(
  "industries",
  "IBM::Schema::BRAVO::Industry",
  { "foreign.sector_id" => "self.sector_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-10-06 12:30:40
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:g9Vh+fv6wIpkCuvvNyCv0w


# You can replace this text with custom content, and it will be preserved on regeneration
1;
