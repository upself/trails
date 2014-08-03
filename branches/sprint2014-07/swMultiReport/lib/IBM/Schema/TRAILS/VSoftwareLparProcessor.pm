package IBM::Schema::TRAILS::VSoftwareLparProcessor;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("v_software_lpar_processor");
__PACKAGE__->add_columns(
  "id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "customer_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "processor_count",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-06-02 17:23:21
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:hyuIVs4P9knbIH3e4xiqRg

__PACKAGE__->set_primary_key("id");

__PACKAGE__->belongs_to(
    'software_lpar',
    'IBM::Schema::TRAILS::SoftwareLpar',
    { 'foreign.id' => 'self.id' },
);
      
1;
