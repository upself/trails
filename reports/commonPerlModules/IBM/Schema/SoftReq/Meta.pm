package IBM::Schema::SoftReq::Meta;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("meta");
__PACKAGE__->add_columns(
  "id",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 11 },
  "sr_form",
  { data_type => "VARCHAR", default_value => "", is_nullable => 0, size => 64 },
  "sr_field",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 64,
  },
  "db_table",
  { data_type => "VARCHAR", default_value => "", is_nullable => 0, size => 64 },
  "db_column",
  { data_type => "VARCHAR", default_value => "", is_nullable => 0, size => 64 },
  "description",
  { data_type => "VARCHAR", default_value => "", is_nullable => 0, size => 64 },
  "comment",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("META_DB_U", ["db_table", "db_column"]);
__PACKAGE__->add_unique_constraint("META_DOMINO_U", ["sr_form", "sr_field"]);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-08-27 13:48:29
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:gpQh+PleG5g6Cpie5gOtHg

# derive version directly from CVS revision.  As good a method as any.
our $VERSION  = '0.' . (split(/ /, q$Revision: 1.13 $))[1];
our $REVISION = '$Id: Meta.pm,v 1.13 2009/08/27 18:32:41 cweyl Exp $';

1;
 
__END__

#############################################################################
#    This is the documentation AND manpage of this module.  Document it     #
#                       it well, and wisely!                                #
#############################################################################


=head1 NAME
 
IBM::Schema::SoftReq::Meta - "meta" information about the softreq tables
 

=head1 DESCRIPTION

This table contains information as to how the tables and columns in this
database relate to the forms and fields in the SoftReq Domino databases.
 
 
=head1 COLUMNS 

    id          Primary key
    sr_form     Domino form
    sr_field    Field in the form
    db_table    Database table
    db_column   Database column
    description Little description of the value (nullable)
    comment     Random comment on it (nullable)

Note that "description" is also used (or rather, will be used) in the
pull-down select menus.

=head1 CONSTRAINTS

Unique constraints on (sr_form, sr_field) and (db_table, db_column).


=head1 RELATIONSHIPS
 
None.  This table does not relationally map to other table's data, just
describes what that data means and how it maps to and from the domino
databases.
 
 
=head1 AUTHOR
 
Chris Weyl <cweyl@us.ibm.com>
 
 
=head1 LICENCE AND COPYRIGHT
 
Copyright (c) 2007, 2008 IBM. All rights reserved.
 
This is for IBM Internal Use ONLY.
 
