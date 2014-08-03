package IBM::Schema::TRAILS::Software;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("software");
__PACKAGE__->add_columns(
  "manufacturer_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "software_category_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "software_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "software_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 128,
  },
  "priority",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "level",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 32,
  },
  "type",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 0, size => 1 },
  "change_justification",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 128,
  },
  "comments",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "remote_user",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 32,
  },
  "record_time",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
  "status",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 32,
  },
  "vendor_managed",
  { data_type => "SMALLINT", default_value => 0, is_nullable => 0, size => 5 },
);
__PACKAGE__->set_primary_key("manufacturer_id", "software_category_id", "software_id");
__PACKAGE__->add_unique_constraint("IF2SOFTWARE", ["software_id"]);
__PACKAGE__->add_unique_constraint("IF5SOFTWARE", ["software_id", "status"]);
__PACKAGE__->add_unique_constraint("IF6SOFTWARE", ["software_name"]);
__PACKAGE__->add_unique_constraint(
  "IF4SOFTWARE",
  [
    "software_id",
    "manufacturer_id",
    "software_name",
    "level",
    "status",
  ],
);
__PACKAGE__->has_many(
  "bundles",
  "IBM::Schema::TRAILS::Bundle",
  { "foreign.software_id" => "self.software_id" },
);
__PACKAGE__->has_many(
  "bundle_softwares",
  "IBM::Schema::TRAILS::BundleSoftware",
  { "foreign.software_id" => "self.software_id" },
);
__PACKAGE__->has_many(
  "dorana_products",
  "IBM::Schema::TRAILS::DoranaProduct",
  { "foreign.software_id" => "self.software_id" },
);
__PACKAGE__->has_many(
  "installed_softwares",
  "IBM::Schema::TRAILS::InstalledSoftware",
  { "foreign.software_id" => "self.software_id" },
);
__PACKAGE__->has_many(
  "license_sw_maps",
  "IBM::Schema::TRAILS::LicenseSwMap",
  { "foreign.software_id" => "self.software_id" },
);
__PACKAGE__->has_many(
  "manual_queues",
  "IBM::Schema::TRAILS::ManualQueue",
  { "foreign.software_id" => "self.software_id" },
);
__PACKAGE__->has_many(
  "recon_softwares",
  "IBM::Schema::TRAILS::ReconSoftware",
  { "foreign.software_id" => "self.software_id" },
);
__PACKAGE__->has_many(
  "sa_products",
  "IBM::Schema::TRAILS::SaProduct",
  { "foreign.software_id" => "self.software_id" },
);
__PACKAGE__->belongs_to(
  "software_category",
  "IBM::Schema::TRAILS::SoftwareCategory",
  { software_category_id => "software_category_id" },
);
__PACKAGE__->belongs_to(
  "manufacturer",
  "IBM::Schema::TRAILS::Manufacturer",
  { manufacturer_id => "manufacturer_id" },
);
__PACKAGE__->has_many(
  "software_filters",
  "IBM::Schema::TRAILS::SoftwareFilter",
  { "foreign.software_id" => "self.software_id" },
);
__PACKAGE__->has_many(
  "software_filter_hs",
  "IBM::Schema::TRAILS::SoftwareFilterH",
  { "foreign.software_id" => "self.software_id" },
);
__PACKAGE__->has_many(
  "software_hs",
  "IBM::Schema::TRAILS::SoftwareH",
  { "foreign.software_id" => "self.software_id" },
);
__PACKAGE__->has_many(
  "software_signatures",
  "IBM::Schema::TRAILS::SoftwareSignature",
  { "foreign.software_id" => "self.software_id" },
);
__PACKAGE__->has_many(
  "software_signature_hs",
  "IBM::Schema::TRAILS::SoftwareSignatureH",
  { "foreign.software_id" => "self.software_id" },
);
__PACKAGE__->has_many(
  "vm_products",
  "IBM::Schema::TRAILS::VmProduct",
  { "foreign.software_id" => "self.software_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-06-02 17:23:21
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ua1X6eWaIqI6/Bv2CHM64w

# derive version directly from CVS revision.  As good a method as any.
our $VERSION  = '0.' . (split(/ /, q$Revision: 1.12 $))[1];
our $REVISION = '$Id: Software.pm,v 1.12 2009/06/02 22:04:31 cweyl Exp $';

# 99% of the time this is correct 
#__PACKAGE__->resultset_attributes({ where => { status => 'ACTIVE' } }); 

#use Moose;
#with 'IBM::SchemaRoles::TRAILS::Software';
#__PACKAGE__->meta->make_immutable(inline_constructor => 0);
#no Moose;

###########################################################################
# lazy accessors 

sub id         { shift->software_id         }
sub name       { shift->software_name       }
sub filters    { shift->software_filters    }
sub sigs       { shift->software_signatures }
sub signatures { shift->software_signatures }
sub category   { shift->software_category   }
sub history    { shift->software_hs         }

# utilizing joins...
sub mf_name           { shift->manufacturer->name }
sub manufacturer_name { shift->manufacturer->name }


1;

__END__

=head1 NAME

IBM::Schema::TRAILS::Software - trails software table

=head1 VERSION

$Id: Software.pm,v 1.12 2009/06/02 22:04:31 cweyl Exp $

=head1 DESCRIPTION

This is a DBIC class representing the software table.

=head1 QUERY RESTRICTIONS

Note that by default, "status = 'ACTIVE'" will be added to all resultsets.
This can be overridden by specifying "where => undef" in the attributes passed
to search().

=head1 AUTHOR

Chris Weyl <cweyl@us.ibm.com>

$Id: Software.pm,v 1.12 2009/06/02 22:04:31 cweyl Exp $

=head1 COPYRIGHT

Copyright 2008, IBM.

For Internal Use Only!

=cut

1;
