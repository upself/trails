package IBM::IAMM::Schema::Result::RawAtpData;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("raw_atp_data");
__PACKAGE__->add_columns(
  "account_number",
  { data_type => "BIGINT", default_value => undef, is_nullable => 1, size => 19 },
  "customer_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 64,
  },
  "customer_type_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 200,
  },
  "customer_number_status",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 32,
  },
  "machine_type",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 8 },
  "serial_number",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 15,
  },
  "category",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 6 },
  "platform",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 6 },
  "inventry",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 8 },
  "iccbill",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 7 },
  "maincust",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 8 },
  "pcfcust",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 7 },
  "sapcust",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 7 },
  "initdate",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 8 },
  "onpcf",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 1 },
  "onsap",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 1 },
  "onicc",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 2 },
  "transtyp",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 4 },
  "leaseamt",
  {
    data_type => "DECIMAL",
    default_value => undef,
    is_nullable => 1,
    size => 13,
  },
  "type",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 5 },
  "baseind",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 1 },
  "onaas",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 1 },
  "onchis",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 1 },
  "lease_type",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 4 },
  "dept",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 6 },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-10-22 14:08:32
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:UfbBKFLe1u4Gbe3vukW+Eg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
