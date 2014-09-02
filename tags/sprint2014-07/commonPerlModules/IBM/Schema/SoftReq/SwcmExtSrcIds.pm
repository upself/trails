package IBM::Schema::SoftReq::SwcmExtSrcIds;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("swcm_ext_src_ids");
__PACKAGE__->add_columns(
  "note_uuid",
  { data_type => "VARCHAR", default_value => "", is_nullable => 0, size => 128 },
  "ext_src_id",
  { data_type => "VARCHAR", default_value => "", is_nullable => 0, size => 32 },
  "stamp",
  {
    data_type => "TIMESTAMP",
    default_value => "CURRENT_TIMESTAMP",
    is_nullable => 0,
    size => 14,
  },
);
__PACKAGE__->set_primary_key("note_uuid");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-02-12 21:25:53
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:gYhyKcEwn0gcjpJleGbd0g


# relate to our parent doc
__PACKAGE__->belongs_to(
    'software_request',
    'IBM::Schema::SoftReq::SoftwareRequest',
    { 'foreign.note_uuid' => 'self.note_uuid' }
);

###########################################################################
# fields stored directly


1;
