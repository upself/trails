package IBM::Schema::CNDB::SectorIndustryRef;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("SECTOR_INDUSTRY_REF");
__PACKAGE__->add_columns(
  "id",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
  "sector",
  { data_type => "VARCHAR", is_nullable => 0, size => 32 },
  "industry",
  { data_type => "VARCHAR", is_nullable => 0, size => 64 },
);
__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.04003 @ 2007-12-12 17:12:48
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:tdO34Syp7LVIE/xC2Urwuw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
