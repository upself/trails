package IBM::Schema::CNDB::VOutsource;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("V_OUTSOURCE");
__PACKAGE__->add_columns(
  "account_number",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
  "process",
  { data_type => "VARCHAR", is_nullable => 1, size => 64 },
  "os_available",
  { data_type => "VARCHAR", is_nullable => 1, size => 3 },
  "os_comment",
  { data_type => "VARCHAR", is_nullable => 1, size => 256 },
  "os_geo",
  { data_type => "VARCHAR", is_nullable => 0, size => 64 },
  "asset_process_id",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
);


# Created by DBIx::Class::Schema::Loader v0.04003 @ 2007-12-12 17:12:50
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:e5pdoTVxQE0p8qbQfmGluA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
