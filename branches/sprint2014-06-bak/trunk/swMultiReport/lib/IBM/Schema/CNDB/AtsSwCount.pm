package IBM::Schema::CNDB::AtsSwCount;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("ATS_SW_COUNT");
__PACKAGE__->add_columns(
  "platform",
  { data_type => "VARCHAR", is_nullable => 0, size => 11 },
  "ibm_owned",
  { data_type => "INTEGER", is_nullable => 1, size => 10 },
  "cust_owned",
  { data_type => "INTEGER", is_nullable => 1, size => 10 },
);


# Created by DBIx::Class::Schema::Loader v0.04003 @ 2007-12-12 17:12:30
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:yaqvk82FDe405zmJYBU9BQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
