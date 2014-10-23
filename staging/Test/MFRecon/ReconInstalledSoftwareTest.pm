package Test::MFRecon::ReconInstalledSoftwareTest;

use strict;
use Test::More;
use base qw(Test::Class Test::Common::ConnectionManager);

use Recon::Delegate::ReconLicenseValidation;
use Recon::InstalledSoftware;
use BRAVO::OM::InstalledSoftware;

sub setup_initConnection : Test(setup){
    my $self = shift;
    $self->{bravoConnection}   = Database::Connection->new('trails');
}