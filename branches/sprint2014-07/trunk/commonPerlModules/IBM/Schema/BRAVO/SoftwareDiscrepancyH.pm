package IBM::Schema::BRAVO::SoftwareDiscrepancyH;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("software_discrepancy_h");
__PACKAGE__->add_columns(
  "installed_software_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "action",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 64,
  },
  "comment",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 512,
  },
  "remote_user",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 64,
  },
  "record_time",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
);
__PACKAGE__->set_primary_key("installed_software_id", "id");
__PACKAGE__->add_unique_constraint("USWDISCREPANCYH", ["id"]);
__PACKAGE__->belongs_to(
  "installed_software",
  "IBM::Schema::BRAVO::InstalledSoftware",
  { id => "installed_software_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-10-06 12:30:40
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:CGAwnnSc8vNpWCXJuZgsfg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
