package IBM::Schema::TRAILS::Pod;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("pod");
__PACKAGE__->add_columns(
  "pod_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "pod_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 32,
  },
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
__PACKAGE__->set_primary_key("pod_id", "pod_name");
__PACKAGE__->add_unique_constraint("IF1POD", ["pod_id"]);
__PACKAGE__->add_unique_constraint("IF2POD", ["pod_name"]);
__PACKAGE__->has_many(
  "customers",
  "IBM::Schema::TRAILS::Customer",
  { "foreign.pod_id" => "self.pod_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-06-02 17:23:20
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ul7ShJbNjh/ZWwEuwu1/SQ

sub id   { shift->id       }
sub name { shift->pod_name }

1;
