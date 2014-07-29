package IBM::Schema::CNDB::AsCndbMap;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("AS_CNDB_MAP");
__PACKAGE__->add_columns(
  "id",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
  "as_id",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
  "cndb_id",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
  "current",
  { data_type => "VARCHAR", is_nullable => 0, size => 1 },
  "remote_user",
  { data_type => "VARCHAR", is_nullable => 0, size => 32 },
  "record_time",
  { data_type => "TIMESTAMP", is_nullable => 0, size => 26 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->belongs_to("a", "IBM::Schema::CNDB::AccountStat", { id => "as_id" });


# Created by DBIx::Class::Schema::Loader v0.04003 @ 2007-12-12 17:12:28
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:xUSaAY3GGVfPq7JlH4mMrQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
