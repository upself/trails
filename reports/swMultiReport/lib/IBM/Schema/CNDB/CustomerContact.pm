package IBM::Schema::CNDB::CustomerContact;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("CUSTOMER_CONTACT");
__PACKAGE__->add_columns(
  "customer_id",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
  "contact_id",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
);
__PACKAGE__->set_primary_key("customer_id", "contact_id");


# Created by DBIx::Class::Schema::Loader v0.04003 @ 2007-12-12 17:12:38
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:CNUM8FkN7l3I/BVcsyx0yA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
