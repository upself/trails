package IBM::Schema::SoftReq::SwcmLicExtSrcIds;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("swcm_lic_ext_src_ids");
__PACKAGE__->add_columns(
  "note_uuid",
  { data_type => "VARCHAR", default_value => "", is_nullable => 0, size => 128 },
  "ext_src_id",
  { data_type => "VARCHAR", default_value => "", is_nullable => 0, size => 20 },
  "stamp",
  {
    data_type => "TIMESTAMP",
    default_value => "CURRENT_TIMESTAMP",
    is_nullable => 0,
    size => 14,
  },
);
__PACKAGE__->set_primary_key("note_uuid");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-08-27 13:48:29
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:wAw8IpSvV06t0Q6kOEtM4g

use overload '""' => sub { shift->ext_src_id };

sub is_unique {
    my $self = shift @_;

    my $rs = $self
        ->result_source
        ->schema
        ->resultset('SwcmLicExtSrcIds')
        ->search({ ext_src_id => $self->ext_src_id })
        ;

    return 0 if $rs->count > 1;
    return 1;
}

1;
