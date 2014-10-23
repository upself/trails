use Test::More 'no_plan';
use File::Copy;

 BEGIN { use_ok( 'TLCMZ::MoveMainframe' ); }
 require_ok( 'TLCMZ::MoveMainframe' );

my $tlcmz = TLCMZ::MoveMainframe->new('mf_scan', 'donnie.txt'); 
ok(defined $tlcmz, 'new returned something');

$tlcmz->setUserEmail("dbryson@us.ibm.com");

ok($tlcmz->getUserEmail() eq "dbryson@us.ibm.com", "check email");
ok($tlcmz->getIncomingDir() eq "/var/ftp/mf_scan/", "check incoming dir");
ok($tlcmz->getPermDir() eq "/var/ftp/mf_scan/perm/", "check perm dir");
ok($tlcmz->getLog() eq "/var/ftp/mf_scan/log.txt", "check log");
ok($tlcmz->getMaxFileSize() == 1024 * 1024, "check max file size");
ok($tlcmz->getFileName() eq "donnie.txt", "check file name");
copy( '/var/ftp/mf_scan/epie.xml.processed', '/var/ftp/mf_scan/bad_meuch.xml');
copy( '/var/ftp/mf_scan/epie.xml.processed', '/var/ftp/mf_scan/good_meuch.xml');
copy( '/var/ftp/mf_scan/meghc.asc.processed', '/var/ftp/mf_scan/good_meusx.asc');

my $badFile = TLCMZ::MoveMainframe->new('mf_scan', 'bad_meuch.xml' );
$badFile->processBadFile('/var/ftp/mf_scan/bad_meuch.xml');
my $goodFile = TLCMZ::MoveMainframe->new('mf_scan', 'meuhc.xml');
($cpu, $lpar, $myTime) = $goodFile->checkIt('good_meuch.xml');
$goodFile->moveFile('/var/ftp/mf_scan/good_meuch.xml', $cpu, $lpar, $myTime);
my $ascFile = TLCMZ::MoveMainframe->new('mf_scan', 'good_meusx.asc');
($cpu, $lpar) = $ascFile->checkIt('good_meusx.asc');
$ascFile->moveFile('/var/ftp/mf_scan/good_meusx.asc', $cpu, $lpar, $myTime);