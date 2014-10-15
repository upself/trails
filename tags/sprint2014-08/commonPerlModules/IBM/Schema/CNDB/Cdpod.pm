package IBM::Schema::CNDB::Cdpod;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("CDPOD");
__PACKAGE__->add_columns(
  "ibmsnap_commitseq",
  { data_type => "CHAR () FOR BIT DATA", is_nullable => 0, size => 10 },
  "ibmsnap_intentseq",
  { data_type => "CHAR () FOR BIT DATA", is_nullable => 0, size => 10 },
  "ibmsnap_operation",
  { data_type => "CHAR", is_nullable => 0, size => 1 },
  "pod_id",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
  "pod_name",
  { data_type => "VARCHAR", is_nullable => 0, size => 255 },
);


# Created by DBIx::Class::Schema::Loader v0.04003 @ 2007-12-12 17:12:34
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:SCcaqhuWmjDfAg3zsHSRog


# You can replace this text with custom content, and it will be preserved on regeneration
1;
