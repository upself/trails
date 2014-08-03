package IBM::Schema::SWCM::TCustomerLpar;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("t_customer_lpar");
__PACKAGE__->add_columns(
  "customer_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "lpar_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
);
__PACKAGE__->set_primary_key("customer_id", "lpar_id");
__PACKAGE__->belongs_to(
  "lpar",
  "IBM::Schema::SWCM::TNamedLpars",
  { lpar_id => "lpar_id" },
);
__PACKAGE__->belongs_to(
  "customer",
  "IBM::Schema::SWCM::TCustomer",
  { customer_id => "customer_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-04-27 14:56:10
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:UfUp//ntI+E2BGvz0n9/cw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
