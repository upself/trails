package IBM::Schema::CNDB::CountryCode;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("COUNTRY_CODE");
__PACKAGE__->add_columns(
  "id",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
  "name",
  { data_type => "VARCHAR", is_nullable => 0, size => 64 },
  "code",
  { data_type => "VARCHAR", is_nullable => 0, size => 64 },
  "region_id",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("SQL070524230500630", ["name"]);
__PACKAGE__->belongs_to("region", "IBM::Schema::CNDB::Region", { id => "region_id" });
__PACKAGE__->has_many(
  "customers",
  "IBM::Schema::CNDB::Customer",
  { "foreign.country_code_id" => "self.id" },
);
__PACKAGE__->has_many(
  "customer_numbers",
  "IBM::Schema::CNDB::CustomerNumber",
  { "foreign.country_code_id" => "self.id" },
);
__PACKAGE__->has_many(
  "outsource_profiles",
  "IBM::Schema::CNDB::OutsourceProfile",
  { "foreign.country_id" => "self.id" },
);


# Created by DBIx::Class::Schema::Loader v0.04003 @ 2007-12-12 17:12:37
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:RqruP3N7Qv3tqSzCw0wWCg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
