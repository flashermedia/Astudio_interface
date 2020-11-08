unit JTAG_AVR;

interface
uses
        jtag_signals,ISP_communication,vars_const;


procedure avr_sequence(tdi2,tdi1:byte );
procedure Pavr_reset(true:byte);
procedure avr_prog_enable;
procedure avr_prog_cmd;
function avr_jtag_instr(instr:byte;delay:integer):byte;
Procedure Enter_Prog_mode;
Procedure Leave_Prog_mode;
procedure idcode;
procedure THE_Jtag_super_init;


implementation


procedure idcode;
begin
	// READ IDCODE
	jtag_goto_state(SHIFT_IR);
	tdi_buf[0]:=AVR_IDCODE;
	jtag_write(4);
	jtag_goto_state(SHIFT_DR);
	jtag_write_and_read(32);//jtag_read(32);
end;

procedure Pbypass;
begin

end;

procedure Pavr_reset(true:byte);
begin
	// RESET
	jtag_goto_state(SHIFT_IR);

	tdi_buf[0]:=AVR_RESET;
	jtag_write(4);
	jtag_goto_state(SHIFT_DR);
	if(true=1) then
        tdi_buf[0]:=1
	else
        tdi_buf[0]:=0;
	jtag_write(1);
end;

procedure avr_prog_enable;
begin
  // ENABLE PROG

	jtag_goto_state(SHIFT_IR);
	tdi_buf[0]:=AVR_PRG_ENABLE;
	jtag_write(4);
	jtag_goto_state(SHIFT_DR);
	tdi_buf[0]:=$70;
	tdi_buf[1]:=$A3;
	jtag_write(16);
end;
procedure avr_prog_cmd;
begin

	jtag_goto_state(SHIFT_IR);
	tdi_buf[0]:=AVR_PRG_CMDS;
	jtag_write(4);
	jtag_goto_state(SHIFT_DR);
end;

Procedure Enter_Prog_mode;
begin
    Reset_one;
    Pavr_reset(1);
    avr_prog_enable;
    avr_prog_cmd;
end;
Procedure LEAVE_Prog_mode;
begin
	jtag_goto_state(SHIFT_IR);
	tdi_buf[0]:=AVR_PRG_CMDS;
	jtag_write(4);
	jtag_goto_state(SHIFT_DR);
	tdi_buf[0]:=$23;   //nop
	tdi_buf[1]:=$00;
	jtag_write(16);
	jtag_goto_state(SHIFT_DR);
	tdi_buf[0]:=$33;   //nop
	tdi_buf[1]:=$00;
	jtag_write(16);
	jtag_goto_state(SHIFT_IR);
	tdi_buf[0]:=AVR_PRG_ENABLE;
	jtag_write(4);
	jtag_goto_state(SHIFT_DR);
	tdi_buf[0]:=$00;
	tdi_buf[1]:=$00;
	jtag_write(16);
        Pavr_reset(0);

end;


function avr_jtag_instr(instr:byte;delay:integer):byte;
begin
	jtag_goto_state(SHIFT_IR);
	tdi_buf[0]:=instr;
	jtag_write(4);
	jtag_goto_state(SHIFT_DR);
	avr_jtag_instr:=1;
end;




//tdi2 = 7 bit
//tdi1 = 8 bit 
procedure avr_sequence(tdi2,tdi1:byte );
begin
	
	jtag_goto_state(SHIFT_DR);
	tdi_buf[0]:=tdi1;  //  select fuse
	tdi_buf[1]:=tdi2;
	jtag_write_and_read(15);
	jtag_goto_state(RUN_TEST_IDLE);
end;

procedure The_Jtag_super_init;
begin
	Pavr_reset(1);
	Pavr_reset(0);

	jtag_reset;
	avr_jtag_instr(AVR_OCD,0);

	tdi_buf[0]:=$00;
	tdi_buf[1]:=$80;
	tdi_buf[2]:=$1D;

	jtag_write(21);

	jtag_reset();
	avr_jtag_instr(AVR_INSTR,0);
	tdi_buf[0]:=$05;
	tdi_buf[1]:=$EF;
	jtag_write(16);

	jtag_reset();
	avr_jtag_instr(AVR_INSTR,0);
	tdi_buf[0]:=$01;
	tdi_buf[1]:=$BF;
	jtag_write(16);



	jtag_reset();
	avr_jtag_instr(AVR_OCD,0);

	tdi_buf[0]:=$0C;
	jtag_write(5);


	jtag_goto_state(SHIFT_DR);
	tdi_buf[0]:=$00;
	tdi_buf[1]:=$00;
	tdi_buf[2]:=$00;
	tdi_buf[3]:=$00;
	jtag_write_and_read(32);

end;

end.
