package IBM::AmTools::Utils::Post;

use Moose;

use MooseX::Types::URI qw{ Uri };

use File::Slurp qw{ slurp };
use HTTP::Request::Common;
use LWP::UserAgent;

our $VERSION  = '0.' . (split(/ /, q$Revision: 1.1 $))[1]; 
our $REVISION = '$Id: Post.pm,v 1.1 2008/11/05 02:21:53 cweyl Exp $';

has base => (is => 'rw', isa => Uri, coerce => 1, lazy_build => 1);
sub _build_base { 'https://am.boulder.ibm.com/put' }

has ua => (is => 'ro', isa => 'LWP::UserAgent', lazy_build => 1);
sub _build_ua { LWP::UserAgent->new }

sub put {
    my $self = shift @_;
    
    my $ua   = $self->ua;
    my $base = $self->base;
    
    # target => content
    my %stuff = @_;

    for my $target (keys %stuff) {
        
        my $target_uri = "$base/$target";    
        my $ref        = ref $stuff{$target};

        my $content 
            = $ref eq 'SCALAR' ? ${$stuff{$target}}
            : $ref eq q{}      ? slurp $stuff{$target}
            :                    "$stuff{$target}"  # try stringifying
            ;
    
        # now, push to am.boulder.ibm.com
        my $rsp = $ua->request(PUT $target_uri, Content => $content);

        die q{Error PUT'ing: } . $rsp->as_string if $rsp->is_error;
    }

    return;
}

1;

__END__

#############################################################################
#    This is the documentation AND manpage of this module.  Document it     #
#                       it well, and wisely!                                #
#############################################################################


=head1 NAME
 
IBM::AmTools::Utils::Post - easy-upload to reporting space on am.b.i.c
 
 
=head1 SYNOPSIS
 
    use IBM::AmTools::Utils::Post;
 
    my $post = IBM::AmTools::Utils::Post->new;

    # post a file
    $post->put('/bravo/sw_multi/foo.xml' => '/tmp/foo.xml');

    # post the contents of a scalar reference
    $post->put('/bravo/sw_multi/foo.xml' => \'xml is evil, anyways!');
    
    # both at once
    $post->put(
        '/bravo/sw_multi/foo.xml' => '/tmp/foo.xml',
        '/bravo/sw_multi/foo.xml' => \'xml is evil, anyways!',
    );
 
    # profit!

 
=head1 DESCRIPTION
 
This is a small utility class, making it easy to PUT files out in the
IIP-protected space on am.boulder.ibm.com.

 
=head1 SUBROUTINES/METHODS 

=head2 new()

Returns a new object.

=head2 put(B<filename> => B<content>, ...)

A method, that will take filename / content pairs and PUT them on the server.
You can do as many as you want at the same time; of any variety.

If B<content> is a scalar, it's treated as a filename and the content is
slurp'ed prior to posting.  If it's a scalar reference, we pass the referenced
data directly.  If it's any other sort of reference, we try stringifying it
and pushing that.
 
=head1 DIAGNOSTICS
 
We die() on any error.

 
=head1 CONFIGURATION AND ENVIRONMENT

This isn't a limitation of this module per se, but the apache configuration on
am.boulder.ibm.com restricts this PUT operation to the following hosts:

    * tap.raleigh.ibm.com
    * tapreports.pok.ibm.com

As this is handled by a cgi-bin run under tha apache userid, the directories
this script writes to must be writable by the wwwrun user.  This can be
enabled by:

    setfacl    -m u:wwwrun:rwx <directory>
    setfacl -d -m u:wwwrun:rwx <directory>

If you have any questions about this, contact the author (Chris Weyl).

 
=head1 INCOMPATIBILITIES
 
None known.

 
=head1 BUGS AND LIMITATIONS
 
There are no known bugs in this module. 

Please report problems to Chris Weyl <cweyl@us.ibm.com>.

Patches are VERY welcome :)
 
=head1 AUTHOR
 
Chris Weyl  <cweyl@us.ibm.com>
 
 
=head1 LICENCE AND COPYRIGHT
 
Copyright (c) 2005 - 2008 IBM. All rights reserved.
 
This is for IBM Internal Use ONLY.
 
$Id: Post.pm,v 1.1 2008/11/05 02:21:53 cweyl Exp $

