package t::tests::Test::Database::Connection;

use Test::More;
use base 'Test::Class';
use Database::Connection;
use Sigbank::OM::BankAccount;
use Staging::Loader;
use Sigbank::Delegate::BankAccountDelegate;

my $connection;

sub class { 'Database::Connection' };

sub startup : Tests(startup => 1) {
    my $test = shift;
    use_ok $test->class;
}

sub cndb_connection_test : Tests(5) {
     my $test  = shift;
     my $class = $test->class;

        for (my $i=0; $i < 5; $i++) {
            $connection = Database::Connection->new('trails');
                isnt($connection,0,$i . " cndb connection is set up.");
                sleep(1);
    }

}

sub swasset_connection_test : Test(5) {
     my $test  = shift;
     my $class = $test->class;

        for (my $i=0; $i < 5; $i++) {
            $connection = Database::Connection->new('swasset');
                isnt($connection,0,$i . " swasset connection is set up.");
                sleep(1);
    }

}
sub atp_connection_test : Tests(5) {
     my $test  = shift;
     my $class = $test->class;
     my $ba = Sigbank::Delegate::BankAccountDelegate->getBankAccountByName('ATP');
     if ( ! length $ba->{_name} ){
        $ba = Sigbank::Delegate::BankAccountDelegate->getBankAccountByName('ATPPROD');
     }

        for (my $i=0; $i < 5; $i++) {
                     $connection = Database::Connection->new($ba);
                 isnt($connection,0,$i . " atp connection is set up.");
                sleep(1);
    }


}
1;
