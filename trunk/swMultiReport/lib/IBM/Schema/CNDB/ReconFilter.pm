package IBM::Schema::CNDB::ReconFilter;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("RECON_FILTER");
__PACKAGE__->add_columns(
  "recon_filter_id",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
  "customer_number",
  { data_type => "VARCHAR", is_nullable => 1, size => 8 },
  "cn_filter",
  { data_type => "SMALLINT", is_nullable => 1, size => 5 },
  "atp_filter",
  { data_type => "SMALLINT", is_nullable => 1, size => 5 },
  "aed_filter",
  { data_type => "SMALLINT", is_nullable => 1, size => 5 },
  "cmr_filter",
  { data_type => "SMALLINT", is_nullable => 1, size => 5 },
  "record_time",
  { data_type => "TIMESTAMP", is_nullable => 1, size => 26 },
);
__PACKAGE__->set_primary_key("recon_filter_id");


# Created by DBIx::Class::Schema::Loader v0.04003 @ 2007-12-12 17:12:46
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:9bjqrJO17ILmbCw7nZyGmQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
