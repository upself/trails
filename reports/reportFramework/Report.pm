package Report;
use lib "/opt/staging/v2";

use Config::Properties::Simple;
use File::Basename;
use Database::Connection;

sub new
{
    my $class = shift;
	my $thisReportName = $0;
	my ($login, $pass, $uid, $gid) = getpwuid($<);
	my ($fileName, $fileDirectory) = fileparse($thisReportName, ".pl");
	my $profileFile = "/home/$login" . "/report.properties";
	my $profileFile = "/home/$login" . "/report.properties";
	my $cfg = Config::Properties::Simple->new(file => $profileFile); 
	
	
	my $production = Database::Connection->new('trails');
	my $staging = Database::Connection->new('staging');
	
    my $self = {
        _thisReport  => $fileName,
        _thisUser => $login,
        _thisUid => $uid,
        _thisGid => 766,
        _thisDir => $fileDirectory,
        _tmpDir => $cfg->getProperty("tmpDir"),
        _productionDatabase => $production->name,
        _productionDatabaseUser => $production->user,
        _productionDatabasePassword => $production->password,
        _stageDatabase => $staging->name,
        _stageDatabaseUser => $staging->user,
        _stageDatabasePassword => $staging->password,
        _reportDatabase => $cfg->getProperty('reportDatabase'),
        _reportDatabaseUser => $cfg->getProperty('reportDatabaseUser'),
        _reportDatabasePassword => $cfg->getProperty('reportDatabasePassword'),
        _db2profile => $cfg->getProperty('db2profile'),
        _gsaUser => $cfg->getProperty("gsaUser"),
        _gsaPassword => $cfg->getProperty("gsaPassword"),
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

sub productionDatabase {
    my $self = shift;
    $self->{_productionDatabase} = shift if scalar @_ == 1;
    return $self->{_productionDatabase};	
}

sub productionDatabaseUser {
    my $self = shift;
    $self->{_productionDatabaseUser} = shift if scalar @_ == 1;
    return $self->{_productionDatabaseUser};	
}

sub productionDatabasePassword {
    my $self = shift;
    $self->{_productionDatabasePassword} = shift if scalar @_ == 1;
    return $self->{_productionDatabasePassword};	
}

sub stageDatabase {
    my $self = shift;
    $self->{_stageDatabase} = shift if scalar @_ == 1;
    return $self->{_stageDatabase};	
}

sub stageDatabaseUser {
    my $self = shift;
    $self->{_stageDatabaseUser} = shift if scalar @_ == 1;
    return $self->{_stageDatabaseUser};	
}

sub stageDatabasePassword {
    my $self = shift;
    $self->{_stageDatabasePassword} = shift if scalar @_ == 1;
    return $self->{_stageDatabasePassword};	
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

sub getLastReplication {
	my $self = shift;
	my $lastReplicated = `tail /gsa/pokgsa/projects/a/amsd/adp/OnDemandProc/PerfMonLogs/TRPSynchDate`;
	return $lastReplicated;
}

sub initReportingSystem {
	my $self = shift;
	system ("echo " . $self->{_gsaPassword} . " | gsa_login -c pokgsa -p ". $self->{_gsaUser});
	system(". " .$cfg->getProperty('db2profile'));
	umask("0002");	
}

1;
