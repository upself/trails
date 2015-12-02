package Conf::ReportProperty;
use lib "/opt/staging/v2";

use Config::Properties::Simple;
use File::Basename;
use Sys::Hostname;

sub new
{
    my $class = shift;
        my $thisReportName = $0;
        my ($login, $pass, $uid, $gid) = getpwuid($<);
        my ($fileName, $fileDirectory) = fileparse($thisReportName, ".pl");
        
        my $host = hostname;
        my $shost = ( split( /\./, $host ) )[0];
        my $systemFile = "/opt/staging/v2/config/connectionConfig.txt";
        my $cfg = Config::Properties::Simple->new(file => $systemFile);

        # don't try to use the db2 information until you properly load the profile because the DBI library
        # requires it
        system(". " .$cfg->getProperty('db2profile'));

    my $self = {
        _cfg =>  $cfg,
        _thisReport  => $fileName,
        _thisUser => $login,
        _thisUid => $uid,
        _thisGid => 766,
        _thisDir => $fileDirectory,
        _tmpDir => $cfg->getProperty("tmpDir"),
        _reportDatabase => $cfg->getProperty('reportDatabase'),
        _reportDatabaseUser => $cfg->getProperty('reportDatabaseUser'),
        _reportDatabasePassword => $cfg->getProperty('reportDatabasePassword'),
	_stagingDatabase => $cfg->getProperty('stagingDatabase'),
        _stagingDatabaseUser => $cfg->getProperty('stagingDatabaseUser'),
        _stagingDatabasePassword => $cfg->getProperty('stagingDatabasePassword'),
        _db2profile => $cfg->getProperty('db2profile'),
        _gsaUser => $cfg->getProperty("gsaUser"),
        _gsaPassword => $cfg->getProperty("gsaPassword"),
        _gsaCell => $cfg->getProperty("gsaCell")
    };
    bless $self, $class;

    return $self;
}

# make a semi-temp file name with this report script name and this part of the report
sub MakeTempName {
        my ( $self, $section, $ext ) = @_;
        return $self->{_tmpDir} . $self->{_thisReport} . $section . $ext;
}

# create a temporary file and returns a file handle to it
sub OpenTemp {
    my ( $self, $fileName ) = @_;
    open (FH, ">", $fileName) or die "Cannot open $fileName: $!";
    chown($self-{_thisUid}, $self->{_thisGid}, $fileName);
        return *FH;
}

# closes a temporary file and removes it
sub RemoveTemp {
    my ( $self, $fileName ) = @_;
        unlink($fileName);
}

sub thisReport {
    my $self = shift;
    $self->{_thisReport} = shift if scalar @_ == 1;
    return $self->{_thisReport};
}

sub thisUser {
    my $self = shift;
    $self->{_thisUser} = shift if scalar @_ == 1;
    return $self->{_thisUser};
}

sub thisDir {
    my $self = shift;
    $self->{_thisDir} = shift if scalar @_ == 1;
    return $self->{_thisDir};
}

sub tmpDir {
    my $self = shift;
    $self->{_tmpDir} = shift if scalar @_ == 1;
    return $self->{_tmpDir};
}

sub reportDatabase {
    my $self = shift;
    $self->{_reportDatabase} = shift if scalar @_ == 1;
    return $self->{_reportDatabase};
}

sub reportDatabaseUser {
    my $self = shift;
    $self->{_reportDatabaseUser} = shift if scalar @_ == 1;
    return $self->{_reportDatabaseUser};
}

sub reportDatabasePassword {
    my $self = shift;
    $self->{_reportDatabasePassword} = shift if scalar @_ == 1;
    return $self->{_reportDatabasePassword};
}

sub stagingDatabase {
    my $self = shift;
    $self->{_stagingDatabase} = shift if scalar @_ == 1;
    return $self->{_stagingDatabase};
}

sub stagingDatabaseUser {
    my $self = shift;
    $self->{_stagingDatabaseUser} = shift if scalar @_ == 1;
    return $self->{_stagingDatabaseUser};
}

sub stagingDatabasePassword {
    my $self = shift;
    $self->{_stagingDatabasePassword} = shift if scalar @_ == 1;
    return $self->{_stagingDatabasePassword};
}

sub db2profile {
    my $self = shift;
    $self->{_db2profile} = shift if scalar @_ == 1;
    return $self->{_db2profile};
}

sub gsaUser {
    my $self = shift;
    $self->{_gsaUser} = shift if scalar @_ == 1;
    return $self->{_gsaUser};
}

sub gsaPassword {
    my $self = shift;
    $self->{_gsaPassword} = shift if scalar @_ == 1;
    return $self->{_gsaPassword};
}

sub gsaPassword {
    my $self = shift;
    $self->{_gsaPassword} = shift if scalar @_ == 1;
    return $self->{_gsaPassword};
}

sub reportDeliveryFolder {
    my ($self,$reportName) = @_;
    if(!defined $reportName){
      die 'Did not give report name';
    }
    return $self->cfg->getProperty($reportName);
}

sub gsaCell {
    my $self = shift;
    $self->{_gsaCell} = shift if scalar @_ == 1;
    return $self->{_gsaCell};
}

sub cfg {
    my $self = shift;
    $self->{_cfg} = shift if scalar @_ == 1;
    return $self->{_cfg};
}

sub initReportingSystem {
        my $self = shift;

        system ("echo " . $self->gsaPassword . " | gsa_login -c ".$self->gsaCell ." -p ". $self->{_gsaUser});
        umask("0002");
}

1;
