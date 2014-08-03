package IBM::Schema::TRAILS::ContactAccount;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("contact_account");
__PACKAGE__->add_columns(
  "customer_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "contact_support_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
);
__PACKAGE__->set_primary_key("customer_id", "contact_support_id", "id");
__PACKAGE__->add_unique_constraint("IF2CONTACTACCOUNT", ["id"]);
__PACKAGE__->add_unique_constraint("IF1CONTACTACCOUNT", ["contact_support_id", "customer_id"]);
__PACKAGE__->belongs_to(
  "contact_support",
  "IBM::Schema::TRAILS::ContactSupport",
  { id => "contact_support_id" },
);
__PACKAGE__->belongs_to(
  "customer",
  "IBM::Schema::TRAILS::Customer",
  { customer_id => "customer_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-06-02 17:23:20
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ka6MqU68vET+0QeSUSEzBA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
