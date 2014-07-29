package IBM::Schema::TRAILS::ReconSwLpar;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("recon_sw_lpar");
__PACKAGE__->add_columns(
  "customer_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "software_lpar_id",
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
__PACKAGE__->set_primary_key("customer_id", "software_lpar_id", "id");
__PACKAGE__->add_unique_constraint("IF2RECONSWLPAR", ["id"]);
__PACKAGE__->belongs_to(
  "customer",
  "IBM::Schema::TRAILS::Customer",
  { customer_id => "customer_id" },
);
__PACKAGE__->belongs_to(
  "software_lpar",
  "IBM::Schema::TRAILS::SoftwareLpar",
  { id => "software_lpar_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-06-02 17:23:20
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:G8n+iycORPWUnTfEQNF8iw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
