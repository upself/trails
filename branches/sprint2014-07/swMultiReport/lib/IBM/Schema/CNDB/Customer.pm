package IBM::Schema::CNDB::Customer;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("CUSTOMER");
__PACKAGE__->add_columns(
  "customer_id",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
  "customer_type_id",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
  "pod_id",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
  "parent_request_number_id",
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
  "abbr_customer_name",
  { data_type => "VARCHAR", is_nullable => 1, size => 64 },
  "contract_number",
  { data_type => "VARCHAR", is_nullable => 1, size => 64 },
  "contract_type",
  { data_type => "VARCHAR", is_nullable => 1, size => 64 },
  "contract_status",
  { data_type => "VARCHAR", is_nullable => 1, size => 64 },
  "contract_sign_date",
  { data_type => "DATE", is_nullable => 1, size => 10 },
  "contract_start_date",
  { data_type => "DATE", is_nullable => 1, size => 10 },
  "contract_end_date",
  { data_type => "DATE", is_nullable => 1, size => 10 },
  "contract_value",
  { data_type => "VARCHAR", is_nullable => 1, size => 64 },
  "contract_hw_orders",
  { data_type => "INTEGER", is_nullable => 1, size => 10 },
  "contract_sw_orders",
  { data_type => "INTEGER", is_nullable => 1, size => 10 },
  "contract_hw_transfers",
  { data_type => "VARCHAR", is_nullable => 1, size => 64 },
  "contract_hw_transfers_count",
  { data_type => "INTEGER", is_nullable => 1, size => 10 },
  "contract_sw_transfers",
  { data_type => "VARCHAR", is_nullable => 1, size => 64 },
  "contract_sw_transfers_count",
  { data_type => "INTEGER", is_nullable => 1, size => 10 },
  "hostname_prefix",
  { data_type => "VARCHAR", is_nullable => 1, size => 64 },
  "tme_object_id",
  { data_type => "VARCHAR", is_nullable => 1, size => 255 },
  "tlm_deployment_status",
  { data_type => "VARCHAR", is_nullable => 1, size => 64 },
  "asset_tools_billing_code",
  { data_type => "VARCHAR", is_nullable => 1, size => 64 },
  "status",
  { data_type => "VARCHAR", is_nullable => 0, size => 32 },
  "maint_only",
  { data_type => "VARCHAR", is_nullable => 1, size => 64 },
  "sw_only_cn",
  { data_type => "VARCHAR", is_nullable => 1, size => 64 },
  "legacy_area",
  { data_type => "VARCHAR", is_nullable => 1, size => 64 },
  "hw_interlock",
  { data_type => "VARCHAR", is_nullable => 1, size => 3 },
  "sw_interlock",
  { data_type => "VARCHAR", is_nullable => 1, size => 3 },
  "inv_interlock",
  { data_type => "VARCHAR", is_nullable => 1, size => 3 },
  "pool",
  { data_type => "VARCHAR", is_nullable => 1, size => 64 },
  "clli",
  { data_type => "VARCHAR", is_nullable => 1, size => 64 },
  "validation_date",
  { data_type => "DATE", is_nullable => 1, size => 10 },
  "validated_by",
  { data_type => "VARCHAR", is_nullable => 1, size => 64 },
  "validation_status",
  { data_type => "VARCHAR", is_nullable => 1, size => 64 },
  "sw_license_mgmt",
  { data_type => "VARCHAR", is_nullable => 1, size => 3 },
  "sw_support",
  { data_type => "VARCHAR", is_nullable => 1, size => 3 },
  "hw_support",
  { data_type => "VARCHAR", is_nullable => 1, size => 3 },
  "geography",
  { data_type => "VARCHAR", is_nullable => 1, size => 32 },
  "tier",
  { data_type => "VARCHAR", is_nullable => 1, size => 16 },
  "transition_status",
  { data_type => "VARCHAR", is_nullable => 1, size => 16 },
  "transition_exit_date",
  { data_type => "DATE", is_nullable => 1, size => 10 },
  "om_org",
  { data_type => "VARCHAR", is_nullable => 1, size => 128 },
  "om_business_level",
  { data_type => "VARCHAR", is_nullable => 1, size => 128 },
  "om_sid",
  { data_type => "VARCHAR", is_nullable => 1, size => 32 },
  "country_code_id",
  { data_type => "BIGINT", is_nullable => 1, size => 19 },
  "customer_prefix",
  { data_type => "VARCHAR", is_nullable => 1, size => 16 },
  "customer_suffix",
  { data_type => "VARCHAR", is_nullable => 1, size => 16 },
  "scan_validity",
  { data_type => "INTEGER", is_nullable => 1, size => 10 },
  "sw_tracking",
  { data_type => "VARCHAR", is_nullable => 1, size => 3 },
  "sw_compliance_mgmt",
  { data_type => "VARCHAR", is_nullable => 1, size => 3 },
  "sw_financial_responsibility",
  { data_type => "VARCHAR", is_nullable => 1, size => 16 },
  "sw_financial_mgmt",
  { data_type => "VARCHAR", is_nullable => 1, size => 3 },
);
__PACKAGE__->set_primary_key("customer_id");
__PACKAGE__->belongs_to(
  "contact_dpe",
  "IBM::Schema::CNDB::Contact",
  { contact_id => "contact_dpe_id" },
);
__PACKAGE__->belongs_to(
  "industry",
  "IBM::Schema::CNDB::Industry",
  { industry_id => "industry_id" },
);
__PACKAGE__->belongs_to(
  "customer_type",
  "IBM::Schema::CNDB::CustomerType",
  { customer_type_id => "customer_type_id" },
);
__PACKAGE__->belongs_to("pod", "IBM::Schema::CNDB::Pod", { pod_id => "pod_id" });
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
__PACKAGE__->has_many(
  "customer_numbers",
  "IBM::Schema::CNDB::CustomerNumber",
  { "foreign.customer_id" => "self.customer_id" },
);
__PACKAGE__->has_many(
  "delegations",
  "IBM::Schema::CNDB::Delegation",
  { "foreign.customer_id" => "self.customer_id" },
);
__PACKAGE__->has_many(
  "delegations_request_datas",
  "IBM::Schema::CNDB::DelegationsRequestData",
  { "foreign.customer_id" => "self.customer_id" },
);
__PACKAGE__->has_many(
  "outsource_profiles",
  "IBM::Schema::CNDB::OutsourceProfile",
  { "foreign.customer_id" => "self.customer_id" },
);
__PACKAGE__->has_many(
  "reval_accounts",
  "IBM::Schema::CNDB::RevalAccount",
  { "foreign.customer_id" => "self.customer_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04003 @ 2007-12-12 17:12:37
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:wtibnzSGpZKKgHCPK28BOQ

###########################################################################
# lazy enablement 

sub id                 { $_[0]->customer_id                             }
sub customer_type_name { $_[0]->customer_type->customer_type_name;      }
sub pod_name           { $_[0]->pod->pod_name;                          }
sub country_name       { $_[0]->country_code->name;                     }
sub region_name        { $_[0]->country_code->region->name;             }
sub geo_name           { $_[0]->country_code->region->geography->name;  }

###########################################################################
# common searches 

# fetch a record by account_number...
sub by_account_number { 
    my $self           = shift @_;
    my $account_number = shift @_;
    
    return $self->search->(
        { account_number => $account_number }, 
        { order_by => "id DESC" }
    )->slice(0,1);
}


1;
