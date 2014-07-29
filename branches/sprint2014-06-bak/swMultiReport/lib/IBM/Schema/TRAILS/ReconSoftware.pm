package IBM::Schema::TRAILS::ReconSoftware;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("recon_software");
__PACKAGE__->add_columns(
  "software_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "action",
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
__PACKAGE__->set_primary_key("software_id", "id");
__PACKAGE__->add_unique_constraint("IF2RECONSOFTWARE", ["id"]);
__PACKAGE__->belongs_to(
  "software",
  "IBM::Schema::TRAILS::Software",
  { software_id => "software_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-06-02 17:23:20
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Qzn62RUo9kaIzRgJSoZHcw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
