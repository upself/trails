package IBM::IAMM::Schema::Result::MetricResult;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("metric_result");
__PACKAGE__->add_columns(
  "metric_result_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "metric_run_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "am_customer_name_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "metric_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "result",
  {
    data_type => "DECIMAL",
    default_value => undef,
    is_nullable => 0,
    size => 12,
  },
  "weight",
  {
    data_type => "DECIMAL",
    default_value => undef,
    is_nullable => 0,
    size => 12,
  },
  "numerator",
  {
    data_type => "DECIMAL",
    default_value => undef,
    is_nullable => 1,
    size => 12,
  },
  "denominator",
  { data_type => "DECIMAL", default_value => 1, is_nullable => 0, size => 12 },
);
__PACKAGE__->set_primary_key("metric_result_id");
__PACKAGE__->belongs_to(
  "am_customer_name",
  "IBM::IAMM::Schema::Result::AmCustomerName",
  { am_customer_name_id => "am_customer_name_id" },
);
__PACKAGE__->belongs_to(
  "metric_run",
  "IBM::IAMM::Schema::Result::MetricRun",
  { metric_run_id => "metric_run_id" },
);
__PACKAGE__->belongs_to(
  "metric",
  "IBM::IAMM::Schema::Result::Metric",
  { metric_id => "metric_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-10-22 14:08:32
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:vFPaooZahYN5oCMMMm4jWw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
