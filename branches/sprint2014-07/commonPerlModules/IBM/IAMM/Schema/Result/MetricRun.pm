package IBM::IAMM::Schema::Result::MetricRun;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("metric_run");
__PACKAGE__->add_columns(
  "metric_run_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "start_date",
  { data_type => "DATE", default_value => undef, is_nullable => 0, size => 10 },
  "end_date",
  { data_type => "DATE", default_value => undef, is_nullable => 0, size => 10 },
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
__PACKAGE__->set_primary_key("metric_run_id");
__PACKAGE__->has_many(
  "metric_results",
  "IBM::IAMM::Schema::Result::MetricResult",
  { "foreign.metric_run_id" => "self.metric_run_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-10-22 14:08:32
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:eLmOayKOnt5eylY/bsvE2g


# You can replace this text with custom content, and it will be preserved on regeneration
1;
