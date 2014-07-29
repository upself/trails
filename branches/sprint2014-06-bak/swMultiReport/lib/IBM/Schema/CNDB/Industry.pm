package IBM::Schema::CNDB::Industry;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("INDUSTRY");
__PACKAGE__->add_columns(
  "industry_id",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
  "sector_id",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
  "industry_name",
  { data_type => "VARCHAR", is_nullable => 0, size => 255 },
);
__PACKAGE__->set_primary_key("industry_id");
__PACKAGE__->has_many(
  "customers",
  "IBM::Schema::CNDB::Customer",
  { "foreign.industry_id" => "self.industry_id" },
);
__PACKAGE__->belongs_to(
  "sector",
  "IBM::Schema::CNDB::Sector",
  { sector_id => "sector_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04003 @ 2007-12-12 17:12:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:SQl3gXVFlz6mqy+oQh+/Gg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
