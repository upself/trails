package IBM::Schema::TRAILS::VReconQueue;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("v_recon_queue");
__PACKAGE__->add_columns(
  "pk",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 66,
  },
  "id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "fk",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "customer_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "action",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 32,
  },
  "table",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 18,
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


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-06-02 17:23:21
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:QaOwCiEaSAigzSUhPPV1Ew


# You can replace this text with custom content, and it will be preserved on regeneration
1;
