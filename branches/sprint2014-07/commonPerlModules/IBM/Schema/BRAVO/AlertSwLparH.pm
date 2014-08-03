package IBM::Schema::BRAVO::AlertSwLparH;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("alert_sw_lpar_h");
__PACKAGE__->add_columns(
  "alert_sw_lpar_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "comments",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "remote_user",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 32,
  },
  "creation_time",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
  "record_time",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
  "open",
  {
    data_type => "SMALLINT",
    default_value => undef,
    is_nullable => 0,
    size => 5,
  },
);
__PACKAGE__->set_primary_key("alert_sw_lpar_id", "id");
__PACKAGE__->belongs_to(
  "alert_sw_lpar",
  "IBM::Schema::BRAVO::AlertSwLpar",
  { id => "alert_sw_lpar_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-10-06 12:30:40
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:+s9LZKw5Eos7Wv60b1jw+Q


# You can replace this text with custom content, and it will be preserved on regeneration
1;
