package IBM::Schema::BRAVO::AlertExpiredMaint;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("alert_expired_maint");
__PACKAGE__->add_columns(
  "license_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "comments",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "remote_user",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 32,
  },
  "creation_time",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
  "record_time",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
  "open",
  {
    data_type => "SMALLINT",
    default_value => undef,
    is_nullable => 0,
    size => 5,
  },
);
__PACKAGE__->set_primary_key("license_id", "id");
__PACKAGE__->add_unique_constraint("UALERTEXPIREDMAINT", ["id"]);
__PACKAGE__->belongs_to(
  "license",
  "IBM::Schema::BRAVO::License",
  { id => "license_id" },
);
__PACKAGE__->has_many(
  "alert_exp_maint_hs",
  "IBM::Schema::BRAVO::AlertExpMaintH",
  { "foreign.alert_expired_maint_id" => "self.id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-10-06 12:30:39
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:T1wReOcYkdk58C5D0dv4AA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
