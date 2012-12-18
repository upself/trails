package Staging::Delegate::MappingService;

use Storable;
use strict;

use Base::Utils;
use CNDB::Delegate::CNDBDelegate;
use BRAVO::Delegate::BRAVODelegate;
use Staging::Delegate::HardwareLparDelegate;
use Database::Connection;

sub new {
	my ($class) = @_;

	my $self = {
		_hwLparMap       => undef,
		_suffix          => undef,
		_prefix          => undef,
		_objectIdMap     => undef,
		_nameMap         => undef,
		_namePrefixMap   => undef,
		_customerAcctMap => undef,
		_inclusionMap    => undef,
		_rootPath        => '/var/staging/mappings/'
	};

	bless $self, $class;

	$self->needUpdate(0);

	return $self;
}

sub hwLparMap {
	my ( $self, $value ) = @_;
	$self->{_hwLparMap} = $value if defined($value);
	return ( $self->{_hwLparMap} );
}

sub suffix {
	my ( $self, $value ) = @_;
	$self->{_suffix} = $value if defined($value);
	return ( $self->{_suffix} );
}

sub prefix {
	my ( $self, $value ) = @_;
	$self->{_prefix} = $value if defined($value);
	return ( $self->{_prefix} );
}

sub objectIdMap {
	my ( $self, $value ) = @_;
	$self->{_objectIdMap} = $value if defined($value);
	return ( $self->{_objectIdMap} );
}

sub nameMap {
	my ( $self, $value ) = @_;
	$self->{_nameMap} = $value if defined($value);
	return ( $self->{_nameMap} );
}

sub namePrefixMap {
	my ( $self, $value ) = @_;
	$self->{_namePrefixMap} = $value if defined($value);
	return ( $self->{_namePrefixMap} );
}

sub customerAcctMap {
	my ( $self, $value ) = @_;
	$self->{_customerAcctMap} = $value if defined($value);
	return ( $self->{_customerAcctMap} );
}

sub inclusionMap {
	my ( $self, $value ) = @_;
	$self->{_inclusionMap} = $value if defined($value);
	return ( $self->{_inclusionMap} );
}

sub rootPath {
	my ( $self, $value ) = @_;
	$self->{_rootPath} = $value if defined($value);
	return ( $self->{_rootPath} );
}

sub init {
	my $self = shift;

	$self->suffix( $self->retrieveMap('suffix') )
	  if !defined $self->suffix;

	$self->hwLparMap( $self->retrieveMap('hwLparMap') )
	  if !defined $self->hwLparMap;

	$self->prefix( $self->retrieveMap('prefix') )
	  if !defined $self->prefix;

	$self->objectIdMap( $self->retrieveMap('objectIdMap') )
	  if !defined $self->objectIdMap;

	$self->nameMap( $self->retrieveMap('nameMap') )
	  if !defined $self->nameMap;

	$self->namePrefixMap( $self->retrieveMap('namePrefixMap') )
	  if !defined $self->namePrefixMap;

	$self->customerAcctMap( $self->retrieveMap('customerAcctMap') )
	  if !defined $self->customerAcctMap;

	$self->inclusionMap( $self->retrieveMap('inclusionMap') )
	  if !defined $self->inclusionMap;
}

sub filePath {

	my $self = shift;

	my %data = undef;

	$data{'hwLparMap'} = $self->rootPath . 'hwLparMap';

	$data{'suffix'}          = $self->rootPath . 'suffix';
	$data{'prefix'}          = $self->rootPath . 'prefix';
	$data{'objectIdMap'}     = $self->rootPath . 'objectIdMap';
	$data{'nameMap'}         = $self->rootPath . 'nameMap';
	$data{'namePrefixMap'}   = $self->rootPath . 'namePrefixMap';
	$data{'customerAcctMap'} = $self->rootPath . 'customerAcctMap';

	$data{'inclusionMap'} = $self->rootPath . 'inclusionMap';

	return \%data;
}

sub prepareMappings {

	my $self = shift;

	ilog(' Acquiring the staging connection ');
	my $stagingConnection = Database::Connection->new('staging');
	ilog(' Staging connection acquired ');
	ilog(' Acquiring the bravo connection ');
	my $bravoConnection = Database::Connection->new('trails');
	ilog(' Bravo connection acquired ');

	dlog(' Start prepareMappings method ');
	ilog(' Obtaining hardware lpar map ');
	my $hwLparMap =
	  HardwareLparDelegate->getHardwareLparCustomerMap($stagingConnection);
	ilog(' Obtained hardware lpar map ');

	ilog(' Obtaining customer map ');
	my ( $suffix, $prefix, $objectIdMap, $nameMap, $namePrefixMap,
		$customerAcctMap )
	  = CNDB::Delegate::CNDBDelegate->getCustomerMaps();
	ilog(' Obtained customer map ');

	ilog(' Obtaining bank account inclusion map ');
	my $inclusionMap =
	  BRAVO::Delegate::BRAVODelegate->getBankAccountInclusionMap(
		$bravoConnection);
	ilog(' Obtained bank account exception map ');

	dlog(' End prepareMappings method ');

	my $fileMapsRef = $self->filePath;

	###presistence the maps into physical files.
	dlog(' Start of mapping presistence ');
	store $hwLparMap, $fileMapsRef->{'hwLparMap'};

	store $suffix,          $fileMapsRef->{'suffix'};
	store $prefix,          $fileMapsRef->{'prefix'};
	store $objectIdMap,     $fileMapsRef->{'objectIdMap'};
	store $nameMap,         $fileMapsRef->{'nameMap'};
	store $namePrefixMap,   $fileMapsRef->{'namePrefixMap'};
	store $customerAcctMap, $fileMapsRef->{'customerAcctMap'};

	store $inclusionMap, $fileMapsRef->{'inclusionMap'};
	dlog(' End of mapping presistence ');
}

sub retrieveMap {
	my ( $self, $mapName ) = @_;

	dlog( 'Start retrieve map ' . $mapName );
	my $path = $self->rootPath;
	$path .= 'suffix'          if ( 'suffix'          eq $mapName );
	$path .= 'prefix'          if ( 'prefix'          eq $mapName );
	$path .= 'objectIdMap'     if ( 'objectIdMap'     eq $mapName );
	$path .= 'nameMap'         if ( 'nameMap'         eq $mapName );
	$path .= 'namePrefixMap'   if ( 'namePrefixMap'   eq $mapName );
	$path .= 'customerAcctMap' if ( 'customerAcctMap' eq $mapName );
	$path .= 'inclusionMap'    if ( 'inclusionMap'    eq $mapName );
	$path .= 'hwLparMap'       if ( 'hwLparMap'       eq $mapName );

	return retrieve($path);
	dlog('End of retrieve map');
}

sub getCustomerId {
	my ( $self, $sr ) = @_;
	$self->init;

	dlog("Start getCustomerId method");

	my $acceptFlag = 0;
	if (   $sr->bankAccountId == 180
		|| $sr->bankAccountId == 406
		|| $sr->bankAccountId == 410
		|| $sr->bankAccountId == 5
		|| $sr->bankAccountId == 740
		|| $sr->bankAccountId == 738 
		|| $sr->bankAccountId == 853 )
	{
		$acceptFlag = 1;
	}

	if ( $sr->isManual == 1 ) {
		if ( exists $self->customerAcctMap->{ $sr->objectId } ) {
			return $self->customerAcctMap->{ $sr->objectId };
		}

		dlog('NO MATCHING ACCOUNT');
		return 999999;
	}

	my $shortName = ( split( /\./, $sr->name ) )[0];
	$shortName = $sr->name if ( !defined $shortName );
	dlog("shortName=$shortName");

	if ( exists $self->hwLparMap->{$shortName} ) {
		my $count           = 0;
		my $exactMatchCount = 0;
		my $customerCount   = 0;
		my $exactId;
		my %customerIds;

		#Loop through all the matches
		foreach my $ref ( @{ $self->hwLparMap->{$shortName} } ) {

			#Loop through the fqhns, there could be 1 short and 1 long
			foreach my $fqhn ( keys %{$ref} ) {

				if ( $acceptFlag == 0 ) {
					if (
						exists
						$self->inclusionMap->{ $ref->{$fqhn}->{'customerId'} } )
					{
						### This customer will only accept certain bank accounts

						if (
							!defined $self->inclusionMap->{ $ref->{$fqhn}
								  ->{'customerId'} }{ $sr->bankAccountId } )
						{
							dlog(   $sr->bankAccountId
								  . " not defined for "
								  . $ref->{$fqhn}->{'customerId'} );
							$count++;
							next;
						}
					}
				}

				#If we match a serial number return it immediately per logic
				if (   ( defined $sr->serialNumber )
					&& ( $ref->{$fqhn}->{'serialNumber'} eq $sr->serialNumber )
				  )
				{
					dlog(   "ATP serial match: $shortName "
						  . $sr->serialNumber . ", "
						  . $sr->name
						  . ", $fqhn" );

					return $ref->{$fqhn}->{'customerId'};
				}

				if ( $fqhn eq $sr->name ) {
					$exactMatchCount++;
					$exactId = $ref->{$fqhn}->{'customerId'};
				}

				if ( !exists $customerIds{ $ref->{$fqhn}->{'customerId'} } ) {
					$customerIds{ $ref->{$fqhn}->{'customerId'} } = 0;
					$customerCount++;
				}

				$count++;
			}
		}

		#If we get here, we know a serial didn't match
		#If our count is equal to 1, then we know we have a fuzzy unique match
		dlog("count=$count");
		if ( $count == 1 ) {
			my $ref = @{ $self->hwLparMap->{$shortName} }[0];

			foreach my $fqhn ( keys %{$ref} ) {
				if ( $acceptFlag == 0 ) {
					if (
						exists
						$self->inclusionMap->{ $ref->{$fqhn}->{'customerId'} } )
					{
						### This customer will only accept certain bank accounts

						if (
							!defined $self->inclusionMap->{ $ref->{$fqhn}
								  ->{'customerId'} }{ $sr->bankAccountId } )
						{
							dlog(   $sr->bankAccountId
								  . " not defined for "
								  . $ref->{$fqhn}->{'customerId'} );
							next;
						}
					}
				}

				dlog("ATP Fuzzy match $fqhn");
				return $ref->{$fqhn}->{'customerId'};
			}
		}

		#If we get here, we know we have multiple matches
		dlog("exactMatchCount=$exactMatchCount");
		if ( $exactMatchCount > 0 ) {

			# If there is one exact match
			if ( $exactMatchCount == 1 ) {
				dlog("ATP exact match: $sr->name");
				return $exactId;
			}

			# If we have only one customerId, thats it
			dlog("customerCount=$customerCount");
			if ( $customerCount == 1 ) {
				foreach my $customerId ( keys %customerIds ) {
					dlog("ATP single customer: $sr->name");
					return $customerId;
				}
			}

	  # if account is swasset, only use if an account matches what is in swasset
			if ( $sr->bankAccountId eq '5' || $sr->bankAccountId eq '410' ) {
				foreach my $customerId ( keys %customerIds ) {
					if ( exists $self->customerAcctMap->{ $sr->objectId }
						&& $self->customerAcctMap->{ $sr->objectId } eq
						$customerId )
					{
						return $customerId;
					}
				}

				dlog('MOVE SWASSET SCAN');
				return 999999;
			}

			#Check the mapping file for hostname
			if ( exists $self->nameMap->{ $sr->name } ) {
				foreach my $customerId ( keys %customerIds ) {
					if ( $self->nameMap->{ $sr->name } eq $customerId ) {
						dlog("ATP Mapping file match $sr->name");
						return $customerId;
					}
				}

				dlog('UPDATE MAPPING FILE');
				return 999999;
			}

			# Use the tme_object_id from cndb
			if (
				exists
				$self->objectIdMap->{ ( split( /\./, uc( $sr->objectId ) ) )[0]
				} )
			{
				foreach my $customerId ( keys %customerIds ) {
					if (
						$self->objectIdMap->{ (
								split( /\./, uc( $sr->objectId ) ) )[0] } eq
						$customerId )
					{
						dlog("ATP tme_object_id match $sr->name");
						return $customerId;
					}
				}

				dlog('TME_OBJECT_ID MISMATCH');
				return 999999;
			}

			dlog('ADD TME_OBJECT_ID TO CNDB');
			return 999999;
		}
	}

	# if account is swasset, only use if an account matches what is in swasset
	if ( $sr->bankAccountId eq '5' || $sr->bankAccountId eq '410' ) {
		if ( exists $self->customerAcctMap->{ $sr->objectId } ) {
			return $self->customerAcctMap->{ $sr->objectId };
		}

		dlog('NO MATCHING ACCOUNT');
		return 999999;
	}

	if ( exists $self->nameMap->{ $sr->name } ) {
		dlog("Found hostname in mapping $sr->name");

		if ( $acceptFlag == 0 ) {
			if ( exists $self->inclusionMap->{ $self->nameMap->{ $sr->name } } )
			{
				### This customer will only accept certain bank accounts

				if (
					defined
					$self->inclusionMap->{ $self->nameMap->{ $sr->name } }
					{ $sr->bankAccountId } )
				{
					return $self->nameMap->{ $sr->name };
				}
			}
			else {
				return $self->nameMap->{ $sr->name };
			}
		}
		else {
			return $self->nameMap->{ $sr->name };
		}
	}

	if ( defined $sr->objectId && $sr->objectId ne '' ) {
		if (
			exists
			$self->objectIdMap->{ ( split( /\./, uc( $sr->objectId ) ) )[0] } )
		{

			if ( $acceptFlag == 0 ) {
				if (
					exists $self->inclusionMap->{
						$self->objectIdMap->{ (
								split( /\./, uc( $sr->objectId ) ) )[0] }
					}
				  )
				{
					### This customer will only accept certain bank accounts

					if (
						defined $self->inclusionMap->{
							$self->objectIdMap->{ (
									split( /\./, uc( $sr->objectId ) ) )[0] }
						}{ $sr->bankAccountId }
					  )
					{
						dlog( "Found tme_object_id in cndb" . $sr->name );
						return
						  $self->objectIdMap->{ (
								split( /\./, uc( $sr->objectId ) ) )[0] };
					}
				}
				else {
					return
					  $self->objectIdMap->{ (
							split( /\./, uc( $sr->objectId ) ) )[0] };
				}
			}
			else {
				return
				  $self->objectIdMap->{ ( split( /\./, uc( $sr->objectId ) ) )
					  [0] };
			}
		}
	}

	dlog("End getCustomerId method");

	dlog('ATP NEED UPDATE');
	return 999999;
}

sub needUpdate {
	my ( $self, $value ) = @_;
	if ( defined $value ) {
		my $update = { UPDATE_FLAGE => $value };
		store $update, $self->rootPath . 'status';
	}
	else {
		my $ref = retrieve( $self->rootPath . 'status' );
		return $ref->{UPDATE_FLAGE};
	}

}
1;

