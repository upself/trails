package IBM::Schema::BRAVO::SoftwareLparOsInfo;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("software_lpar_os_info");
__PACKAGE__->add_columns(
  "software_lpar_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "os_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "os_type",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 64,
  },
  "os_major_vers",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 32,
  },
  "os_minor_vers",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 32,
  },
  "os_sub_vers",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 32,
  },
  "os_inst_date",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 32,
  },
);
__PACKAGE__->set_primary_key("software_lpar_id", "id");
__PACKAGE__->add_unique_constraint("USWLPAROSINFO", ["id"]);
__PACKAGE__->belongs_to(
  "software_lpar",
  "IBM::Schema::BRAVO::SoftwareLpar",
  { id => "software_lpar_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-10-06 12:30:40
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:FbmG/5DgWu2pOP/oMVOpqg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
