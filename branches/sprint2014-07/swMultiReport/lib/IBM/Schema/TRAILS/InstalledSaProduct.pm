package IBM::Schema::TRAILS::InstalledSaProduct;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("installed_sa_product");
__PACKAGE__->add_columns(
  "installed_software_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "sa_product_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "bank_account_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
);
__PACKAGE__->set_primary_key(
  "installed_software_id",
  "sa_product_id",
  "bank_account_id",
  "id",
);
__PACKAGE__->add_unique_constraint(
  "IF3INSTSAPRODUCT",
  ["installed_software_id", "sa_product_id", "bank_account_id"],
);
__PACKAGE__->add_unique_constraint("IF4INSTSAPRODUCT", ["id"]);
__PACKAGE__->belongs_to(
  "sa_product",
  "IBM::Schema::TRAILS::SaProduct",
  { id => "sa_product_id" },
);
__PACKAGE__->belongs_to(
  "installed_software",
  "IBM::Schema::TRAILS::InstalledSoftware",
  { id => "installed_software_id" },
);
__PACKAGE__->belongs_to(
  "bank_account",
  "IBM::Schema::TRAILS::BankAccount",
  { id => "bank_account_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-06-02 17:23:20
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:A6hlpT5VL4kEuQhoJo1yEA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
