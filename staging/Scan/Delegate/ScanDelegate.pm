package ScanDelegate;

use strict;
use Base::Utils;
use File::Copy;
use File::stat;    

###TODO this probably should be broken out into respective delegates...its getting big
###TODO need to take into account processor counts for bank accounts other than tcm

sub getDisconnectedFile {
    my ( $self, $bankAccount, $delta, $filePart ) = @_;

    my $rootDir         = '/var/ftp/staging/secondary';
    my $disconnectedDir = '/var/staging/disconnected';
    my $fileName        = $bankAccount->name . '_' . $filePart . '.tsv.gz';
    dlog("fileName=$fileName");

    ###We need to make sure that if it is not the computer file
    ###Then we need to make sure the computer file has been
    ###processed.  I'm not going to worry about this right now
    ###To tell you the truth

    ###Delta or not, we will process the newest file
    if ( -e "$rootDir/$fileName" ) {
        dlog("$rootDir/$fileName exists");

        my $st = stat("$rootDir/$fileName") or die "No $rootDir/$fileName: $!";
        ##TODO from the bbus_computer_memory I am ncot getting a value....odd
        my $mtime = $st->mtime;
        dlog("mtime=$mtime");
        my $minutes = ( time - $st->mtime ) / 60;
        dlog("minutes=$minutes");

        if ( $minutes > 5 ) {
            dlog('File has not been modified for over 5 minute');

            dlog("Copying $rootDir/$fileName to $disconnectedDir/$fileName");
            copy( "$rootDir/$fileName", "$disconnectedDir/$fileName" );
            dlog('Copy complete');

            dlog("Changing file permissions");
            chmod(0744, "$disconnectedDir/$fileName");
            dlog("Changed file permissions");

            my $sourceSize = $st->size;
            dlog("sourcesize=$sourceSize");
            my $targetSize = stat("$disconnectedDir/$fileName")->size;
            dlog("targetsize=$targetSize");

            if ( $sourceSize == $targetSize ) {
                dlog('Filesizes are equal, removing source');

                unlink("$rootDir/$fileName");
                dlog('Source file removed');
                dlog('Returning file to process');
                return "$disconnectedDir/$fileName";
            }
            else {
                dlog('Filesizes are unequal, removing target file');
                unlink("$disconnectedDir/$fileName");
                dlog('Target file removed');
                die('filesize issue, will not continue');
            }
        }
    }

    ###We get here and we don't have a touchable new file
    dlog('No new file');

    ###Return undef if we are only looking for new files
    if($filePart ne 'software_filter') {
        return undef if ($delta);
    }

     dlog("$disconnectedDir/$fileName");
    ###We get here and we will return the old file if it exists
    if ( -e "$disconnectedDir/$fileName" ) {
        return "$disconnectedDir/$fileName" if ( -e "$disconnectedDir/$fileName" );
    }
    else {
        return undef;
    }
}
1;
