#!/usr/bin/perl -w

use strict;
use Base::Utils;
use Staging::Delegate::StagingDelegate;

my $name;
my $sql;

print_sql( Staging::Delegate::StagingDelegate->queryLicenseData( 0, 1 ) );
print_sql( Staging::Delegate::StagingDelegate->queryHardwareData( 0, 1 ) );
print_sql( Staging::Delegate::StagingDelegate->querySoftwareLparIds( 0, 1 ) );
print_sql( Staging::Delegate::StagingDelegate->querySoftwareLparDataByMinMaxIds( 0, 1 ) );

exit 0;

sub print_sql {
	my ( $name, $sql ) = @_;
	$sql =~ s/from\s+/from eaadmin./g;
	$sql =~ s/join\s+/join eaadmin./g;
	print "-- $name\n";
	print "$sql\n;\n";	
}
