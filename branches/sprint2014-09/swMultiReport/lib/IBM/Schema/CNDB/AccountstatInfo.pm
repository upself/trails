package IBM::Schema::CNDB::AccountstatInfo;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("ACCOUNTSTAT_INFO");
__PACKAGE__->add_columns(
  "profile_id",
  { data_type => "VARCHAR", is_nullable => 0, size => 30 },
  "account_name",
  { data_type => "VARCHAR", is_nullable => 1, size => 100 },
  "last_mod_date",
  { data_type => "DATE", is_nullable => 1, size => 10 },
  "category",
  { data_type => "VARCHAR", is_nullable => 1, size => 25 },
  "industry",
  { data_type => "VARCHAR", is_nullable => 1, size => 100 },
  "pe_name",
  { data_type => "VARCHAR", is_nullable => 1, size => 75 },
  "pe_phone",
  { data_type => "VARCHAR", is_nullable => 1, size => 35 },
  "pe_mail",
  { data_type => "VARCHAR", is_nullable => 1, size => 50 },
  "pe_pager",
  { data_type => "VARCHAR", is_nullable => 1, size => 45 },
  "dpe_name",
  { data_type => "VARCHAR", is_nullable => 1, size => 75 },
  "dpe_phone",
  { data_type => "VARCHAR", is_nullable => 1, size => 35 },
  "dpe_mail",
  { data_type => "VARCHAR", is_nullable => 1, size => 50 },
  "dpe_pager",
  { data_type => "VARCHAR", is_nullable => 1, size => 45 },
  "sector",
  { data_type => "VARCHAR", is_nullable => 1, size => 100 },
  "active",
  { data_type => "INTEGER", is_nullable => 1, size => 10 },
  "smb_plus",
  { data_type => "INTEGER", is_nullable => 1, size => 10 },
  "rept_inst",
  { data_type => "VARCHAR", is_nullable => 1, size => 50 },
  "generalist",
  { data_type => "INTEGER", is_nullable => 1, size => 10 },
);
__PACKAGE__->set_primary_key("profile_id");


# Created by DBIx::Class::Schema::Loader v0.04003 @ 2007-12-12 17:12:27
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:roo+iyakEDapiLhH7n9a/Q


# You can replace this text with custom content, and it will be preserved on regeneration
1;
