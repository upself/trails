package IBM::Schema::CNDB::AssetProcess;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("ASSET_PROCESS");
__PACKAGE__->add_columns(
  "id",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
  "name",
  { data_type => "VARCHAR", is_nullable => 1, size => 64 },
  "description",
  { data_type => "VARCHAR", is_nullable => 1, size => 128 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->has_many(
  "outsource_profiles",
  "IBM::Schema::CNDB::OutsourceProfile",
  { "foreign.asset_process_id" => "self.id" },
);


# Created by DBIx::Class::Schema::Loader v0.04003 @ 2007-12-12 17:12:28
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:DF4WZGX9PGqqAZINXnOnSw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
