package MifParser::inv40::Processor;

use Class::Struct;
use MifParser::MifGroup;
use MifParser::inv40::Component;
use Text::ParseWords;
use strict;
use base ("MifParser::inv40::Component");

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
# Use this method to get the standard sql insert statement 
# 
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
sub getStandardSQLInsert {
    my $rc;

    my $self        = shift;
    my $tablePre    = shift;
    my $hwsysid     = shift;    
    return unless $hwsysid;

    my $qh         = shift;

    $rc->[1] = "insert into ".$tablePre."inst_processor ".
            "(computer_sys_id, processor_id, processor_num, ser_num) ".
            "values ("."\'".$hwsysid."\',\'".$qh->{'ID'}."\',".
            $qh->{'Index'}.",\'".$qh->{'Serial Number'}."\')\n";


    my $mclockspeed = "null";
    my $clockspeed = "null";
    my $cfamily = "null";
    my $cstep = "null";
    my $cmodel = "null";

    $qh->{'Chip Features'} = $qh->{'Chip Features'} ? $qh->{'Chip Features'} : 
        "null";
    $qh->{'MaxClockSpeed'} = $qh->{'MaxClockSpeed'} ? $qh->{'MaxClockSpeed'} : 
        "null";
    $qh->{'CurrentClockSpeed'} = $qh->{'CurrentClockSpeed'} ? 
        $qh->{'CurrentClockSpeed'} : "null";
    $qh->{'Chip Family'} = $qh->{'Chip Family'} ? $qh->{'Chip Family'} : 
        "null";
    $qh->{'Chip Model'} = $qh->{'Chip Model'} ? $qh->{'Chip Model'} : 
        "null";
    $qh->{'Chip Stepping'} = $qh->{'Chip Stepping'} ? $qh->{'Chip Stepping'} : 
        "null";

    $rc->[0] = "insert into ".$tablePre."processor ".
            "(processor_id, manufacturer, processor_model, ".
            "processor_features,  max_speed, current_speed, chip_family, ".
            "chip_model, chip_stepping, virt_mode_ext, page_size_ext, ".
            "time_stamp_counter, model_specific_reg, physical_addr_ext, ".
            "machinecheck_excpt, cmpxchg8b_supp, on_chip_apic, ".
            "mem_type_range_reg, page_global_enable, machinecheck_arch, ".
            "cond_move_supp, mmx_technology, on_chip_fpu, debug_ext_present, ".
            "fast_sys_call, page_attr_table, page_size_ext36, ".
            "ser_num_enabled, fast_float_save, simd_ext_supp, now_3_d_arch) ".
            "values ("."\'".$qh->{'ID'}."\',".
            "\'".$qh->{'Manufacturer'}."\',".
            "\'".$qh->{'Family'}."\',".
            $qh->{'Chip Features'}." ,".
            $qh->{'MaxClockSpeed'}." ,".
            $qh->{'CurrentClockSpeed'}." ,".
            $qh->{'Chip Family'}." ,".
            $qh->{'Chip Model'}." ,".
            $qh->{'Chip Stepping'}." ,".
            "\'".$qh->{'Virtual Mode Extensions'}."\',".
            "\'".$qh->{'Page Size Extensions'}."\',".
            "\'".$qh->{'Time Stamp Counter'}."\',".
            "\'".$qh->{'Model Specific Registers'}."\',".
            "\'".$qh->{'Physical Address Extensions'}."\',".
            "\'".$qh->{'Machine Check Exceptions'}."\',".
            "\'".$qh->{'CMPXCHG8B Instruction Support'}."\',".
            "\'".$qh->{'On chip APIC'}."\',".
            "\'".$qh->{'Memory Type Range Registers'}."\',".
            "\'".$qh->{'Page Global Enable'}."\',".
            "\'".$qh->{'Machine Check Architecture'}."\',".
            "\'".$qh->{'Conditional Move Instruction'}."\',".
            "\'".$qh->{'MMX(tm) Techonlogy'}."\',".
            "\'".$qh->{'Floating Point Unit Present'}."\',".
            "\'".$qh->{'Debug Extension Present'}."\',".
            "\'".$qh->{'Fast System Call'}."\',".
            "\'".$qh->{'Page Attribute Table'}."\',".
            "\'".$qh->{'36-bit Page Size Extension'}."\',".
            "\'".$qh->{'Process Serial Number Enabled'}."\',".
            "\'".$qh->{'Fast Floating Point Save/Restore'}."\',".
            "\'".$qh->{'Streaming SIMD Extensions'}."\',".
            "\'".$qh->{'AMD 3DNow!(tm) Technology'}."\')\n";


    return $rc;
}

1;
