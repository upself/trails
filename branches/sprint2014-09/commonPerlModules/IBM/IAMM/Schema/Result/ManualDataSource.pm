package IBM::IAMM::Schema::Result::ManualDataSource;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("manual_data_source");
__PACKAGE__->add_columns(
  "data_source",
  { data_type => "VARCHAR", default_value => "''", is_nullable => 0, size => 64 },
  "data_type",
  { data_type => "VARCHAR", default_value => "''", is_nullable => 0, size => 32 },
  "monthly_total",
  { data_type => "DECIMAL", default_value => "0.0", is_nullable => 0, size => 7 },
  "am_customer_name_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 1, size => 19 },
);
__PACKAGE__->set_primary_key("data_source", "data_type");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-10-22 14:08:32
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:UbhoU/wg4rSXtyEzbFxnCw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
