package IBM::Schema::SWCM::TCountryCode;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("t_country_code");
__PACKAGE__->add_columns(
  "country_code",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 3 },
  "country_code_desc",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 150,
  },
  "currency_code",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 3 },
  "ibm_ctry_code",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 3 },
  "org_level_1",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "org_level_2",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "org_level_3",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
);
__PACKAGE__->set_primary_key("country_code");
__PACKAGE__->belongs_to(
  "org_level_3",
  "IBM::Schema::SWCM::TOrgLevel3",
  { org_level3_id => "org_level_3" },
);
__PACKAGE__->belongs_to(
  "org_level_2",
  "IBM::Schema::SWCM::TOrgLevel2",
  { org_level2_id => "org_level_2" },
);
__PACKAGE__->belongs_to(
  "org_level_1",
  "IBM::Schema::SWCM::TOrgLevel1",
  { org_level1_id => "org_level_1" },
);
__PACKAGE__->has_many(
  "t_customers",
  "IBM::Schema::SWCM::TCustomer",
  { "foreign.cus_country_code" => "self.country_code" },
);
__PACKAGE__->has_many(
  "t_draft_licenses",
  "IBM::Schema::SWCM::TDraftLicense",
  { "foreign.dr_lic_order_country_code" => "self.country_code" },
);
__PACKAGE__->has_many(
  "t_draft_maintenances",
  "IBM::Schema::SWCM::TDraftMaintenance",
  { "foreign.dr_maint_order_country_code" => "self.country_code" },
);
__PACKAGE__->has_many(
  "t_licenses",
  "IBM::Schema::SWCM::TLicense",
  { "foreign.lic_order_country_code" => "self.country_code" },
);
__PACKAGE__->has_many(
  "t_maintenances",
  "IBM::Schema::SWCM::TMaintenance",
  { "foreign.maint_order_country_code" => "self.country_code" },
);
__PACKAGE__->has_many(
  "t_suppliers",
  "IBM::Schema::SWCM::TSupplier",
  { "foreign.sup_country_code" => "self.country_code" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-04-27 14:56:10
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ZU8rcV/9Y6Y1imEsn97/sg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
