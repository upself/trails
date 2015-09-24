package scanRecordToLpar::isTADZ;


use Test::More;
use base 'Test::Class';
use Staging::ScanRecordToLparLoader;

sub class { 'Staging::ScanRecordToLparLoader' }

sub startup : Tests(startup => 1) {
    my $test = shift;
    use_ok $test->class;
}

sub checkIsTadz : Tests(5) {
	my $test  = shift;
	my $class = $test->class;
	

	is($class->isTADz(1),0, "bankAccount 1 is not TADZ");
	is($class->isTADz(-99999),0, "bankAccount -99999 is not TADZ");
	is($class->isTADz(undef),0, "bankAccount undefined is not TADZ");
	is($class->isTADz(1000),1, "bankAccount 1000 is TADZ");
	is($class->isTADz(1010),1, "bankAccount 1010 is TADZ");

}

1;