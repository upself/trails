package IBM::Schema::SWCM::TWlData;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("t_wl_data");
__PACKAGE__->add_columns(
  "wl_data_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "wl_data_ext_src_id",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 20,
  },
  "wl_data_ext_src_code",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "wl_data_created",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
  "wl_data_last_modified",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
  "wl_data_deleted",
  {
    data_type => "CHAR () FOR BIT DATA",
    default_value => "'0'",
    is_nullable => 0,
    size => 1,
  },
  "wl_data_attr01",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 15,
  },
  "wl_data_attr02",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 20,
  },
  "wl_data_attr03",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 100,
  },
  "wl_data_attr04",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 10,
  },
  "wl_data_attr05",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 20,
  },
  "wl_data_attr06",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 50,
  },
  "wl_data_attr07",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 100,
  },
  "wl_data_attr08",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 240,
  },
  "wl_data_gen01",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 10,
  },
  "wl_data_gen02",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 10,
  },
  "wl_data_gen03",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 10,
  },
  "wl_data_gen04",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 10,
  },
  "wl_data_gen05",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 10,
  },
  "wl_data_gen06",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 10,
  },
  "wl_data_gen07",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 50,
  },
  "wl_data_gen08",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 50,
  },
  "wl_data_gen09",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 50,
  },
  "wl_data_gen10",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 50,
  },
  "wl_data_gen11",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 50,
  },
  "wl_data_gen12",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 50,
  },
  "wl_data_gen13",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 50,
  },
  "wl_data_gen14",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 50,
  },
  "wl_data_gen15",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 100,
  },
  "wl_data_gen16",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 100,
  },
  "wl_data_gen17",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 100,
  },
  "wl_data_gen18",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 100,
  },
  "wl_data_gen19",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 500,
  },
  "wl_data_gen20",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 500,
  },
);
__PACKAGE__->set_primary_key("wl_data_id");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-04-27 14:56:12
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Sptp/4r+o8wQkOTT8c9hCw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
