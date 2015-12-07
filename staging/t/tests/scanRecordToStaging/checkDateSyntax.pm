package scanRecordToStaging::checkDateSyntax;

use Test::More;
use base 'Test::Class';
use Scan::Delegate::ComputerDelegate;

sub checkDateSyntax_test : Tests(8) {
	
	is(ComputerDelegate->checkDateSyntax('','1970-01-01-00.00.00.000000'),'1970-01-01-00.00.00.000000',"checkDateSyntax: '' -> 1970-01-01-00.00.00.000000");
	is(ComputerDelegate->checkDateSyntax(undef,'1970-01-01-00.00.00.000000'),'1970-01-01-00.00.00.000000',"checkDateSyntax: undef -> 1970-01-01-00.00.00.000000");
	is(ComputerDelegate->checkDateSyntax('aaa','1970-01-01-00.00.00.000000'),'1970-01-01-00.00.00.000000',"checkDateSyntax: aaa -> 1970-01-01-00.00.00.000000");
	is(ComputerDelegate->checkDateSyntax('2000-02-02-09.09.09.0','default'),'2000-02-02-09.09.09.000000',"checkDateSyntax: 2000-02-02-09.09.09.0 -> 2000-02-02-09.09.09.000000");
	is(ComputerDelegate->checkDateSyntax('2000-92-02-09.09.09.000000','1970-01-01-00.00.00.000000'),'1970-01-01-00.00.00.000000',"checkDateSyntax: 2000-92-02-09.09.09.000000 -> '1970-01-01-00.00.00.000000'");
	is(ComputerDelegate->checkDateSyntax('2000-02-02 09:09:09.000000','default'),'2000-02-02 09:09:09.000000',"checkDateSyntax: 2000-02-02 09:09:09.000000 -> 2000-02-02-09:09:09.000000");
	is(ComputerDelegate->checkDateSyntax('2000-02-02-09:09:09','default'),'default',"checkDateSyntax: 2000-02-02-09:09:09.000000 -> default");
	is(ComputerDelegate->checkDateSyntax('2000-02-02','default'),'2000-02-02-00.00.00.000000',"checkDateSyntax: 2000-02-02 -> 2000-02-02-00.00.00.000000");

}

1;