package IBM::Schema::SoftReq::SwcmCpuExtSrcIds;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("swcm_cpu_ext_src_ids");
__PACKAGE__->add_columns(
  "id",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 11 },
  "sr_source",
  { data_type => "ENUM", default_value => "", is_nullable => 0, size => 4 },
  "sr_serial_num",
  { data_type => "VARCHAR", default_value => "", is_nullable => 0, size => 255 },
  "stamp",
  {
    data_type => "TIMESTAMP",
    default_value => "CURRENT_TIMESTAMP",
    is_nullable => 0,
    size => 14,
  },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("sr_source", ["sr_source", "sr_serial_num"]);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-08-27 13:48:29
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:fhCQxcMRn2llNVy6IxBM3Q

use overload '""' => sub { shift->id };

1;
