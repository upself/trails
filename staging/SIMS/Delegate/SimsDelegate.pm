package SIMS::Delegate::SimsDelegate;

use strict;
use Base::Utils;
use Database::Connection;
use SIMS::OM::Procgrps;
use SIMS::OM::Mips;
use BRAVO::Delegate::BRAVODelegate;

sub getMipsData {
    my ( $self, $connection, $bravoConnection ) = @_;

    dlog('In getMipsData method');
    ###We are not doing deltas here

    my %mipsList;

    ###Prepare the query
    $connection->prepareSqlQuery( $self->queryMipsData );

    ###Define the fields
    my @fields = (qw(type model group vendor mipsVendor mips updUser updStamp updIntranetID));
    
    ###Get mach type data.
    my $mtNameMap = BRAVO::Delegate::BRAVODelegate->getMachineTypeNameMap($bravoConnection);

    ###Get the statement handle
    my $sth = $connection->sql->{mipsData};

    ###Bind the columns
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @fields );

    ###Execute the query
    $sth->execute();
    while ( $sth->fetchrow_arrayref ) {        

        ###Build our mips object
        my $mips = $self->buildMips( \%rec );
        next if ( !defined $mips );
        
        ###check if the mips type is a valid machine type in bravo
        my $type = $mips->type;
        if ( !defined $mtNameMap->{$type} ) {
            dlog ("Machine type $type not found in BRAVO -> skipping record" );
            next;
        }

        ###replace the type name with type id 
        $mips->type( $mtNameMap->{$type} );
                 
        ###Build our mips object list
        my $key = $mips->type . '|' . $mips->model . '|' . $mips->group . '|' . $mips->vendor . '|' . $mips->mipsVendor;
        $mipsList{$key} = $mips
          if ( !defined $mipsList{$key} );        
    }

    ###Close the statement handle
    $sth->finish;

    ###Return the lists
    return ( \%mipsList );

}

sub getProcgrpsData {
    my ( $self, $connection, $bravoConnection ) = @_;

    dlog('In getProcgrpsData method');
    ###We are not doing deltas here

    my %procgrpsList;

    ###Prepare the query
    $connection->prepareSqlQuery( $self->queryProcgrpsData );

    ###Define the fields
    my @fields = (
        qw(type model group vendor description updUser updStamp msu pslcInd wlcInd totalEngines zosEngines ewlcInd updIntranetID)
    );
    
    ###Get mach type data.
    my $mtNameMap = BRAVO::Delegate::BRAVODelegate->getMachineTypeNameMap($bravoConnection);

    ###Get the statement handle
    my $sth = $connection->sql->{procgrpsData};

    ###Bind the columns
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @fields );  

    ###Execute the query
    $sth->execute();
    while ( $sth->fetchrow_arrayref ) {

        my $procgrps = $self->buildProcgrps( \%rec );
        next if ( !defined $procgrps );
        
        ###check if the procgrps type is a valid machine type in bravo
        my $type = $procgrps->type;
        if ( !defined $mtNameMap->{$type} ) {
            next;
        }

        ###replace the type name with type id 
        $procgrps->type( $mtNameMap->{$type} );  
                 
        ###Build our procgrps object list
        my $key = $procgrps->type . '|' . $procgrps->model . '|' . $procgrps->group . '|' . $procgrps->vendor;
        $procgrpsList{$key} = $procgrps
          if ( !defined $procgrpsList{$key} );
    }

    ###Close the statement handle
    $sth->finish;

    ###Return the lists
    return ( \%procgrpsList );

}

sub buildMips {
    my ( $self, $rec ) = @_;

    cleanValues($rec);
    upperValues($rec);

    ###Build the mips record
    my $mips = new SIMS::OM::Mips();
    $mips->type( $rec->{type} );
    $mips->model( $rec->{model} );
    $mips->group( $rec->{group} );
    $mips->vendor( $rec->{vendor} );
    $mips->mipsVendor( $rec->{mipsVendor} );
    $mips->mips( $rec->{mips} );
    $mips->updUser( $rec->{updUser} );
    $mips->updStamp( $rec->{updStamp} );
    $mips->updIntranetID( $rec->{updIntranetID} );

    return $mips;
}

sub buildProcgrps {
    my ( $self, $rec ) = @_;

    cleanValues($rec);
    upperValues($rec);

    ###Build the procgrps record
    my $procgrps = new SIMS::OM::Procgrps();
    $procgrps->type( $rec->{type} );
    $procgrps->model( $rec->{model} );
    $procgrps->group( $rec->{group} );
    $procgrps->vendor( $rec->{vendor} );
    $procgrps->description( $rec->{description} );
    $procgrps->updUser( $rec->{updUser} );
    $procgrps->updStamp( $rec->{updStamp} );
    $procgrps->msu( $rec->{msu} );
    $procgrps->pslcInd( $rec->{pslcInd} );
    $procgrps->wlcInd( $rec->{wlcInd} );
    $procgrps->totalEngines( $rec->{totalEngines} );
    $procgrps->zosEngines( $rec->{zosEngines} );
    $procgrps->ewlcInd( $rec->{ewlcInd} );
    $procgrps->updIntranetID( $rec->{updIntranetID} );

    return $procgrps;
}

sub queryMipsData {
    my $query = '
        select
            a.type
            ,a.model
            ,a.group
            ,a.vendor
            ,a.mipsvendor
            ,a.mips
            ,a.upduser
            ,a.updstamp
            ,a.upd_intranet_id
        from
            sims.mips a
        order by a.type,a.model,a.group,a.vendor,a.mipsvendor,a.updstamp desc
        with ur
    ';

    return ( 'mipsData', $query );
}

sub queryProcgrpsData {
    my @fields = (
        qw(type model group vendor description upduser updStamp msu pslcInd wlcInd totalEngines zosEngines ewlcInd updIntranetID)
    );
    my $query = '
        select
            a.type
            ,a.model
            ,a.group
            ,a.vendor
            ,a.description
            ,a.upduser
            ,a.updstamp
            ,a.msu
            ,a.pslc_ind
            ,a.wlc_ind
            ,a.total_engines
            ,a.zos_engines
            ,ewlc_ind
            ,a.upd_intranet_id
        from
            sims.procgrps a
        order by a.type,a.model,a.group,a.vendor,a.updstamp desc            
        with ur
    ';

    return ( 'procgrpsData', $query );
}
1;
