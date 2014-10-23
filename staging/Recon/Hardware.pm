package Recon::Hardware;

use strict;
use Base::Utils;
use Carp qw( croak );
use Recon::AlertHardware;
use Recon::Delegate::ReconDelegate;

sub new {
    my ( $class, $connection, $hardware, $action ) = @_;
    my $self = {
                 _connection => $connection,
                 _hardware   => $hardware,
                 _action     => $action
    };
    bless $self, $class;

    $self->validate;

    return $self;
}

sub validate {
    my $self = shift;

    croak 'Connection is undefined'
      unless defined $self->connection;

    croak 'Hardware is undefined'
      unless defined $self->hardware;
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
	my $autoquery = "";
	
	return unless $action =~ /^[01]+[0123]$/ ; # action is not composed of 0's and 1's (with 0123 at the end)
	
	wlog("Reconing action $action, hardware ".$self->hardware->id);
	
	chomp($action);
	
	# now we will slice the $action string from left, character by character
	for (my $i=0; $i<3; $i++) # 10^0 to 10^2 ignored
		{ catchRight(\$action); }
	
	if ( catchRight(\$action) == "1" ){ # 10^3
		$manquery.=$allocMethodologyMap->{'Per hardware processor'}.$allocMethodologyMap->{'Per PVU'}; # 10^3
		$autoquery.="2, 17, ";
	}
	if ( catchRight(\$action) == "1" ){ # 10^4
		$manquery.=$allocMethodologyMap->{'Per hardware chip'}.$allocMethodologyMap->{'Per PVU'};
		$autoquery.="48, 17, ";
	}
	if ( catchRight(\$action) == "1" ){ # 10^5
		$manquery.=$allocMethodologyMap->{'Per PVU'};
		$autoquery.="17, ";
	}
	if ( catchRight(\$action) == "1" ){ # 10^6
		$manquery.=$allocMethodologyMap->{'Per PVU'};
		$autoquery.="17, ";
	}
	catchRight(\$action); # 10^7 ignored
	catchRight(\$action); # 10^8 ignored
	catchRight(\$action); # 10^9 ignored
	if ( catchRight(\$action) == "1" ){ # 10^10
		$manquery.=$allocMethodologyMap->{'Per hardware IBM LSPR MIPS'};
		$autoquery.="5, ";
	}
	if ( catchRight(\$action) == "1" ){ # 10^11
		$manquery.=$allocMethodologyMap->{'Per hardware Gartner MIPS'};
		$autoquery.="70, ";
	}
	if ( catchRight(\$action) == "1" ){ # 10^12
		$manquery.=$allocMethodologyMap->{'Per hardware MSU'};
		$autoquery.="9, ";
	}
		
	return if ($manquery == "");
	
	$manquery =~ s/, $//; # removing the closing ", " in the $manquery
	$autoquery =~ s/, $//; # the same for autoquery
	
	wlog("Breaking these allocation methodologies: $manquery, cap. types $autoquery");
	
	my %rec;
	
    $self->connection->prepareSqlQueryAndFields( $self->queryGetReconcilesByMethodology($manquery, $autoquery ) );

    ###access statement handle
    my $sth = $self->connection->sql->{getReconcilesByMethodology};

    ###Bind columns
    $sth->bind_columns( map { \$rec{$_} } @{ $self->connection->sql->{getReconcilesByMethodologyFields} } );

    ###Execute query
    $sth->execute( $self->hardware->id );
    
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

    my $alert = Recon::AlertHardware->new($self->connection, $self->hardware);
    $alert->recon;
    
    $self->recon0101;
}

sub connection {
    my $self = shift;
    $self->{_connection} = shift if scalar @_ == 1;
    return $self->{_connection};
}

sub hardware {
    my $self = shift;
    $self->{_hardware} = shift if scalar @_ == 1;
    return $self->{_hardware};    
}

sub action {
	my $self = shift;
	$self->{_action} = shift if scalar @_ == 1;
	return $self->{_action};
}

sub queryGetReconcilesByMethodology {
	my $self=shift;
	my $methodologies=shift;
	my $captypes=shift;

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
		  join hardware_lpar hl on hl.id = hsc.hardware_lpar_id
		  join reconcile_used_license rul on rul.reconcile_id = r.id
		  join used_license ul on rul.used_license_id = ul.id
      where
          hl.hardware_id = ?
          and ( 
				( ( r.reconcile_type_id = 1 ) and ( r.allocation_methodology_id in ( $methodologies ) ) )
			 or
				( ( r.reconcile_type_id = 5 ) and ( ul.capacity_type_id in ( $captypes ) ) )
			)
    };

    return ( 'getReconcilesByMethodology', $query, \@fields );
}


1;
