package IBM::Schema::TRAILS::ReconcileType;

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
__PACKAGE__->add_unique_constraint("IF1RECONCILETYPE", ["name"]);
__PACKAGE__->has_many(
  "reconciles",
  "IBM::Schema::TRAILS::Reconcile",
  { "foreign.reconcile_type_id" => "self.id" },
);
__PACKAGE__->has_many(
  "reconcile_hs",
  "IBM::Schema::TRAILS::ReconcileH",
  { "foreign.reconcile_type_id" => "self.id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-06-02 17:23:21
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:HPI8JMpqoZilbYzlBNPl4w


# You can replace this text with custom content, and it will be preserved on regeneration
1;
