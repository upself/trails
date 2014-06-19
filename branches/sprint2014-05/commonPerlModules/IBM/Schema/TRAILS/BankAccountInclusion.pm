package IBM::Schema::TRAILS::BankAccountInclusion;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("bank_account_inclusion");
__PACKAGE__->add_columns(
  "customer_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "bank_account_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
);
__PACKAGE__->set_primary_key("customer_id", "bank_account_id");
__PACKAGE__->belongs_to(
  "bank_account",
  "IBM::Schema::TRAILS::BankAccount",
  { id => "bank_account_id" },
);
__PACKAGE__->belongs_to(
  "customer",
  "IBM::Schema::TRAILS::Customer",
  { customer_id => "customer_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-06-02 17:23:20
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:4iv2oTAss6TFtswC4PdBuA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
