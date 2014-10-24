package IBM::Schema::SWCM::VMaintTransf2dash;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("v_maint_transf2dash");
__PACKAGE__->add_columns(
  "transf_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "maint_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-04-27 14:56:12
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Nher+0Y2hkjN0rNSZzAVuQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
