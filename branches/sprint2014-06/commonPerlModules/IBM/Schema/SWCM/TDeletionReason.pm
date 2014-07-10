package IBM::Schema::SWCM::TDeletionReason;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("t_deletion_reason");
__PACKAGE__->add_columns(
  "del_re_id",
  {
    data_type => "SMALLINT",
    default_value => undef,
    is_nullable => 0,
    size => 5,
  },
  "del_re_text",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 50,
  },
);
__PACKAGE__->set_primary_key("del_re_id");
__PACKAGE__->has_many(
  "t_contracts",
  "IBM::Schema::SWCM::TContract",
  { "foreign.con_del_re_id" => "self.del_re_id" },
);
__PACKAGE__->has_many(
  "t_licenses",
  "IBM::Schema::SWCM::TLicense",
  { "foreign.lic_del_re_id" => "self.del_re_id" },
);
__PACKAGE__->has_many(
  "t_locs",
  "IBM::Schema::SWCM::TLoc",
  { "foreign.loc_del_re_id" => "self.del_re_id" },
);
__PACKAGE__->has_many(
  "t_maintenances",
  "IBM::Schema::SWCM::TMaintenance",
  { "foreign.maint_del_re_id" => "self.del_re_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-04-27 14:56:10
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:N+0YYEX/5V1WcfyV7NVB0Q


# You can replace this text with custom content, and it will be preserved on regeneration
1;
