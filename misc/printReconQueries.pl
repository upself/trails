#!/usr/bin/perl -w

my $tmpDir = '/tmp/query';
my $script = $tmpDir . '/torun.sh';
my $db     = 'trails3';

use strict;
use Base::Utils;
use Recon::Delegate::ReconDelegate;
use Recon::InstalledSoftware;
use Recon::License;
use Recon::Software;

die "Directory $tmpDir not found!!\n" unless -d "$tmpDir";
unlink "$script" if -e "$script";    

my $name;
my $sql;

generate( Recon::Delegate::ReconDelegate->queryDistinctCustomerIdsFromQueueFifo(0) );
generate( Recon::Delegate::ReconDelegate->queryDistinctSoftwareIdsFromQueueFifo(0) );
generate( Recon::Delegate::ReconDelegate->queryReconQueueByCustomerId(0) );
generate( Recon::Delegate::ReconDelegate->queryReconQueueBySoftwareId(0) );
generate( Recon::Delegate::ReconDelegate->queryReconQueueBySoftwareId(0) );
generate( ReconInstalledSoftwareDelegate->queryReconInstalledSoftwareBaseData(0) );
generate( ReconInstalledSoftwareDelegate->queryReconInstalledSoftwareExtendedData(0) );
generate( ReconInstalledSoftwareDelegate->queryValidateLicenseAllocation(0) );
generate( ReconInstalledSoftwareDelegate->queryFreePoolData(0) );
generate( ReconInstalledSoftwareDelegate->queryLicenseReconMapsByReconcileId(0) );
generate( ReconLicenseDelegate->queryLicenseAllocationsData(0) );
generate( ReconLicenseDelegate->queryPotentialInstalledSoftwaresHwSpecific(0) );
generate( ReconLicenseDelegate->queryPotentialInstalledSoftwares(0) );
generate( ReconSoftwareDelegate->queryInstalledSoftwareIdsBySoftwareId(0) );

exit 0;

sub generate {
    my ( $name, $sql ) = @_;
    my $advisFile = "$tmpDir/$name.advis.sql";
    my $advis     = $sql;
    $advis =~ s/from\s+/from eaadmin./g;
    $advis =~ s/join\s+/join eaadmin./g;
    open ADVIS, ">$advisFile";
    print ADVIS "$advis\n;\n";
    close ADVIS;
    my $explnFile = "$tmpDir/$name.expln.sql";
    my $expln     = $advis;
    $expln =~ s/\n/ /g;
    open EXPLN, ">$explnFile";
    print EXPLN "$expln\n";
    close EXPLN;
    open TORUN, ">>$script";
    print TORUN "db2expln -database $db -stmtfile $explnFile -o $explnFile.out\n";
    close TORUN;
}

#db2advis -d trails3 -i 1f.sql -m I -o 1f.out -a tap/mar30db2
#db2expln -database trails3 -stmtfile 1e-explain.sql -o 1e-explain.out
