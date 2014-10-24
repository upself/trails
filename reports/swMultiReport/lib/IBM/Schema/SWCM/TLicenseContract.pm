package IBM::Schema::SWCM::TLicenseContract;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("t_license_contract");
__PACKAGE__->add_columns(
  "contract_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "license_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "lic_contr_created",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
  "lic_contr_deleted",
  {
    data_type => "CHAR () FOR BIT DATA",
    default_value => "'0'",
    is_nullable => 0,
    size => 1,
  },
  "lic_contr_created_by",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 200,
  },
);
__PACKAGE__->set_primary_key("contract_id", "license_id");
__PACKAGE__->belongs_to(
  "license",
  "IBM::Schema::SWCM::TLicense",
  { license_id => "license_id" },
);
__PACKAGE__->belongs_to(
  "contract",
  "IBM::Schema::SWCM::TContract",
  { contract_id => "contract_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-04-27 14:56:11
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:IZe3BI2EgYJ+VWRcKqga7A


# You can replace this text with custom content, and it will be preserved on regeneration
1;
