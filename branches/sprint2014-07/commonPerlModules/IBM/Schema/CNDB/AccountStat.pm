package IBM::Schema::CNDB::AccountStat;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("ACCOUNT_STAT");
__PACKAGE__->add_columns(
  "id",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
  "account_name",
  { data_type => "VARCHAR", is_nullable => 0, size => 128 },
  "category",
  { data_type => "VARCHAR", is_nullable => 1, size => 32 },
  "so_scope",
  { data_type => "VARCHAR", is_nullable => 1, size => 256 },
  "so_scope_comments",
  { data_type => "VARCHAR", is_nullable => 1, size => 256 },
  "customer_locations",
  { data_type => "VARCHAR", is_nullable => 1, size => 256 },
  "dpe_name",
  { data_type => "VARCHAR", is_nullable => 1, size => 64 },
  "phase",
  { data_type => "VARCHAR", is_nullable => 1, size => 16 },
  "smb_plus",
  { data_type => "VARCHAR", is_nullable => 1, size => 1 },
  "sector",
  { data_type => "VARCHAR", is_nullable => 1, size => 32 },
  "industry",
  { data_type => "VARCHAR", is_nullable => 1, size => 32 },
  "contract_start",
  { data_type => "DATE", is_nullable => 1, size => 10 },
  "contract_end",
  { data_type => "DATE", is_nullable => 1, size => 10 },
  "contract_scope",
  { data_type => "VARCHAR", is_nullable => 1, size => 256 },
  "delivery_sites",
  { data_type => "VARCHAR", is_nullable => 1, size => 256 },
  "delivery_sites_comments",
  { data_type => "VARCHAR", is_nullable => 1, size => 256 },
  "inventory",
  { data_type => "VARCHAR", is_nullable => 1, size => 1 },
  "order",
  { data_type => "VARCHAR", is_nullable => 1, size => 1 },
  "sw_asset",
  { data_type => "VARCHAR", is_nullable => 1, size => 1 },
  "hw_asset",
  { data_type => "VARCHAR", is_nullable => 1, size => 1 },
  "sw_license",
  { data_type => "VARCHAR", is_nullable => 1, size => 1 },
  "logistics",
  { data_type => "VARCHAR", is_nullable => 1, size => 1 },
  "financial",
  { data_type => "VARCHAR", is_nullable => 1, size => 1 },
  "cndb_map",
  { data_type => "VARCHAR", is_nullable => 1, size => 1 },
  "status",
  { data_type => "VARCHAR", is_nullable => 1, size => 1 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("SQL070130144250610", ["account_name"]);
__PACKAGE__->has_many(
  "as_cndb_maps",
  "IBM::Schema::CNDB::AsCndbMap",
  { "foreign.as_id" => "self.id" },
);
__PACKAGE__->has_many(
  "financials",
  "IBM::Schema::CNDB::Financial",
  { "foreign.as_id" => "self.id" },
);
__PACKAGE__->has_many(
  "hw_assets",
  "IBM::Schema::CNDB::HwAsset",
  { "foreign.as_id" => "self.id" },
);
__PACKAGE__->has_many(
  "inventories",
  "IBM::Schema::CNDB::Inventory",
  { "foreign.as_id" => "self.id" },
);
__PACKAGE__->has_many(
  "logistics",
  "IBM::Schema::CNDB::Logistics",
  { "foreign.as_id" => "self.id" },
);
__PACKAGE__->has_many(
  "orders",
  "IBM::Schema::CNDB::Order",
  { "foreign.as_id" => "self.id" },
);
__PACKAGE__->has_many(
  "service_line_scopes",
  "IBM::Schema::CNDB::ServiceLineScope",
  { "foreign.as_id" => "self.id" },
);
__PACKAGE__->has_many(
  "sw_assets",
  "IBM::Schema::CNDB::SwAsset",
  { "foreign.as_id" => "self.id" },
);
__PACKAGE__->has_many(
  "sw_licenses",
  "IBM::Schema::CNDB::SwLicense",
  { "foreign.as_id" => "self.id" },
);


# Created by DBIx::Class::Schema::Loader v0.04003 @ 2007-12-12 17:12:27
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:lLnUdDdvTFObiOh9aIqdyA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
