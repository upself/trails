package Recon::HardwareLpar;

use strict;
use Base::Utils;
use Carp qw( croak );
use BRAVO::OM::Hardware;
use Recon::Lpar;
use Recon::AlertHardwareLpar;
use Recon::AlertZeroHWProcessorCount;
use Recon::AlertZeroHwChipCount;
use Recon::AlertHwLparNoCpuModel;
use Recon::AlertHwLparNoProcType;
use Recon::Hardware;
use Recon::Delegate::ReconDelegate;

sub new {
    my ( $class, $connection, $hardwareLpar, $action ) = @_;
    my $self = {
                 _connection   => $connection,
                 _hardwareLpar => $hardwareLpar,
                 _action       => $action
    };
    bless $self, $class;

    $self->validate;

    return $self;
}

sub validate {
    my $self = shift;

    croak 'Connection is undefined'
      unless defined $self->connection;

    croak 'Hardware Lpar is undefined'
      unless defined $self->hardwareLpar;
}

sub catchRight { # chops the rightmost character from a string (referenced), returns the character
	my $string=shift;
	
	return undef if (length($$string)==0);
	
	my $toret= substr $$string, -1, 1;
	$$string = substr $$string, 0, ( length($$string) - 1 );
	
	return $toret;
}

sub recon0101 {
	my $self = shift;
	my $action = $self->action;
	
	my $allocMethodologyMap =
	  Recon::Delegate::ReconDelegate->getAllocationMethodologyMap();
	
	my $manquery = "";
	my $autoquery= "";
	my $namequery;
	
	return unless $action =~ /^[01]+[0123]$/ ; # action is not composed of 0's and 1's (with 0123 at the end)
	
	wlog("Reconing action $action, HW LPAR ".$self->hardwareLpar->id);
	
	chomp($action);
	
	# now we will slice the $action string from left, character by character
	for (my $i=0; $i<5; $i++) # 10^0 to 10^4 ignored
		{ catchRight(\$action); }
	
	if ( catchRight(\$action) == "1" ){ # 10^5
		$manquery.=$allocMethodologyMap->{'Per LPAR IBM LSPR MIPS'};
		$autoquery.="5, ";
	}
	if ( catchRight(\$action) == "1" ){ # 10^6
		$manquery.=$allocMethodologyMap->{'Per LPAR MSU'};
		$autoquery.="9, ";
	}
	if ( catchRight(\$action) == "1" ){ # 10^7
		$manquery.=$allocMethodologyMap->{'Per LPAR Gartner MIPS'};
		$autoquery.="70, ";
	}
	catchRight(\$action); # 10^8 ignored
	if ( catchRight(\$action) == "1" ){ # 10^9
		$manquery.=$allocMethodologyMap->{'Per processor'};
		$autoquery.="2, ";
	}
		
	return if ($manquery == "");
	
	$manquery =~ s/, $//; # removing the closing ", " in the $manquery
	$autoquery =~ s/, $//; # the same for autoquery
	$namequery = $manquery;
	$namequery =~ s/, /-/;
	
	wlog("Breaking these allocation methodologies: $manquery, captypes: $autoquery");
	
	my %rec;
	
    $self->connection->prepareSqlQueryAndFields( $self->queryGetReconcilesByMethodology($manquery, $autoquery, $namequery) );

    ###access statement handle
    my $sth = $self->connection->sql->{'getReconcilesByMethodology-'.$namequery};

    ###Bind columns
    $sth->bind_columns( map { \$rec{$_} } @{ $self->connection->sql->{'getReconcilesByMethodology-'.$namequery.'Fields'} } );

    ###Execute query
    $sth->execute( $self->hardwareLpar->id );
    
    my %reIDsbroken;

    ###Loop through results
    while ( $sth->fetchrow_arrayref ) {
       	my $curr_rId=$rec{rId};
	
		next if ( exists $reIDsbroken{$curr_rId} );
	
		dlog("Breaking reconcile $curr_rId");
		
		Recon::Delegate::ReconDelegate->breakReconcileById( $self->connection, $curr_rId );
	
		$reIDsbroken{$curr_rId} = 1;

    }
    ###End loop

    ###close statement handle
    $sth->finish;
    
    dlog(scalar(keys %reIDsbroken)." reconciles broken, returning to HW LPAR recon");
		
}

sub recon {
    my $self = shift;

    ilog("Entering recon method of ReconHardwareLparDelegate");
    ilog( $self->hardwareLpar->toString );

    ilog("Obtaining the Hardware object");
    my $hardware = new BRAVO::OM::Hardware();
    $hardware->id( $self->hardwareLpar->hardwareId );
    $hardware->getById( $self->connection );
    ilog("Obtained the Hardware object");
    ilog( $hardware->toString );

    ###Create recon lpar object
    my $reconLpar = new Recon::Lpar();

    ###Set the database connection
    $reconLpar->connection( $self->connection );

    ###Set the hardware lpar
    $reconLpar->hardwareLpar( $self->hardwareLpar );

    ###Set the hardware
    $reconLpar->hardware($hardware);

    ###Call the recon method of the recon lpar object
    ilog("Performing recon");
    $reconLpar->recon;
    ilog("Recon complete");
    
    ###Perform the special actions
    $self->recon0101();

    ###Run the alert logic
    ilog("Performing alert logic");
    my $alert = Recon::AlertHardwareLpar->new( $self->connection,$reconLpar->hardware,$self->hardwareLpar, $reconLpar->softwareLpar );
    $alert->recon;
    
    my $alertZeorHwProCount =Recon::AlertZeroHWProcessorCount->new($self->connection,$reconLpar->hardware,$self->hardwareLpar);
    $alertZeorHwProCount->recon;
    
    my $alertZeorHWChipsCount =Recon::AlertZeroHwChipCount->new($self->connection,$reconLpar->hardware,$self->hardwareLpar);
    $alertZeorHWChipsCount->recon;
    
    my $alertNoCpuModel =Recon::AlertHwLparNoCpuModel->new($self->connection,$reconLpar->hardware,$self->hardwareLpar);
    $alertNoCpuModel->recon;
    
    my $alertNoProcType =Recon::AlertHwLparNoProcType->new($self->connection,$reconLpar->hardware,$self->hardwareLpar);
    $alertNoProcType->recon;
    ilog("Alert logic complete");

    ###Call recon on items we have designated to reconcile from the recon logic
    ilog("Performing additional reconciliations");
    $reconLpar->performAdditionalRecons;
    ilog("Additional reconciliations complete");

    ###Call recon on the hardware object
    my $recon = Recon::Hardware->new( $self->connection, $hardware, "UPDATE" );
    $recon->recon;

    ilog("Recon complete");
}

sub connection {
    my $self = shift;
    $self->{_connection} = shift if scalar @_ == 1;
    return $self->{_connection};
}

sub action {
    my $self = shift;
    $self->{_action} = shift if scalar @_ == 1;
    return $self->{_action};
}

sub hardwareLpar {
    my $self = shift;
    $self->{_hardwareLpar} = shift if scalar @_ == 1;
    return $self->{_hardwareLpar};
}

sub queryGetReconcilesByMethodology {
	my $self=shift;
	my $methodologies=shift;
	my $captypes=shift;
	my $namequery=shift;

    my @fields = qw(
      rId
    );

    my $query = qq{
      select
          r.id
      from
		  reconcile r
		  join installed_software is on is.id = r.installed_software_id
		  join hw_sw_composite hsc on hsc.software_lpar_id = is.software_lpar_id
		  join reconcile_used_license rul on rul.reconcile_id = r.id
		  join used_license ul on rul.used_license_id = ul.id
      where
          hsc.hardware_lpar_id = ?
          and (
				( ( r.reconcile_type_id = 1 ) and ( r.allocation_methodology_id in ( $methodologies ) ) )
			or
				( ( r.reconcile_type_id = 5 ) and ( ul.capacity_type_id in ( $captypes ) ) )
		  )
	  with ur
    };

    return ( 'getReconcilesByMethodology-'.$namequery, $query, \@fields );
}

1;
