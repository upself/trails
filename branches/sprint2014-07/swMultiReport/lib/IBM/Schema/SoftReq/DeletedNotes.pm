package IBM::Schema::SoftReq::DeletedNotes;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("deleted_notes");
__PACKAGE__->add_columns(
  "unid",
  { data_type => "VARCHAR", default_value => "", is_nullable => 0, size => 32 },
  "deletion_type",
  { data_type => "ENUM", default_value => "", is_nullable => 0, size => 4 },
  "stamp",
  {
    data_type => "TIMESTAMP",
    default_value => "CURRENT_TIMESTAMP",
    is_nullable => 0,
    size => 14,
  },
);
__PACKAGE__->set_primary_key("unid");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-08-27 13:48:29
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:9oOVB+PtUdjLaJ3kvsuZXA


1;

__END__

#############################################################################
#    This is the documentation AND manpage of this module.  Document it     #
#                       it well, and wisely!                                #
#############################################################################


=head1 NAME
 
IBM::Schema::SoftReq::DeletedNotes - track "soft-deleted" documents 
 

=head1 DESCRIPTION

This table tracks the UNID of deleted documents in the SoftReq Domino
databases.  Note that at the moment we only track soft-deleted notes, as the
API Toolkit seems to want to make it as difficult as possible to extract the
UNID of hard-deleted notes.
 
 
=head1 COLUMNS 

Pretty self-explanitory.

=head3 unid

=head3 deletion_type

=head3 stamp


=head1 CONSTRAINTS

unid is the primary key of this table.

 
=head1 RELATIONSHIPS
 
None.  This table does not relationally map to other table's data as such.
 
 
=head1 AUTHOR
 
Chris Weyl <cweyl@us.ibm.com>
 
 
=head1 LICENCE AND COPYRIGHT
 
Copyright (c) 2007, 2008 IBM. All rights reserved.
 
This is for IBM Internal Use ONLY.
 

