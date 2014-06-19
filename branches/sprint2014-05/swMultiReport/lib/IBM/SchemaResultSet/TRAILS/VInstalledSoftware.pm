#############################################################################
#
# Custom rs methods for TRAILS::VInstalledSoftware (s/w multireport)
#
# Author:   Chris Weyl (Global Asset Tools Team), <cweyl@us.ibm.com>
# Company:  IBM
# Created:  05/14/2009 01:33:35 PM EDT
# Revision: $Id: VInstalledSoftware.pm,v 1.2 2009/05/22 22:25:26 cweyl Exp $
#
# Detailed documentation, including the CVS commit log, can be found at the
# end of this file.
#
# Copyright (c) 2009 IBM <cweyl@us.ibm.com>
#
# This library is for IBM Internal Use only!
# 
#############################################################################

package IBM::SchemaResultSet::TRAILS::VInstalledSoftware;

use strict;
use warnings;

use base 'DBIx::Class::ResultSet';

use English qw{ -no_match_vars };  # Avoids regex performance penalty

# derive version directly from CVS revision.  As good a method as any.
our $VERSION  = '0.' . (split(/ /, q$Revision: 1.2 $))[1];
our $REVISION = '$Id: VInstalledSoftware.pm,v 1.2 2009/05/22 22:25:26 cweyl Exp $';

=begin original_query

## ORIGINAL:
    my $query = " select
                      a.account_number
                      ,b.nodename
                      ,b.model
                      ,b.bios_serial
                      ,case
                          when g.processor_count is null or g.status = 'INACTIVE' then b.processor_count
                          else g.processor_count
                       end
                      ,b.scantime
                      ,c.software_name
                      ,c.level
                      ,c.priority
                      ,b.version
                      ,d.name
                      ,e.software_category_name
                      ,b.os_minor_vers
                      ,b.os_sub_vers
                  from
                      eaadmin.customer a
                      ,eaadmin.v_installed_software b
                      left outer join eaadmin.software_lpar_eff g
                          on g.software_lpar_id = b.software_lpar_id
                      ,eaadmin.software c
                      ,eaadmin.bank_account d
                      ,eaadmin.software_category e
                  where
                      a.customer_id = $customerId
                      and b.software_lpar_status = 'ACTIVE'
                      and b.discrepancy_type_id != 3
                      and b.discrepancy_type_id != 5
                      and b.software_lpar_status = b.inst_status
                      and b.inst_status = c.status
                      and c.status = e.status
                      and a.customer_id = b.customer_id
                      and b.software_id = c.software_id
                      and b.bank_account_id = d.id
                      and c.software_category_id = e.software_category_id
                  order by priority ASC with ur";

=end original_query
=cut

# ugly, but I'm unsure of a good way to resolve it dbic-style (yet)
my $proc_count = q{
    case when software_lpar_eff.processor_count is null 
        or software_lpar_eff.status = 'INACTIVE' 
    then me.processor_count else software_lpar_eff.processor_count
    end
};

sub multi_report_rs {
    my $self = shift @_;

=begin comment
    #my @relateds = qw{ customer software bank_account software_lpar_eff };
    my @relateds = qw{ software bank_account software_lpar_eff };
    my @cols = qw{ 
        nodename model bios_serial scantime me.software_lpar_id 
        me.software_id 
    };
    my @as_cols = qw{ 
        nodename model bios_serial scantime software_lpar_id 
        software_id 
    };
=end comment
=cut

    # NOTE we don't include the funky "case.." as it doesn't appear that we
    # can insert literal sql through a column yet...  in any case the
    # row->eff_proc_count() will do the same thing.
    
    my @relateds = qw{ software bank_account software_lpar_eff software_lpar };
    my @cols = qw{ 
        me.customer_id me.nodename me.model me.bios_serial
        me.scantime me.software_lpar_id software_lpar.os_name 
        software_lpar.os_major_vers me.software_id software.software_name
        software.level software.priority bank_account.name
    };
    my @as_cols = qw{ 
        customer_id nodename model bios_serial scantime software_lpar_id 
        os_name os_major_version software_id software_name level 
        priority bank_account_name
    };

    my $schema = $self->result_source->schema;
    my $ok_swids = $schema->resultset('Software')->search(
        { 'me.status' => 'ACTIVE', 'software_category.status' => 'ACTIVE' },
        { join => [ 'software_category' ]                                 },
    );

    my $rs = $self->search(
        {
            software_lpar_status       => 'ACTIVE', 
            inst_status                => 'ACTIVE',
            # 2 following handled in the subquery
            #'software.status'          => 'ACTIVE',
            #'software_category.status' => 'ACTIVE',
            'me.software_id' => 
                { IN => $ok_swids->get_column('software_id')->as_query },
        
            # I'm pretty sure we can condense this, but it's late in the
            # evening and I have to bike home :)
            discrepancy_type_id  => { '!=' => 3 },
            discrepancy_type_id  => { '!=' => 5 },
        
        },
        {
            join     => [ @relateds ],
            select   => [ @cols,   ],
            as       => [ @as_cols ], 
            distinct => 1,
            #group_by => [ @cols,   ],
            #columns  => [ @cols,    \$proc_count     ],
            #as       => [ @as_cols, 'eff_proc_count' ], 
            #having => { software_lpar_status => 'ACTIVE' },
            
            #prefetch => [ @relateds ], 
            order_by => [ 'me.software_lpar_id', 'software.priority' ],

            page => 1, rows => 65_000,
        }
    );

    return $rs;
}

sub product_count_rs {
    my $self = shift @_;

    my @cols = 
        qw{ me.customer_id software_lpar.os_name software.software_name software.level
        me.software_lpar_id  me.software_id };
        
    my $proc_count_XXX = 
        'coalesce(software_lpar_eff.processor_count, me.processor_count)';

    my $rs = $self->search(
        { 
            software_lpar_status => 'ACTIVE', 
            'software.status'    => 'ACTIVE',
            inst_status          => 'ACTIVE',
        },
        { 
            select =>  [ 
                @cols, 
                { SUM   => \"$proc_count" }, 
                { COUNT => '*'            },
                #{ SUM   => \"sum($proc_count) as proc_count" }, 
                #{ count => \'count(*) as sw_count'           },
            ],
            as       => [ qw{ customer_id os_name sw_name level software_lpar_id software_id proc_count sw_count } ],
            group_by => [ @cols                                           ], 
            join     => [ qw{ software_lpar software software_lpar_eff }  ],
        })
        ;            

    return $rs;
}

1;

__END__

# $Log: VInstalledSoftware.pm,v $
# Revision 1.2  2009/05/22 22:25:26  cweyl
# - update DBIC::Schema::Loader script to correctly generate unique constraints
# - add a role, RS class and row methods to support the s/w multi report
#
# Revision 1.1  2009/05/15 05:15:11  cweyl
# initial import
#

=head1 NAME

<Module::Name> - <One line description of module's purpose>


=head1 SYNOPSIS

	use <Module::Name>;
	# Brief but working code example(s) here showing the most common usage(s)

	# This section will be as far as many users bother reading
	# so make it as educational and exemplary as possible.


=head1 DESCRIPTION

A full description of the module and its features.
May include numerous subsections (i.e. =head2, =head3, etc.)


=head1 SUBROUTINES/METHODS

A separate section listing the public components of the module's interface.
These normally consist of either subroutines that may be exported, or methods
that may be called on objects belonging to the classes that the module provides.
Name the section accordingly.

In an object-oriented module, this section should begin with a sentence of the
form "An object of this class represents...", to give the reader a high-level
context to help them understand the methods that are subsequently described.


=head1 DIAGNOSTICS

A list of every error and warning message that the module can generate
(even the ones that will "never happen"), with a full explanation of each
problem, one or more likely causes, and any suggested remedies.


=head1 CONFIGURATION AND ENVIRONMENT

A full explanation of any configuration system(s) used by the module,
including the names and locations of any configuration files, and the
meaning of any environment variables or properties that can be set. These
descriptions must also include details of any configuration language used.


=head1 DEPENDENCIES

A list of all the other modules that this module relies upon, including any
restrictions on versions, and an indication whether these required modules are
part of the standard Perl distribution, part of the module's distribution,
or must be installed separately.


=head1 INCOMPATIBILITIES

A list of any modules that this module cannot be used in conjunction with.
This may be due to name conflicts in the interface, or competition for
system or program resources, or due to internal limitations of Perl
(for example, many modules that use source code filters are mutually
incompatible).

=head1 SEE ALSO

L<...>

=head1 BUGS AND LIMITATIONS

A list of known problems with the module, together with some indication
whether they are likely to be fixed in an upcoming release.

Also a list of restrictions on the features the module does provide:
data types that cannot be handled, performance issues and the circumstances
in which they may arise, practical limitations on the size of data sets,
special cases that are not (yet) handled, etc.

The initial template usually just has:

All complex software has bugs lurking in it, and this module is no exception. 
If you find a bug please either email me:

    Chris Weyl <cweyl@us.ibm.com>.

Patches are welcome.

=head1 AUTHOR

Chris Weyl  <cweyl@us.ibm.com>

$Id: VInstalledSoftware.pm,v 1.2 2009/05/22 22:25:26 cweyl Exp $

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2009 IBM. All rights reserved.

This library is for IBM Internal Use only.

=cut

