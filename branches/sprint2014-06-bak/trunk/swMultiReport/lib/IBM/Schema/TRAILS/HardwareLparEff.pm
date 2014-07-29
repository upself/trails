package IBM::Schema::TRAILS::HardwareLparEff;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("hardware_lpar_eff");
__PACKAGE__->add_columns(
  "hardware_lpar_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "processor_count",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "status",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 32,
  },
);
__PACKAGE__->set_primary_key("hardware_lpar_id", "id");
__PACKAGE__->add_unique_constraint("IF2HARDWARELPAREFF", ["id"]);
__PACKAGE__->add_unique_constraint("IF1HARDWARELPAREFF", ["hardware_lpar_id"]);
__PACKAGE__->belongs_to(
  "hardware_lpar",
  "IBM::Schema::TRAILS::HardwareLpar",
  { id => "hardware_lpar_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-06-02 17:23:20
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:80lExoCedlsWxuKt7RHz0A


# You can replace this text with custom content, and it will be preserved on regeneration
1;
