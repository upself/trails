package IBM::Schema::TRAILS::VLicenseUsedQty;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("v_license_used_qty");
__PACKAGE__->add_columns(
  "license_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "used_quantity",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => 10,
  },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-06-02 17:23:21
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:yLy9WkbdbxgaYDA7AwDyig


# You can replace this text with custom content, and it will be preserved on regeneration
1;
