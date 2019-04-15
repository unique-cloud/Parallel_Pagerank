# TCL File Generated by Component Editor 10.0
# Mon Apr 25 23:22:07 EDT 2011
# DO NOT MODIFY


# +-----------------------------------
# | 
# | export_master "Avalon Master to Conduit Bridge" v10.0
# | John Freeman 2011.04.25.23:22:07
# | Export an avalon master to the top level design
# | 
# | /data/jfreeman/opencl/pcie_partition/ip/export/export_master.v
# | 
# |    ./export_master.v syn, sim
# | 
# +-----------------------------------

# +-----------------------------------
# | request TCL package from ACDS 10.0
# | 
package require -exact sopc 10.0
# | 
# +-----------------------------------

# +-----------------------------------
# | module export_master
# | 
set_module_property DESCRIPTION "Export an avalon master to the top level design"
set_module_property NAME acl_export_master
set_module_property VERSION 10.0
set_module_property GROUP "ACL Internal Components"
set_module_property AUTHOR "Altera OpenCL"
set_module_property DISPLAY_NAME "Avalon Master to Conduit Bridge"
set_module_property TOP_LEVEL_HDL_FILE export_master.v
set_module_property TOP_LEVEL_HDL_MODULE export_master
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
set_module_property ELABORATION_CALLBACK elaborate
set_module_property VALIDATION_CALLBACK validate
# | 
# +-----------------------------------

# +-----------------------------------
# | files
# | 
add_file export_master.v {SYNTHESIS SIMULATION}
# | 
# +-----------------------------------

# +-----------------------------------
# | parameters
# | 
add_parameter NUM_BYTES INTEGER 4
set_parameter_property NUM_BYTES DEFAULT_VALUE 4
set_parameter_property NUM_BYTES DISPLAY_NAME "Data Width"
set_parameter_property NUM_BYTES UNITS "bytes"
set_parameter_property NUM_BYTES ALLOWED_RANGES {1 2 4 8 16 32 64 128}
set_parameter_property NUM_BYTES AFFECTS_ELABORATION true
set_parameter_property NUM_BYTES HDL_PARAMETER true

add_parameter DATA_WIDTH INTEGER 32
set_parameter_property DATA_WIDTH DEFAULT_VALUE 32
set_parameter_property DATA_WIDTH DISPLAY_NAME "Data Width"
set_parameter_property DATA_WIDTH UNITS "bits"
set_parameter_property DATA_WIDTH HDL_PARAMETER false
set_parameter_property DATA_WIDTH DERIVED true

add_parameter BYTE_ADDRESS_WIDTH INTEGER 12
set_parameter_property BYTE_ADDRESS_WIDTH DEFAULT_VALUE 12
set_parameter_property BYTE_ADDRESS_WIDTH DISPLAY_NAME "Byte address width"
set_parameter_property BYTE_ADDRESS_WIDTH UNITS "bits"
set_parameter_property BYTE_ADDRESS_WIDTH HDL_PARAMETER true
set_parameter_property BYTE_ADDRESS_WIDTH AFFECTS_ELABORATION true

add_parameter WORD_ADDRESS_WIDTH INTEGER 12
set_parameter_property WORD_ADDRESS_WIDTH DEFAULT_VALUE 12
set_parameter_property WORD_ADDRESS_WIDTH DISPLAY_NAME "Word address width"
set_parameter_property WORD_ADDRESS_WIDTH UNITS "bits"
set_parameter_property WORD_ADDRESS_WIDTH HDL_PARAMETER true
set_parameter_property WORD_ADDRESS_WIDTH DERIVED true

add_parameter PENDING_READS INTEGER 1
set_parameter_property PENDING_READS DEFAULT_VALUE 1
set_parameter_property PENDING_READS DISPLAY_NAME "Max Pending Reads"
set_parameter_property PENDING_READS UNITS None
set_parameter_property PENDING_READS ALLOWED_RANGES 1:256
set_parameter_property PENDING_READS AFFECTS_ELABORATION true
set_parameter_property PENDING_READS HDL_PARAMETER false

add_parameter BURSTCOUNT_WIDTH INTEGER 1
set_parameter_property BURSTCOUNT_WIDTH DEFAULT_VALUE 1
set_parameter_property BURSTCOUNT_WIDTH DISPLAY_NAME "Burstcount Width"
set_parameter_property BURSTCOUNT_WIDTH UNITS ""
set_parameter_property BURSTCOUNT_WIDTH ALLOWED_RANGES 1:10
set_parameter_property BURSTCOUNT_WIDTH AFFECTS_ELABORATION true
set_parameter_property BURSTCOUNT_WIDTH HDL_PARAMETER true

# | 
# +-----------------------------------

# +-----------------------------------
# | display items
# | 
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point clk
# | 
add_interface clk clock end
set_interface_property clk ENABLED true
add_interface_port clk clk clk Input 1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point clk_reset
# | 
add_interface clk_reset reset end
set_interface_property clk_reset associatedClock clk
set_interface_property clk_reset synchronousEdges DEASSERT
set_interface_property clk_reset ASSOCIATED_CLOCK clk
set_interface_property clk_reset ENABLED true
add_interface_port clk_reset reset reset Input 1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point s1
# | 
add_interface s1 avalon end
set_interface_property s1 addressAlignment DYNAMIC
set_interface_property s1 bridgesToMaster ""
set_interface_property s1 associatedClock clk
set_interface_property s1 associatedReset clk_reset
set_interface_property s1 burstOnBurstBoundariesOnly false
set_interface_property s1 explicitAddressSpan 0
set_interface_property s1 holdTime 0
set_interface_property s1 isMemoryDevice false
set_interface_property s1 isNonVolatileStorage false
set_interface_property s1 linewrapBursts false
set_interface_property s1 printableDevice false
set_interface_property s1 readLatency 0
set_interface_property s1 readWaitTime 0
set_interface_property s1 setupTime 0
set_interface_property s1 timingUnits cycles
set_interface_property s1 writeWaitTime 0
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point export
# | 
add_interface export conduit end
set_interface_property export ENABLED true
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point irq
# | 
add_interface irq interrupt end
set_interface_property irq associatedAddressablePoint s1
set_interface_property irq associatedClock clk
set_interface_property irq associatedReset clk_reset
add_interface_port irq interrupt irq Output 1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point irq_export
# | 
add_interface irq_export conduit end
add_interface_port irq_export export_interrupt export Input 1
# | 
# +-----------------------------------

proc elaborate {} {
    set num_bytes [ get_parameter_value NUM_BYTES ]
    set byte_address_width [ get_parameter_value BYTE_ADDRESS_WIDTH ]
    set word_address_width [ get_parameter_value WORD_ADDRESS_WIDTH ]
    set data_width [ get_parameter_value DATA_WIDTH ]
    set pending_reads [ get_parameter_value PENDING_READS ]
    set burstcount_width [ get_parameter_value BURSTCOUNT_WIDTH ]

    # +-----------------------------------
    # | connection point s1
    # | 
    add_interface_port s1 read read Input 1
    add_interface_port s1 readdata readdata Output $data_width
    add_interface_port s1 readdatavalid readdatavalid Output 1
    add_interface_port s1 write write Input 1
    add_interface_port s1 writedata writedata Input $data_width
    add_interface_port s1 burstcount burstcount Input $burstcount_width
    add_interface_port s1 burstbegin beginbursttransfer Input 1
    add_interface_port s1 byteenable byteenable Input $num_bytes
    add_interface_port s1 address address Input $word_address_width
    add_interface_port s1 waitrequest waitrequest output 1

    set_interface_property s1 maximumPendingReadTransactions $pending_reads
    # | 
    # +-----------------------------------

    # +-----------------------------------
    # | connection point export
    # | 
    add_interface_port export export_address export Output $byte_address_width
    add_interface_port export export_read export Output 1
    add_interface_port export export_readdata export Input $data_width
    add_interface_port export export_readdatavalid export Input 1
    add_interface_port export export_write export Output 1
    add_interface_port export export_writedata export Output $data_width
    add_interface_port export export_burstcount export Output $burstcount_width
    add_interface_port export export_burstbegin export Output 1
    add_interface_port export export_byteenable export Output $num_bytes
    add_interface_port export export_waitrequest export Input 1
    # | 
    # +-----------------------------------
}

proc validate {} {
    set num_bytes [ get_parameter_value NUM_BYTES ]
    set byte_address_width [ get_parameter_value BYTE_ADDRESS_WIDTH ]
    set word_address_width [ expr int ( $byte_address_width - ceil (log ($num_bytes) / (log(2)))) ]

    set_parameter_value DATA_WIDTH [ expr $num_bytes * 8 ]
    set_parameter_value WORD_ADDRESS_WIDTH $word_address_width

}
