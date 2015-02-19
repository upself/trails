package softwareToBravo::SoftwareLoader;

use Test::More;
use base 'Test::Class';
use Database::Connection;

sub class { 'BRAVO::SoftwareLoader' };


sub startup : Tests(startup => 1) {
	my $tmp = shift;
	use_ok $tmp->class;
}

sub getKbDefinitionIdByGUID : Tests(10) {
	my $test = shift;
	my $class = $test->class;
	
	can_ok $class,'getKbDefinitionIdByGUID';
	pass("Semi online test - !! If test fails, check test expected results and data from TRAILS first.!!");
	
     my $connection = Database::Connection->new('trails');
     isnt($connection,0," trails connection is set up");
       
       
     is($class->getKbDefinitionIdByGUID($connection,'c4cd23ace3b0fc3e492ec3b293b3e39d'),'472651','getKbDefinitionIdByGUID -> guid: c4cd23ace3b0fc3e492ec3b293b3e39d - MF_Id: 472651');
     is($class->getKbDefinitionIdByGUID($connection,'c4cd23aee6b20c3b3d47fbb18dafc59d'),'472688','getKbDefinitionIdByGUID -> guid: c4cd23aee6b20c3b3d47fbb18dafc59d - MF_Id: 472651');
     is($class->getKbDefinitionIdByGUID($connection,'c50423ad00d1ef79442da2c2afcec67f'),'472702','getKbDefinitionIdByGUID -> guid: c50423ad00d1ef79442da2c2afcec67f - MF_Id: 472702');
     
     is($class->getKbDefinitionIdByGUID($connection,'c582e4809e71925054906bdd2d9002ad'),'469693','getKbDefinitionIdByGUID -> guid: c582e4809e71925054906bdd2d9002ad - MV_Id: 469693');
     is($class->getKbDefinitionIdByGUID($connection,'e40bc664b22d8e9461275ff4516dfd66'),'469679','getKbDefinitionIdByGUID -> guid: e40bc664b22d8e9461275ff4516dfd66 - MV_Id: 469679');
     is($class->getKbDefinitionIdByGUID($connection,'9da0786be8484584bdd6c9e103f518a9'),'119049','getKbDefinitionIdByGUID -> guid: 9da0786be8484584bdd6c9e103f518a9 - MV_Id: 119049');
     is($class->getKbDefinitionIdByGUID($connection,'5e627bd2fcd34bda85caaa7974bdc804'),'119330','getKbDefinitionIdByGUID -> guid: 5e627bd2fcd34bda85caaa7974bdc804 - MV_Id: 119330');
	
}
1;