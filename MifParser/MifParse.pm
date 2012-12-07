package MifParser::MifParse;

use Class::Struct;
use MifParser::MifGroup;
use MifParser::MifAttribute;
use Text::ParseWords;
use strict;

struct MifParse => {
    groups        => '%',
    name          => '$',
};

sub parse {
    my $self     = shift;
    my $mif_file = shift;

    #print "Using: $mif_file\n";
    open MIF, $mif_file or die "$!";

    my $attribute_data = MifAttribute->new();
    my $group_data     = MifGroup->new();

    my $flags;
    
    my %comp_re = (
        "name"   => qr/\s*name\s*=\s*(.*)/i,
        "id"     => qr/\s*id\s*=\s*(.*)/i,
        "class"  => qr/\s*class\s*=\s*(.*)/i,
        "access" => qr/\s*access\s*=\s*(.*)/i,
        "key"    => qr/\s*key\s*=\s*(.*)/i,
        "value"  => qr/\s*value\s*=\s*(.*)/i,
        "type"   => qr/\s*type\s*=\s*(.*)/i,
    );
    

    while (<MIF>) {
        chomp;
        s/\r//;
        $flags = set_flags($self,$flags,$_);
    
        next if $flags->{"table"};

        my %value_tracker;

        foreach my $key (keys %comp_re) {
            if (/$comp_re{$key}/) {
                #$value_tracker{$key} = $1 if (/$comp_re{$key}/);
                #$value_tracker{$key} = (quotewords(",",0,$1))[0];
                $value_tracker{$key} = $1; # if (/$comp_re{$key}/);
                $value_tracker{$key} = (quotewords(",",0,$1))[0];
            }
        }

        if ($flags->{"component"}) {
            if ($flags->{"group"}) {
                if ($flags->{"attribute"}) {
                    if ($flags->{"attribute_enum"}) {
                        if ($value_tracker{"name"}) {
                            $attribute_data->
                                    setEnumName($value_tracker{"name"}) ;
                        }
                        elsif ($value_tracker{"type"}) {
                        }
                        else {
                            $attribute_data->addEnum($_); 
                        }
                        next;
                    }
                    $attribute_data->name($value_tracker{"name"})
                            if $value_tracker{"name"};
                    $attribute_data->id($value_tracker{"id"})
                            if $value_tracker{"id"};
                    $attribute_data->access($value_tracker{"access"})
                            if $value_tracker{"access"};
                    $attribute_data->value($value_tracker{"value"})
                            if $value_tracker{"value"};
                    if ($value_tracker{"type"}) {
                        $attribute_data->type($value_tracker{"type"});
                        if ($value_tracker{"type"} =~ /\s*start enum\s*/i) {
                            $flags->{"attribute_enum"} = 1;
                        }
                    }
                }
                elsif ($flags->{"end_attribute"}) {
                    $group_data->addAttribute($attribute_data->name,
                            $attribute_data);
                    $attribute_data = MifAttribute->new();
                }
                else {
                    #print "$_\n";
                    #print "value tracker = ",$value_tracker{"name"},"\n";
                    $group_data->name($value_tracker{"name"}) 
                            if $value_tracker{"name"};
                    $group_data->class($value_tracker{"class"})
                            if $value_tracker{"class"};
                    $group_data->key($value_tracker{"key"})
                            if $value_tracker{"key"};
                    #print $group_data->name(),"\n";
                    #print $group_data->class(),"\n";
                    #print $group_data->key(),"\n";
                }
            }
            elsif ($flags->{"end_group"}) {
                # print "$_\n";
                $self->groups($group_data->name,$group_data);
                $group_data = MifGroup->new();
                # Look for a table?
            }
            else {
                $self->name($value_tracker{"name"}) 
                        if $value_tracker{"name"};
            }
        }
    }

    close MIF;
}

sub set_flags {
    my $self        = shift;
    my $flags       = shift;
    my $data_line   = shift;

    $flags->{"end_group"}     = 0;
    $flags->{"end_attribute"} = 0;


    $flags->{"table"} = 1 if  (/\s*start table\s*/i);
    $flags->{"table"} = 0 if  (/\s*end table\s*/i);
    $flags->{"group"} = 1 if  (/\s*start group\s*/i);
    $flags->{"group"} = 0 if  (/\s*end group\s*/i);
    $flags->{"attribute"} = 1 if  (/\s*start attribute\s*/i);

    if (/\s*end attribute\s*/i) {
        $flags->{"attribute"} = 0;
        $flags->{"end_attribute"} = 1;
    }
    if (/\s*end group\s*/i) {
        $flags->{"group"} = 0;
        $flags->{"end_group"} = 1;
    }

    

    $flags->{"component"} = 1 if  (/\s*start component\s*/i);
    $flags->{"component"} = 0 if  (/\s*end component\s*/i);

    if ($flags->{"attribute"}) {
        $flags->{"attribute_enum"} = 0 if  (/\s*end enum\s*/i);
    }

    return $flags;
}
    
1;
