package IBM::Schema::BRAVO::Software;

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
__PACKAGE__->add_unique_constraint("USOFTWARE", ["software_id"]);
__PACKAGE__->has_many(
  "bundles",
  "IBM::Schema::BRAVO::Bundle",
  { "foreign.software_id" => "self.software_id" },
);
__PACKAGE__->has_many(
  "bundle_softwares",
  "IBM::Schema::BRAVO::BundleSoftware",
  { "foreign.software_id" => "self.software_id" },
);
__PACKAGE__->has_many(
  "dorana_products",
  "IBM::Schema::BRAVO::DoranaProduct",
  { "foreign.software_id" => "self.software_id" },
);
__PACKAGE__->has_many(
  "installed_softwares",
  "IBM::Schema::BRAVO::InstalledSoftware",
  { "foreign.software_id" => "self.software_id" },
);
__PACKAGE__->has_many(
  "license_sw_maps",
  "IBM::Schema::BRAVO::LicenseSwMap",
  { "foreign.software_id" => "self.software_id" },
);
__PACKAGE__->has_many(
  "recon_softwares",
  "IBM::Schema::BRAVO::ReconSoftware",
  { "foreign.software_id" => "self.software_id" },
);
__PACKAGE__->has_many(
  "sa_products",
  "IBM::Schema::BRAVO::SaProduct",
  { "foreign.software_id" => "self.software_id" },
);
__PACKAGE__->belongs_to(
  "software_category",
  "IBM::Schema::BRAVO::SoftwareCategory",
  { software_category_id => "software_category_id" },
);
__PACKAGE__->belongs_to(
  "manufacturer",
  "IBM::Schema::BRAVO::Manufacturer",
  { manufacturer_id => "manufacturer_id" },
);
__PACKAGE__->has_many(
  "software_filters",
  "IBM::Schema::BRAVO::SoftwareFilter",
  { "foreign.software_id" => "self.software_id" },
);
__PACKAGE__->has_many(
  "software_filter_hs",
  "IBM::Schema::BRAVO::SoftwareFilterH",
  { "foreign.software_id" => "self.software_id" },
);
__PACKAGE__->has_many(
  "software_hs",
  "IBM::Schema::BRAVO::SoftwareH",
  { "foreign.software_id" => "self.software_id" },
);
__PACKAGE__->has_many(
  "software_signatures",
  "IBM::Schema::BRAVO::SoftwareSignature",
  { "foreign.software_id" => "self.software_id" },
);
__PACKAGE__->has_many(
  "software_signature_hs",
  "IBM::Schema::BRAVO::SoftwareSignatureH",
  { "foreign.software_id" => "self.software_id" },
);
__PACKAGE__->has_many(
  "vm_products",
  "IBM::Schema::BRAVO::VmProduct",
  { "foreign.software_id" => "self.software_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-10-06 12:30:40
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Q351yVDbu3OAI8R5ovsDIg

# derive version directly from CVS revision.  As good a method as any.
our $VERSION  = (split(/ /, q$Revision: 1.2 $))[1];
our $REVISION = '$Id: Software.pm,v 1.2 2008/10/17 20:28:27 cweyl Exp $';

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
sub mf_name    { shift->manufacturer->name  }


1;
