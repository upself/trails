package IBM::Schema::CNDB::CustomerNumberContact;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("CUSTOMER_NUMBER_CONTACT");
__PACKAGE__->add_columns(
  "contact_id",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
  "customer_number_id",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
);
__PACKAGE__->set_primary_key("customer_number_id", "contact_id");


# Created by DBIx::Class::Schema::Loader v0.04003 @ 2007-12-12 17:12:38
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:l9t80utKRBmj8jF1lxXcYg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
