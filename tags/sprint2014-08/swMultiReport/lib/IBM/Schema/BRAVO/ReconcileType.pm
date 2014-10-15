package IBM::Schema::BRAVO::ReconcileType;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("reconcile_type");
__PACKAGE__->add_columns(
  "id",
  {
    data_type => "SMALLINT",
    default_value => undef,
    is_nullable => 0,
    size => 5,
  },
  "name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 64,
  },
  "is_manual",
  {
    data_type => "SMALLINT",
    default_value => undef,
    is_nullable => 0,
    size => 5,
  },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->has_many(
  "reconciles",
  "IBM::Schema::BRAVO::Reconcile",
  { "foreign.reconcile_type_id" => "self.id" },
);
__PACKAGE__->has_many(
  "reconcile_hs",
  "IBM::Schema::BRAVO::ReconcileH",
  { "foreign.reconcile_type_id" => "self.id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-10-06 12:30:40
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:S9egJrUpwSkk5wFnJrQfbw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
