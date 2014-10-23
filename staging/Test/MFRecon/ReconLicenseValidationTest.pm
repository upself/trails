package Test::PvuRecon::ReconLicenseValidationTest;

use strict;
use Test::More;
use base qw(Test::Class Test::Common::ConnectionManager);

use Recon::Delegate::ReconLicenseValidation;
use BRAVO::OM::InstalledSoftware;

sub setup_initConnection : Test(setup){
    my $self = shift;
    $self->{bravoConnection}   = Database::Connection->new('trails');
}
sub test01_try_and_buy : Test(3) {
    my $self   = shift;
    $self->{bravoConnection}->prepareSqlQuery( $self->queryExpireDate );

	 #acquire the statement handle.
	 my $sth = $self->{bravoConnection}->sql->{queryExpireDate};
	
	 #bind fields.
	 my $expireDate1;
	 my $expireDate2;
	 my $expireDate3;	
	 $sth->bind_columns( \$expireDate1);
	 $sth->execute(1158);
	 $sth->fetchrow_arrayref;
	 diag("expireDate1 = $expireDate1");
	 $sth->bind_columns( \$expireDate2);
	 $sth->execute(359842);
     $sth->fetchrow_arrayref;
     diag("expireDate2 = $expireDate2");
     $sth->bind_columns( \$expireDate3);
     $sth->execute(353202);
     $sth->fetchrow_arrayref;
     diag("expireDate3 = $expireDate3");
	 my $validation = new Recon::Delegate::ReconLicenseValidation();
	 $validation->validationCode(1);
	 my $result1 = $validation->validateTryAndBuy(1, 5, undef, 0);
	 is( $validation->validationCode, 1, 'valid' );
	 $validation->validationCode(1);
	 my $result2 = $validation->validateTryAndBuy(1, 5, undef, 0);
	 is( $validation->validationCode, 1, 'valid' );
	 $validation->validationCode(1);
	 my $result3 = $validation->validateTryAndBuy(1, 5, undef, 0);
	 is( $validation->validationCode, 1, 'valid' );
}

sub test02_MaintenanceExpiration : Test(3) {
    my $self   = shift;
    $self->{bravoConnection}->prepareSqlQuery( $self->queryExpireDay );

     #acquire the statement handle.
     my $sth = $self->{bravoConnection}->sql->{queryExpireDay};
    
     #bind fields.
     my $expireDay1;
     my $expireDay2;
     my $expireDay3;   
     $sth->bind_columns( \$expireDay1);
     $sth->execute(1158);
     $sth->fetchrow_arrayref;
     diag("expireDay1 = $expireDay1");
     $sth->bind_columns( \$expireDay2);
     $sth->execute(359842);
     $sth->fetchrow_arrayref;
     diag("expireDay2 = $expireDay2");
     $sth->bind_columns( \$expireDay3);
     $sth->execute(353202);
     $sth->fetchrow_arrayref;
     diag("expireDay3 = $expireDay3");
     my $validation = new Recon::Delegate::ReconLicenseValidation();
     $validation->validationCode(1);
     my $result1 = $validation->validateMaintenanceExpiration('MAINFRAME', 0,  $expireDay1, undef, 0);
     is( $validation->validationCode, 1, 'valid' );
     $validation->validationCode(1);
     my $result2 = $validation->validateMaintenanceExpiration('MAINFRAME', 0, $expireDay2, undef, 0);
     is( $validation->validationCode, 1, 'valid' );
     $validation->validationCode(1);
     my $result3 = $validation->validateMaintenanceExpiration('MAINFRAME', 0, $expireDay3, undef, 0);
     is( $validation->validationCode, 1, 'valid' );
}

sub queryExpireDate {
 my $query = "
            select expire_date 
            from license
            where id=?
   ";
 return ( 'queryExpireDate', $query );
}

sub queryExpireDay {
 my $query = "
            select days(expire_date ) - days( CURRENT TIMESTAMP )
            from license
            where id=?
   ";
 return ( 'queryExpireDay', $query );
}
  
sub teardown_closeConnection : Test(teardown) {
     my $self            = shift;
     $self->{bravoConnection}->disconnect;
 }
1;
