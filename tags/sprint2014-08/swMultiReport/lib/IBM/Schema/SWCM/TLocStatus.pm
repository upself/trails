package IBM::Schema::SWCM::TLocStatus;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("t_loc_status");
__PACKAGE__->add_columns(
  "loc_status_id",
  {
    data_type => "SMALLINT",
    default_value => undef,
    is_nullable => 0,
    size => 5,
  },
  "loc_status_code",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 20,
  },
  "loc_status_desc",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 70,
  },
  "loc_status_created",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
  "loc_status_last_modified",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
);
__PACKAGE__->set_primary_key("loc_status_id");
__PACKAGE__->add_unique_constraint("UC_LOC_STATUS_CODE", ["loc_status_code"]);
__PACKAGE__->has_many(
  "t_locs",
  "IBM::Schema::SWCM::TLoc",
  { "foreign.loc_loc_status_id" => "self.loc_status_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-04-27 14:56:11
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:UpcZkCjV1rku1Vz50sWufw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
