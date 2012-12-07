#!/usr/bin/perl -w
# NOTE: this is NOT the manual recovery script. That script is manualRecovery.pl. Do not run 
# this script to only restore manual recon items.

use strict;
use Database::Connection;
use Base::Utils;

###Setup work
$| = 1;

my $serverList     = readServers('c:/temp/restoreServers.txt');
my $testConnection = Database::Connection->new('t2trails');
my $prodConnection = Database::Connection->new('trails');

print "ACCOUNT\tCUSTOMER NAME\tHOSTNAME\tSOFTWARE NAME\tPREVIOUS COMMENTS\tCURRENT COMMENTS\tACTION\n";

foreach my $account ( sort keys %{$serverList} ) {

    foreach my $name ( sort keys %{ $serverList->{$account} } ) {

        ###Get the alternate purchase from test database
        my $restoredInfo = getAlternatePurchaseInfo( $testConnection, $account, $name );

        foreach my $installedSoftwareId ( sort keys %{$restoredInfo} ) {
            my $customerName = $restoredInfo->{$installedSoftwareId}->{customerName};
            my $softwareName = $restoredInfo->{$installedSoftwareId}->{softwareName};
            my $comments     = $restoredInfo->{$installedSoftwareId}->{comments};

            print "$account\t$customerName\t$name\t$softwareName\t$comments\t";

            ###Get the alternate purchase from the prod database
            my ( $reconcileId, $prodComments ) =
              getProductionAlternatePurchase( $prodConnection, $installedSoftwareId );

            if ( defined $reconcileId ) {

                if ( !defined $prodComments || $prodComments ne $comments ) {

                    #updateProductionComment( $prodConnection, $reconcileId, $comments );
                    #updateProductionCommentHistory( $prodConnection, $installedSoftwareId, $comments );
                    print "Comment updated\n";
                }
                else {
                    print "No update required\n";
                }
            }
            else {
                print "\t";
                print "No current alternate purchase reconciliation\n";
            }
        }

        $restoredInfo = getAutoReconInfo( $testConnection, $account, $name );

        foreach my $installedSoftwareId ( sort keys %{$restoredInfo} ) {
            my $customerName = $restoredInfo->{$installedSoftwareId}->{customerName};
            my $softwareName = $restoredInfo->{$installedSoftwareId}->{softwareName};
            my $comments     = $restoredInfo->{$installedSoftwareId}->{comments};
            
            print "$account\t$customerName\t$name\t$softwareName\t$comments\t";

            ###Get the alternate purchase from the prod database
            my ( $reconcileId, $prodComments ) = getProductionManual( $prodConnection, $installedSoftwareId );

            if ( defined $reconcileId ) {

                #Recon::Delegate::ReconDelegate->breakReconcileById($prodConnection,$reconcileId);
                print "Reconcile Broken\n";
            }
            else {
                print "\t";
                print "No current manual reconciliation\n";
            }
        }
    }
}

sub updateProductionComment {
    my ( $connection, $reconcileId, $comments ) = @_;

    $connection->prepareSqlQuery( queryUpdateProductionComment() );
    my $sth = $connection->sql->{updateProuctionComment};
    $sth->execute( $comments, $reconcileId );
    $sth->finish;
}

sub queryUpdateProductionComment {
    my $query = '
        update
            reconcile r
        set
            r.comments = ?
        where
            r.id = ?
    ';

    return ( 'updateProductionComment', $query );
}

sub updateProductionCommentHistory {
    my ( $connection, $installedSoftwareId, $comments ) = @_;

    $connection->prepareSqlQuery( queryUpdateProductionCommentHistory() );
    my $sth = $connection->sql->{updateProuctionCommentHistory};
    $sth->execute( $comments, $installedSoftwareId );
    $sth->finish;
}

sub queryUpdateProductionCommentHistory {
    my $query = '
        update
            reconcile_h rh
        set
            rh.comments = ?
        where
            rh.installed_software_id = ?
    ';

    return ( 'updateProductionCommentHistory', $query );
}

sub getProductionManual {
    my ( $connection, $installedSoftwareId ) = @_;

    my %data;

    $connection->prepareSqlQueryAndFields( queryProductionManual() );
    my $sth = $connection->sql->{productionManual};
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @{ $connection->sql->{productionManualFields} } );
    $sth->execute($installedSoftwareId);
    $sth->fetchrow_arrayref;
    $sth->finish;

    return \%data;
}

sub queryProductionManual {
    my @fields = qw( reconcileId comments );
    my $query  = '
        select
            r.id
            ,r.comments
        from
            reconcile r
            ,reconcile_type rt
        where
            r.installed_software_id = ?
            and r.reconcile_type_id = rt.id
            and rt.is_manual = 1
    ';

    return ( 'productionManual', $query, \@fields );
}

sub getAutoReconInfo {
    my ( $connection, $account, $name ) = @_;

    my %data;

    $connection->prepareSqlQueryAndFields( queryAutoRecon() );
    my $sth = $connection->sql->{autoRecon};
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @{ $connection->sql->{autoReconFields} } );
    $sth->execute( $account, $name );
    while ( $sth->fetchrow_arrayref ) {
        $data{ $rec{installedSoftwareId} }{customerName} = $rec{customerName};
        $data{ $rec{installedSoftwareId} }{softwareName} = $rec{softwareName};
        $data{ $rec{installedSoftwareId} }{comments}     = $rec{comments};
    }
    $sth->finish;

    return \%data;
}

sub queryAutoRecon {
    my @fields = qw( customerName installedSoftwareId softwareName comments );    
    my $query  = '
        select
            c.customer_name
            ,is.id
            ,s.software_name
            ,r.comments            
        from
            customer c
            ,software_lpar sl
            ,installed_software is
            ,software s
            ,reconcile r
            ,reconcile_type rt
        where
            c.account_number = ?
            and sl.name = ?
            and c.customer_id = sl.customer_id
            and sl.id = is.software_lpar_id
            and is.software_id = s.software_id
            and is.id = r.installed_software_id
            and r.reconcile_type_id = rt.id
            and rt.is_manual = 0
    ';

    return ( 'autoRecon', $query, \@fields );
}

sub getProductionAlternatePurchase {
    my ( $connection, $installedSoftwareId ) = @_;

    my %data;

    $connection->prepareSqlQueryAndFields( queryProductionAlternatePurchase() );
    my $sth = $connection->sql->{productionAlternatePurchase};
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @{ $connection->sql->{productionAlternatePurchaseFields} } );
    $sth->execute($installedSoftwareId);
    $sth->fetchrow_arrayref;
    $sth->finish;

    return ( $rec{reconcileId}, $rec{comments} );
}

sub queryProductionAlternatePurchase {
    my @fields = qw( reconcileId comments );
    my $query  = '
        select
            r.id
            ,r.comments
        from
            reconcile r
        where
            r.installed_software_id = ?
            and r.reconcile_type_id = 3
    ';

    return ( 'productionAlternatePurchase', $query, \@fields );
}

sub getAlternatePurchaseInfo {
    my ( $connection, $account, $name ) = @_;
    my %data;

    $connection->prepareSqlQueryAndFields( queryAlternatePurchase() );
    my $sth = $connection->sql->{alternatePurchase};
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @{ $connection->sql->{alternatePurchaseFields} } );
    $sth->execute( $account, $name );
    while ( $sth->fetchrow_arrayref ) {
        $data{ $rec{installedSoftwareId} }{customerName} = $rec{customerName};
        $data{ $rec{installedSoftwareId} }{softwareName} = $rec{softwareName};
        $data{ $rec{installedSoftwareId} }{comments}     = $rec{comments};
    }
    $sth->finish;

    return \%data;
}

sub queryAlternatePurchase {
    my @fields = qw( customerName installedSoftwareId softwareName comments );
    my $query  = '
        select
            c.customer_name
            ,is.id
            ,s.software_name
            ,r.comments
        from
            customer c
            ,software_lpar sl
            ,installed_software is
            ,software s
            ,reconcile r
        where
            c.account_number = ?
            and sl.name = ?
            and c.customer_id = sl.customer_id
            and sl.id = is.software_lpar_id
            and is.software_id = s.software_id
            and is.id = r.installed_software_id
            and r.reconcile_type_id = 3
    ';

    return ( 'alternatePurchase', $query, \@fields );
}

sub readServers {
    my $file = shift;

    my %data;
    my $account;
    my $name;

    open( FILE, "<$file" ) or die $!;

    while (<FILE>) {
        my $account = trim( ( split( "\t", $_ ) )[0] );
        my $name    = trim( ( split( "\t", $_ ) )[1] );
        $data{$account}{$name} = 1;
    }
    close FILE or die "$file: $!";

    return \%data;
}
