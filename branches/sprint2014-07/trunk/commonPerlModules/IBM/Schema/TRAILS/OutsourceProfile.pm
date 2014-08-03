package IBM::Schema::TRAILS::OutsourceProfile;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("outsource_profile");
__PACKAGE__->add_columns(
  "customer_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "asset_process_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "country_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 1, size => 19 },
  "outsourceable",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 3 },
  "comment",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 256,
  },
  "approver",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 128,
  },
  "record_time",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 1,
    size => 26,
  },
  "current",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 1 },
  "creation_date_time",
  {
    data_type => "TIMESTAMP",
    default_value => "CURRENT TIMESTAMP",
    is_nullable => 0,
    size => 26,
  },
  "update_date_time",
  {
    data_type => "TIMESTAMP",
    default_value => "CURRENT TIMESTAMP",
    is_nullable => 0,
    size => 26,
  },
);
__PACKAGE__->set_primary_key("customer_id", "id");
__PACKAGE__->add_unique_constraint("IF1OUTSRCPROFILE", ["id"]);
__PACKAGE__->belongs_to(
  "customer",
  "IBM::Schema::TRAILS::Customer",
  { customer_id => "customer_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-06-02 17:23:20
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:jqi/PwP2Hy6K+WOIJUnBVA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
