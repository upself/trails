#!/usr/bin/perl -w

#
# Includes
#
use strict;
use XML::Parser;
use Data::Dumper;

#
# Global Variables
#
my $index;
my $s;
my $package;
my $class;
my $table;
my %props = ();
my %meths = ();

#
# Subroutines
#
sub handle_init {
}

sub handle_start {
    my ( $expat, $elem, %attrs ) = @_;
    if ( $elem eq "class" ) {
        $index   = -1;
        $package = $attrs{"package"};
        $class   = $attrs{"name"};
        $table   = $attrs{"sql-name"};
    }
    elsif ( $elem eq "property" ) {
        $index++;
        if ( defined $attrs{"name"} ) {
            $props{$index}->{"name"} = $attrs{"name"};
        }
        else {
            die "ERROR: Must specify property name!!\n";
        }
        if ( defined $attrs{"type"} ) {
            $props{$index}->{"type"} = $attrs{"type"};
        }
        else {
            die "ERROR: Must specify property type!!\n";
        }
        if ( defined $attrs{"default"} ) {
            $props{$index}->{"default"} = $attrs{"default"};
        }
        else {
            $props{$index}->{"default"} = "undef";
        }
        if ( defined $attrs{"equals"} ) {
            $props{$index}->{"equals"} = $attrs{"equals"};
        }
        else {
            $props{$index}->{"equals"} = "false";
        }
        if ( defined $attrs{"sql-name"} ) {
            $props{$index}->{"sql-name"} = $attrs{"sql-name"};
        }
        else {
            $props{$index}->{"sql-name"} = "null";
        }
        if ( defined $attrs{"sql-key"} ) {
            $props{$index}->{"sql-key"} = $attrs{"sql-key"};
        }
        else {
            $props{$index}->{"sql-key"} = "false";
        }
        if ( defined $attrs{"biz-key"} ) {
            $props{$index}->{"biz-key"} = $attrs{"biz-key"};
        }
        else {
            $props{$index}->{"biz-key"} = "false";
        }
        if ( defined $attrs{"noprint"} ) {
            $props{$index}->{"noprint"} = $attrs{"noprint"};
        }
        else {
            $props{$index}->{"noprint"} = "false";
        }
    }
    elsif ( $elem eq "method" ) {
        $meths{ $attrs{"name"} }++;
    }
}

sub handle_char {
    my ( $expat, $text ) = @_;
    $s = $text;
    $s =~ s/^\s+|\s+$//g;
}

sub handle_end {
    my ( $expat, $elem ) = @_;
    if ( $elem eq "class" ) {
    }
    elsif ( $elem eq "property" ) {
    }
    elsif ( $elem eq "method" ) {
    }
}

sub handle_final {
}

#
# Main
#
die "Usage: $0 <obj-xml-file>\n"
  unless scalar(@ARGV) == 1;

my $parser = XML::Parser->new( ErrorContext => 2 );
$parser->setHandlers(
                      Init  => \&handle_init,
                      Start => \&handle_start,
                      Char  => \&handle_char,
                      End   => \&handle_end,
                      Final => \&handle_final
);
$parser->parsefile( $ARGV[0] );

#print STDOUT Dumper(\%props);

my $packageClass = $package . "::" . $class;
print <<EOL;
package $packageClass;

use strict;
use Base::Utils;

sub new {
    my (\$class) = \@_;
    my \$self = {
EOL

foreach my $i ( sort { $a <=> $b } keys %props ) {
    my $prop    = $props{$i}->{"name"};
    my $default = $props{$i}->{"default"};
    if ( $i > 0 ) {
        print "        ,";
    }
    else {
        print "        ";
    }
    if ( $default eq "undef" ) {
        print "_" . $prop . " => " . $default . "\n";
    }
    elsif ( $default =~ m/\d+/ ) {
        print "_" . $prop . " => " . $default . "\n";
    }
    else {
        print "_" . $prop . " => '" . $default . "'\n";
    }
}

print <<EOL;
    };
    bless \$self, \$class;
    return \$self;
}

sub equals {
    my (\$self, \$object) = \@_;
    my \$equal;

EOL

foreach my $i ( sort { $a <=> $b } keys %props ) {
    my $prop   = $props{$i}->{"name"};
    my $type   = $props{$i}->{"type"};
    my $equals = $props{$i}->{"equals"};
    if ( $equals eq "true" ) {
        print <<EOL;
    \$equal = 0;
    if (defined \$self->$prop && defined \$object->$prop) {
EOL

        if ( $type eq "scalar" ) {
            print <<EOL;
        \$equal = 1 if \$self->$prop eq \$object->$prop;
EOL
        }
        else {
            print <<EOL;
        \$equal = 1 if \$self->$prop->equals(\$object->$prop);
EOL
        }
        print <<EOL;
    }
    \$equal = 1 if (!defined \$self->$prop && !defined \$object->$prop);
    return 0 if \$equal == 0;

EOL
    }
}

print <<EOL;
    return 1;
}

EOL

foreach my $i ( sort { $a <=> $b } keys %props ) {
    my $prop = $props{$i}->{"name"};
    print <<EOL;
sub $prop {
    my \$self = shift;
    \$self->{_$prop} = shift if scalar \@_ == 1;
    return \$self->{_$prop};
}

EOL
}

print <<EOL;
sub toString {
    my (\$self) = \@_;
    my \$s = "[$class] ";
EOL

foreach my $i ( sort { $a <=> $b } keys %props ) {
    my $prop    = $props{$i}->{"name"};
    my $type    = $props{$i}->{"type"};
    my $noprint = $props{$i}->{"noprint"};
    next if $noprint eq "true";
    if ( $type eq "object" ) {
        print <<EOL;
    \$s .= "$prop->id=";
    if (defined \$self->{_$prop}) {
        if (defined \$self->{_$prop}->id) {
            \$s .= \$self->{_$prop}->id;
        }
    }
    \$s .= ",";
EOL
    }
    else {
        print <<EOL;
    \$s .= "$prop=";
    if (defined \$self->{_$prop}) {
        \$s .= \$self->{_$prop};
    }
    \$s .= ",";
EOL
    }
}
print <<EOL;
    chop \$s;
    return \$s;
}

EOL

if ( exists( $meths{'save'} ) ) {
    my $flag;
    my $insertString = "insert" . $class;
    my $updateString = "update" . $class;
    print <<EOL;
sub save {
    my(\$self, \$connection) = \@_;
    ilog(\"saving: \".\$self->toString());
    if( ! defined \$self->id ) {
        \$connection->prepareSqlQuery(\$self->queryInsert());
        my \$sth = \$connection->sql->{$insertString};
        my \$id;
        \$sth->bind_columns(\\\$id);
        \$sth->execute(
EOL
    $flag = 0;
    foreach my $i ( sort { $a <=> $b } keys %props ) {
        my $prop = $props{$i}->{"name"};
        next if $prop eq "id";
        next if $prop eq "remoteUser";
        next if $prop eq "recordTime";
        next if $prop eq "creationTime";
        my $sqlName = $props{$i}->{"sql-name"};
        next if $sqlName eq "null";
        my $type = $props{$i}->{"type"};
        $prop = $prop . "->id" if $type eq "object";
        my $s = "\$self->$prop";
        $s = "," . $s unless $flag == 0;
        $flag = 1;
        print <<EOL;
            $s
EOL
    }
    print <<EOL;
        );
        \$sth->fetchrow_arrayref;
        \$sth->finish;
        \$self->id(\$id);
    }
EOL
    $flag = 0;
    foreach my $i ( sort { $a <=> $b } keys %props ) {
        my $prop    = $props{$i}->{"name"};
        my $sqlName = $props{$i}->{"sql-name"};
        my $sqlKey  = $props{$i}->{"sql-key"};
        $flag = 1 if ( $sqlName ne "null" && $sqlKey eq "false" );
    }
    if ( $flag == 1 ) {
        print <<EOL;
    else {
        \$connection->prepareSqlQuery(\$self->queryUpdate);
        my \$sth = \$connection->sql->{$updateString};
        \$sth->execute(
EOL
        $flag = 0;
        foreach my $i ( sort { $a <=> $b } keys %props ) {
            my $prop    = $props{$i}->{"name"};
            my $type    = $props{$i}->{"type"};
            my $sqlName = $props{$i}->{"sql-name"};
            my $sqlKey  = $props{$i}->{"sql-key"};
            next if $sqlName eq "null";
            next if $sqlKey  eq "true";
            next if $prop    eq "remoteUser";
            next if $prop    eq "recordTime";
            $prop = $prop . "->id" if $type eq "object";
            my $s = "\$self->$prop";
            $s = "," . $s unless $flag == 0;
            $flag = 1;
            print <<EOL;
            $s
EOL
        }
        foreach my $i ( sort { $a <=> $b } keys %props ) {
            my $prop    = $props{$i}->{"name"};
            my $type    = $props{$i}->{"type"};
            my $sqlName = $props{$i}->{"sql-name"};
            my $sqlKey  = $props{$i}->{"sql-key"};
            next if $sqlName eq "null";
            next unless $sqlKey eq "true";
            $prop = $prop . "->id" if $type eq "object";
            my $s = "\$self->$prop";
            $s = "," . $s unless $flag == 0;
            $flag = 1;
            print <<EOL;
            $s
EOL
        }
        print <<EOL;
        );
        \$sth->finish;
    }
EOL
    }
    print <<EOL;
}

sub queryInsert {
    my \$query = '
        select
EOL
    $flag = 0;
    foreach my $i ( sort { $a <=> $b } keys %props ) {
        my $prop    = $props{$i}->{"name"};
        my $sqlName = $props{$i}->{"sql-name"};
        my $sqlKey  = $props{$i}->{"sql-key"};
        next unless $sqlKey eq "true";
        my $s = $sqlName;
        $s = "rtrim(ltrim(cast(char($sqlName) as varchar(255))))" unless $prop eq "id";
        $s = "|| \\\'|\\\' || $s" unless $flag == 0;
        $flag = 1;
        print <<EOL;
            $s
EOL
    }
    print <<EOL;
        from
            final table (
        insert into $table (
EOL
    $flag = 0;
    foreach my $i ( sort { $a <=> $b } keys %props ) {
        my $prop = $props{$i}->{"name"};
        next if $prop eq "id";
        my $sqlName = $props{$i}->{"sql-name"};
        next if $sqlName eq "null";
        my $s = $sqlName;
        $s = "," . $s unless $flag == 0;
        $flag = 1;
        print <<EOL;
            $s
EOL
    }
    print <<EOL;
        ) values (
EOL
    $flag = 0;
    foreach my $i ( sort { $a <=> $b } keys %props ) {
        my $prop    = $props{$i}->{"name"};
        my $default = $props{$i}->{"default"};
        next if $prop eq "id";
        my $sqlName = $props{$i}->{"sql-name"};
        next if $sqlName eq "null";
        my $s = "?";
        if ( $prop eq "remoteUser" ) {
            die "ERROR: remoteUser property must have a default value specified!!\n"
              if $default eq 'undef';
            $s = "\\\'" . $default . "\\\'";
        }
        $s = "CURRENT TIMESTAMP" if $prop eq "recordTime";
        $s = "CURRENT TIMESTAMP" if $prop eq "creationTime";
        $s = "," . $s unless $flag == 0;
        $flag = 1;
        print <<EOL;
            $s
EOL
    }
    print <<EOL;
        ))
    ';
    return ('$insertString', \$query);
}
EOL
    $flag = 0;
    foreach my $i ( sort { $a <=> $b } keys %props ) {
        my $prop    = $props{$i}->{"name"};
        my $sqlName = $props{$i}->{"sql-name"};
        my $sqlKey  = $props{$i}->{"sql-key"};
        $flag = 1 if ( $sqlName ne "null" && $sqlKey eq "false" );
    }
    if ( $flag == 1 ) {
        print <<EOL;

sub queryUpdate {
    my \$query = '
        update $table
        set
EOL
        $flag = 0;
        foreach my $i ( sort { $a <=> $b } keys %props ) {
            my $prop    = $props{$i}->{"name"};
            my $default = $props{$i}->{"default"};
            my $sqlName = $props{$i}->{"sql-name"};
            my $sqlKey  = $props{$i}->{"sql-key"};
            next if $sqlName eq "null";
            next if $sqlKey  eq "true";
            my $s = "$sqlName = ?";
            if ( $prop eq "remoteUser" ) {
                die "ERROR: remoteUser property must have a default value specified!!\n"
                  if $default eq 'undef';
                $s = "$sqlName = \\\'" . $default . "\\\'";
            }
            $s = "$sqlName = CURRENT TIMESTAMP" if $prop eq "recordTime";
            $s = "," . $s unless $flag == 0;
            $flag = 1;
            print <<EOL;
            $s
EOL
        }
        print <<EOL;
        where
EOL
        $flag = 0;
        foreach my $i ( sort { $a <=> $b } keys %props ) {
            my $prop    = $props{$i}->{"name"};
            my $sqlName = $props{$i}->{"sql-name"};
            my $sqlKey  = $props{$i}->{"sql-key"};
            next if $sqlName eq "null";
            next if $sqlKey  eq "false";
            my $s = "$sqlName = ?";
            $s = "and " . $s unless $flag == 0;
            $flag = 1;
            print <<EOL;
            $s
EOL
        }
        print <<EOL;
    ';
    return ('$updateString', \$query);
}
EOL
    }
}

if ( exists( $meths{'delete'} ) ) {
    my $flag;
    my $deleteString = "delete" . $class;
    print <<EOL;

sub delete {
    my(\$self, \$connection) = \@_;
    ilog(\"deleting: \".\$self->toString());
    if( defined \$self->id ) {
        \$connection->prepareSqlQuery(\$self->queryDelete());
        my \$sth = \$connection->sql->{$deleteString};
        \$sth->execute(
EOL
    $flag = 0;
    foreach my $i ( sort { $a <=> $b } keys %props ) {
        my $prop    = $props{$i}->{"name"};
        my $type    = $props{$i}->{"type"};
        my $sqlName = $props{$i}->{"sql-name"};
        my $sqlKey  = $props{$i}->{"sql-key"};
        next if $sqlName eq "null";
        next if $sqlKey  eq "false";
        $prop = $prop . "->id" if $type eq "object";
        my $s = "\$self->$prop";
        $s = "," . $s unless $flag == 0;
        $flag = 1;
        print <<EOL;
            $s
EOL
    }
    print <<EOL;
        );
        \$sth->finish;
    }
}

sub queryDelete {
    my \$query = '
        delete from $table
        where
EOL
    $flag = 0;
    foreach my $i ( sort { $a <=> $b } keys %props ) {
        my $prop    = $props{$i}->{"name"};
        my $sqlName = $props{$i}->{"sql-name"};
        my $sqlKey  = $props{$i}->{"sql-key"};
        next if $sqlName eq "null";
        next if $sqlKey  eq "false";
        my $s = "$sqlName = ?";
        $s = "and " . $s unless $flag == 0;
        $flag = 1;
        print <<EOL;
            $s
EOL
    }
    print <<EOL;
    ';
    return ('$deleteString', \$query);
}
EOL
}

if ( exists( $meths{'getByBizKey'} ) ) {
    my $flag;
    my $getByBizKeyString = "getByBizKey" . $class;
    print <<EOL;

sub getByBizKey {
    my(\$self, \$connection) = \@_;
    \$connection->prepareSqlQuery(\$self->queryGetByBizKey());
    my \$sth = \$connection->sql->{$getByBizKeyString};
EOL
    $flag = 0;
    foreach my $i ( sort { $a <=> $b } keys %props ) {
        my $prop    = $props{$i}->{"name"};
        my $type    = $props{$i}->{"type"};
        my $sqlName = $props{$i}->{"sql-name"};
        my $bizKey  = $props{$i}->{"biz-key"};
        next if $bizKey eq "true";
        next if ( $sqlName eq "null" && $prop ne "id" );
        my $s = "my \$" . $prop . ";";
        $flag = 1;
        print <<EOL;
    $s
EOL
    }
    print <<EOL;
    \$sth->bind_columns(
EOL
    $flag = 0;
    foreach my $i ( sort { $a <=> $b } keys %props ) {
        my $prop    = $props{$i}->{"name"};
        my $type    = $props{$i}->{"type"};
        my $sqlName = $props{$i}->{"sql-name"};
        my $bizKey  = $props{$i}->{"biz-key"};
        die "ERROR: getByBizKey can not be created for objects w/ other objects as attrs!!\n"
          if $type eq "object";
        next if $bizKey eq "true";
        next if ( $sqlName eq "null" && $prop ne "id" );
        my $s = "\\\$" . $prop;
        $s = "," . $s unless $flag == 0;
        $flag = 1;
        print <<EOL;
        $s
EOL
    }
    print <<EOL;
    );
    \$sth->execute(
EOL
    $flag = 0;
    foreach my $i ( sort { $a <=> $b } keys %props ) {
        my $prop    = $props{$i}->{"name"};
        my $type    = $props{$i}->{"type"};
        my $sqlName = $props{$i}->{"sql-name"};
        my $bizKey  = $props{$i}->{"biz-key"};
        next if $sqlName eq "null";
        next unless $bizKey eq "true";
        my $s = "\$self->$prop";
        $s = "," . $s unless $flag == 0;
        $flag = 1;
        print <<EOL;
        $s
EOL
    }
    print <<EOL;
    );
    \$sth->fetchrow_arrayref;
    \$sth->finish;
EOL
    $flag = 0;
    foreach my $i ( sort { $a <=> $b } keys %props ) {
        my $prop    = $props{$i}->{"name"};
        my $type    = $props{$i}->{"type"};
        my $sqlName = $props{$i}->{"sql-name"};
        my $bizKey  = $props{$i}->{"biz-key"};
        next if $bizKey eq "true";
        next if ( $sqlName eq "null" && $prop ne "id" );
        my $s = "\$self->" . $prop . "(\$" . $prop . ");";
        $flag = 1;
        print <<EOL;
    $s
EOL
    }
    print <<EOL;
}

sub queryGetByBizKey {
    my \$query = '
        select
EOL
    $flag = 0;
    foreach my $i ( sort { $a <=> $b } keys %props ) {
        my $prop    = $props{$i}->{"name"};
        my $sqlName = $props{$i}->{"sql-name"};
        my $sqlKey  = $props{$i}->{"sql-key"};
        my $bizKey  = $props{$i}->{"biz-key"};
        next if $bizKey eq "true";
        if ( $prop eq "id" && $sqlName eq "null" ) {
            my $flag2 = 0;
            foreach my $j ( sort { $a <=> $b } keys %props ) {
                my $prop2    = $props{$j}->{"name"};
                my $sqlName2 = $props{$j}->{"sql-name"};
                my $sqlKey2  = $props{$j}->{"sql-key"};
                next unless $sqlKey2 eq "true";
                my $s = "rtrim(ltrim(cast(char($sqlName2) as varchar(255))))";
                $s     = "|| \\\'|\\\' || $s" unless $flag2 == 0;
                $flag  = 1;
                $flag2 = 1;
                print <<EOL;
            $s
EOL
            }
        }
        else {
            next if $sqlName eq "null";
            my $s = $sqlName;
            $s = "," . $s unless $flag == 0;
            $flag = 1;
            print <<EOL;
            $s
EOL
        }
    }
    print <<EOL;
        from
            $table
        where
EOL
    $flag = 0;
    foreach my $i ( sort { $a <=> $b } keys %props ) {
        my $prop    = $props{$i}->{"name"};
        my $sqlName = $props{$i}->{"sql-name"};
        my $bizKey  = $props{$i}->{"biz-key"};
        next if $sqlName eq "null";
        next if $bizKey  eq "false";
        my $s = "$sqlName = ?";
        $s = "and " . $s unless $flag == 0;
        $flag = 1;
        print <<EOL;
            $s
EOL
    }
    print <<EOL;
    ';
    return ('$getByBizKeyString', \$query);
}
EOL
}

if ( exists( $meths{'getById'} ) ) {
    my $flag;
    my $getByIdString = "getByIdKey" . $class;
    print <<EOL;

sub getById {
    my(\$self, \$connection) = \@_;
    \$connection->prepareSqlQuery(\$self->queryGetById());
    my \$sth = \$connection->sql->{$getByIdString};
EOL
    $flag = 0;
    foreach my $i ( sort { $a <=> $b } keys %props ) {
        my $prop    = $props{$i}->{"name"};
        my $type    = $props{$i}->{"type"};
        my $sqlName = $props{$i}->{"sql-name"};
        my $sqlKey  = $props{$i}->{"sql-key"};
        next if $sqlName eq "null";
        next if $sqlKey  eq "true";
        my $s = "my \$" . $prop . ";";
        $flag = 1;
        print <<EOL;
    $s
EOL
    }
    print <<EOL;
    \$sth->bind_columns(
EOL
    $flag = 0;
    foreach my $i ( sort { $a <=> $b } keys %props ) {
        my $prop    = $props{$i}->{"name"};
        my $type    = $props{$i}->{"type"};
        my $sqlName = $props{$i}->{"sql-name"};
        my $sqlKey  = $props{$i}->{"sql-key"};
        die "ERROR: getById can not be created for objects w/ other objects as attrs!!\n"
          if $type eq "object";
        next if $sqlName eq "null";
        next if $sqlKey  eq "true";
        my $s = "\\\$" . $prop;
        $s = "," . $s unless $flag == 0;
        $flag = 1;
        print <<EOL;
        $s
EOL
    }
    print <<EOL;
    );
    \$sth->execute(
EOL
    $flag = 0;
    foreach my $i ( sort { $a <=> $b } keys %props ) {
        my $prop    = $props{$i}->{"name"};
        my $type    = $props{$i}->{"type"};
        my $sqlName = $props{$i}->{"sql-name"};
        my $sqlKey  = $props{$i}->{"sql-key"};
        next if $sqlName eq "null";
        next unless $sqlKey eq "true";
        my $s = "\$self->$prop";
        $s = "," . $s unless $flag == 0;
        $flag = 1;
        print <<EOL;
        $s
EOL
    }
    print <<EOL;
    );
    my \$found = \$sth->fetchrow_arrayref;
    \$sth->finish;
EOL
    $flag = 0;
    foreach my $i ( sort { $a <=> $b } keys %props ) {
        my $prop    = $props{$i}->{"name"};
        my $type    = $props{$i}->{"type"};
        my $sqlName = $props{$i}->{"sql-name"};
        my $sqlKey  = $props{$i}->{"sql-key"};
        next if $sqlName eq "null";
        next if $sqlKey  eq "true";
        my $s = "\$self->" . $prop . "(\$" . $prop . ");";
        $flag = 1;
        print <<EOL;
    $s
EOL
    }
    print <<EOL;
    return (defined \$found) ? 1 : 0;
}

sub queryGetById {
    my \$query = '
        select
EOL
    $flag = 0;
    foreach my $i ( sort { $a <=> $b } keys %props ) {
        my $prop    = $props{$i}->{"name"};
        my $sqlName = $props{$i}->{"sql-name"};
        my $sqlKey  = $props{$i}->{"sql-key"};
        next if $sqlName eq "null";
        next if $sqlKey  eq "true";
        my $s = $sqlName;
        $s = "," . $s unless $flag == 0;
        $flag = 1;
        print <<EOL;
            $s
EOL
    }
    print <<EOL;
        from
            $table
        where
EOL
    $flag = 0;
    foreach my $i ( sort { $a <=> $b } keys %props ) {
        my $prop    = $props{$i}->{"name"};
        my $sqlName = $props{$i}->{"sql-name"};
        my $sqlKey  = $props{$i}->{"sql-key"};
        next if $sqlName eq "null";
        next if $sqlKey  eq "false";
        my $s = "$sqlName = ?";
        $s = "and " . $s unless $flag == 0;
        $flag = 1;
        print <<EOL;
            $s
EOL
    }
    print <<EOL;
    ';
    return ('$getByIdString', \$query);
}
EOL
}

print "\n1;\n";

exit 0; 
