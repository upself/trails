package IBM::Schema::BRAVO::Customer;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("customer");
__PACKAGE__->add_columns(
  "customer_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "customer_type_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "pod_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "industry_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "account_number",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "customer_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 64,
  },
  "contact_dpe_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 1, size => 19 },
  "contact_fa_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 1, size => 19 },
  "contact_hw_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 1, size => 19 },
  "contact_sw_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 1, size => 19 },
  "contact_focal_asset_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 1, size => 19 },
  "contact_transition_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 1, size => 19 },
  "asset_tools_billing_code",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 64,
  },
  "status",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 32,
  },
  "hw_interlock",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 3 },
  "sw_interlock",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 3 },
  "inv_interlock",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 3 },
  "sw_license_mgmt",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 3 },
  "sw_support",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 3 },
  "hw_support",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 3 },
  "transition_status",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 16,
  },
  "transition_exit_date",
  { data_type => "DATE", default_value => undef, is_nullable => 1, size => 10 },
  "country_code_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 1, size => 19 },
  "scan_validity",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => 10,
  },
  "sw_tracking",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 3 },
  "sw_compliance_mgmt",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 3 },
  "sw_financial_responsibility",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 16,
  },
  "sw_financial_mgmt",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 3 },
);
__PACKAGE__->set_primary_key("customer_id");
__PACKAGE__->has_many(
  "bank_account_inclusions",
  "IBM::Schema::BRAVO::BankAccountInclusion",
  { "foreign.customer_id" => "self.customer_id" },
);
__PACKAGE__->has_many(
  "contact_accounts",
  "IBM::Schema::BRAVO::ContactAccount",
  { "foreign.customer_id" => "self.customer_id" },
);
__PACKAGE__->belongs_to(
  "contact_fa",
  "IBM::Schema::BRAVO::Contact",
  { contact_id => "contact_fa_id" },
);
__PACKAGE__->belongs_to(
  "contact_dpe",
  "IBM::Schema::BRAVO::Contact",
  { contact_id => "contact_dpe_id" },
);
__PACKAGE__->belongs_to(
  "contact_focal_asset",
  "IBM::Schema::BRAVO::Contact",
  { contact_id => "contact_focal_asset_id" },
);
__PACKAGE__->belongs_to(
  "industry",
  "IBM::Schema::BRAVO::Industry",
  { industry_id => "industry_id" },
);
__PACKAGE__->belongs_to(
  "contact_hw",
  "IBM::Schema::BRAVO::Contact",
  { contact_id => "contact_hw_id" },
);
__PACKAGE__->belongs_to(
  "contact_sw",
  "IBM::Schema::BRAVO::Contact",
  { contact_id => "contact_sw_id" },
);
__PACKAGE__->belongs_to(
  "country_code",
  "IBM::Schema::BRAVO::CountryCode",
  { id => "country_code_id" },
);
__PACKAGE__->belongs_to(
  "contact_transition",
  "IBM::Schema::BRAVO::Contact",
  { contact_id => "contact_transition_id" },
);
__PACKAGE__->belongs_to("pod", "IBM::Schema::BRAVO::Pod", { pod_id => "pod_id" });
__PACKAGE__->belongs_to(
  "customer_type",
  "IBM::Schema::BRAVO::CustomerType",
  { customer_type_id => "customer_type_id" },
);
__PACKAGE__->has_many(
  "customer_bluegroups",
  "IBM::Schema::BRAVO::CustomerBluegroup",
  { "foreign.customer_id" => "self.customer_id" },
);
__PACKAGE__->has_many(
  "customer_numbers",
  "IBM::Schema::BRAVO::CustomerNumber",
  { "foreign.customer_id" => "self.customer_id" },
);
__PACKAGE__->has_many(
  "hardware_lpars",
  "IBM::Schema::BRAVO::HardwareLpar",
  { "foreign.customer_id" => "self.customer_id" },
);
__PACKAGE__->has_many(
  "licenses",
  "IBM::Schema::BRAVO::License",
  { "foreign.customer_id" => "self.customer_id" },
);
__PACKAGE__->has_many(
  "outsource_profiles",
  "IBM::Schema::BRAVO::OutsourceProfile",
  { "foreign.customer_id" => "self.customer_id" },
);
__PACKAGE__->has_many(
  "recon_customers",
  "IBM::Schema::BRAVO::ReconCustomer",
  { "foreign.customer_id" => "self.customer_id" },
);
__PACKAGE__->has_many(
  "recon_customer_logs",
  "IBM::Schema::BRAVO::ReconCustomerLog",
  { "foreign.customer_id" => "self.customer_id" },
);
__PACKAGE__->has_many(
  "recon_hardwares",
  "IBM::Schema::BRAVO::ReconHardware",
  { "foreign.customer_id" => "self.customer_id" },
);
__PACKAGE__->has_many(
  "recon_hs_composites",
  "IBM::Schema::BRAVO::ReconHsComposite",
  { "foreign.customer_id" => "self.customer_id" },
);
__PACKAGE__->has_many(
  "recon_hw_lpars",
  "IBM::Schema::BRAVO::ReconHwLpar",
  { "foreign.customer_id" => "self.customer_id" },
);
__PACKAGE__->has_many(
  "recon_installed_sws",
  "IBM::Schema::BRAVO::ReconInstalledSw",
  { "foreign.customer_id" => "self.customer_id" },
);
__PACKAGE__->has_many(
  "recon_licenses",
  "IBM::Schema::BRAVO::ReconLicense",
  { "foreign.customer_id" => "self.customer_id" },
);
__PACKAGE__->has_many(
  "recon_sw_lpars",
  "IBM::Schema::BRAVO::ReconSwLpar",
  { "foreign.customer_id" => "self.customer_id" },
);
__PACKAGE__->has_many(
  "software_lpars",
  "IBM::Schema::BRAVO::SoftwareLpar",
  { "foreign.customer_id" => "self.customer_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-10-06 12:30:40
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:TVO3gZaCrOoL3Oy84TseTg

# derive version directly from CVS revision.  As good a method as any.
our $VERSION  = (split(/ /, q$Revision: 1.2 $))[1];
our $REVISION = '$Id: Customer.pm,v 1.2 2008/10/17 20:32:55 cweyl Exp $';


###########################################################################
# lazy enablement 

sub id                 { shift->customer_id(@_)                           }
sub customer_type_name { shift->customer_type->customer_type_name(@_)     }
sub pod_name           { shift->pod->pod_name(@_)                         }
sub country_name       { shift->country_code->name(@_)                    }
sub region_name        { shift->country_code->region->name(@_)            }
sub geo_name           { shift->country_code->region->geography->name(@_) }

###########################################################################
# common searches 

## FIXME!  these are WRONG, MUST to be handled by custom resultsets, not in
## here!

# fetch a record by account_number...
sub by_account_number { 
    my $self           = shift @_;
    my $account_number = shift @_;
    
    return $self->search(
        { account_number => $account_number }, 
        { order_by => 'id DESC' }
    )->slice(0,1);
}

sub emea_accounts {
    my $self = shift @_;

    return $self->search(
        { status => 'ACTIVE', 'geography.name' => 'EMEA'        },
        { join => { country_code => { region => 'geography' } } },
    );
}

1;

__END__

#############################################################################
#    This is the documentation AND manpage of this module.  Document it     #
#                       it well, and wisely!                                #
#############################################################################


=head1 NAME
 
IBM::Schema::BRAVO::Customer - Customer resultset (eaadmin.customer)
 
 
=head1 SYNOPSIS
 
    use IBM::Schema::TRAILS3;
 
    my $trails3 = IBM::Schema::TRAILS3->easy_connect();
 
    # get our resultset...
    my $rs = $trails3->resultset('Customer');

    # profit!
     
  
=head1 DESCRIPTION
 
This resultset class defines our interactions with the Customer table in the
TRAILS3 database, as well as this table's relationship with other tables.
There are often convience functions defined here, either shorter accessors or
methods that execute commonly run searches, for instance.
 
This class is NOT meant to be used directly; rather, it should be returned as
a call to the resultset() function of an IBM::Schema::TRAILS3 object.
 
 
=head1 SUBROUTINES/METHODS 


=head2 Row Methods

The convenience methods id(), pod_name(), customer_type_name(), geo_name(),
region_name(), and country_name() all do exactly what you think they do.

=head2 ResultSet operations (searches, etc)

=head3 by_account_number($account_number)

Looks up and returns the row corresponding to customer.account_number.  undef
returned if not found.

=head1 TABLE RELATIONSHIPS
 
We could use a little documentation here :)
 
 
=head1 AUTHOR
 
Chris Weyl  <cweyl@us.ibm.com>
 
 
=head1 LICENCE AND COPYRIGHT
 
Copyright (c) 2007, 2008 IBM. All rights reserved.
 
This is for IBM Internal Use ONLY.
 

