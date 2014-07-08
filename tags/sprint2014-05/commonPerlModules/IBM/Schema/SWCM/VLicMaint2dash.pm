package IBM::Schema::SWCM::VLicMaint2dash;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("v_lic_maint2dash");
__PACKAGE__->add_columns(
  "license_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "maint_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-04-27 14:56:12
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:aMJ57D+lw/1EaNyP8g61MQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
