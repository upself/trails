package IBM::Schema::CNDB::CustomerNumber;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("CUSTOMER_NUMBER");
__PACKAGE__->add_columns(
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
  "country_code_id",
  { data_type => "BIGINT", is_nullable => 1, size => 19 },
);
__PACKAGE__->set_primary_key("customer_number_id");
__PACKAGE__->belongs_to(
  "contact_dock",
  "IBM::Schema::CNDB::Contact",
  { contact_id => "contact_dock_id" },
);
__PACKAGE__->belongs_to(
  "parent_request_number",
  "IBM::Schema::CNDB::RequestNumber",
  { request_number_id => "parent_request_number_id" },
);
__PACKAGE__->belongs_to(
  "country_code",
  "IBM::Schema::CNDB::CountryCode",
  { id => "country_code_id" },
);
__PACKAGE__->belongs_to(
  "customer",
  "IBM::Schema::CNDB::Customer",
  { customer_id => "customer_id" },
);
__PACKAGE__->belongs_to("lpid", "IBM::Schema::CNDB::Lpid", { lpid_id => "lpid_id" });
__PACKAGE__->has_many(
  "delegations",
  "IBM::Schema::CNDB::Delegation",
  { "foreign.customer_number_id" => "self.customer_number_id" },
);
__PACKAGE__->has_many(
  "delegations_request_datas",
  "IBM::Schema::CNDB::DelegationsRequestData",
  { "foreign.customer_number_id" => "self.customer_number_id" },
);
__PACKAGE__->has_many(
  "reval_customer_numbers",
  "IBM::Schema::CNDB::RevalCustomerNumber",
  { "foreign.customer_number_id" => "self.customer_number_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04003 @ 2007-12-12 17:12:38
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ywqDY2tM8Djrvp6NdvsWNg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
