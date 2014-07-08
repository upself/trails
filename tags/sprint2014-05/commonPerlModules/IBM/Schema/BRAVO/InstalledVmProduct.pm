package IBM::Schema::BRAVO::InstalledVmProduct;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("installed_vm_product");
__PACKAGE__->add_columns(
  "installed_software_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "vm_product_id",
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
  "vm_product_id",
  "bank_account_id",
  "id",
);
__PACKAGE__->add_unique_constraint("UINSTVMPRODUCT", ["id"]);
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
  "vm_product",
  "IBM::Schema::BRAVO::VmProduct",
  { id => "vm_product_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-10-06 12:30:40
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:sj/rz9wuhLPy4pLxfYmMNA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
