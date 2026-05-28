`timescale 1ns / 1ns
`define CLK  6 
`define SPI_CLK 24
`define DELAY 256
module test;
reg debug_print ;

reg  clk, 
     rcc_sclk,
     reset, 
     scan_en, 
     scan_in0, 
     scan_in1, 
     scan_in2, 
     spi_clk, 
     spi_data, 
     spi_fs, 
     test_mode,
     scan_clk,
     ibias,
     humm_mode;

wire [7:0]  tdigit;
reg dumpRamFile;


reg dumpRam;
reg int;
reg [15:0] port_pad_data_in;
wire [15:0] port_pad_data_out;
wire [7:0] out_p1;
reg [7:0] load_digit;
reg pllrst;

dtmf_chip top(
    .tdigit(tdigit),
    .tdigit_flag(tdigit_flag),
    .refclk(clk),
    .reset(reset),
    .int(int),
    .port_pad_data_out(port_pad_data_out),
    .port_pad_data_in(port_pad_data_in),
    //.spi_clk(spi_clk),
    .spi_data(spi_data),
    .spi_fs(spi_fs),
    //.scan_out0(scan_out0),
    //.scan_out1(scan_out1),
    //.scan_out2(scan_out2),
    .scan_en(scan_en),
    .scan_clk(scan_clk),
    //.scan_in0(scan_in0),
    //.scan_in1(scan_in1),
    //.scan_in2(scan_in2),
    .test_mode(test_mode),
    .pllrst(pllrst),
    .vcop(vcop),
    .vcom(vcom),
    .ibias(ibias) 
    ); 

parameter packet_size = 512; // 0.064 sec @ 8000 samples/sec
parameter quiet = packet_size;
parameter signal = packet_size;
parameter signalSize = 12*quiet + 11*signal;
parameter signalMemRange = signalSize - 1 ;

integer signalAddress, i, j ;

reg [7:0] signalMem [0:signalMemRange];
reg start;
wire [7:0] ulawPcm =signalMem[signalAddress];

initial
begin 

    $timeformat(-3,6," ms", 16);
  
 
  
    clk = 1'b0;
    rcc_sclk = 1'b0;
    spi_clk = 1'b0;
    spi_data = 1'b0;
    spi_fs = 1'b0;
    scan_en = 1'b0;
    scan_in0 = 1'b0;
    scan_in1 = 1'b0;
    scan_in2 = 1'b0;
    test_mode = 1'b0;
    reset = 1'b0;
    signalAddress = 0; 
    port_pad_data_in = 16'h0000; 
   int = 0; 
    $readmemh("../etc/ulaw_pcm.hex", signalMem);
    //$readmemh("../etc/pcm256_0.hex", top.mem);
  pllrst =1;  
  ibias = 1;
  $shm_open("waves.shm");
  $shm_probe("AC");
    #1 reset=1;
    #50 reset=0;
     int =1;
    pllrst = 0; 
    port_pad_data_in = 16'hffff; 
    #100 port_pad_data_in = 16'h33f4;
     int = 0;
    #200 port_pad_data_in = 16'h6777;
     int = 1;
   #300 port_pad_data_in = 16'h4545; 
    
end
 
  initial
      begin
        
        if ($test$plusargs("toggle")) begin
            $toggle_count(test.top.DTMF_INST.PLLCLK_INST);
          //  $toggle_count(test.top.DTMF_INST.ROM_512x16_0_INST);
            $toggle_count(test.top);
	     $toggle_count_mode(1); 
        end
	 
      end
      
      initial
      begin
        
     #500000   if ($test$plusargs("toggle")) begin
            $toggle_count_report_hier("../sim/top.hier.rtl.tcf","test.top.DTMF_INST.PLLCLK_INST");
          //  $toggle_count_report_hier("../sim/top.hier.rtl.tcf","test.top.DTMF_INST.ROM_512x16_0_INST");
            $toggle_count_report_hier("../sim/top.hier.rtl.tcf","test.top");
            $toggle_count_report_flat("../sim/top.flat.rtl.tcf","test.top");
        end
	 
      end

always #`CLK clk = ~clk ;

always #200
  ibias = ~ibias ;

always@(tdigit) $display("%c",tdigit);

 always @(tdigit_flag)
    begin

	
	$strobe("** Found digit(%c)  @ %t", tdigit, $time) ;
    end
    
/*
 *
 * generate spi interface, data to be shifted out resides in "signalMem"
 *
 */

always
    begin
    
  
    #`SPI_CLK spi_fs = 1'b1 ;
    #`SPI_CLK spi_fs = 1'b0 ;
    
    j = 7 ;
    spi_data = ulawPcm[j] ;
    for (i = 0 ; i <= 7 ; i = i + 1)
        begin
        #`SPI_CLK spi_clk = 1'b1 ;
        #`SPI_CLK spi_clk = 1'b0 ;
        if (i <= 6)
            j = j - 1 ;
        spi_data = ulawPcm[j] ;
        end
    signalAddress = signalAddress + 1 ;
    if (signalAddress == signalSize) 
    begin
    
        signalAddress = 0 ;
	$display("data loaded");
	 $finish(2);
	end
   
    #`DELAY ; 
   $display("ULAW Samples Processed : %d data=%c", signalAddress,ulawPcm);
  
    end



endmodule 
