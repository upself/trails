package softwareToBravo::SoftwareLoader;

use Test::More;
use base 'Test::Class';
use Database::Connection;

sub class { 'BRAVO::SoftwareLoader' };


sub startup : Tests(startup => 1) {
	my $tmp = shift;
	use_ok $tmp->class;
}

sub getMainframeFeatureIdByGUID : Tests(10) {
	my $test = shift;
	my $class = $test->class;
	
	can_ok $class,'getMainframeFeatureIdByGUID';
	pass("Semi online test - !! If test fails, check test expected results and data from TRAILS first.!!");
	
     my $connection = Database::Connection->new('trails');
     isnt($connection,0," trails connection is set up");
       
       
     is($class->getMainframeFeatureIdByGUID($connection,'c4cd23ace3b0fc3e492ec3b293b3e39d'),'472651','getMainframeFeatureIdByGUID -> guid: c4cd23ace3b0fc3e492ec3b293b3e39d - MF_Id: 472651');
     is($class->getMainframeFeatureIdByGUID($connection,'c4cd23aee6b20c3b3d47fbb18dafc59d'),'472688','getMainframeFeatureIdByGUID -> guid: c4cd23aee6b20c3b3d47fbb18dafc59d - MF_Id: 472651');
     is($class->getMainframeFeatureIdByGUID($connection,'c50423ad00d1ef79442da2c2afcec67f'),'472702','getMainframeFeatureIdByGUID -> guid: c582e4809e71925054906bdd2d9002ad - MF_Id: 472651');
     
     is($class->getMainframeFeatureIdByGUID($connection,'c582e4809e71925054906bdd2d9002ad'),undef,'getMainframeFeatureIdByGUID -> guid: e40bc664b22d8e9461275ff4516dfd66 - MF_Id: undef');
     is($class->getMainframeFeatureIdByGUID($connection,'e40bc664b22d8e9461275ff4516dfd66'),undef,'getMainframeFeatureIdByGUID -> guid: c4cd23ace3b0fc3e492ec3b293b3e39d - MF_Id: undef');
     is($class->getMainframeFeatureIdByGUID($connection,'9da0786be8484584bdd6c9e103f518a9'),undef,'getMainframeFeatureIdByGUID -> guid: 9da0786be8484584bdd6c9e103f518a9 - MF_Id: undef');
     is($class->getMainframeFeatureIdByGUID($connection,'5e627bd2fcd34bda85caaa7974bdc804'),undef,'getMainframeFeatureIdByGUID -> guid: 5e627bd2fcd34bda85caaa7974bdc804 - MF_Id: undef');
	
}
1;