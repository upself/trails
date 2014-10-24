package IBM::IAMM::Schema::Result::NonStdCustomers;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("non_std_customers");
__PACKAGE__->add_columns(
  "am_customer_name_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "monthly_order_total",
  { data_type => "DECIMAL", default_value => "0.0", is_nullable => 0, size => 5 },
);
__PACKAGE__->set_primary_key("am_customer_name_id");
__PACKAGE__->belongs_to(
  "am_customer_name",
  "IBM::IAMM::Schema::Result::AmCustomerName",
  { am_customer_name_id => "am_customer_name_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-10-22 14:08:32
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:2iemIUGiv13q/7lIa8p/ig


# You can replace this text with custom content, and it will be preserved on regeneration
1;
