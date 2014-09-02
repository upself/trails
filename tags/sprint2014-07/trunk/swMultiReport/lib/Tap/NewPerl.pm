package Tap::NewPerl;

use warnings;
use strict;

use Carp;

our $VERSION = '0.0.4';

# debugging...
#use Smart::Comments;

# for an explanation of what the mystical variable names that follow are, see
# 'perldoc perlvar'.
#
# Note that we do our magic in import(), so we take advantage of the BEGIN { }
# block provided by someone use'ing us.

my $NEW_TAP_PERL = '/usr/perl5_8_8/bin/perl';

sub do_exec {

    # if we get here, we're running system perl and -auto has been passed
    exec $NEW_TAP_PERL, $0, @main::ARGV
        if -x $NEW_TAP_PERL;

    return;
}

sub import {
    my ($classname, $do_auto) = @_;
    
    ### @_
    
    return if $^X eq $NEW_TAP_PERL;
    
    $ENV{DBIC_NO_WARN_BAD_PERL} = 1;
    
    # only do our stuff if use'ed with '-auto'
    return do_exec if (not defined $do_auto) || $do_auto ne '-noauto';
    
    # make sure we don't do anything wonky
    croak "Unknown symbol passed to Tap::NewPerl: '$do_auto'" 
        if $do_auto ne '-noauto';

    return;
}

"perl is perl is perl... unless you're on tap";

__END__

=head1 NAME

Tap::NewPerl - use a newer perl, iff you're on tap.raleigh.ibm.com 

=head1 SYNOPSIS

    use Tap::NewPerl;

That's it :)

=head1 DESCRIPTION

Perl on tap is old. Really, really, REALLY OLD.  Which is old enough to keep
us from using any modern Perl framework like Moose, DBIx::Class, etc.

Fortunately, we have a new, shining installation of Perl 5.8.8 (from the
Fedora 9 perl-5.8.8-41 sources) available under /usr/perl5_8_8.  However, we'd
like to be able to run our Perl programs on more than one host, without
having to worry about what path to use in our #! lines.

Enter Tap::NewPerl; using this module will check the perl interperter you're
using, and if it's /usr/bin/perl, look for /usr/perl5_8_8/bin/perl.  If
/usr/perl5_8_8/bin/perl is found, exec() is called, resuling in the program
running under Perl 5.8.8. 

Neat, eh?


=head1 USAGE

"use Tap::NewPerl;" at the beginning of your script (but right after "use
strict; use warnings;", right?).  If you're on tap, the new perl will be used;
anywhere else and the script continues unmolested.


=head1 EXPORTED

This module exports nothing into your namespace.

=head1 FUNCTIONS

=head2 do_exec

do_exec() does the actual re-exec()'ing of perl.  You can call this manually,
but, why?

=head1 AUTHOR

Chris Weyl, C<< <cweyl at us.ibm.com> >>

=head1 BUGS

None known.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Tap::NewPerl


=head1 COPYRIGHT & LICENSE

Copyright 2008 IBM.

For Internal Use Only.

=cut
