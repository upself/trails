package IBM::Schema::BRAVO::SoftwareLparMemory;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("software_lpar_memory");
__PACKAGE__->add_columns(
  "software_lpar_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "physical_memory",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
);
__PACKAGE__->set_primary_key("software_lpar_id", "physical_memory", "id");
__PACKAGE__->add_unique_constraint("USWLPARMEMORY", ["id"]);
__PACKAGE__->belongs_to(
  "software_lpar",
  "IBM::Schema::BRAVO::SoftwareLpar",
  { id => "software_lpar_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-10-06 12:30:40
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:HDXunmkrcqSMnnyzZLOGfw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
