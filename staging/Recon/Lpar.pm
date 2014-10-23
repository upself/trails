package Recon::Lpar;

use strict;
use Base::Utils;
use BRAVO::OM::HardwareSoftwareComposite;
use BRAVO::OM::Hardware;
use BRAVO::OM::SoftwareLpar;
use BRAVO::OM::HardwareLpar;
use BRAVO::OM::SoftwareLparEff;
use BRAVO::OM::HardwareLparEff;
use BRAVO::OM::SoftwareLparEffHistory;

sub new {
    my ($class) = @_;
    my $self = {
                 _connection           => undef,
                 _hardwareLpar         => undef,
                 _softwareLpar         => undef,
                 _hwSwComposite        => undef,
                 _hardware             => undef,
                 _softwareLpars        => undef,
                 _hardwareLpars        => undef,
                 _softwareLparsToRecon => {},
                 _hardwareLparsToRecon => {},
                 _reconDeep            => undef
    };
    bless $self, $class;
    return $self;
}

########################################################################################################################
### main method
########################################################################################################################

sub recon {
    my $self = shift;

    ###Die if a connection is not passed
    die 'Connection is invalid' if !defined $self->connection;

    ###Die if the calling script has defined both lpars, we can only recon one at a time
    die 'Multiple lpars defined' if defined $self->hardwareLpar && defined $self->softwareLpar;

    if ( defined $self->hardwareLpar ) {
        $self->reconFromHardwareLpar;
        return;
    }
    elsif ( defined $self->softwareLpar ) {
        $self->reconFromSoftwareLpar;
        return;
    }

    die 'Lpar must be defined';
}

########################################################################################################################
### Software lpar recon methods
########################################################################################################################

###Main software lpar recon method
sub reconFromSoftwareLpar {
    my $self = shift;
    dlog("Begin reconFromSoftwareLpar");

    ###Populate required data
    $self->populate;

    if ( $self->softwareLpar->status eq 'INACTIVE' ) {
        dlog("software lpar is inactive");
        if ( defined $self->hwSwComposite ) {
            dlog("composite is defined");
            ###Add the hardware lpar to list to recon
            $self->addToHardwareLparsToRecon( $self->hwSwComposite->hardwareLparId );

            ###Break the composite
            dlog("breaking composite");
            $self->hwSwComposite->delete( $self->connection );

            $self->reconDeep(1);
        }

        $self->effectiveProcessorLogic;

        return;
    }

    ###see if we can find a match
    my $matchType = $self->findHardwareLparMatch;
    dlog("MatchType=$matchType");

    if ( defined $self->hwSwComposite ) {
        ###We are currently in a composite
        dlog("composite is defined");

        if ( defined $matchType ) {
            ###We found a definitive unique match
            dlog("we have a match");

            if ( $self->hardwareLpar->id eq $self->hwSwComposite->hardwareLparId ) {
                ###Match is current
                dlog("match is current");

                if ( $matchType ne $self->hwSwComposite->matchMethod ) {
                    dlog("match type needs to be updated");
                    $self->hwSwComposite->matchMethod($matchType);
                    $self->hwSwComposite->save( $self->connection );
                }

                $self->effectiveProcessorLogic;
            }
            else {
                ###Our hardware lpar has changed
                dlog("we match to a different hw lpar");

                ###Update the composite
                $self->hwSwComposite->hardwareLparId( $self->hardwareLpar->id );
                $self->hwSwComposite->matchMethod($matchType);
                $self->hwSwComposite->save( $self->connection );

                ###Run through the processor logic
                $self->effectiveProcessorLogic;

                $self->reconDeep(1);

                ###We want to recon this one deep no matter what the effective tells us
                $self->addToHardwareLparsToRecon( $self->hwSwComposite->hardwareLparId );
            }
        }
        else {
            ###Nothing matched
            dlog("no matches");

            ###Add the hardware lpar to list to recon
            $self->addToHardwareLparsToRecon( $self->hwSwComposite->hardwareLparId );

            ###Break the composite
            dlog("break composite");
            $self->hwSwComposite->delete( $self->connection );

            ###Recon deep
            $self->reconDeep(1);

            ###run through the processor logic
            $self->effectiveProcessorLogic;
        }
    }
    elsif ( defined $matchType && $self->hardwareLpar->lparStatus eq 'ACTIVE') 
     {
        ###We found a definitive unique match
        dlog("we have a match");

        dlog("saving composite");
        my $hwSwComposite = new BRAVO::OM::HardwareSoftwareComposite();
        $hwSwComposite->softwareLparId( $self->softwareLpar->id );
        $hwSwComposite->hardwareLparId( $self->hardwareLpar->id );
        $hwSwComposite->matchMethod($matchType);
        $hwSwComposite->save( $self->connection );

        $self->reconDeep(1);

        $self->effectiveProcessorLogic;

        $self->addToHardwareLparsToRecon( $self->hardwareLpar->id );
    }
}

###Find hardware lpar for our software lpar
sub findHardwareLparMatch {
    my $self = shift;

    ###Find a unique ext id match
    $self->findUniqueExtIdMatch;

    ###Return if we found one
    return 'EXT_ID' if ( defined $self->hardwareLpar );

    ###Create the shortname
    my $shortName = ( split( /\./, $self->softwareLpar->name ) )[0];

    ###populate potential matches
    $self->getSoftwareLparsByCustomerIdAndShortName( $shortName, $self->softwareLpar->customerId );
    $self->getHardwareLparsByCustomerIdAndShortName( $shortName, $self->softwareLpar->customerId );

    ###Find unique hostname matches
    $self->findUniqueHostnameMatches;
    return 'HOSTNAME' if ( defined $self->hardwareLpar );

    ###Find unique shortname serial matches
    $self->findUniqueShortnameSerialMatches;
    return 'SHORTNAME_SERIAL' if ( defined $self->hardwareLpar );

    ###Find unique shortname serial5 matches
    $self->findUniqueShortnameSerial5Matches;
    return 'SHORTNAME_SERIAL5' if ( defined $self->hardwareLpar );

    ###Find unique shortname matches
    $self->findUniqueShortnameMatches;
    return 'SHORTNAME' if ( defined $self->hardwareLpar );

    return undef;
}

########################################################################################################################
### Hardware lpar recon methods
########################################################################################################################

sub reconFromHardwareLpar {
    my $self = shift;
    dlog("begin recon from hardwarelpar");

    ###Populate required data
    $self->populate;

    if ( $self->hardwareLpar->lparStatus eq 'INACTIVE' 
         || $self->hardwareLpar->lparStatus eq 'HWCOUNT' ) {    
        dlog("hardware lpar is inactive");
        if ( defined $self->hwSwComposite ) {
            ###Add the hardware lpar to list to recon
            dlog("hardware lpar is in composite");
            $self->addToSoftwareLparsToRecon( $self->hwSwComposite->softwareLparId );

            ###Break the composite
            dlog("break composite");
            $self->hwSwComposite->delete( $self->connection );
        }

        return;
    }

    ###see if we can find a match
    my $matchType = $self->findSoftwareLparMatch;
    dlog("MatchType=$matchType");

    if ( defined $self->hwSwComposite ) {
        ###We are currently in a composite
        dlog("we are in a composite");

        if ( defined $matchType ) {
            ###We found a definitive unique match
            dlog("we have a match");

            if ( $self->softwareLpar->id eq $self->hwSwComposite->softwareLparId ) {
                ###Match is current
                dlog("match is current");

                if ( $matchType ne $self->hwSwComposite->matchMethod ) {
                    dlog("match method update");
                    $self->hwSwComposite->matchMethod($matchType);
                    $self->hwSwComposite->save( $self->connection );
                }

                $self->effectiveProcessorLogic;
            }
            else {
                ###Our software lpar has changed
                dlog("we have a new software lpar match");

                ###Update the composite
                dlog("save the composite");
                $self->hwSwComposite->softwareLparId( $self->softwareLpar->id );
                $self->hwSwComposite->matchMethod($matchType);
                $self->hwSwComposite->save( $self->connection );

                ###Run through the processor logic
                $self->effectiveProcessorLogic;

                ###We want to recon this one deep no matter what the effective tells us
                $self->addToSoftwareLparsToRecon( $self->hwSwComposite->softwareLparId );
            }
        }
        else {
            ###Nothing matched
            dlog("we have no match");

            ###Add the software lpar to list to recon
            $self->addToSoftwareLparsToRecon( $self->hwSwComposite->softwareLparId );

            ###Break the composite
            dlog("break composite");
            $self->hwSwComposite->delete( $self->connection );
        }
    }
    elsif ( defined $matchType &&  $self->softwareLpar->status eq 'ACTIVE' ) {
        ###We found a definitive unique match
        dlog("we have a match");

        dlog("saving composite");
        my $hwSwComposite = new BRAVO::OM::HardwareSoftwareComposite();
        $hwSwComposite->softwareLparId( $self->softwareLpar->id );
        $hwSwComposite->hardwareLparId( $self->hardwareLpar->id );
        $hwSwComposite->matchMethod($matchType);
        $hwSwComposite->save( $self->connection );

        $self->effectiveProcessorLogic;

        $self->addToSoftwareLparsToRecon( $self->softwareLpar->id );
    }
}

sub findSoftwareLparMatch {
    my $self = shift;

    ###Find a unique ext id match
    $self->findUniqueExtIdMatch;

    ###Return if we found one
    return 'EXT_ID' if ( defined $self->softwareLpar );

    ###Create the shortname
    my $shortName = ( split( /\./, $self->hardwareLpar->name ) )[0];

    ###populate potential matches
    $self->getSoftwareLparsByCustomerIdAndShortName( $shortName, $self->hardwareLpar->customerId );
    $self->getHardwareLparsByCustomerIdAndShortName( $shortName, $self->hardwareLpar->customerId );

    ###Find unique hostname matches
    $self->findUniqueHostnameMatches;
    return 'HOSTNAME' if ( defined $self->softwareLpar );

    ###Find unique shortname serial matches
    $self->findUniqueShortnameSerialMatches;
    return 'SHORTNAME_SERIAL' if ( defined $self->softwareLpar );

    ###Find unique shortname serial5 matches
    $self->findUniqueShortnameSerial5Matches;
    return 'SHORTNAME_SERIAL5' if ( defined $self->softwareLpar );

    ###Find unique shortname matches
    $self->findUniqueShortnameMatches;
    return 'SHORTNAME' if ( defined $self->softwareLpar );

    return undef;
}

########################################################################################################################
### Match methods
########################################################################################################################
sub checkSoftwareLpar {
    my ( $self, $matchType ) = @_;

    ###Get the composite for the lpar
    my $hwSwComposite = $self->populateBySoftwareLpar;

    ###Return if we are not in a composite
    return if !defined $hwSwComposite;

    dlog( $hwSwComposite->toString );

    ###Return if we are the same match
    if ( defined $self->hwSwComposite && $self->hwSwComposite->hardwareLparId eq $hwSwComposite->hardwareLparId ) {
        dlog("we are the same match");
        return;
    }

    ###Different lpar to our current match, so this must be a greater match
    if ( $self->matchTypes->{$matchType} > $self->matchTypes->{ $hwSwComposite->matchMethod } ) {
        dlog("different lpar...greater match");
        ###Add the software lpar to recon
        $self->addToHardwareLparsToRecon( $hwSwComposite->hardwareLparId );

        ###Break for we are a different match
        dlog("break composite");
        $hwSwComposite->delete( $self->connection );

        return;
    }

    ###Our proposed match type is less than the current, set the lpar to undef
    $self->softwareLpar(undef);

    return;
}

sub checkHardwareLpar {
    my ( $self, $matchType ) = @_;

    ###Get the composite for the lpar
    my $hwSwComposite = $self->populateByHardwareLpar;

    ###Return if we are not in a composite
    return if !defined $hwSwComposite;

    dlog( $hwSwComposite->toString );

    ###Return if we are the same match
    if ( defined $self->hwSwComposite && $self->hwSwComposite->softwareLparId eq $hwSwComposite->softwareLparId ) {
        dlog("same match");
        return;
    }

    ###Different lpar to our current match, so this must be a greater match
    if ( $self->matchTypes->{$matchType} > $self->matchTypes->{ $hwSwComposite->matchMethod } ) {
        dlog("different lpar..greater match");

        ###Add the software lpar to recon
        $self->addToSoftwareLparsToRecon( $hwSwComposite->softwareLparId );

        ###Break for we are a different match
        dlog("break composite");
        $hwSwComposite->delete( $self->connection );

        return;
    }

    ###Our proposed match type is less than the current, set the lpar to undef
    $self->hardwareLpar(undef);

    return;
}

###Match method #1
###Find unique ext_id match
sub findUniqueExtIdMatch {
    my $self = shift;
    
    # unfortunately, we are forced to use a completely different field for TADz matches, thus we have to check
    # if this is a valid TADz match based on SOFTWARE_LPAR.TECH_IMG_ID == HARDWARE_LPAR.TECH_IMG_ID
    if ( defined $self->hardwareLpar ) {
    	# check if techImgId exists and has a value
    	if ( defined $self->hardwareLpar->techImageId && ($self->hardwareLpar->techImageId !~ /^\s*$/ ) ) {
    		# check to see if a match exists in the software_lpar table
    		my $softwareLpar = $self->getSoftwareLparByTechImgId($self->hardwareLpar->techImageId, $self->hardwareLpar->customerId );
    		if ( defined $softwareLpar ) {
        		my $hardwareLpar = $self->getHardwareLparByTechImgId( $self->hardwareLpar->techImageId, $self->hardwareLpar->customerId );
       			if ( defined $hardwareLpar ) {
        			$self->softwareLpar($softwareLpar);
        			$self->checkSoftwareLpar('EXT_ID');
        			return;       				
       			}
    			
    		}
    		
    	}

    } elsif ( defined $self->softwareLpar ) {
    	# check if techImgId exists and it is four characters long
    	if ( defined $self->softwareLpar->techImgId && ($self->softwareLpar->techImgId !~ /^\s*$/ ) ) {
    		# check to see if a match exists in the software_lpar table
    		my $hardwareLpar = $self->getHardwareLparByTechImgId($self->softwareLpar->techImgId, $self->softwareLpar->customerId );
    		if ( defined $hardwareLpar ) {
        		my $softwareLpar = $self->getSoftwareLparByTechImgId( $self->softwareLpar->techImgId, $self->softwareLpar->customerId );
       			if ( defined $softwareLpar ) {
        			$self->hardwareLpar($hardwareLpar);
        			$self->checkHardwareLpar('EXT_ID');
        			return;       				
       			}
    			
    		}
    		
    	}
    	
    }
    # types of matches because we are NOT tadz
    # END TADz techImgId matching logic

    if ( defined $self->hardwareLpar ) {
        return if ( !defined $self->hardwareLpar->extId || $self->hardwareLpar->extId eq '' );

        my $softwareLpar = $self->getSoftwareLparByExtId( $self->hardwareLpar->extId, $self->hardwareLpar->customerId );
        return if ( !defined $softwareLpar );

        my $hardwareLpar = $self->getHardwareLparByExtId( $self->hardwareLpar->extId, $self->hardwareLpar->customerId );
        return if ( !defined $hardwareLpar );

        $self->softwareLpar($softwareLpar);

        $self->checkSoftwareLpar('EXT_ID');

        return;
    }
    else {
        return if ( !defined $self->softwareLpar->extId || $self->softwareLpar->extId eq '' );

        my $hardwareLpar = $self->getHardwareLparByExtId( $self->softwareLpar->extId, $self->softwareLpar->customerId );
        return if ( !defined $hardwareLpar );

        my $softwareLpar = $self->getSoftwareLparByExtId( $self->softwareLpar->extId, $self->softwareLpar->customerId );
        return if ( !defined $softwareLpar );

        $self->hardwareLpar($hardwareLpar);

        $self->checkHardwareLpar('EXT_ID');

        return;
    }
}

sub findUniqueHostnameMatches {
    my $self = shift;

    return if ( scalar keys %{ $self->softwareLpars } == 0 );
    return if ( scalar keys %{ $self->hardwareLpars } == 0 );

    if ( defined $self->hardwareLpar ) {
        my $softwareLpar = $self->getSoftwareLparByHostname( $self->hardwareLpar->name );
        return if ( !defined $softwareLpar );

        my $hardwareLpar = $self->getHardwareLparByHostname( $self->hardwareLpar->name );
        return if ( !defined $hardwareLpar );

        $self->softwareLpar($softwareLpar);

        $self->checkSoftwareLpar('HOSTNAME');

        return;
    }
    else {
        my $hardwareLpar = $self->getHardwareLparByHostname( $self->softwareLpar->name );
        return if ( !defined $hardwareLpar );

        my $softwareLpar = $self->getSoftwareLparByHostname( $self->softwareLpar->name );
        return if ( !defined $softwareLpar );

        $self->hardwareLpar($hardwareLpar);

        $self->checkHardwareLpar('HOSTNAME');

        return;
    }
}

sub findUniqueShortnameSerialMatches {
    my $self = shift;

    return if ( scalar keys %{ $self->softwareLpars } == 0 );
    return if ( scalar keys %{ $self->hardwareLpars } == 0 );

    if ( defined $self->hardwareLpar ) {
        my $softwareLpar = $self->getSoftwareLparByShortnameSerial( $self->hardware->serial );
        return if ( !defined $softwareLpar );

        my $hardwareLpar = $self->getHardwareLparByShortnameSerial( $self->hardware->serial );
        return if ( !defined $hardwareLpar );

        $self->softwareLpar($softwareLpar);

        $self->checkSoftwareLpar('SHORTNAME_SERIAL');

        return;
    }
    else {
        my $hardwareLpar = $self->getHardwareLparByShortnameSerial( $self->softwareLpar->biosSerial );
        return if ( !defined $hardwareLpar );

        my $softwareLpar = $self->getSoftwareLparByShortnameSerial( $self->softwareLpar->biosSerial );
        return if ( !defined $softwareLpar );

        $self->hardwareLpar($hardwareLpar);

        $self->checkHardwareLpar('SHORTNAME_SERIAL');

        return;
    }
}

sub findUniqueShortnameSerial5Matches {
    my $self = shift;

    return if ( scalar keys %{ $self->softwareLpars } == 0 );
    return if ( scalar keys %{ $self->hardwareLpars } == 0 );

    if ( defined $self->hardwareLpar ) {
        my $serial5 = substr( $self->hardware->serial, -5, 5 );

        my $softwareLpar = $self->getSoftwareLparByShortnameSerial5($serial5);
        return if ( !defined $softwareLpar );

        my $hardwareLpar = $self->getHardwareLparByShortnameSerial5($serial5);
        return if ( !defined $hardwareLpar );

        $self->softwareLpar($softwareLpar);

        $self->checkSoftwareLpar('SHORTNAME_SERIAL5');

        return;
    }
    else {
        my $serial5 = substr( $self->softwareLpar->biosSerial, -5, 5 );
        my $hardwareLpar = $self->getHardwareLparByShortnameSerial5($serial5);
        return if ( !defined $hardwareLpar );

        my $softwareLpar = $self->getSoftwareLparByShortnameSerial5($serial5);
        return if ( !defined $softwareLpar );

        $self->hardwareLpar($hardwareLpar);

        $self->checkHardwareLpar('SHORTNAME_SERIAL5');

        return;
    }
}

sub findUniqueShortnameMatches {
    my $self = shift;

    return if ( scalar keys %{ $self->softwareLpars } == 0 );
    return if ( scalar keys %{ $self->hardwareLpars } == 0 );

    if ( defined $self->hardwareLpar ) {

        my $softwareLpar = $self->getSoftwareLparByShortname;
        return if ( !defined $softwareLpar );

        my $hardwareLpar = $self->getHardwareLparByShortname;
        return if ( !defined $hardwareLpar );

        $self->softwareLpar($softwareLpar);

        $self->checkSoftwareLpar('SHORTNAME');

        return;
    }
    else {

        my $hardwareLpar = $self->getHardwareLparByShortname;
        return if ( !defined $hardwareLpar );

        my $softwareLpar = $self->getSoftwareLparByShortname;
        return if ( !defined $softwareLpar );

        $self->hardwareLpar($hardwareLpar);

        $self->checkHardwareLpar('SHORTNAME');

        return;
    }
}

sub getSoftwareLparByHostname {
    my ( $self, $hostname ) = @_;

    my $count = 0;
    my $softwareLpar;

    foreach my $id ( keys %{ $self->softwareLpars } ) {

        if ( $hostname eq $self->softwareLpars->{$id}->name ) {
            $count++;
            $softwareLpar = $self->softwareLpars->{$id};
        }

    }

    return undef if ( $count == 0 || $count > 1 );

    return $softwareLpar;
}

sub getHardwareLparByHostname {
    my ( $self, $hostname ) = @_;

    my $count = 0;
    my $hardwareLpar;

    foreach my $id ( keys %{ $self->hardwareLpars } ) {

        if ( $hostname eq $self->hardwareLpars->{$id}->name ) {
            $count++;
            $hardwareLpar = $self->hardwareLpars->{$id};
        }

    }

    return undef if ( $count == 0 || $count > 1 );

    return $hardwareLpar;
}

sub getSoftwareLparByShortnameSerial {
    my ( $self, $serial ) = @_;

    my $count = 0;
    my $softwareLpar;

    foreach my $id ( keys %{ $self->softwareLpars } ) {

        next if ( !defined $self->softwareLpars->{$id}->biosSerial );
        next if ( $self->softwareLpars->{$id}->biosSerial eq '' );

        if ( $serial eq $self->softwareLpars->{$id}->biosSerial ) {
            $count++;
            $softwareLpar = $self->softwareLpars->{$id};
        }

    }

    return undef if ( $count == 0 || $count > 1 );

    return $softwareLpar;
}

sub getHardwareLparByShortnameSerial {
    my ( $self, $serial ) = @_;

    my $count = 0;
    my $hardwareLpar;

    foreach my $id ( keys %{ $self->hardwareLpars } ) {

        my $hardware = new BRAVO::OM::Hardware();
        $hardware->id( $self->hardwareLpars->{$id}->hardwareId );
        $hardware->getById( $self->connection );

        if ( $serial eq $hardware->serial ) {
            $count++;
            $hardwareLpar = $self->hardwareLpars->{$id};
        }

    }

    return undef if ( $count == 0 || $count > 1 );

    return $hardwareLpar;
}

sub getSoftwareLparByShortnameSerial5 {
    my ( $self, $serial5 ) = @_;

    my $count = 0;
    my $softwareLpar;

    foreach my $id ( keys %{ $self->softwareLpars } ) {

        next if ( !defined $self->softwareLpars->{$id}->biosSerial );
        next if ( $self->softwareLpars->{$id}->biosSerial eq '' );

        if ( $serial5 eq substr( $self->softwareLpars->{$id}->biosSerial, -5, 5 ) ) {
            $count++;
            $softwareLpar = $self->softwareLpars->{$id};
        }

    }

    return undef if ( $count == 0 || $count > 1 );

    return $softwareLpar;
}

sub getHardwareLparByShortnameSerial5 {
    my ( $self, $serial5 ) = @_;

    my $count = 0;
    my $hardwareLpar;

    foreach my $id ( keys %{ $self->hardwareLpars } ) {

        my $hardware = new BRAVO::OM::Hardware();
        $hardware->id( $self->hardwareLpars->{$id}->hardwareId );
        $hardware->getById( $self->connection );

        if ( $serial5 eq substr( $hardware->serial, -5, 5 ) ) {
            $count++;
            $hardwareLpar = $self->hardwareLpars->{$id};
        }

    }

    return undef if ( $count == 0 || $count > 1 );

    return $hardwareLpar;
}

sub getSoftwareLparByShortname {
    my $self = shift;

    my $count = 0;
    my $softwareLpar;

    foreach my $id ( keys %{ $self->softwareLpars } ) {
        $count++;
        $softwareLpar = $self->softwareLpars->{$id};
    }

    return undef if ( $count == 0 || $count > 1 );

    return $softwareLpar;
}

sub getHardwareLparByShortname {
    my ( $self, $serial5 ) = @_;

    my $count = 0;
    my $hardwareLpar;

    foreach my $id ( keys %{ $self->hardwareLpars } ) {
        $count++;
        $hardwareLpar = $self->hardwareLpars->{$id};
    }

    return undef if ( $count == 0 || $count > 1 );

    return $hardwareLpar;
}

########################################################################################################################
### Match method queries
########################################################################################################################

# TADz techImgId specific queries
sub getSoftwareLparByTechImgId {
	my ( $self, $techImgId, $customerId ) = @_;
    ###method variables
    my @fields;
    my %rec;

    ###prepare query
    $self->connection->prepareSqlQueryAndFields( $self->querySoftwareLparByTechImgId() );

    ###access statement handle
    my $sth = $self->connection->sql->{softwareLparByTechImgId};

    ###Bind columns
    $sth->bind_columns( map { \$rec{$_} } @{ $self->connection->sql->{softwareLparByTechImgIdFields} } );

    ###Execute query
    $sth->execute( $customerId, $techImgId );

    ###Setup counter
    my $count = 0;

    ###Loop through results
    while ( $sth->fetchrow_arrayref ) {
        $count++;
    }
    ###End loop

    ###close statement handle
    $sth->finish;

    return undef if ( $count == 0 || $count > 1 );

    my $softwareLpar = new BRAVO::OM::SoftwareLpar();
    $softwareLpar->id( $rec{id} );
    $softwareLpar->getById( $self->connection );

    return $softwareLpar;
	
}

sub querySoftwareLparByTechImgId {
    my @fields = (qw( id ));

    my $query = qq{
        select
            sl.id
        from 
            software_lpar sl
        where 
            sl.customer_id = ?
            and sl.tech_img_id = ?
            and sl.status = 'ACTIVE'
    };

    return ( 'softwareLparByTechImgId', $query, \@fields );
}

sub getHardwareLparByTechImgId {
    my ( $self, $techImgId, $customerId ) = @_;

    ###method variables
    my @fields;
    my %rec;

    ###prepare query
    $self->connection->prepareSqlQueryAndFields( $self->queryHardwareLparByTechImgId() );

    ###access statement handle
    my $sth = $self->connection->sql->{hardwareLparByTechImgId};

    ###Bind columns
    $sth->bind_columns( map { \$rec{$_} } @{ $self->connection->sql->{hardwareLparByTechImgIdFields} } );

    ###Execute query
    $sth->execute( $customerId, $techImgId );

    ###Setup counter
    my $count = 0;

    ###Loop through results
    while ( $sth->fetchrow_arrayref ) {
        $count++;
    }
    ###End loop

    ###close statement handle
    $sth->finish;

    return undef if ( $count == 0 || $count > 1 );

    my $hardwareLpar = new BRAVO::OM::HardwareLpar();
    $hardwareLpar->id( $rec{id} );
    $hardwareLpar->getById( $self->connection );

    return $hardwareLpar;
}

sub queryHardwareLparByTechImgId {
    my @fields = (qw( id ));

    my $query = qq{
        select
            hl.id
        from 
            hardware_lpar hl
        where 
            hl.customer_id = ?
            and hl.tech_image_id = ?
            and hl.status = 'ACTIVE'
    };

    return ( 'hardwareLparByTechImgId', $query, \@fields );
}


# end TADz specific queries

sub getSoftwareLparByExtId {
    my ( $self, $extId, $customerId ) = @_;

    ###method variables
    my @fields;
    my %rec;

    ###prepare query
    $self->connection->prepareSqlQueryAndFields( $self->querySoftwareLparByExtId() );

    ###access statement handle
    my $sth = $self->connection->sql->{softwareLparByExtId};

    ###Bind columns
    $sth->bind_columns( map { \$rec{$_} } @{ $self->connection->sql->{softwareLparByExtIdFields} } );

    ###Execute query
    $sth->execute( $customerId, $extId );

    ###Setup counter
    my $count = 0;

    ###Loop through results
    while ( $sth->fetchrow_arrayref ) {
        $count++;
    }
    ###End loop

    ###close statement handle
    $sth->finish;

    return undef if ( $count == 0 || $count > 1 );

    my $softwareLpar = new BRAVO::OM::SoftwareLpar();
    $softwareLpar->id( $rec{id} );
    $softwareLpar->getById( $self->connection );

    return $softwareLpar;
}

sub querySoftwareLparByExtId {
    my @fields = (qw( id ));

    my $query = qq{
        select
            sl.id
        from 
            software_lpar sl
        where 
            sl.customer_id = ?
            and sl.ext_id = ?
            and sl.status = 'ACTIVE'
    };

    return ( 'softwareLparByExtId', $query, \@fields );
}

sub getHardwareLparByExtId {
    my ( $self, $extId, $customerId ) = @_;

    ###method variables
    my @fields;
    my %rec;

    ###prepare query
    $self->connection->prepareSqlQueryAndFields( $self->queryHardwareLparByExtId() );

    ###access statement handle
    my $sth = $self->connection->sql->{hardwareLparByExtId};

    ###Bind columns
    $sth->bind_columns( map { \$rec{$_} } @{ $self->connection->sql->{hardwareLparByExtIdFields} } );

    ###Execute query
    $sth->execute( $customerId, $extId );

    ###Setup counter
    my $count = 0;

    ###Loop through results
    while ( $sth->fetchrow_arrayref ) {
        $count++;
    }
    ###End loop

    ###close statement handle
    $sth->finish;

    return undef if ( $count == 0 || $count > 1 );

    my $hardwareLpar = new BRAVO::OM::HardwareLpar();
    $hardwareLpar->id( $rec{id} );
    $hardwareLpar->getById( $self->connection );

    return $hardwareLpar;
}

sub queryHardwareLparByExtId {
    my @fields = (qw( id ));

    my $query = qq{
        select
            hl.id
        from 
            hardware_lpar hl
        where 
            hl.customer_id = ?
            and hl.ext_id = ?
            and hl.status = 'ACTIVE'
    };

    return ( 'hardwareLparByExtId', $query, \@fields );
}

sub getSoftwareLparsByCustomerIdAndShortName {
    my ( $self, $shortName, $customerId ) = @_;

    ###Initialize software lpars hash
    my %softwareLpars = ();

    ###Escape any underscores to avoid use as wildcard.
    my $shortNameForLike = $shortName;
    $shortNameForLike =~ s/\\/\\\\/g;
    $shortNameForLike =~ s/_/\\_/g;

    ###Prepare and execute the necessary sql
    $self->connection->prepareSqlQueryAndFields( $self->querySwLparByCustomerIdAndShortName() );
    my $sth = $self->connection->sql->{swLparsByCustomerIdAndShortName};
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @{ $self->connection->sql->{swLparsByCustomerIdAndShortNameFields} } );
    $sth->execute( $customerId, $shortName, $shortNameForLike . '.%' );
    while ( $sth->fetchrow_arrayref ) {

        ###Get the lpar object.
        my $softwareLpar = new BRAVO::OM::SoftwareLpar();
        $softwareLpar->id( $rec{id} );
        $softwareLpar->getById( $self->connection );

        ###Add to the list.
        $softwareLpars{ $rec{id} } = $softwareLpar;
    }
    $sth->finish;

    $self->softwareLpars( \%softwareLpars );
}

sub querySwLparByCustomerIdAndShortName {
    my @fields = (qw( id ));
    my $query  = '
        select
            a.id
        from
            software_lpar a
        where
            a.customer_id = ?
            and (a.name = ? or a.name like ? escape \'\\\')
            and a.status = \'ACTIVE\'
    ';

    return ( 'swLparsByCustomerIdAndShortName', $query, \@fields );
}

sub getHardwareLparsByCustomerIdAndShortName {
    my ( $self, $shortName, $customerId ) = @_;

    my %hardwareLpars = ();

    ###Escape any underscores to avoid use as wildcard.
    dlog( "shortName=" . $shortName );
    my $shortNameForLike = $shortName;
    $shortNameForLike =~ s/\\/\\\\/g;
    $shortNameForLike =~ s/_/\\_/g;
    dlog( "shortNameForLike=" . $shortNameForLike );

    ###Prepare and execute the necessary sql
    $self->connection->prepareSqlQueryAndFields( $self->queryHwLparByCustomerIdAndShortName() );
    my $sth = $self->connection->sql->{hwLparsByCustomerIdAndShortName};
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @{ $self->connection->sql->{hwLparsByCustomerIdAndShortNameFields} } );
    $sth->execute( $customerId, $shortName, $shortNameForLike . '.%' );
    while ( $sth->fetchrow_arrayref ) {

        ###Get the lpar object.
        my $hardwareLpar = new BRAVO::OM::HardwareLpar();
        $hardwareLpar->id( $rec{id} );
        $hardwareLpar->getById( $self->connection );

        ###Add to the list.
        $hardwareLpars{ $rec{id} } = $hardwareLpar;
        dlog( "added id=" . $rec{id} );
    }
    $sth->finish;

    $self->hardwareLpars( \%hardwareLpars );
}

sub queryHwLparByCustomerIdAndShortName {
    my @fields = (qw( id ));

    my $query = '
        select
            a.id
        from
            hardware_lpar a
        where
            a.customer_id = ?
            and (a.name = ? or a.name like ? escape \'\\\')
            and a.status = \'ACTIVE\'
    ';
    return ( 'hwLparsByCustomerIdAndShortName', $query, \@fields );
}

########################################################################################################################
### Effective processor logic
########################################################################################################################

sub effectiveProcessorLogic {
    my $self = shift;

    my $softwareLparEff = new BRAVO::OM::SoftwareLparEff();
    $softwareLparEff->softwareLparId( $self->softwareLpar->id );
    $softwareLparEff->getByBizKey( $self->connection );

    my $hardwareLparEff = new BRAVO::OM::HardwareLparEff();
    if ( defined $self->hardwareLpar ) {
        $hardwareLparEff->hardwareLparId( $self->hardwareLpar->id );
        $hardwareLparEff->getByBizKey( $self->connection );
    }

    if ( defined $hardwareLparEff->id ) {
        ###New effective processor is defined

        if ( defined $softwareLparEff->id ) {
            ###Current effective processor is defined

            if ( $hardwareLparEff->status eq 'ACTIVE' ) {
                ###New effective processor is active

                if ( $softwareLparEff->status eq 'ACTIVE' ) {
                    ###Current effective processor is active

                    if (    $hardwareLparEff->processorCount != $softwareLparEff->processorCount
                         && $softwareLparEff->remoteUser eq 'ATP' )
                    {
                        ###Current effective processor is not equal to new and was updated from ATP
                        $softwareLparEff->processorCount( $hardwareLparEff->processorCount );
                        $softwareLparEff->save( $self->connection );

                        my $effProcHistory = new BRAVO::OM::SoftwareLparEffHistory();
                        $effProcHistory->effProcId( $softwareLparEff->id );
                        $effProcHistory->processorCount( $softwareLparEff->processorCount );
                        $effProcHistory->status('ACTIVE');
                        $effProcHistory->action('Update');
                        $effProcHistory->save( $self->connection );

                        $self->addToSoftwareLparsToRecon( $self->softwareLpar->id );
                        $self->reconDeep(1);
                    }
                }
                else {
                    ###Current effective processor is inactive
                    $softwareLparEff->processorCount( $hardwareLparEff->processorCount );
                    $softwareLparEff->status('ACTIVE');
                    $softwareLparEff->save( $self->connection );

                    my $effProcHistory = new BRAVO::OM::SoftwareLparEffHistory();
                    $effProcHistory->effProcId( $softwareLparEff->id );
                    $effProcHistory->processorCount( $softwareLparEff->processorCount );
                    $effProcHistory->status('ACTIVE');
                    $effProcHistory->action('Create');
                    $effProcHistory->save( $self->connection );

                    $self->addToSoftwareLparsToRecon( $self->softwareLpar->id );
                    $self->reconDeep(1);
                }
            }
            elsif ( $softwareLparEff->status eq 'ACTIVE' && $softwareLparEff->remoteUser eq 'ATP' ) {
                ###New effective processor is inactive and old is active and updated from ATP
                $softwareLparEff->status('INACTIVE');
                $softwareLparEff->save( $self->connection );

                my $effProcHistory = new BRAVO::OM::SoftwareLparEffHistory();
                $effProcHistory->effProcId( $softwareLparEff->id );
                $effProcHistory->processorCount( $softwareLparEff->processorCount );
                $effProcHistory->status('INACTIVE');
                $effProcHistory->action('Update');
                $effProcHistory->save( $self->connection );

                $self->addToSoftwareLparsToRecon( $self->softwareLpar->id );
                $self->reconDeep(1);
            }
        }
        elsif ( $hardwareLparEff->status eq 'ACTIVE' ) {
            ###Current effective processor is not defined and new is active
            $softwareLparEff->processorCount( $hardwareLparEff->processorCount );
            $softwareLparEff->status('ACTIVE');
            $softwareLparEff->save( $self->connection );

            my $effProcHistory = new BRAVO::OM::SoftwareLparEffHistory();
            $effProcHistory->effProcId( $softwareLparEff->id );
            $effProcHistory->processorCount( $softwareLparEff->processorCount );
            $effProcHistory->status('ACTIVE');
            $effProcHistory->action('Update');
            $effProcHistory->save( $self->connection );

            $self->addToSoftwareLparsToRecon( $self->softwareLpar->id );
            $self->reconDeep(1);
        }
    }
    elsif (    defined $softwareLparEff->id
            && $softwareLparEff->status     eq 'ACTIVE'
            && $softwareLparEff->remoteUser eq 'ATP' )
    {
        ###Current is active and was updated from ATP
        $softwareLparEff->status('INACTIVE');
        $softwareLparEff->save( $self->connection );

        my $effProcHistory = new BRAVO::OM::SoftwareLparEffHistory();
        $effProcHistory->effProcId( $softwareLparEff->id );
        $effProcHistory->processorCount( $softwareLparEff->processorCount );
        $effProcHistory->status('INACTIVE');
        $effProcHistory->action('Update');
        $effProcHistory->save( $self->connection );

        $self->addToSoftwareLparsToRecon( $self->softwareLpar->id );
        $self->reconDeep(1);
    }
}

########################################################################################################################
### Object populate methods
########################################################################################################################

###This populates the appropriate objects
sub populate {
    my $self = shift;

    $self->hwSwComposite( $self->populateByHardwareLpar );
    $self->hwSwComposite( $self->populateBySoftwareLpar ) if !defined $self->hwSwComposite;
    $self->hardware( $self->populateHardware );
}

sub populateBySoftwareLpar {
    my $self = shift;

    return undef if !defined $self->softwareLpar;

    ###method variables
    my @fields;
    my %rec;

    ###prepare query
    $self->connection->prepareSqlQueryAndFields( $self->queryGetBySoftwareLpar() );

    ###access statement handle
    my $sth = $self->connection->sql->{getBySoftwareLpar};

    ###bind columns
    $sth->bind_columns( map { \$rec{$_} } @{ $self->connection->sql->{getBySoftwareLparFields} } );

    ###execute query
    $sth->execute( $self->softwareLpar->id );
    $sth->fetchrow_arrayref;

    ###close statement handle
    $sth->finish;

    return if !defined $rec{id};

    ###Assign remaining attributes
    my $hwSwComposite = new BRAVO::OM::HardwareSoftwareComposite();
    $hwSwComposite->id( $rec{id} );
    $hwSwComposite->hardwareLparId( $rec{hardwareLparId} );
    $hwSwComposite->softwareLparId( $self->softwareLpar->id );
    $hwSwComposite->matchMethod( $rec{matchMethod} );

    return $hwSwComposite;
}

sub queryGetBySoftwareLpar {

    my @fields = qw(
      id
      hardwareLparId
      matchMethod
    );

    my $query = qq{
      select
          a.id
          ,a.hardware_lpar_id
          ,a.match_method
      from
          hw_sw_composite a
      where
          a.software_lpar_id = ?
    };

    return ( 'getBySoftwareLpar', $query, \@fields );
}

sub populateByHardwareLpar {
    my $self = shift;

    return undef if !defined $self->hardwareLpar;

    ###method variables
    my @fields;
    my %rec;

    ###prepare query
    $self->connection->prepareSqlQueryAndFields( $self->queryGetByHardwareLpar() );

    ###access statement handle
    my $sth = $self->connection->sql->{getByHardwareLpar};

    ###bind columns
    $sth->bind_columns( map { \$rec{$_} } @{ $self->connection->sql->{getByHardwareLparFields} } );

    ###execute query
    $sth->execute( $self->hardwareLpar->id );
    $sth->fetchrow_arrayref;

    ###close statement handle
    $sth->finish;

    return if !defined $rec{id};

    ###Assign remaining attributes
    my $hwSwComposite = new BRAVO::OM::HardwareSoftwareComposite();
    $hwSwComposite->id( $rec{id} );
    $hwSwComposite->hardwareLparId( $self->hardwareLpar->id );
    $hwSwComposite->softwareLparId( $rec{softwareLparId} );
    $hwSwComposite->matchMethod( $rec{matchMethod} );

    return $hwSwComposite;
}

sub queryGetByHardwareLpar {

    my @fields = qw(
      id
      softwareLparId
      matchMethod
    );

    my $query = qq{
      select
          a.id
          ,a.software_lpar_id
          ,a.match_method
      from
          hw_sw_composite a
      where
          a.hardware_lpar_id = ?
    };

    return ( 'getByHardwareLpar', $query, \@fields );
}

sub populateHardware {
    my $self = shift;

    return if !defined $self->hardwareLpar;

    my $hardware = new BRAVO::OM::Hardware();
    $hardware->id( $self->hardwareLpar->hardwareId );
    $hardware->getById( $self->connection );

    return $hardware;
}

########################################################################################################################
### Class methods
########################################################################################################################

###Holds the database connection
sub connection {
    my $self = shift;
    $self->{_connection} = shift if scalar @_ == 1;
    return $self->{_connection};
}

###If we are performing a recon from the hardware lpar
###This must be populated initially, else it will
###Populate if there is a match found
sub hardwareLpar {
    my $self = shift;
    $self->{_hardwareLpar} = shift if scalar @_ == 1;
    return $self->{_hardwareLpar};
}

###If we are performing a recon from the software lpar
###This must be populated initially, else it will
###Populate if there is a match found
sub softwareLpar {
    my $self = shift;
    $self->{_softwareLpar} = shift if scalar @_ == 1;
    return $self->{_softwareLpar};
}

###This will be populated if a composite exists
###And should only be populated through use of the
###populate method
sub hwSwComposite {
    my $self = shift;
    $self->{_hwSwComposite} = shift if scalar @_ == 1;
    return $self->{_hwSwComposite};
}

###This will be populated from the populate method
###If this is a recon being performed from the
###Hardware lpar
sub hardware {
    my $self = shift;
    $self->{_hardware} = shift if scalar @_ == 1;
    return $self->{_hardware};
}

###Holds the potential list of hardware lpar matches
###Based on shortname
sub hardwareLpars {
    my $self = shift;
    $self->{_hardwareLpars} = shift if scalar @_ == 1;
    return $self->{_hardwareLpars};
}

###Holds the potential list of software lpar matches
###Based on shortname
sub softwareLpars {
    my $self = shift;
    $self->{_softwareLpars} = shift if scalar @_ == 1;
    return $self->{_softwareLpars};
}

sub hardwareLparsToRecon {
    my $self = shift;
    $self->{_hardwareLparsToRecon} = shift if scalar @_ == 1;
    return $self->{_hardwareLparsToRecon};
}

###Holds the potential list of software lpar matches
###Based on shortname
sub softwareLparsToRecon {
    my $self = shift;
    $self->{_softwareLparsToRecon} = shift if scalar @_ == 1;
    return $self->{_softwareLparsToRecon};
}

###Tells us to recon the installed software
sub reconDeep {
    my $self = shift;
    $self->{_reconDeep} = shift if scalar @_ == 1;
    return $self->{_reconDeep};
}

sub addToHardwareLparsToRecon {
    my ( $self, $id ) = @_;

    my $hash = $self->hardwareLparsToRecon;
    $hash->{$id} = 1;

    $self->hardwareLparsToRecon($hash);
}

sub addToSoftwareLparsToRecon {
    my ( $self, $id ) = @_;

    my $hash = $self->softwareLparsToRecon;
    $hash->{$id} = 1;

    $self->softwareLparsToRecon($hash);
}

sub performAdditionalRecons {
    my $self = shift;

    if ( defined $self->hardwareLparsToRecon ) {
        foreach my $id ( keys %{ $self->hardwareLparsToRecon } ) {
            my $hardwareLpar = new BRAVO::OM::HardwareLpar();
            $hardwareLpar->id($id);
            $hardwareLpar->getById( $self->connection );

            my $recon = Recon::HardwareLpar->new( $self->connection, $hardwareLpar, "UPDATE" );
            $recon->recon;
        }
    }

    if ( defined $self->softwareLparsToRecon ) {
        foreach my $id ( keys %{ $self->softwareLparsToRecon } ) {
            my $softwareLpar = new BRAVO::OM::SoftwareLpar();
            $softwareLpar->id($id);
            $softwareLpar->getById( $self->connection );

            my $recon = Recon::SoftwareLpar->new( $self->connection, $softwareLpar );
            $recon->reconDeep(1);
            $recon->recon;
        }
    }
}

sub matchTypes {
    my $self = shift;

    my %matchTypes = ( "EXT_ID", 4, "HOSTNAME", 3, "SHORTNAME_SERIAL", 2, "SHORTNAME_SERIAL5", 1 );

    return \%matchTypes;
}

1;
