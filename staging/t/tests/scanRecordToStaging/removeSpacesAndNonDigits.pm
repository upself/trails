package scanRecordToStaging::removeSpacesAndNonDigits;


use Test::More;
use base 'Test::Class';


sub class { 'Staging::ScanRecordLoader' };

sub startup : Tests(startup => 1) {
    my $test = shift;
    use_ok $test->class;
}


sub removeSpacesAndNonDigits_test : Tests(2) {

	my $test  = shift;
	my $class = $test->class;
	
	is($class->removeSpacesAndNonDigits('2011-08-31-17.26.09.000000'),'20110831172609000000', "removeSpacesAndNonDigits - 2011-08-31-17.26.09.000000 => 20110831172609000000");
	is($class->removeSpacesAndNonDigits('2011 -08-31-17.26.09 .0000 00'),'20110831172609000000', "removeSpacesAndNonDigits - 2011 -08-31-17.26.09 .0000 00 => 20110831172609000000");
	
}

1;