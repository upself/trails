package IBM::Schema::SWCM::TCurrencyCode;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("t_currency_code");
__PACKAGE__->add_columns(
  "currency_code",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 3 },
  "currency_code_desc",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 150,
  },
  "currency_code_rate",
  {
    data_type => "DECIMAL",
    default_value => "0.00",
    is_nullable => 1,
    size => 13,
  },
);
__PACKAGE__->set_primary_key("currency_code");
__PACKAGE__->has_many(
  "t_contract_con_cost_curr_codes",
  "IBM::Schema::SWCM::TContract",
  { "foreign.con_cost_curr_code" => "self.currency_code" },
);
__PACKAGE__->has_many(
  "t_contract_con_invoice_curr_codes",
  "IBM::Schema::SWCM::TContract",
  { "foreign.con_invoice_curr_code" => "self.currency_code" },
);
__PACKAGE__->has_many(
  "t_draft_contract_dr_con_cost_curr_codes",
  "IBM::Schema::SWCM::TDraftContract",
  { "foreign.dr_con_cost_curr_code" => "self.currency_code" },
);
__PACKAGE__->has_many(
  "t_draft_contract_dr_con_invoice_curr_codes",
  "IBM::Schema::SWCM::TDraftContract",
  { "foreign.dr_con_invoice_curr_code" => "self.currency_code" },
);
__PACKAGE__->has_many(
  "t_draft_licenses",
  "IBM::Schema::SWCM::TDraftLicense",
  { "foreign.dr_lic_cost_curr_code" => "self.currency_code" },
);
__PACKAGE__->has_many(
  "t_draft_maintenances",
  "IBM::Schema::SWCM::TDraftMaintenance",
  { "foreign.dr_maint_cost_curr_code" => "self.currency_code" },
);
__PACKAGE__->has_many(
  "t_licenses",
  "IBM::Schema::SWCM::TLicense",
  { "foreign.lic_cost_curr_code" => "self.currency_code" },
);
__PACKAGE__->has_many(
  "t_maintenances",
  "IBM::Schema::SWCM::TMaintenance",
  { "foreign.maint_cost_curr_code" => "self.currency_code" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-04-27 14:56:10
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:PShPUJCXwlC6EO09wtHmYQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
