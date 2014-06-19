package IBM::Schema::TRAILS::SoftwareLparAdc;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("software_lpar_adc");
__PACKAGE__->add_columns(
  "software_lpar_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "ep_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 64,
  },
  "ep_oid",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 50,
  },
  "ip_address",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 15,
  },
  "cust",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 3 },
  "loc",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 3 },
  "gu",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 10 },
  "server_type",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 1 },
  "sesdr_location",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 15 },
  "sesdr_bp_using",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 12 },
  "sesdr_systid",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 8 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("IF2SOFTWARELPARADC", ["software_lpar_id"]);
__PACKAGE__->add_unique_constraint("IF3SOFTWARELPARADC", ["software_lpar_id", "ep_name"]);
__PACKAGE__->belongs_to(
  "software_lpar",
  "IBM::Schema::TRAILS::SoftwareLpar",
  { id => "software_lpar_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-06-02 17:23:21
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:rvoo9CSwxgetq04pvAQzsg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
