package IBM::Schema::TRAILS::SoftwareLparEff;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("software_lpar_eff");
__PACKAGE__->add_columns(
  "software_lpar_id",
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
  "status",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 32,
  },
);
__PACKAGE__->set_primary_key("software_lpar_id", "id");
__PACKAGE__->add_unique_constraint("IF1SOFTWARELPAREFF", ["software_lpar_id"]);
__PACKAGE__->add_unique_constraint("IF2SOFTWARELPAREFF", ["id"]);
__PACKAGE__->add_unique_constraint(
  "IF3SOFTWARELPAREFF",
  ["status", "software_lpar_id", "processor_count"],
);
__PACKAGE__->belongs_to(
  "software_lpar",
  "IBM::Schema::TRAILS::SoftwareLpar",
  { id => "software_lpar_id" },
);
__PACKAGE__->has_many(
  "software_lpar_eff_hs",
  "IBM::Schema::TRAILS::SoftwareLparEffH",
  { "foreign.software_lpar_eff_id" => "self.id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-06-02 17:23:21
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:NcTyL855EpA8z5v+G03pfg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
