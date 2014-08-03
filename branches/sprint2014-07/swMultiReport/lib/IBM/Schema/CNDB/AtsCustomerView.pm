package IBM::Schema::CNDB::AtsCustomerView;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("ATS_CUSTOMER_VIEW");
__PACKAGE__->add_columns(
  "id",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
  "pod_name",
  { data_type => "VARCHAR", is_nullable => 0, size => 255 },
  "customer_type_name",
  { data_type => "VARCHAR", is_nullable => 0, size => 255 },
  "sector_name",
  { data_type => "VARCHAR", is_nullable => 0, size => 255 },
  "industry_name",
  { data_type => "VARCHAR", is_nullable => 0, size => 255 },
  "customer_name",
  { data_type => "VARCHAR", is_nullable => 0, size => 64 },
  "account_number",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
  "dpe_email",
  { data_type => "VARCHAR", is_nullable => 0, size => 255 },
  "dpe_name",
  { data_type => "VARCHAR", is_nullable => 0, size => 255 },
  "status",
  { data_type => "VARCHAR", is_nullable => 0, size => 32 },
);


# Created by DBIx::Class::Schema::Loader v0.04003 @ 2007-12-12 17:12:28
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:5woDzRGaKuUqu7XNPoN+fw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
