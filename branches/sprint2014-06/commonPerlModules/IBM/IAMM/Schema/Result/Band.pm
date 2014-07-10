package IBM::IAMM::Schema::Result::Band;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("band");
__PACKAGE__->add_columns(
  "band_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "band",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 16,
  },
  "band_numeric",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "band_type",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 16,
  },
  "cost_per_hour",
  {
    data_type => "DECIMAL",
    default_value => undef,
    is_nullable => 1,
    size => 12,
  },
);
__PACKAGE__->set_primary_key("band_id");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-10-22 14:08:32
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:0elg8FbH4ytZB1ZDbZt5xw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
