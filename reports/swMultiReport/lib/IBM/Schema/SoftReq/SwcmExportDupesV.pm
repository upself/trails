package IBM::Schema::SoftReq::SwcmExportDupesV;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("swcm_export_dupes_v");
__PACKAGE__->add_columns(
  "ext_src_id",
  { data_type => "VARCHAR", default_value => "", is_nullable => 0, size => 32 },
  "frequency",
  { data_type => "BIGINT", default_value => 0, is_nullable => 0, size => 21 },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-02-12 21:25:53
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:BsZBQhNEN09khgyVkMVmIw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
