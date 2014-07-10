package IBM::Schema::TRAILS::VInstalledSoftware;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("v_installed_software");
__PACKAGE__->add_columns(
  "software_lpar_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "customer_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "nodename",
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
  "acquisition_time",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 1,
    size => 26,
  },
  "software_lpar_status",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 32,
  },
  "installed_software_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "software_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "users",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "inst_processor_count",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "authenticated",
  {
    data_type => "SMALLINT",
    default_value => undef,
    is_nullable => 0,
    size => 5,
  },
  "inst_status",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 32,
  },
  "discrepancy_type_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "installed_product_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "product_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "bank_account_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "version",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 64,
  },
  "product_type",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 0, size => 9 },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-06-02 17:23:21
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:dgqQDa0+YYavfXu7hfUNIg

# FIXME implement this at some point
#__PACKAGE__->resultset_attributes({ where => { status => 'ACTIVE' } }); 

use DBIx::Class::ResultClass::HashRefInflator;

# debugging
use Smart::Comments '###', '####';

# relationships... not auto-found.  We are a view, after all! :)

__PACKAGE__->belongs_to(
    'software_lpar',
    'IBM::Schema::TRAILS::SoftwareLpar',
    { "foreign.id" => "self.software_lpar_id" },
);

__PACKAGE__->belongs_to(
    'software_lpar_eff',
    'IBM::Schema::TRAILS::SoftwareLparEff',
    { 'foreign.software_lpar_id' => 'self.software_lpar_id' },
    { join_type => 'left'                                   },
);

__PACKAGE__->belongs_to(
    'customer',
    'IBM::Schema::TRAILS::Customer',
    { "foreign.customer_id" => "self.customer_id" },
);

__PACKAGE__->belongs_to(
    'installed_software',
    'IBM::Schema::TRAILS::InstalledSoftware',
    { "foreign.id" => "self.installed_software_id" },
);

__PACKAGE__->belongs_to(
    'software',
    'IBM::Schema::TRAILS::Software',
    { "foreign.software_id" => "self.software_id" },
    { prefetch => [ 'software_category' ]         },
);

__PACKAGE__->belongs_to(
    'bank_account',
    'IBM::Schema::TRAILS::BankAccount',
    { "foreign.id" => "self.bank_account_id" },
);

__PACKAGE__->has_one(
    'v_software_lpar_processors',
    'IBM::Schema::TRAILS::VSoftwareLparProcessor',
    { 'foreign.id' => 'self.software_lpar_id' },
);
      
sub product_count_eff_proc_count {
    my $self = shift @_;

    my $rs = $self
        ->result_source
        ->schema
        ->resultset('VInstalledSoftware')
        #->result_class('DBIx::Class::ResultSet::HashReinflator')
        ->search(
            { 
                'me.customer_id' => $self->customer_id, 
                'me.software_id' => $self->software_id,
                'me.status'      => 'ACTIVE',
                'me.software_lpar_status' => 'ACTIVE',
                'software.status' => 'ACTIVE',
                #'software_lpar_eff.status' => 'ACTIVE',
            },
            {
                #distinct => 1,
                join => [ qw{ software software_lpar_eff } ],
                columns => [ qw{ 
                    software_lpar_eff.status 
                    software_lpar_eff.processor_count 
                    me.processor_count
                } ],
            }
        );


    # NOTE I would NOT, repeat NOT normally recommend this
    my $proc_count = 0;
    my $cursor     = $rs->cursor;
    while (my @val = $cursor->next) {

        $proc_count += $val[0] ne 'ACTIVE' || not defined $val[1] 
                     ? $val[2]  # sw_lpar_eff.processor_count
                     : $val[1]  # me.processor_count
                     ;
    }
    
    
    return $proc_count;
}

# NOTE, we should moosify this if we need to call it more than once on a row
sub version_rollup {
    my $self = shift @_;

    my @versions = $self
        ->result_source
        ->schema
        ->resultset('VInstalledSoftware')
        ->search(
            { 
                customer_id      => $self->customer_id,
                software_lpar_id => $self->software_lpar_id,
                software_id      => $self->software_id,
            },
            { distinct => 1, columns  => [ 'version' ] },
        )
        ->get_column('version')
        ->all
        ;

    # now, sort!
    return $self->_max_sw_version(@versions);
}

#-----------------------------------------------------------------------------

# AMT-TI80422-76416

#
#		Toralf Foerster
#		Hamburg
#		Germany
#

#-----------------------------------------------------------------------------
#
#	input: a list of version strings ('version.release.modification.fixpack')
#	output:a string clobbered the strings into a readable format
#
sub _max_sw_version (@)	{
    my $self     = shift @_;
	my @aStrings = @_;

	return "" unless (scalar @aStrings);

	my %hString = ();
	foreach my $String (@aStrings)	{
		my ($Version, $Release) = split (/\./, $String . ".");
		return "*" if ($Version eq "*");				# rule 1

		$hString{$Version}->{$Release}->{$String} = 1;
	}

	my @aResult = ();
	foreach my $Version (keys %hString)	{
		my @aRelease = keys %{$hString{$Version}};

		next unless (scalar @aRelease == 1);
		my $Release = $aRelease[0];
		if (scalar keys %{$hString{$Version}->{$Release}} == 1)	{	# rule 2
			push (@aResult, keys %{$hString{$Version}->{$Release}});
			delete ($hString{$Version});
		}
	}

	foreach my $Version (sort { $a <=> $b } keys %hString)	{		# rule 3
		my @aRelease = keys %{$hString{$Version}};

		push (@aResult,	(scalar @aRelease > 1) ? "$Version.*" : "$Version.$aRelease[0].*");
	}

	return join (",", sort @aResult);
}

###########################################################################
# Bring in our roles 

use Moose;

with 'IBM::SchemaRoles::TRAILS::SoftwareLparOsBits';

__PACKAGE__->meta->make_immutable(inline_constructor => 0);
no Moose;

1;
