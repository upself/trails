package IBM::Schema::TRAILS::InstalledFilter;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("installed_filter");
__PACKAGE__->add_columns(
  "installed_software_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "software_filter_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "bank_account_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
);
__PACKAGE__->set_primary_key(
  "installed_software_id",
  "software_filter_id",
  "bank_account_id",
  "id",
);
__PACKAGE__->add_unique_constraint("IF4INSTALLEDFILTER", ["id"]);
__PACKAGE__->add_unique_constraint(
  "IF3INSTALLEDFILTER",
  [
    "installed_software_id",
    "software_filter_id",
    "bank_account_id",
  ],
);
__PACKAGE__->belongs_to(
  "installed_software",
  "IBM::Schema::TRAILS::InstalledSoftware",
  { id => "installed_software_id" },
);
__PACKAGE__->belongs_to(
  "bank_account",
  "IBM::Schema::TRAILS::BankAccount",
  { id => "bank_account_id" },
);
__PACKAGE__->belongs_to(
  "software_filter",
  "IBM::Schema::TRAILS::SoftwareFilter",
  { software_filter_id => "software_filter_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-06-02 17:23:20
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ejHpp1RjaoNNQcYF6OJv5g


# You can replace this text with custom content, and it will be preserved on regeneration
1;
