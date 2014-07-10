package IBM::Schema::CNDB::AccountstatMap;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("ACCOUNTSTAT_MAP");
__PACKAGE__->add_columns(
  "profile_id",
  { data_type => "VARCHAR", is_nullable => 0, size => 30 },
  "cust_num",
  { data_type => "VARCHAR", is_nullable => 0, size => 100 },
);
__PACKAGE__->set_primary_key("profile_id", "cust_num");


# Created by DBIx::Class::Schema::Loader v0.04003 @ 2007-12-12 17:12:27
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Q94T7EgMJGIswJLm0XjjOg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
