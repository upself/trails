# Licensed Materials - Property of IBM
# TIVOCIT00
# Copyright IBM Corp. 2005, 2006. All Rights Reserved.
# US Government Users Restricted Rights - Use, duplication or
# disclosure restricted by GSA ADP Schedule contract with
# IBM Corp.

# Version: src/enabler/VMWare/common/retrieve.pl, enabler, cit_2.3, 20070610v2.3
# Build date: 07/06/10 14:53:30


use Env;
use VMware::VmPerl;
use VMware::VmPerl::VM;
use VMware::VmPerl::Server;
use VMware::VmPerl::ConnectParams;
use strict;

# Input:
# 6 parameters: node id, node manufact, node product, node version, node type,node capacity
# 7 parameters: node id, node manufact, node product, node version, node type, node capacity, verbose flag
#osstmp2 << STR_OK_NODE_ID << " " << info.SerialNum << endl << endl;
#osstmp2 << STR_OK_HOST_MAN << " " << info.Manufact << endl << endl;
#osstmp2 << STR_OK_HOST_PROD << " " << hprod<< endl << endl;
#osstmp2 << STR_OK_HOST_VER << " " << hver<< endl << endl;
#osstmp2 << STR_OK_HOST_TYPE << " " << htype<< endl << endl;

my $OUTFILE;
my $verbose;

sub setvmvar {
    my($vm, $key, $value) = @_;
    my $rc;
    do {
        $rc = $vm->set_guest_info($key, $value);
    }
    while ($rc != 1);
    if ($verbose){
        printf OUTFILE "Set $key to $value ok.\n";
    }
}



if ((@ARGV ne 6) && (@ARGV ne 7)) {
    exit(5);
}
my $node_id;
my $node_man;
my $node_prod;
my $node_ver;
my $node_type;
my $node_capacity;

if (@ARGV == 6) {
  ($node_id,$node_man,$node_prod,$node_ver,$node_type, $node_capacity) = @ARGV;
}
if (@ARGV == 7) {
    ($node_id, $node_man,$node_prod,$node_ver,$node_type,$node_capacity) = @ARGV;
    $verbose = 1;
}

if ($verbose) {
  open(OUTFILE, ">>retr_out.txt");
}

my $vm_capacity = 1; # if running on a ESX server this value will be changed later

# Create a ConnectParams object
my $connect_params = VMware::VmPerl::ConnectParams::new();

# Establish a persistent connection with server
my $server = VMware::VmPerl::Server::new();
if (!$server->connect($connect_params)) {
   # Could not connect to server
   if ($verbose) {
      printf OUTFILE "ERROR: Could not connect to virtual machine (could not connect to server)\n";
   }
   exit(7);
}

# Enumerate all VMs
# Obtain a list containing every config file path registered with the server.
my @list = $server->registered_vm_names();
if (!defined($list[0])) {
  # Could not get list of VMs from server
  if ($verbose) {
      printf OUTFILE "ERROR: Could not get list of VMs from server\n";
  }
  exit(6);
}

# Get data from PHYSICAL_PROCESSOR environmental variable
my $physical_processor_data = $ENV{PHYSICAL_PROCESSOR};
if ($verbose) {
  printf OUTFILE "PHYSICAL_PROCESSOR = '%s'\n", $physical_processor_data;
}


my $cfg_path;

foreach $cfg_path (@list) {
  my $vm = VMware::VmPerl::VM::new();

  if (!$vm->connect($connect_params, $cfg_path)) {
    undef $vm;
    # Could not connect to vm
    if ($verbose) {
      printf OUTFILE "WARNING! Could not connect to virtual machine: '%s'. Probably powered down.\n", $cfg_path;
    }
    next;
  }
  if ($verbose) {
    printf OUTFILE "OK: connected to virtual machine: '%s'\n", $cfg_path;
  }

  my $vm_uuid = $vm->get_config("uuid.bios");
  if (!defined($vm_uuid)) {
    $vm_uuid = "NO UUID";
  }
  my $vm_name = $vm->get_config("displayName");
  if (!defined($vm_name)) {
    $vm_name = "NO NAME ";
  }
  $vm_name = $vm_name . "_" . $vm_uuid; #makes vm_name unique
  if ($verbose) {
      printf OUTFILE "OK: Virtual machine ID: %s\n", $vm_name;
  }

  # Check if this VM runs on a ESX Server
  if ($vm->get_product_info(VM_PRODINFO_PRODUCT) == VM_PRODUCT_ESX) {
    # Change VM Capacity
    # to reflect VM configuration on ESX Server
    my $cpu_max = $vm->get_resource("cpu.max");
    $vm_capacity = $cpu_max / 100;
    if ($verbose) {
      printf OUTFILE "OK: vm cpu max = %d\n", $cpu_max;
    }
  }

  # On ESX Server this information is retrieved
  # from VM and if this VM is down the value printed
  # can be missleading
  # if ($verbose) {
  #    printf OUTFILE "OK: Virtual machine capacity: %d\n\n", $vm_capacity;
  # }

  if ($vm->get_execution_state() == VM_EXECUTION_STATE_ON) {
    if ($verbose){
        printf OUTFILE "Transfering data to machine: %s\n", $vm_name;
    }
    setvmvar($vm, "CIT_NODE_ID", $node_id);
    setvmvar($vm, "CIT_NODE_MAN", $node_man);
    setvmvar($vm, "CIT_NODE_PROD", $node_prod);
    setvmvar($vm, "CIT_NODE_VER", $node_ver);
    setvmvar($vm, "CIT_NODE_TYPE", $node_type);
    setvmvar($vm, "CIT_NODE_CAPACITY", $node_capacity);
    setvmvar($vm, "CIT_VM_ID", $vm_name);
    setvmvar($vm, "CIT_VM_CAPACITY", $vm_capacity);
    setvmvar($vm, "CIT_PHYSICAL_PROCESSOR", $physical_processor_data);
    if ($verbose){
        printf OUTFILE "\n";
    }
  }
  else {
    if ($verbose) {
      printf OUTFILE "WARNING: Machine not running: %s\n\n", $vm_name;
    }
  }

  # Destroys the virtual machine object, thus disconnecting from the virtual machine.
  undef $vm;
}

# Destroys the server object, thus disconnecting from the server.
undef $server;

exit(0);

