package t::unit_test::sftpTransfer::sftpTransfer;

require '../../sftpTransfer.pl';

sub sftp_test : Tests(5) {
fopen ($fh, ">testConfig.txt");

print $fh <<EOL;
[TESTING]
direction=rem2loc # rem2loc - remote to local, or loc2rem - in the future we shall implement also some zipping
srchostname=lexbz2250.cloud.dst.ibm.com
source=/home/myyysha/SFTPfrom
target=/home/michal.g/SFTPto
filemask=^w.*
srcftpuser=myyysha # for logging
srcftppwd=567uJHGt
delsource=false
minage=2
flag=weareREADY
EOL

fclose($fh);

open(CFGFILE,"<testConfig.txt");

is(readcfgfile(\*CFGFILE),1,"Config file read.");
is(filetomove("what.txt",time-180),1,"File filter works.");
is(filetomove("no.txt",time-180),0,"File mask works... no.txt doesnt start with w");
is(filetomove("weareyoung.txt",time-3),0,"File age works... this file is too young");

print "The flag has not been found yet" if ($flagispresent == 0);

is(filetomove("weareREADY",time-180),0,"This file is the flag, so it should not be transferred");

print "The flag has been found" if ($flagispresent == 1);

close(CFGFILE);

unlink("testConfig.txt");
}

1;
