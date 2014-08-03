package IBM::Schema::BRAVO::SoftwareSignature;

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
__PACKAGE__->add_unique_constraint("USOFTWARESIGNATURE", ["software_signature_id"]);
__PACKAGE__->has_many(
  "installed_signatures",
  "IBM::Schema::BRAVO::InstalledSignature",
  { "foreign.software_signature_id" => "self.software_signature_id" },
);
__PACKAGE__->belongs_to(
  "software",
  "IBM::Schema::BRAVO::Software",
  { software_id => "software_id" },
);
__PACKAGE__->has_many(
  "software_signature_hs",
  "IBM::Schema::BRAVO::SoftwareSignatureH",
  { "foreign.software_signature_id" => "self.software_signature_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-10-06 12:30:40
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:VfNfDjtwLw2+nlA8iD+vOQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
