package IBM::Schema::TRAILS::VLparBankAccount;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("v_lpar_bank_account");
__PACKAGE__->add_columns(
  "id",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 64 },
  "software_lpar_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "bank_account_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-06-02 17:23:21
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:DbAqSWBnTaoG5BGxtehdGQ

__PACKAGE__->belongs_to(
    'bank_account',
    'IBM::Schema::TRAILS::BankAccount',
    { "foreign.id" => "self.bank_account_id" },
);  
            
__PACKAGE__->belongs_to(
    'software_lpar',
    'IBM::Schema::TRAILS::SoftwareLpar',
    { "foreign.id" => "self.software_lpar_id" },
);  

1;
