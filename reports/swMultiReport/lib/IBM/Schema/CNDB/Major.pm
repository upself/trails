package IBM::Schema::CNDB::Major;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("MAJOR");
__PACKAGE__->add_columns(
  "major_id",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
  "major_name",
  { data_type => "VARCHAR", is_nullable => 0, size => 255 },
);
__PACKAGE__->set_primary_key("major_id");
__PACKAGE__->has_many(
  "lpids",
  "IBM::Schema::CNDB::Lpid",
  { "foreign.major_id" => "self.major_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04003 @ 2007-12-12 17:12:45
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:pOLHowRytpQoVi79JMeAcg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
