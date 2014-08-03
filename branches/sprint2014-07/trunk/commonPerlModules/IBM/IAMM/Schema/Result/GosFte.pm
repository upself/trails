package IBM::IAMM::Schema::Result::GosFte;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("gos_fte");
__PACKAGE__->add_columns(
  "fte",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 64,
  },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-10-22 14:08:32
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:pQ9RET2/37GfdbjLVuDx1g


# You can replace this text with custom content, and it will be preserved on regeneration
1;
