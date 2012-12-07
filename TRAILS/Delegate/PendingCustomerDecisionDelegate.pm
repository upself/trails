package TRAILS::Delegate::PendingCustomerDecisionDelegate;

use Base::Utils;
use Database::Connection;

sub getByGeoRegionCountryAccountData {
    my ( $self, $connection ) = @_;
    my @pendingCustomerDecisionList;

    dlog('In PendingCustomerDecisionDelegate->getByGeoRegionCountryAccountData method');

    ### Prepare the query
    $connection->prepareSqlQuery( $self->queryByGeoRegionCountryAccountData );

    ### Define the fields
    my @fields = (
        qw(geo region country accountNumber customerName customerTypeName timeline1 timeline2 timeline3 timeline4
            timeline5 timeline6)
    );

    ### Get the statement handle
    my $sth = $connection->sql->{byGeoRegionCountryAccountData};

    ### Bind the columns
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @fields );

    ###Execute the query
    $sth->execute();
    while ( $sth->fetchrow_arrayref ) {

        logRec( 'dlog', \%rec );
        my $key;
        my $value;
        my %myRec;
        while ( ( $key, $value ) = each %rec ) {
            $myRec{$key} = $value;
        }
        push @pendingCustomerDecisionList, \%myRec;

    }

    ### Close the statement handle
    $sth->finish;

    ### Return the lists
    return ( \@pendingCustomerDecisionList );
}

sub getByGeoRegionCountryData {
    my ( $self, $connection ) = @_;
    my @pendingCustomerDecisionList;

    dlog('In PendingCustomerDecisionDelegate->getByGeoRegionCountryData method');

    ### Prepare the query
    $connection->prepareSqlQuery( $self->queryByGeoRegionCountryData );

    ### Define the fields
    my @fields = (
        qw(geo region country timeline1 timeline2 timeline3 timeline4
            timeline5 timeline6)
    );

    ### Get the statement handle
    my $sth = $connection->sql->{byGeoRegionCountryData};

    ### Bind the columns
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @fields );

    ###Execute the query
    $sth->execute();
    while ( $sth->fetchrow_arrayref ) {

        logRec( 'dlog', \%rec );
        my $key;
        my $value;
        my %myRec;
        while ( ( $key, $value ) = each %rec ) {
            $myRec{$key} = $value;
        }
        push @pendingCustomerDecisionList, \%myRec;

    }

    ### Close the statement handle
    $sth->finish;

    ### Return the lists
    return ( \@pendingCustomerDecisionList );
}

sub queryByGeoRegionCountryAccountData {
    my $query = '
        SELECT G.Name AS G_Name, R1.Name AS R1_Name, CC.Name AS CC_Name, C.Account_Number, C.Customer_Name,
            CT.Customer_Type_Name,
            SUM(CASE WHEN DAYS(CURRENT TIMESTAMP) - DAYS(AUS.Creation_Time) < 46 THEN 1 ELSE 0 END),
            SUM(CASE WHEN DAYS(CURRENT TIMESTAMP) - DAYS(AUS.Creation_Time) BETWEEN 46 AND 90 THEN 1 ELSE 0 END),
            SUM(CASE WHEN DAYS(CURRENT TIMESTAMP) - DAYS(AUS.Creation_Time) BETWEEN 91 AND 120 THEN 1 ELSE 0 END),
            SUM(CASE WHEN DAYS(CURRENT TIMESTAMP) - DAYS(AUS.Creation_Time) BETWEEN 121 AND 180 THEN 1 ELSE 0 END),
            SUM(CASE WHEN DAYS(CURRENT TIMESTAMP) - DAYS(AUS.Creation_Time) BETWEEN 181 AND 365 THEN 1 ELSE 0 END),
            SUM(CASE WHEN DAYS(CURRENT TIMESTAMP) - DAYS(AUS.Creation_Time) > 365 THEN 1 ELSE 0 END)
        FROM EAADMIN.Geography G,
            EAADMIN.Region R1,
            EAADMIN.Country_Code CC,
            EAADMIN.Customer C,
            EAADMIN.Customer_Type CT,
            EAADMIN.Alert_Unlicensed_Sw AUS,
            EAADMIN.Installed_Software IS,
            EAADMIN.Software_Lpar SL,
            EAADMIN.Reconcile R2
        WHERE G.Id = R1.Geography_Id
        AND R1.Id = CC.Region_Id
        AND CC.Id = C.Country_Code_Id
        AND CT.Customer_Type_Id = C.Customer_Type_Id
        AND AUS.Open = 0
        AND AUS.Installed_Software_Id = IS.Id
        AND SL.Id = IS.Software_Lpar_Id
        AND SL.Customer_Id = C.Customer_Id
        AND R2.Installed_Software_Id = IS.Id
        AND R2.Reconcile_Type_Id = 14
        GROUP BY G.Name, R1.Name, CC.Name, C.Account_Number, C.Customer_Name, CT.Customer_Type_Name
        ORDER BY G.Name, R1.Name, CC.Name, C.Account_Number';

    return ( 'byGeoRegionCountryAccountData', $query );
}

sub queryByGeoRegionCountryData {
    my $query = '
        SELECT G.Name AS G_Name, R1.Name AS R1_Name, CC.Name AS CC_Name,
            SUM(CASE WHEN DAYS(CURRENT TIMESTAMP) - DAYS(AUS.Creation_Time) < 46 THEN 1 ELSE 0 END),
            SUM(CASE WHEN DAYS(CURRENT TIMESTAMP) - DAYS(AUS.Creation_Time) BETWEEN 46 AND 90 THEN 1 ELSE 0 END),
            SUM(CASE WHEN DAYS(CURRENT TIMESTAMP) - DAYS(AUS.Creation_Time) BETWEEN 91 AND 120 THEN 1 ELSE 0 END),
            SUM(CASE WHEN DAYS(CURRENT TIMESTAMP) - DAYS(AUS.Creation_Time) BETWEEN 121 AND 180 THEN 1 ELSE 0 END),
            SUM(CASE WHEN DAYS(CURRENT TIMESTAMP) - DAYS(AUS.Creation_Time) BETWEEN 181 AND 365 THEN 1 ELSE 0 END),
            SUM(CASE WHEN DAYS(CURRENT TIMESTAMP) - DAYS(AUS.Creation_Time) > 365 THEN 1 ELSE 0 END)
        FROM EAADMIN.Geography G,
            EAADMIN.Region R1,
            EAADMIN.Country_Code CC,
            EAADMIN.Customer C,
            EAADMIN.Alert_Unlicensed_Sw AUS,
            EAADMIN.Installed_Software IS,
            EAADMIN.Software_Lpar SL,
            EAADMIN.Reconcile R2
        WHERE G.Id = R1.Geography_Id
        AND R1.Id = CC.Region_Id
        AND CC.Id = C.Country_Code_Id
        AND AUS.Open = 0
        AND AUS.Installed_Software_Id = IS.Id
        AND SL.Id = IS.Software_Lpar_Id
        AND SL.Customer_Id = C.Customer_Id
        AND R2.Installed_Software_Id = IS.Id
        AND R2.Reconcile_Type_Id = 14
        GROUP BY G.Name, R1.Name, CC.Name
        ORDER BY G.Name, R1.Name, CC.Name';

    return ( 'byGeoRegionCountryData', $query );
}

1;
