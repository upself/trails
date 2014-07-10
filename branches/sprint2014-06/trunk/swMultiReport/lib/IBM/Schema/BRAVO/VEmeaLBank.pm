package IBM::Schema::BRAVO::VEmeaLBank;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("v_emea_l_bank");
__PACKAGE__->add_columns(
  "key",
  { data_type => "BIGINT", default_value => undef, is_nullable => 1, size => 19 },
  "str",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 1000,
  },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-10-06 12:30:40
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:QILCr7U/VrnAJOtYE4hRaA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
