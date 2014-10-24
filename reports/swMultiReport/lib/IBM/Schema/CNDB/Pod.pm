package IBM::Schema::CNDB::Pod;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("POD");
__PACKAGE__->add_columns(
  "pod_id",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
  "pod_name",
  { data_type => "VARCHAR", is_nullable => 0, size => 255 },
);
__PACKAGE__->set_primary_key("pod_id");
__PACKAGE__->has_many(
  "customers",
  "IBM::Schema::CNDB::Customer",
  { "foreign.pod_id" => "self.pod_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04003 @ 2007-12-12 17:12:46
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Obm4tZXRsZum5UDItJmzew


# You can replace this text with custom content, and it will be preserved on regeneration
1;
