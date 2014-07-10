package IBM::Schema::TRAILS::ReconcileSignoffDocument;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("reconcile_signoff_document");
__PACKAGE__->add_columns(
  "reconcile_signoff_document_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "reconcile_signoff_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "signoff_document",
  {
    data_type => "BLOB",
    default_value => undef,
    is_nullable => 1,
    size => 1048576,
  },
);
__PACKAGE__->set_primary_key("reconcile_signoff_document_id");
__PACKAGE__->belongs_to(
  "reconcile_signoff",
  "IBM::Schema::TRAILS::ReconcileSignoff",
  { reconcile_signoff_id => "reconcile_signoff_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-10-06 12:32:46
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:+H7ldRzQ7xpY6AM7kSEcBw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
