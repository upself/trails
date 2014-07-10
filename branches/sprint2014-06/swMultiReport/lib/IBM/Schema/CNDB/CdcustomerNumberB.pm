package IBM::Schema::CNDB::CdcustomerNumberB;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("CDCUSTOMER_NUMBER_B");
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
  "parent_request_number_id",
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
  "cnc_comments",
  { data_type => "VARCHAR", is_nullable => 1, size => 255 },
  "claim_work_item",
  { data_type => "VARCHAR", is_nullable => 1, size => 64 },
  "claim_activity_code",
  { data_type => "VARCHAR", is_nullable => 1, size => 64 },
  "app_code",
  { data_type => "VARCHAR", is_nullable => 1, size => 64 },
  "fa_code_description",
  { data_type => "VARCHAR", is_nullable => 1, size => 64 },
  "cno_exception",
  { data_type => "VARCHAR", is_nullable => 1, size => 3 },
  "cno_exception_justification",
  { data_type => "VARCHAR", is_nullable => 1, size => 255 },
  "fa_code",
  { data_type => "VARCHAR", is_nullable => 1, size => 64 },
  "tower",
  { data_type => "VARCHAR", is_nullable => 1, size => 64 },
  "pool",
  { data_type => "VARCHAR", is_nullable => 1, size => 64 },
  "sub_group",
  { data_type => "VARCHAR", is_nullable => 1, size => 64 },
  "division",
  { data_type => "VARCHAR", is_nullable => 1, size => 64 },
  "state",
  { data_type => "VARCHAR", is_nullable => 1, size => 64 },
  "country",
  { data_type => "VARCHAR", is_nullable => 1, size => 64 },
  "postal_code",
  { data_type => "VARCHAR", is_nullable => 1, size => 64 },
  "address_title",
  { data_type => "VARCHAR", is_nullable => 1, size => 64 },
  "address1",
  { data_type => "VARCHAR", is_nullable => 1, size => 64 },
  "address2",
  { data_type => "VARCHAR", is_nullable => 1, size => 64 },
  "city",
  { data_type => "VARCHAR", is_nullable => 1, size => 64 },
  "central_recv_supp",
  { data_type => "VARCHAR", is_nullable => 1, size => 64 },
  "taxable_status",
  { data_type => "VARCHAR", is_nullable => 1, size => 64 },
  "exemption_reason",
  { data_type => "VARCHAR", is_nullable => 1, size => 64 },
  "charge_to_dept",
  { data_type => "VARCHAR", is_nullable => 1, size => 64 },
  "function",
  { data_type => "VARCHAR", is_nullable => 1, size => 64 },
  "igf_customer_number",
  { data_type => "VARCHAR", is_nullable => 1, size => 64 },
  "branch_office_code",
  { data_type => "VARCHAR", is_nullable => 1, size => 64 },
  "active_date",
  { data_type => "DATE", is_nullable => 1, size => 10 },
  "inactive_date",
  { data_type => "DATE", is_nullable => 1, size => 10 },
  "validation_date",
  { data_type => "DATE", is_nullable => 1, size => 10 },
  "validated_by",
  { data_type => "VARCHAR", is_nullable => 1, size => 64 },
  "validation_status",
  { data_type => "VARCHAR", is_nullable => 1, size => 64 },
  "status",
  { data_type => "VARCHAR", is_nullable => 0, size => 32 },
  "contact_hw_id",
  { data_type => "BIGINT", is_nullable => 1, size => 19 },
  "contact_sw_id",
  { data_type => "BIGINT", is_nullable => 1, size => 19 },
  "clli",
  { data_type => "VARCHAR", is_nullable => 1, size => 64 },
  "area",
  { data_type => "VARCHAR", is_nullable => 1, size => 64 },
  "cr_service_level",
  { data_type => "VARCHAR", is_nullable => 1, size => 32 },
);


# Created by DBIx::Class::Schema::Loader v0.04003 @ 2007-12-12 17:12:32
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:j4codH/TnJEArUS7NjBDNg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
