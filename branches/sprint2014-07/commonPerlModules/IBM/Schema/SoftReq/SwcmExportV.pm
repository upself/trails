package IBM::Schema::SoftReq::SwcmExportV;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("swcm_export_v");
__PACKAGE__->add_columns(
  "note_uuid",
  { data_type => "VARCHAR", default_value => "", is_nullable => 0, size => 128 },
  "docunid",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 40,
  },
  "ext_src_id",
  { data_type => "VARCHAR", default_value => "", is_nullable => 0, size => 32 },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-02-12 21:25:53
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:WgaTyXTZPYw23bgrcgAHWQ

=head1 NAME

IBM::Schema::SoftReq::SwcmExportV - View of SwCM export information

=head1 SYNOPSIS

=head1 CREATE VIEW SQL

While it's recommended that you always pull this information "on the fly" from
the database proper, here's the command used to create the view:

  create view swcm_export_v as 
  select sr.note_uuid, sr.docunid, swcm.ext_src_id 
  from software_request as sr inner join swcm_ext_src_ids as swcm 
  on sr.note_uuid = swcm.note_uuid 
  where 
  (
    (original_form = "SRMF") 
    or 
    (original_form = 'SR' and renewal_status != 'Renewed' and add_remove != 'Remove') 
    and 
    (
        software_status = "Active" 
        or software_status like '%Complete%' 
        or (work_request_num != "" and software_status = "")
    ) 
    and account_number != "" 
    and original_po_code != null
  );

=cut

# You can replace this text with custom content, and it will be preserved on regeneration
1;

__END__
