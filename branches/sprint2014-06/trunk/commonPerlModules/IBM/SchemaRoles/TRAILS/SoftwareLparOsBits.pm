package IBM::SchemaRoles::TRAILS::SoftwareLparOsBits;

use Moose::Role;

# derive version directly from CVS revision.  As good a method as any.
our $VERSION  = '0.' . (split(/ /, q$Revision: 1.2 $))[1];
our $REVISION = '$Id: SoftwareLparOsBits.pm,v 1.2 2009/06/07 22:35:16 cweyl Exp $';
     
###########################################################################
# 

has _os           => (is => 'ro', isa => 'DBIx::Class::ResultSet', lazy_build => 1);
has sw_os_name    => (is => 'ro', isa => 'Maybe[Str]', lazy_build => 1);
has sw_os_version => (is => 'ro', isa => 'Maybe[Str]', lazy_build => 1);

sub _build_sw_os_name { 
    my $self = shift @_;
    
    return $self->_os->first->get_column('software_name') 
        if $self->_os->count;
    return;
}

sub _build_sw_os_version { 
    my $self = shift @_;
    
    return $self->_os->first->get_column('version') 
        if $self->_os->count;
    return;
}

sub _build__os {
    my $self = shift @_;
    
    return $self
        ->result_source
        ->schema
        ->resultset('VInstalledSoftware')
        ->search(
            {   
                software_lpar_id => $self->software_lpar_id,
                'software_category_name' => 'Operating Systems',
                'me.inst_status' => 'ACTIVE',
                'software.status' => 'ACTIVE',
            },
            {   
                'join' => [ { software => 'software_category' } ],
                select => 
                    [ 'software.software_name', 'me.version', 'me.software_id' ],
                as => [ 'software_name', 'version', 'software_id' ],
            }
        )
        ;
}

sub sw_os_name_XXX {
    my $self = shift @_;
    
    my $os_name = $self
        ->result_source
        ->schema
        ->resultset('VInstalledSoftware')
        ->search(
            {   
                software_lpar_id => $self->software_lpar_id,
                'software_category_name' => 'Operating Systems',
                'me.inst_status' => 'ACTIVE',
                'software.status' => 'ACTIVE',
            },
            {   
                'join' => [ { software => 'software_category' } ],
                select => 
                    [ 'software.software_name', 'me.version', 'me.software_id' ],
                as => [ 'software_name', 'version', 'software_id' ],
            }
        )
        ->first
        ;
        
    return $os_name->get_column('software_name') if $os_name;
    return;
}

sub eff_proc_count { shift->v_software_lpar_processors->processor_count }

has eff_proc_count_XXX => (is => 'ro', isa => 'Maybe[Int]', lazy_build => 1);

sub _build_eff_proc_count {
    my $self = shift @_;

    # aka: case
    #   when g.processor_count is null or g.status = 'INACTIVE' 
    #   then b.processor_count else g.processor_count

    my $eff = $self->software_lpar_eff || return $self->processor_count;
    return $self->processor_count
        if not defined $eff->processor_count or $eff->status eq 'INACTIVE';
    return $eff->processor_count;
}

# Is this correct for roles??
#__PACKAGE__->meta->make_immutable(inline_constructor => 0);
no Moose;

1;
