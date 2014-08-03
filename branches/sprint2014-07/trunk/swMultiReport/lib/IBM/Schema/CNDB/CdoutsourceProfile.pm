package IBM::Schema::CNDB::CdoutsourceProfile;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("CDOUTSOURCE_PROFILE");
__PACKAGE__->add_columns(
  "ibmsnap_commitseq",
  { data_type => "CHAR () FOR BIT DATA", is_nullable => 0, size => 10 },
  "ibmsnap_intentseq",
  { data_type => "CHAR () FOR BIT DATA", is_nullable => 0, size => 10 },
  "ibmsnap_operation",
  { data_type => "CHAR", is_nullable => 0, size => 1 },
  "id",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
  "customer_id",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
  "asset_process_id",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
  "country_id",
  { data_type => "BIGINT", is_nullable => 1, size => 19 },
  "outsourceable",
  { data_type => "VARCHAR", is_nullable => 1, size => 3 },
  "comment",
  { data_type => "VARCHAR", is_nullable => 1, size => 256 },
  "approver",
  { data_type => "VARCHAR", is_nullable => 1, size => 128 },
  "record_time",
  { data_type => "TIMESTAMP", is_nullable => 1, size => 26 },
  "current",
  { data_type => "VARCHAR", is_nullable => 1, size => 1 },
);


# Created by DBIx::Class::Schema::Loader v0.04003 @ 2007-12-12 17:12:34
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:oXvugoAxnJj3Pljmn8VWRQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
