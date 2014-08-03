package IBM::Schema::TRAILS::AccountPool;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("account_pool");
__PACKAGE__->add_columns(
  "account_pool_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "master_account_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "member_account_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "logical_delete_ind",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
);
__PACKAGE__->set_primary_key("account_pool_id");
__PACKAGE__->add_unique_constraint("IF1ACCOUNTPOOL", ["member_account_id"]);
__PACKAGE__->belongs_to(
  "master_account",
  "IBM::Schema::TRAILS::Customer",
  { customer_id => "master_account_id" },
);
__PACKAGE__->belongs_to(
  "member_account",
  "IBM::Schema::TRAILS::Customer",
  { customer_id => "member_account_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-06-02 17:23:20
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:u/AOPwhbsqh+1x5u07Umwg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
