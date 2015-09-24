package Sigbank::Delegate::BankAccountDelegate;

use strict;
use Base::Utils;
use Sigbank::OM::BankAccount;
use Database::Connection;    

sub updateBankAccount {
    my ( $self, $bankAccount ) = @_;

    dlog('Start updateBankAccount method');

    ###Get the trails connection
    my $trailsConnection = Database::Connection->new('trails');

    $bankAccount->comments( substr( $bankAccount->comments, 0, 254 ) );

    $bankAccount->save($trailsConnection);

    ###Close the connection
    $trailsConnection->disconnect;

    dlog('End updateBankAccount method');
}

sub getBankAccountByName {
    my ( $self, $name ) = @_;

    dlog('Start getBankAccountByName method');
    dlog("name=$name");

    ###Get the trails connection
    my $trailsConnection = Database::Connection->new('trails');

    ###Prepare the query
    $trailsConnection->prepareSqlQueryAndFields( $self->queryBankAccountByName() );

    ###Get the statement handle
    my $sth = $trailsConnection->sql->{bankAccountByName};

    dlog('Binding columns');
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @{ $trailsConnection->sql->{bankAccountByNameFields} } );
    dlog('Columns binded');

    ###Execute the query
    dlog("Exectuing query");
    $sth->execute($name);
    $sth->fetchrow_arrayref;
    $sth->finish;

    ###Create a new bank account object and set
    my $ba = new Sigbank::OM::BankAccount();
    $ba->id( $rec{id} );
    $ba->name( $rec{name} );
    $ba->description( $rec{description} );
    $ba->type( $rec{type} );
    $ba->version( $rec{version} );
    $ba->connectionType( $rec{connectionType} );
    $ba->connectionStatus( $rec{connectionStatus} );
    $ba->dataType( $rec{dataType} );
    $ba->databaseType( $rec{databaseType} );
    $ba->databaseVersion( $rec{databaseVersion} );
    $ba->databaseName( $rec{databaseName} );
    $ba->databaseSchema( $rec{databaseSchema} );
    $ba->databaseIp( $rec{databaseIp} );
    $ba->databasePort( $rec{databasePort} );
    $ba->databaseUser( $rec{databaseUser} );
    $ba->databasePassword( $rec{databasePassword} );
    $ba->socks( $rec{socks} );
    $ba->tunnel( $rec{tunnel} );
    $ba->tunnelPort( $rec{tunnelPort} );
    $ba->authenticatedData( $rec{authenticatedData} );
    $ba->syncSig( $rec{syncSig} );
    $ba->comments( $rec{comments} );
    $ba->remoteUser( $rec{remoteUser} );
    $ba->recordTime( $rec{recordTime} );
    $ba->status( $rec{status} );
    dlog( $ba->toString );

    ###Close the connection
    $trailsConnection->disconnect;

    dlog('End getBankAccountByName method');

    ###Return the bank account
    return $ba;
}

sub getBankAccountById {
    my ( $self, $id ) = @_;

    dlog('Start getBankAccountById method');
    dlog("id=$id");

    ###Get the trails connection
    my $trailsConnection = Database::Connection->new('trails');

    ###Prepare the query
    $trailsConnection->prepareSqlQueryAndFields( $self->queryBankAccountById() );

    ###Get the statement handle
    my $sth = $trailsConnection->sql->{bankAccountById};

    dlog('Binding columns');
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @{ $trailsConnection->sql->{bankAccountByIdFields} } );
    dlog('Columns binded');

    ###Execute the query
    dlog("Exectuing query");
    $sth->execute($id);
    $sth->fetchrow_arrayref;
    $sth->finish;

    ###Create a new bank account object and set
    my $ba = new Sigbank::OM::BankAccount();
    $ba->id( $rec{id} );
    $ba->name( $rec{name} );
    $ba->description( $rec{description} );
    $ba->type( $rec{type} );
    $ba->version( $rec{version} );
    $ba->connectionType( $rec{connectionType} );
    $ba->connectionStatus( $rec{connectionStatus} );
    $ba->dataType( $rec{dataType} );
    $ba->databaseType( $rec{databaseType} );
    $ba->databaseVersion( $rec{databaseVersion} );
    $ba->databaseName( $rec{databaseName} );
    $ba->databaseSchema( $rec{databaseSchema} );
    $ba->databaseIp( $rec{databaseIp} );
    $ba->databasePort( $rec{databasePort} );
    $ba->databaseUser( $rec{databaseUser} );
    $ba->databasePassword( $rec{databasePassword} );
    $ba->socks( $rec{socks} );
    $ba->tunnel( $rec{tunnel} );
    $ba->tunnelPort( $rec{tunnelPort} );
    $ba->authenticatedData( $rec{authenticatedData} );
    $ba->syncSig( $rec{syncSig} );
    $ba->comments( $rec{comments} );
    $ba->remoteUser( $rec{remoteUser} );
    $ba->recordTime( $rec{recordTime} );
    $ba->status( $rec{status} );
    dlog( $ba->toString );

    ###Close the connection
    $trailsConnection->disconnect;

    dlog('End getBankAccountById method');

    ###Return the bank account
    return $ba;
}

sub getBankAccounts {
    my ($self,$ntadz) = @_;

    my @data;

    ###Get the trails connection
    my $trailsConnection = Database::Connection->new('trails');

    ###Prepare the query
    if (defined $ntadz && $ntadz eq 1){
      $trailsConnection->prepareSqlQuery( $self->queryNTadzBankAccounts() );
    }elsif(defined $ntadz && $ntadz eq 2){
      $trailsConnection->prepareSqlQuery( $self->queryOrderedBankAccounts() );
    } else {
      $trailsConnection->prepareSqlQuery( $self->queryBankAccounts() );
    }

    ###Define the fields
    my @fields = (qw(name));

    ###Get the statement handle
    my $sth = $trailsConnection->sql->{bankAccounts};

    ###Bind the columns
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @fields );

    ###Execute the query
    $sth->execute();
    while ( $sth->fetchrow_arrayref ) {
        push @data, $rec{name};
    }

    ###Close the statement handle
    $sth->finish;

    ###Return the bank account
    return @data;
}

sub queryBankAccounts {
    my $query = '
        select
            ba.name
        from
            bank_account ba
        where
            ba.status = \'ACTIVE\'
            and ba.data_type = \'INVENTORY\' 
        order by
            ba.connection_status
            ,ba.record_time
	    ,ba.name
    ';

    return ( 'bankAccounts', $query );
}

sub queryNTadzBankAccounts {
    my $query = '
        select
            ba.name
        from
            bank_account ba
        where
            ba.status = \'ACTIVE\'
            and ba.data_type = \'INVENTORY\' 
            and ba.type !=\'TADZ\'
        order by
            ba.connection_status
            ,ba.record_time
	    ,ba.name
    ';

    return ( 'bankAccounts', $query );
}

###feature added by ticket:131
sub queryOrderedBankAccounts {
    my $query = '

select a.name from   
(select ba.name,ba.connection_status,row_number() over(order by max(baj.end_time) asc nulls first) as timeNo
from
eaadmin.bank_account ba left outer join eaadmin.bank_account_job baj
on (ba.id =  baj.bank_account_id and baj.name like \'%SIGNATURE PULL (FULL)%\')
where
ba.status = \'ACTIVE\'
and ba.data_type = \'INVENTORY\'
and ba.type !=\'TADZ\'
group by 
ba.connection_status
,ba.name
order by 
ba.connection_status
,timeNo
,ba.name) as a
    ';

    return ( 'bankAccounts', $query );
}


sub getBankAccountsByType {
    my ($self,$type) = @_;

    my @data;

    ###Get the trails connection
    my $trailsConnection = Database::Connection->new('trails');

    ###Prepare the query
    $trailsConnection->prepareSqlQuery( $self->queryBankAccountsByType() );

    ###Define the fields
    my @fields = (qw(name));
    dlog("$type");
    ###Get the statement handle
    my $sth = $trailsConnection->sql->{bankAccounts};

    ###Bind the columns
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @fields );

    ###Execute the query
    $sth->execute($type);
    while ( $sth->fetchrow_arrayref ) {
        push @data, $rec{name};
    }

    ###Close the statement handle
    $sth->finish;

    ###Return the bank account
    return @data;
}

sub queryBankAccountsByType {
    my $query = '
        select
            ba.name
        from
            bank_account ba
        where
            ba.status = \'ACTIVE\'
            and ba.data_type = \'INVENTORY\' 
            and ba.type = ?
        order by
            ba.connection_status
            ,ba.record_time
	    ,ba.name
    ';

    return ( 'bankAccounts', $query );
}

sub getBankAccountIdsByType {
    my ($self,$type) = @_;

    my @data;

    ###Get the trails connection
    my $trailsConnection = Database::Connection->new('trails');

    ###Prepare the query
    $trailsConnection->prepareSqlQuery( $self->queryBankAccountIdsByType() );

    ###Define the fields
    my @fields = (qw(id));
    dlog("$type");
    ###Get the statement handle
    my $sth = $trailsConnection->sql->{bankAccountIds};

    ###Bind the columns
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @fields );

    ###Execute the query
    $sth->execute($type);
    while ( $sth->fetchrow_arrayref ) {
        push @data, $rec{id};
    }

    ###Close the statement handle
    $sth->finish;

    ###Return the bank account
    return \@data;
}

sub queryBankAccountIdsByType {
    my $query = '
        select
            ba.id
        from
            bank_account ba
        where
            ba.status = \'ACTIVE\'
            and ba.data_type = \'INVENTORY\' 
            and ba.type = ?
        order by
            ba.connection_status
            ,ba.record_time
	    ,ba.name
    ';

    return ( 'bankAccountIds', $query );
}
sub queryBankAccountByName {
    my @fields = (
        qw(
          id
          name
          description
          type
          version
          connectionType
          connectionStatus
          dataType
          databaseType
          databaseVersion
          databaseName
          databaseSchema
          databaseIp
          databasePort
          databaseUser
          databasePassword
          socks
          tunnel
          tunnelPort
          authenticatedData
          syncSig
          comments
          remoteUser
          recordTime
          status)
    );

    my $query = '
        select
            id
            ,name
            ,description
            ,type
            ,version
            ,connection_type
            ,connection_status
            ,data_type
            ,database_type
            ,database_version
            ,database_name
            ,database_schema
            ,database_ip
            ,database_port
            ,database_user
            ,database_password
            ,socks
            ,tunnel
            ,tunnel_port
            ,authenticated_data
            ,sync_sig
            ,comments
            ,remote_user
            ,record_time
            ,status
        from
            bank_account
        where
            name = ?
    ';

    return ( 'bankAccountByName', $query, \@fields );
}
sub queryBankAccountById {
    my @fields = (
        qw(
          id
          name
          description
          type
          version
          connectionType
          connectionStatus
          dataType
          databaseType
          databaseVersion
          databaseName
          databaseSchema
          databaseIp
          databasePort
          databaseUser
          databasePassword
          socks
          tunnel
          tunnelPort
          authenticatedData
          syncSig
          comments
          remoteUser
          recordTime
          status)
    );

    my $query = '
        select
            id
            ,name
            ,description
            ,type
            ,version
            ,connection_type
            ,connection_status
            ,data_type
            ,database_type
            ,database_version
            ,database_name
            ,database_schema
            ,database_ip
            ,database_port
            ,database_user
            ,database_password
            ,socks
            ,tunnel
            ,tunnel_port
            ,authenticated_data
            ,sync_sig
            ,comments
            ,remote_user
            ,record_time
            ,status
        from
            bank_account
        where
            id = ?
    ';

    return ( 'bankAccountById', $query, \@fields );
}

sub getBankAccountTypeById() {
	my ($self,$id) = @_;
	my $trailsConnection = Database::Connection->new('trails');
	$trailsConnection->prepareSqlQuery( $self->queryBankAccountTypeById() );
    my @fields = (qw(type));
    my $sth = $trailsConnection->sql->{bankAccountTypeById};
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @fields );
    $sth->execute($id);
    
    my $returnType;
    while ( $sth->fetchrow_arrayref ) {
        $returnType = $rec{type};
    }    
    
    $sth->finish;

	dlog("for bankAccountId $id returning type $returnType");
    return $returnType;
    
}


sub queryBankAccountTypeById {
    my $query = '
        select
            ba.type
        from
            bank_account ba
        where
            ba.id=?
    ';

    return ( 'bankAccountTypeById', $query );
}

1;
