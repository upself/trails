package IBM::IAMM::Schema::Result::Metric;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("metric");
__PACKAGE__->add_columns(
  "metric_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "metric",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 0, size => 8 },
  "metric_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 128,
  },
  "metric_definition",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 255,
  },
  "metric_use",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 255,
  },
  "metric_unit",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 16,
  },
  "metric_calculation",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
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
__PACKAGE__->set_primary_key("metric_id");
__PACKAGE__->has_many(
  "metric_results",
  "IBM::IAMM::Schema::Result::MetricResult",
  { "foreign.metric_id" => "self.metric_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-10-22 14:08:32
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:lffoE2hO0VxoIZNL4Sj4Ig


# You can replace this text with custom content, and it will be preserved on regeneration
1;
