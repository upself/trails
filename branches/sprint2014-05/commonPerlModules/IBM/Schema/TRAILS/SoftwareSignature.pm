package IBM::Schema::TRAILS::SoftwareSignature;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("software_signature");
__PACKAGE__->add_columns(
  "software_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "software_signature_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "tcm_id",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 32,
  },
  "file_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 128,
  },
  "file_size",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "software_version",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 32,
  },
  "signature_source",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 32,
  },
  "checksum_quick",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 8 },
  "checksum_crc32",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 8 },
  "checksum_md5",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 32,
  },
  "end_of_support",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 1,
    size => 26,
  },
  "os_type",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 32,
  },
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
);
__PACKAGE__->set_primary_key("software_id", "software_signature_id");
__PACKAGE__->add_unique_constraint("IF2SWSIGNATURE", ["file_name", "file_size"]);
__PACKAGE__->add_unique_constraint("IF1SWSIGNATURE", ["software_signature_id"]);
__PACKAGE__->add_unique_constraint(
  "IF3SWSIGNATURE",
  ["software_signature_id", "software_version"],
);
__PACKAGE__->has_many(
  "installed_signatures",
  "IBM::Schema::TRAILS::InstalledSignature",
  { "foreign.software_signature_id" => "self.software_signature_id" },
);
__PACKAGE__->belongs_to(
  "software",
  "IBM::Schema::TRAILS::Software",
  { software_id => "software_id" },
);
__PACKAGE__->has_many(
  "software_signature_hs",
  "IBM::Schema::TRAILS::SoftwareSignatureH",
  { "foreign.software_signature_id" => "self.software_signature_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-06-02 17:23:21
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:5I6vTwg1lFc0jeXBPg23Kw

# derive version directly from CVS revision.  As good a method as any.
our $VERSION  = '0.' . (split(/ /, q$Revision: 1.11 $))[1];
our $REVISION = '$Id: SoftwareSignature.pm,v 1.11 2009/06/02 22:04:31 cweyl Exp $';

use Moose;

with 'IBM::SchemaRoles::TRAILS::SoftwareSignature';

__PACKAGE__->meta->make_immutable(inline_constructor => 0);

no Moose;

1;
