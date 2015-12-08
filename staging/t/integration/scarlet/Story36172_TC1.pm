package integration::scarlet::Story36172_TC1;

use base 'Test::Class';
use Test::More;
use Test::File;
use Test::Cmd::Common;

use Base::Utils;
use Base::ConfigManager;
use Recon::LicensingReconEngineCustomer;

sub TC1 : Tests(5) {    

 my $connectionConfig = '/opt/staging/v2/config/connectionConfig.txt';
 file_contains_like( $connectionConfig, qr{scarlet\.license\s*=\s*http} );

 my $opt_f = 'integration/scarlet/Story36172_reconEnginConf.txt';

 #2 checkers here;
 file_contains_like( $opt_f,
  [ qr{testMode\s*=\s*0}, qr{debugLevel\s*=\s*debug} ] );

 my $opt_c = '7458';
 my $opt_d = '2099-01-01';
 my $opt_p = 0;
 my $opt_l = '/tmp/reconEngine.log.child.7458';

 my $cfgMgr = Base::ConfigManager->instance($opt_f);

 logfile($opt_l);
 logging_level( $cfgMgr->debugLevel );

 diag('start recon');
 my $reconEngine =
   new Recon::LicensingReconEngineCustomer( $opt_c, $opt_d, $opt_p );
 $reconEngine->recon;
 diag('end recon');

 file_contains_like( $opt_l, qr{returning to caller} );
 file_contains_unlike( $opt_l, qr{ERROR} );

}

1;

