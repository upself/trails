package SWASSET::TARLoader;

use strict;
use File::Copy;
use Base::Utils;
use Carp qw( croak );
use Database::Connection;

###Object constructor.
sub new {
    my ( $class,           $applyChanges, $tarDir,
         $completeDir,     $workDir,      $errorDir,
         $unregisteredDir, $garbageDir,   $logDir
        )
        = @_;

    my $self = { _applyChanges    => $applyChanges,
                 _tarDir          => $tarDir,
                 _completeDir     => $completeDir,
                 _workDir         => $workDir,
                 _errorDir        => $errorDir,
                 _unregisteredDir => $unregisteredDir,
                 _garbageDir      => $garbageDir,
                 _logDir          => $logDir
    };
    bless $self, $class;
    dlog("instantiated self");

    $self->validate;

    return $self;
}

sub validate {
    my $self = shift;

    croak 'applyChanges is undefined'
        unless defined $self->applyChanges;

    croak 'tarDir is undefined'
        unless defined $self->tarDir;

    croak 'completeDir is undefined'
        unless defined $self->completeDir;

    croak 'workDir is undefined'
        unless defined $self->workDir;

    croak 'errorDir is undefined'
        unless defined $self->errorDir;

    croak 'unregisteredDir is undefined'
        unless defined $self->unregisteredDir;

    croak 'garbageDir is undefined'
        unless defined $self->garbageDir;

    croak 'logDir is undefined'
        unless defined $self->logDir;

    croak "tarDir: " . $self->tarDir . " does not exist"
        unless ( -d $self->tarDir );

    croak "completeDir: " . $self->completeDir . " does not exist"
        unless ( -d $self->completeDir );

    croak "workDir: " . $self->workDir . " does not exist"
        unless ( -d $self->workDir );

    croak "errorDir: " . $self->errorDir . " does not exist"
        unless ( -d $self->errorDir );

    croak "unregisteredDir: " . $self->unregisteredDir . " does not exist"
        unless ( -d $self->unregisteredDir );

    croak "garbageDir: " . $self->garbageDir . " does not exist"
        unless ( -d $self->garbageDir );

    croak "tarDir: " . $self->logDir . " does not exist"
        unless ( -d $self->logDir );    

}

sub load {
    my $self = shift;
    
    $self->getTarFiles;
    $self->validateTarFileNames;
}

sub getTarFiles {
    my $self = shift;
    
    my %files;
    
    opendir(TAR, $self->tarDir) || die("Cannot open tar directory!");
    while ( defined (my $file = readdir TAR) ) {
        
        next if $file =~ /^\.\.?$/;
        next if $file =~ /^inv_/;
        
        unless ( $file =~ /\.tar$/i ) {
            $self->moveFileToGarbage($file);
            next;
        }
        
        my $origFile = $file;
        $file = uc($file); 
        $file =~ s/\.TAR$/\.tar/;
        
        $files{$file} = $origFile;
    }
    closedir(TAR);

    $self->tarFiles(\%files);
}

sub moveFileToGarbage {
    my($self, $file) = @_;
    
    move($file,$self->garbageDir);
}

sub applyChanges {
    my ( $self, $value ) = @_;
    $self->{_applyChanges} = $value if defined($value);
    return ( $self->{_applyChanges} );
}

sub tarDir {
    my ( $self, $value ) = @_;
    $self->{_tarDir} = $value if defined($value);
    return ( $self->{_tarDir} );
}

sub completeDir {
    my ( $self, $value ) = @_;
    $self->{_completeDir} = $value if defined($value);
    return ( $self->{_completeDir} );
}

sub workDir {
    my ( $self, $value ) = @_;
    $self->{_workDir} = $value if defined($value);
    return ( $self->{_workDir} );
}

sub errorDir {
    my ( $self, $value ) = @_;
    $self->{_errorDir} = $value if defined($value);
    return ( $self->{_errorDir} );
}

sub unregisteredDir {
    my ( $self, $value ) = @_;
    $self->{_unregisteredDir} = $value if defined($value);
    return ( $self->{_unregisteredDir} );
}

sub garbageDir {
    my ( $self, $value ) = @_;
    $self->{_garbageDir} = $value if defined($value);
    return ( $self->{_garbageDir} );
}

sub logDir {
    my ( $self, $value ) = @_;
    $self->{_logDir} = $value if defined($value);
    return ( $self->{_logDir} );
}

1;
