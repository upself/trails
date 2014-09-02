package IBM::Schema::CNDB::CdcustomerNumber;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("CDCUSTOMER_NUMBER");
__PACKAGE__->add_columns(
  "ibmsnap_commitseq",
  { data_type => "CHAR () FOR BIT DATA", is_nullable => 0, size => 10 },
  "ibmsnap_intentseq",
  { data_type => "CHAR () FOR BIT DATA", is_nullable => 0, size => 10 },
  "ibmsnap_operation",
  { data_type => "CHAR", is_nullable => 0, size => 1 },
  "customer_number_id",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
  "customer_id",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
  "lpid_id",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
  "contact_cno_id",
  { data_type => "BIGINT", is_nullable => 1, size => 19 },
  "contact_dock_id",
  { data_type => "BIGINT", is_nullable => 1, size => 19 },
  "contact_customer_pool_id",
  { data_type => "BIGINT", is_nullable => 1, size => 19 },
  "customer_number",
  { data_type => "VARCHAR", is_nullable => 0, size => 255 },
  "central_recv_supp",
  { data_type => "VARCHAR", is_nullable => 1, size => 64 },
  "igf_customer_number",
  { data_type => "VARCHAR", is_nullable => 1, size => 64 },
  "status",
  { data_type => "VARCHAR", is_nullable => 0, size => 32 },
);


# Created by DBIx::Class::Schema::Loader v0.04003 @ 2007-12-12 17:12:32
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:TxjwAtwiA4uxjVUoCZ5I8w


# You can replace this text with custom content, and it will be preserved on regeneration
1;
