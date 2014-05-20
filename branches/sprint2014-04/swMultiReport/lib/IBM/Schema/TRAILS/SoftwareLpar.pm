package IBM::Schema::TRAILS::SoftwareLpar;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("software_lpar");
__PACKAGE__->add_columns(
  "customer_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 255,
  },
  "model",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 128,
  },
  "bios_serial",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 128,
  },
  "processor_count",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "scantime",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 1,
    size => 26,
  },
  "acquisition_time",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 1,
    size => 26,
  },
  "remote_user",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 64,
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
  "object_id",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 128,
  },
  "computer_id",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 255,
  },
  "os_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 128,
  },
  "os_type",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 128,
  },
  "os_major_vers",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => 10,
  },
  "os_minor_vers",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => 10,
  },
  "os_sub_vers",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 32,
  },
  "os_inst_date",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 32,
  },
  "user_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "bios_manufacturer",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 64,
  },
  "bios_model",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 64,
  },
  "server_type",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 64,
  },
  "tech_img_id",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 64,
  },
  "ext_id",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 8 },
  "memory",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => 10,
  },
  "disk",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => 10,
  },
  "dedicated_processors",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => 10,
  },
  "total_processors",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => 10,
  },
  "shared_processors",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => 10,
  },
  "processor_type",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => 10,
  },
  "shared_proc_by_cores",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => 10,
  },
  "dedicated_proc_by_cores",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => 10,
  },
  "total_proc_by_cores",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => 10,
  },
  "alias",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 120,
  },
  "physical_total_kb",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => 10,
  },
  "virtual_memory",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => 10,
  },
  "physical_free_memory",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => 10,
  },
  "virtual_free_memory",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => 10,
  },
  "node_capacity",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 64,
  },
  "lpar_capacity",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 64,
  },
  "bios_date",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 1,
    size => 26,
  },
  "bios_serial_number",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 64,
  },
  "bios_unique_id",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 36,
  },
  "board_serial",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 64,
  },
  "case_serial",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 64,
  },
  "case_asset_tag",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 64,
  },
  "power_on_password",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 64,
  },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("IF1SOFTWARELPAR", ["name", "customer_id"]);
__PACKAGE__->add_unique_constraint("IF2SOFTWARELPAR", ["customer_id", "id"]);
__PACKAGE__->add_unique_constraint("IF6SOFTWARELPAR", ["customer_id", "scantime", "id"]);
__PACKAGE__->add_unique_constraint("IF7SOFTWARELPAR", ["customer_id", "id"]);
__PACKAGE__->add_unique_constraint("IF5SOFTWARELPAR", ["id", "customer_id", "scantime"]);
__PACKAGE__->add_unique_constraint(
  "IF8SOFTWARELPAR",
  ["status", "id", "customer_id", "name", "scantime"],
);
__PACKAGE__->add_unique_constraint("IF3SOFTWARELPAR", ["customer_id", "id", "status"]);
__PACKAGE__->add_unique_constraint(
  "IF9SOFTWARELPAR",
  ["customer_id", "id", "name", "processor_count"],
);
__PACKAGE__->has_many(
  "alert_expired_scans",
  "IBM::Schema::TRAILS::AlertExpiredScan",
  { "foreign.software_lpar_id" => "self.id" },
);
__PACKAGE__->has_many(
  "alert_sw_lpars",
  "IBM::Schema::TRAILS::AlertSwLpar",
  { "foreign.software_lpar_id" => "self.id" },
);
__PACKAGE__->has_many(
  "hw_sw_composites",
  "IBM::Schema::TRAILS::HwSwComposite",
  { "foreign.software_lpar_id" => "self.id" },
);
__PACKAGE__->has_many(
  "installed_softwares",
  "IBM::Schema::TRAILS::InstalledSoftware",
  { "foreign.software_lpar_id" => "self.id" },
);
__PACKAGE__->has_many(
  "recon_sw_lpars",
  "IBM::Schema::TRAILS::ReconSwLpar",
  { "foreign.software_lpar_id" => "self.id" },
);
__PACKAGE__->belongs_to(
  "customer",
  "IBM::Schema::TRAILS::Customer",
  { customer_id => "customer_id" },
);
__PACKAGE__->has_many(
  "software_lpar_adcs",
  "IBM::Schema::TRAILS::SoftwareLparAdc",
  { "foreign.software_lpar_id" => "self.id" },
);
__PACKAGE__->has_many(
  "software_lpar_effs",
  "IBM::Schema::TRAILS::SoftwareLparEff",
  { "foreign.software_lpar_id" => "self.id" },
);
__PACKAGE__->has_many(
  "software_lpar_hdisks",
  "IBM::Schema::TRAILS::SoftwareLparHdisk",
  { "foreign.software_lpar_id" => "self.id" },
);
__PACKAGE__->has_many(
  "software_lpar_ip_addresses",
  "IBM::Schema::TRAILS::SoftwareLparIpAddress",
  { "foreign.software_lpar_id" => "self.id" },
);
__PACKAGE__->has_many(
  "software_lpar_mem_mods",
  "IBM::Schema::TRAILS::SoftwareLparMemMod",
  { "foreign.software_lpar_id" => "self.id" },
);
__PACKAGE__->has_many(
  "software_lpar_processors",
  "IBM::Schema::TRAILS::SoftwareLparProcessor",
  { "foreign.software_lpar_id" => "self.id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-06-02 17:23:21
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:DdgV72ghDvooNIcdzmDL/A

# derive version directly from CVS revision.  As good a method as any.
our $VERSION  = '0.' . (split(/ /, q$Revision: 1.11 $))[1];
our $REVISION = '$Id: SoftwareLpar.pm,v 1.11 2009/06/02 22:04:31 cweyl Exp $';
     
###########################################################################
# lazy cheats

sub nodename          { shift->name                      }
sub software_lpar_id  { shift->id                        }
# OK as there's a unique constraint on sw_lpar_id in sw_lpar_eff
sub software_lpar_eff { shift->software_lpar_effs->first }

###########################################################################
# extended relationships 

# This as an extended relationship is a little bogus, since the intermediate
# table has unique indices on all columns (save "match_method")
__PACKAGE__->many_to_many(
    'hardware_lpars',
    hw_sw_composites => 'hardware_lpar',
);

sub hardware_lpar { shift->hardware_lpars->first }

# view relationship
__PACKAGE__->has_many(
  'lpar_bank_accounts',
  'IBM::Schema::TRAILS::VLparBankAccount',
  { 'foreign.software_lpar_id' => 'self.id' },
);

__PACKAGE__->many_to_many(
    'bank_accounts',
    lpar_bank_accounts => 'bank_account',
);

sub all_bank_account_names 
    { join q{,}, shift->bank_accounts->get_column('name')->all }

__PACKAGE__->has_one(
    'v_software_lpar_processors',
    'IBM::Schema::TRAILS::VSoftwareLparProcessor',
    { 'foreign.id' => 'self.id' },
);
      

###########################################################################
# Bring in our roles 

use Moose;

with 'IBM::SchemaRoles::TRAILS::SoftwareLparOsBits';

__PACKAGE__->meta->make_immutable(inline_constructor => 0);
no Moose;

1;
