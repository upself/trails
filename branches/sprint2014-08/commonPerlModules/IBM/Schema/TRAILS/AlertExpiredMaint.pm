package IBM::Schema::TRAILS::AlertExpiredMaint;

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
__PACKAGE__->add_unique_constraint("IF2ALERTEXPMAINT", ["id"]);
__PACKAGE__->add_unique_constraint("IF1ALERTEXPMAINT", ["license_id"]);
__PACKAGE__->belongs_to(
  "license",
  "IBM::Schema::TRAILS::License",
  { id => "license_id" },
);
__PACKAGE__->has_many(
  "alert_exp_maint_hs",
  "IBM::Schema::TRAILS::AlertExpMaintH",
  { "foreign.alert_expired_maint_id" => "self.id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-06-02 17:23:20
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:DBIsTKBZbhqeJezU5aWJZA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
