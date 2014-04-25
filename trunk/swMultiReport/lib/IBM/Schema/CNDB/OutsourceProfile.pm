package IBM::Schema::CNDB::OutsourceProfile;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("OUTSOURCE_PROFILE");
__PACKAGE__->add_columns(
  "id",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
  "customer_id",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
  "asset_process_id",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
  "country_id",
  { data_type => "BIGINT", is_nullable => 1, size => 19 },
  "outsourceable",
  { data_type => "VARCHAR", is_nullable => 1, size => 3 },
  "comment",
  { data_type => "VARCHAR", is_nullable => 1, size => 256 },
  "approver",
  { data_type => "VARCHAR", is_nullable => 1, size => 128 },
  "record_time",
  { data_type => "TIMESTAMP", is_nullable => 1, size => 26 },
  "current",
  { data_type => "VARCHAR", is_nullable => 1, size => 1 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->belongs_to(
  "asset_process",
  "IBM::Schema::CNDB::AssetProcess",
  { id => "asset_process_id" },
);
__PACKAGE__->belongs_to(
  "country",
  "IBM::Schema::CNDB::CountryCode",
  { id => "country_id" },
);
__PACKAGE__->belongs_to(
  "customer",
  "IBM::Schema::CNDB::Customer",
  { customer_id => "customer_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04003 @ 2007-12-12 17:12:45
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Qyxq00KuqTbR+T6Ajy+Iew


# You can replace this text with custom content, and it will be preserved on regeneration
1;
