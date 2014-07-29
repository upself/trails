package IBM::Schema::BRAVO::Industry;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("industry");
__PACKAGE__->add_columns(
  "sector_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "industry_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "industry_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 255,
  },
);
__PACKAGE__->set_primary_key("sector_id", "industry_id", "industry_name");
__PACKAGE__->add_unique_constraint("UINDUSTRY", ["industry_id"]);
__PACKAGE__->has_many(
  "customers",
  "IBM::Schema::BRAVO::Customer",
  { "foreign.industry_id" => "self.industry_id" },
);
__PACKAGE__->belongs_to(
  "sector",
  "IBM::Schema::BRAVO::Sector",
  { sector_id => "sector_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-10-06 12:30:40
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:dosdzQHYOOPLjmqjVbJwQw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
