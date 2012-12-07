#!/usr/bin/perl -w

use File::Basename;
use TLCMZ::MoveMainframe;

# Main

my @files = glob '/var/ftp/mf_scan/' . "*.{txt,TXT,xml,XML,asc,ASC}";

for my $file (@files) {
	my ( $basefile, $dir, $ext ) = fileparse($file);
	unless ( $basefile eq "log.txt"
		|| ( $basefile eq "to_scan.txt" )
		|| ( $basefile eq "nudge" )
		|| ( $basefile eq "perm" )
		|| ( $basefile eq "error_file.txt" ) )
	{
		my $subFile = TLCMZ::MoveMainframe->new('mf_scan', "$basefile" );
		my ( $cpu, $lpar, $myTime ) = $subFile->checkIt($basefile);
		if ( $cpu eq "bad" ) {
			$subFile->processBadFile($file);
		}
		elsif ( $cpu eq "working" ) {
			print "$basefile is currently being transmitted";
		}
		else {
			$subFile->moveFile( $file, $cpu, $lpar, $myTime );
		}
	}
}

