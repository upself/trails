package IBM::Schema::TRAILS::ReconcileSignoff;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("reconcile_signoff");
__PACKAGE__->add_columns(
  "reconcile_signoff_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "customer_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "approver",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 32,
  },
  "signoff_document_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 100,
  },
  "standard_language_contract",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 8 },
  "record_time",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
  "requestor",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 32,
  },
  "asset_email",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 100,
  },
  "discrepency_date",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 1,
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
__PACKAGE__->set_primary_key("customer_id", "status", "record_time");
__PACKAGE__->add_unique_constraint("URECONCILESIGNOFF", ["reconcile_signoff_id"]);
__PACKAGE__->has_many(
  "reconcile_signoff_documents",
  "IBM::Schema::TRAILS::ReconcileSignoffDocument",
  { "foreign.reconcile_signoff_id" => "self.reconcile_signoff_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-10-06 12:32:46
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:mdVgK4IvGZXJ/6K/KZ6R1A


# You can replace this text with custom content, and it will be preserved on regeneration
1;
