module iopads( 
               tdigit, tdigit_flag,
               reset, int, tdsp_port_out, tdsp_port_in,
	       scan_en, test_mode, scan_clk,
               spi_data, spi_fs,
	       refclk, vcop, vcom, pllrst, ibias,
               tdigitO, tdigit_flagO,
               resetI, intI, tdsp_portO, tdsp_portI,
	       scan_enI, test_modeI, scan_clkI,
               spi_dataI, spi_fsI,
	       refclkI, vcopO, vcomO, pllrstI, ibiasI, scan_in_1, scan_in_2, scan_out_1, scan_out_2, scan_in_1I, scan_in_2I, scan_out_1O, scan_out_2O);

   output  [7:0] tdigit ;
   output [15:0] tdsp_port_out ;

   input  [15:0] tdsp_port_in ;

   output tdigit_flag	,
          vcop		,
          vcom ;

   input  reset		,
          int		,
          scan_en	,
          scan_clk	,
          test_mode	,
          spi_data	,
          spi_fs	,
          refclk	,
          pllrst	,
	 ibias ;

   input   [7:0] tdigitO ;
   input  [15:0] tdsp_portO ;

   output [15:0] tdsp_portI ;

   input  tdigit_flagO	,
          vcopO		,
          vcomO ;

   output resetI	,
          intI		,
          scan_enI	,
          scan_clkI	,
          test_modeI	,
          spi_dataI	,
          spi_fsI	,
          refclkI	,
          pllrstI	,
          ibiasI ;

   output scan_in_1I;
   output scan_in_2I;
   output scan_out_1;
   output scan_out_2;

   input scan_out_1O;
   input scan_out_2O;
   input scan_in_1;
   input scan_in_2;

/* Power and Ground cells should be added through FE ioc file */
/*   PVSS1DGZ  Pvss0( );  */
/*   PVSS1DGZ  Pvss1( );  */
/*   PVSS1DGZ  Pvss2( );  */
/*   PVSS1DGZ  Pvss3( );  */
/*   PVDD1DGZ  Pvdd0( );  */
/*   PVDD1DGZ  Pvdd1( );  */
/*   PVDD1DGZ  Pvdd2( );  */
/*   PVDD1DGZ  Pvdd3( );  */
/*   PVDD1DGZ  Pavdd0( );  */
/*   PVSS1DGZ  Pavss0( );  */
/*   PCORNERDG Pcornerul( );  
   PCORNERDG Pcornerur( );  
   PCORNERDG Pcornerll( );  
   PCORNERDG Pcornerlr( );*/
  
   PCORNERDG Pcornerlr ();
   PCORNERDG Pcornerll ();
   PCORNERDG Pcornerur ();
   PCORNERDG Pcornerul ();
   PVSS1DGZ Pavss0 ();
   PVDD1DGZ Pavdd0 ();
   PVDD1DGZ Pvdd3 ();
   PVDD1DGZ Pvdd2 ();
   PVDD1DGZ Pvdd1 ();
   PVDD1DGZ Pvdd0 ();
   PVSS1DGZ Pvss3 ();
   PVSS1DGZ Pvss2 ();
   PVSS1DGZ Pvss1 ();
   PVSS1DGZ Pvss0 ();
   PDO04CDG  Ptdspop15(.I(tdsp_portO[15]),	.PAD(tdsp_port_out[15]));
   PDO04CDG  Ptdspop14(.I(tdsp_portO[14]),	.PAD(tdsp_port_out[14]));
   PDO04CDG  Ptdspop13(.I(tdsp_portO[13]),	.PAD(tdsp_port_out[13]));
   PDO04CDG  Ptdspop12(.I(tdsp_portO[12]),	.PAD(tdsp_port_out[12]));
   PDO04CDG  Ptdspop11(.I(tdsp_portO[11]),	.PAD(tdsp_port_out[11]));
   PDO04CDG  Ptdspop10(.I(tdsp_portO[10]),	.PAD(tdsp_port_out[10]));
   PDO04CDG  Ptdspop09(.I(tdsp_portO[9]),	.PAD(tdsp_port_out[9]));
   PDO04CDG  Ptdspop08(.I(tdsp_portO[8]),	.PAD(tdsp_port_out[8]));
   PDO04CDG  Ptdspop07(.I(tdsp_portO[7]),	.PAD(tdsp_port_out[7]));
   PDO04CDG  Ptdspop06(.I(tdsp_portO[6]),	.PAD(tdsp_port_out[6]));
   PDO04CDG  Ptdspop05(.I(tdsp_portO[5]),	.PAD(tdsp_port_out[5]));
   PDO04CDG  Ptdspop04(.I(tdsp_portO[4]),	.PAD(tdsp_port_out[4]));
   PDO04CDG  Ptdspop03(.I(tdsp_portO[3]),	.PAD(tdsp_port_out[3]));
   PDO04CDG  Ptdspop02(.I(tdsp_portO[2]),	.PAD(tdsp_port_out[2]));
   PDO04CDG  Ptdspop01(.I(tdsp_portO[1]),	.PAD(tdsp_port_out[1]));
   PDO04CDG  Ptdspop00(.I(tdsp_portO[0]),	.PAD(tdsp_port_out[0]));
   PDO04CDG  Ptdigfgop(.I(tdigit_flagO),	.PAD(tdigit_flag));
   PDO04CDG  Ptdigop7( .I(tdigitO[7]),		.PAD(tdigit[7]));
   PDO04CDG  Ptdigop6( .I(tdigitO[6]),		.PAD(tdigit[6]));
   PDO04CDG  Ptdigop5( .I(tdigitO[5]),		.PAD(tdigit[5]));
   PDO04CDG  Ptdigop4( .I(tdigitO[4]),		.PAD(tdigit[4]));
   PDO04CDG  Ptdigop3( .I(tdigitO[3]),		.PAD(tdigit[3]));
   PDO04CDG  Ptdigop2( .I(tdigitO[2]),		.PAD(tdigit[2]));
   PDO04CDG  Ptdigop1( .I(tdigitO[1]),		.PAD(tdigit[1]));
   PDO04CDG  Ptdigop0( .I(tdigitO[0]),		.PAD(tdigit[0]));
   PDO04CDG  Pvcopop(  .I(vcopO),		.PAD(vcop));
   PDO04CDG  Pvcomop(  .I(vcomO),		.PAD(vcom));

   PDIDGZ    Ptdspip15(.PAD(tdsp_port_in[15]),		.C(tdsp_portI[15]));
   PDIDGZ    Ptdspip14(.PAD(tdsp_port_in[14]),		.C(tdsp_portI[14]));
   PDIDGZ    Ptdspip13(.PAD(tdsp_port_in[13]),		.C(tdsp_portI[13]));
   PDIDGZ    Ptdspip12(.PAD(tdsp_port_in[12]),		.C(tdsp_portI[12]));
   PDIDGZ    Ptdspip11(.PAD(tdsp_port_in[11]),		.C(tdsp_portI[11]));
   PDIDGZ    Ptdspip10(.PAD(tdsp_port_in[10]),		.C(tdsp_portI[10]));
   PDIDGZ    Ptdspip09(.PAD(tdsp_port_in[9]),		.C(tdsp_portI[9]));
   PDIDGZ    Ptdspip08(.PAD(tdsp_port_in[8]),		.C(tdsp_portI[8]));
   PDIDGZ    Ptdspip07(.PAD(tdsp_port_in[7]),		.C(tdsp_portI[7]));
   PDIDGZ    Ptdspip06(.PAD(tdsp_port_in[6]),		.C(tdsp_portI[6]));
   PDIDGZ    Ptdspip05(.PAD(tdsp_port_in[5]),		.C(tdsp_portI[5]));
   PDIDGZ    Ptdspip04(.PAD(tdsp_port_in[4]),		.C(tdsp_portI[4]));
   PDIDGZ    Ptdspip03(.PAD(tdsp_port_in[3]),		.C(tdsp_portI[3]));
   PDIDGZ    Ptdspip02(.PAD(tdsp_port_in[2]),		.C(tdsp_portI[2]));
   PDIDGZ    Ptdspip01(.PAD(tdsp_port_in[1]),		.C(tdsp_portI[1]));
   PDIDGZ    Ptdspip00(.PAD(tdsp_port_in[0]),		.C(tdsp_portI[0]));
   PDIDGZ    Pscanenip(.PAD(scan_en),		.C(scan_enI));
   PDIDGZ    Pscanckip(.PAD(scan_clk),		.C(scan_clkI));
   PDIDGZ    Ptestmdip(.PAD(test_mode),		.C(test_modeI));
   PDIDGZ    Pspifsip( .PAD(spi_fs),		.C(spi_fsI));
   PDIDGZ    Pspidip(  .PAD(spi_data),		.C(spi_dataI));
   PDIDGZ    Presetip( .PAD(reset),		.C(resetI));
   PDIDGZ    Pintip (.PAD(int),			.C(intI));
   PDIDGZ    Prefclkip(.PAD(refclk),		.C(refclkI));
   PDIDGZ    Ppllrstip(.PAD(pllrst),		.C(pllrstI));
   PDIDGZ    Pibiasip(.PAD(ibias),		.C(ibiasI));
   
   PDIDGZ    Pscanin1ip  (.PAD(scan_in_1), .C(scan_in_1I));
   PDIDGZ    Pscanin2ip  (.PAD(scan_in_2), .C(scan_in_2I));  
   PDO04CDG  Pscanout2op (.I(scan_out_2O), .PAD(scan_out_2));
   PDO04CDG  Pscanout1op (.I(scan_out_1O), .PAD(scan_out_1));


endmodule 



