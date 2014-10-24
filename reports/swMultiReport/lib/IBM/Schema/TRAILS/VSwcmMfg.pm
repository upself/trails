package IBM::Schema::TRAILS::VSwcmMfg;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("v_swcm_mfg");
__PACKAGE__->add_columns(
  "manufacturer_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "manufacturer_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 64,
  },
  "tlm_manufacturer_id",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 0, size => 9 },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-06-02 17:23:21
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:HaXpi2+eiMnUMk7xg2YH3g


# You can replace this text with custom content, and it will be preserved on regeneration
1;
