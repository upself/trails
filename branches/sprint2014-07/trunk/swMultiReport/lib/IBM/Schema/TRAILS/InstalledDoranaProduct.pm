package IBM::Schema::TRAILS::InstalledDoranaProduct;

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
__PACKAGE__->add_unique_constraint(
  "IF3INSTDORANAPROD",
  [
    "installed_software_id",
    "dorana_product_id",
    "bank_account_id",
  ],
);
__PACKAGE__->add_unique_constraint("IF4INSTDORANAPROD", ["id"]);
__PACKAGE__->belongs_to(
  "bank_account",
  "IBM::Schema::TRAILS::BankAccount",
  { id => "bank_account_id" },
);
__PACKAGE__->belongs_to(
  "dorana_product",
  "IBM::Schema::TRAILS::DoranaProduct",
  { id => "dorana_product_id" },
);
__PACKAGE__->belongs_to(
  "installed_software",
  "IBM::Schema::TRAILS::InstalledSoftware",
  { id => "installed_software_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-06-02 17:23:20
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:31duHUZ2CBDK+BSAOHliOg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
