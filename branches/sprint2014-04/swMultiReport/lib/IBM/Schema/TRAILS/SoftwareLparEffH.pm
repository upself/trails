package IBM::Schema::TRAILS::SoftwareLparEffH;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("software_lpar_eff_h");
__PACKAGE__->add_columns(
  "software_lpar_eff_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "processor_count",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => 10,
  },
  "action",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 64,
  },
  "status",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 32,
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
__PACKAGE__->set_primary_key("software_lpar_eff_id", "id");
__PACKAGE__->add_unique_constraint("IF1SWLPAREFFH", ["id"]);
__PACKAGE__->belongs_to(
  "software_lpar_eff",
  "IBM::Schema::TRAILS::SoftwareLparEff",
  { id => "software_lpar_eff_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-06-02 17:23:21
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:B044u1RrFmcuuGNdPoXEgw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
