package IBM::IAMM::Schema::Result::AmLpid;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("am_lpid");
__PACKAGE__->add_columns(
  "am_lpid_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "am_lpid",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 16,
  },
  "status",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 32,
  },
  "remote_user",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 32,
  },
  "record_time",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
);
__PACKAGE__->set_primary_key("am_lpid_id");
__PACKAGE__->has_many(
  "am_lpid_maps",
  "IBM::IAMM::Schema::Result::AmLpidMap",
  { "foreign.am_lpid_id" => "self.am_lpid_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-10-22 14:08:32
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Ei03iGLDjErDcEHB0ZTmFw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
