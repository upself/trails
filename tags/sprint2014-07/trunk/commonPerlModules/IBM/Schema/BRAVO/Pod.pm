package IBM::Schema::BRAVO::Pod;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("pod");
__PACKAGE__->add_columns(
  "pod_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "pod_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 32,
  },
);
__PACKAGE__->set_primary_key("pod_id", "pod_name");
__PACKAGE__->add_unique_constraint("UPOD", ["pod_id"]);
__PACKAGE__->has_many(
  "customers",
  "IBM::Schema::BRAVO::Customer",
  { "foreign.pod_id" => "self.pod_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-10-06 12:30:40
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:vdjojWWInL1dX51KtTHY6A

# derive version directly from CVS revision.  As good a method as any.
our $VERSION  = (split(/ /, q$Revision: 1.2 $))[1];
our $REVISION = '$Id: Pod.pm,v 1.2 2008/10/17 20:33:46 cweyl Exp $';

# lazy! :-)
sub id   { shift->pod_id   }
sub name { shift->pod_name }

1;
