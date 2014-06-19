package IBM::Schema::BRAVO::InstalledDoranaProduct;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("installed_dorana_product");
__PACKAGE__->add_columns(
  "installed_software_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "dorana_product_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "bank_account_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
);
__PACKAGE__->set_primary_key(
  "installed_software_id",
  "dorana_product_id",
  "bank_account_id",
  "id",
);
__PACKAGE__->belongs_to(
  "bank_account",
  "IBM::Schema::BRAVO::BankAccount",
  { id => "bank_account_id" },
);
__PACKAGE__->belongs_to(
  "installed_software",
  "IBM::Schema::BRAVO::InstalledSoftware",
  { id => "installed_software_id" },
);
__PACKAGE__->belongs_to(
  "dorana_product",
  "IBM::Schema::BRAVO::DoranaProduct",
  { id => "dorana_product_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-10-06 12:30:40
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:cA0Wu8YS7arXWUSWqz/eJw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
