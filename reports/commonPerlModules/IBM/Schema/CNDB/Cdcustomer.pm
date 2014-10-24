package IBM::Schema::CNDB::Cdcustomer;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("CDCUSTOMER");
__PACKAGE__->add_columns(
  "ibmsnap_commitseq",
  { data_type => "CHAR () FOR BIT DATA", is_nullable => 0, size => 10 },
  "ibmsnap_intentseq",
  { data_type => "CHAR () FOR BIT DATA", is_nullable => 0, size => 10 },
  "ibmsnap_operation",
  { data_type => "CHAR", is_nullable => 0, size => 1 },
  "customer_id",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
  "customer_type_id",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
  "pod_id",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
  "industry_id",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
  "contact_dpe_id",
  { data_type => "BIGINT", is_nullable => 1, size => 19 },
  "contact_fa_id",
  { data_type => "BIGINT", is_nullable => 1, size => 19 },
  "contact_hw_id",
  { data_type => "BIGINT", is_nullable => 1, size => 19 },
  "contact_sw_id",
  { data_type => "BIGINT", is_nullable => 1, size => 19 },
  "contact_focal_asset_id",
  { data_type => "BIGINT", is_nullable => 1, size => 19 },
  "contact_transition_id",
  { data_type => "BIGINT", is_nullable => 1, size => 19 },
  "account_number",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
  "customer_name",
  { data_type => "VARCHAR", is_nullable => 0, size => 64 },
  "asset_tools_billing_code",
  { data_type => "VARCHAR", is_nullable => 1, size => 64 },
  "status",
  { data_type => "VARCHAR", is_nullable => 0, size => 32 },
  "country_code_id",
  { data_type => "BIGINT", is_nullable => 1, size => 19 },
);


# Created by DBIx::Class::Schema::Loader v0.04003 @ 2007-12-12 17:12:32
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Mg8eMAOuZ4ZXenYs5ZaGWg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
