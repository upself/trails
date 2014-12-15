#!/usr/bin/perl -w

use strict;
use Base::Utils;
use Sigbank::Delegate::BankAccountDelegate;
use TRAILS::Delegate::MachineTypeDelegate;    
use CNDB::Delegate::CNDBDelegate;

###Set the logging level
logging_level("error");

dlog('Acquiring customer number map');
# Edit sprint9 2014 - Ondrej
my ($customerNumberMap, $accountNumberMap) = CNDB::Delegate::CNDBDelegate->getCustomerNumberMap;
dlog('Customer number map acquired');

dlog('Acquiring machine type map');
my $machineTypeMap = MachineTypeDelegate->getMachineTypeMap;
dlog('Machine type map acquired');

dlog('Acquiring atp bank account');
my $atpBankAccount = BankAccountDelegate->getBankAccountByName('ATP');
dlog('ATP bank account acquired');

dlog('Acquiring atp connection');
my $atpConnection = Database::Connection->new($atpBankAccount);
dlog('ATP connection acquired');

dlog('Preparing atp data query');
$atpConnection->prepareSqlQueryAndFields( queryATPData() );
dlog('ATP data query prepared');

dlog('Acquiring statement handle');
my $sth = $atpConnection->sql->{atpData};
dlog('Statement handle acquired');

dlog('Binding columns');
my %rec;
$sth->bind_columns( map { \$rec{$_} } @{ $atpConnection->sql->{atpDataFields} } );
dlog('Columns binded');

dlog('Executing query');
$sth->execute();

###Hash of unique lparKeys to identify dups.
my %lparKeys = ();

while ( $sth->fetchrow_arrayref ) {

    ###Cleaning the values
    cleanValues( \%rec );
    upperValues( \%rec );

    ###We can't have a blank serial
    next if ( ( !defined $rec{serial} ) || ( $rec{serial} eq '' ) );

    ###We can't have a blank country
    next if ( ( !defined $rec{country} ) || ( $rec{country} eq '' ) );

    ###We don't want stuff thats not in our customer number map
    next if ( !defined $customerNumberMap->{ $rec{customerNumber} } );

    ###We don't want stuff thats not in our machine type map
    next if ( !defined $machineTypeMap->{ $rec{machineType} } );

    ###Continue if the lpar name is not defined
    next if ( ( !defined $rec{name} ) || ( $rec{name} eq '' ) );

    ###Don't process if the name has a space in it
    next if ( $rec{name} =~ / / );

    ###Get the lparKey.
    my $lparKey = $rec{name} . '|' . $customerNumberMap->{ $rec{customerNumber} };

    ###Get the record string.
    my $recString =
        $rec{machineType} . '|'
      . $rec{serial} . '|'
      . $rec{customerNumber} . '|'
      . $customerNumberMap->{ $rec{customerNumber} } . '|'
      . $rec{owner} . '|'
      . $rec{hardwareStatus} . '|'
      . $rec{country} . '|'
      . $rec{name} . '|'
      . $rec{effProc} . '|'
      . $rec{status} . '|'
      . $rec{hwDate} . '|'
      . $rec{lparDate};

    ###Flag duplicate if lparKey is already in lparKeys hash.
    my $duplicate = ( exists $lparKeys{$lparKey} ) ? 1 : 0;

    ###Add lparKey and record string to the hash.
    push @{ $lparKeys{$lparKey} }, $recString;

    ###Print if duplicate.
    if ( $duplicate == 1 ) {

        print "### Duplicate Lpar Records:\n";
        foreach my $s ( @{ $lparKeys{$lparKey} } ) {
            print "$s\n";
        }
    }
}

dlog('Complete executing query');

dlog('Closing statement handle');
$sth->finish;
dlog('Statement handle closed');

dlog('Disconnecting from bank account');
$atpConnection->disconnect;
dlog('Disconnected from bank account');

exit 0;

sub queryATPData {
    my @fields = (
        qw(
          machineType
          serial
          customerNumber
          owner
          hardwareStatus
          country
          name
          effProc
          status
          hwDate
          lparDate)
    );
    my $query = '
        select
            machtype
            ,serial
            ,primbill
            ,type
            ,hwstatus
            ,isocntry
            ,ltrim(rtrim(lpar))
            ,effproc
            ,case when( hwstatus = \'HWCOUNT\'
                or hwstatus = \'ACTIVE\'
                or hwstatus is null
                or hwstatus = \'\' ) then \'ACTIVE\'
            else \'INACTIVE\'
            end
            ,lastupdt
            ,case when( lparupdt is null
                or lparupdt = \'\' ) then \'1970-01-01\'
            else date(substr(lparupdt,1,4)|| \'-\' || substr(lparupdt,5,2) || \'-\' || substr(lparupdt,7,2))
            end as lparDate
        from
            atpprod.bravo
        with ur
    ';
    dlog("queryATPData=$query");
    return ( 'atpData', $query, \@fields );
}
