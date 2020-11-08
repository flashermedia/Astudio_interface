unit JTAG_AVR_TAP;

interface
uses
        SysUtils,Vars_const,JTAG_signals,JTAG_AVR;

procedure rd_lock_avr;
procedure rd_efuse_avr;
procedure rd_lfuse_avr;
procedure rd_hfuse_avr;
procedure rd_signature_avr ;
procedure rd_flash_page(byteCount:word;address:word);
function chip_erase:boolean;
procedure rd_eeprom_page(byteCount:integer; address:word);
procedure wr_eeprom_page(byteCount:integer; address:word;pb:pbyte) ;
procedure wr_flash_page(bytecount:integer;address:word;p:pbyte);
procedure wr_hfuse_avr;
procedure wr_lfuse_avr;
procedure wr_efuse_avr;
procedure wr_lock_avr;

implementation

procedure rd_flash_page(byteCount:word;address:word);
var
        i:integer;
        addr:word;
begin

       //	adress >>= 1;
       addr:=address;
	avr_sequence($23, $02);
        i:=0;
	while i< byteCount-1 do
	begin
		avr_sequence($07, (addr shr 8) and $FF);
		avr_sequence($03, addr and $FF);
		avr_sequence($32, $00);
		avr_sequence($36, $00);
                data[i]:=tdo_buf[0];
		avr_sequence($37, $00);
                data[i + 1]:=tdo_buf[0];
                inc(i,2);
                inc(addr);
	end;
end;


procedure rd_lock_avr;
begin

	avr_sequence($23,$04);	//enter fuse lock bits
	avr_sequence($36,$00);	// select lfuse
	avr_sequence($37,$00);	// read lock

end;

procedure rd_efuse_avr;
begin

	avr_sequence($23,$04);	//enter fuse lock bits
	avr_sequence($32,$00);	// select lfuse
	avr_sequence($33,$00); // read lfuse

end;

procedure rd_lfuse_avr;
begin

	avr_sequence($23,$04);	//enter fuse lock bits
	avr_sequence($32,$00);	// select lfuse
	avr_sequence($33,$00); // read lfuse

end;


procedure rd_hfuse_avr;
begin
        avr_sequence($23,$04);	//enter fuse lock bits
	avr_sequence($3E,$00);	// select hfuse
	avr_sequence($3F,$00); // read hfuse

end;

procedure rd_fuse_avr ;
begin
end;


procedure rd_signature_avr ;
begin

	avr_sequence($23,$08);
	avr_sequence($03,$00);
	avr_sequence($32,$00);
	avr_sequence($33,$00);
        signature[1]:=tdo_buf[0];

	avr_sequence($23,$08);
	avr_sequence($03,$01);
	avr_sequence($32,$00);
	avr_sequence($33,$00);
        signature[2]:=tdo_buf[0];

	avr_sequence($23,$08);
	avr_sequence($03,$02);
	avr_sequence($32,$00);
	avr_sequence($33,$00);
        signature[3]:=tdo_buf[0];

end;


procedure wr_hfuse_avr;
begin
	avr_sequence($23,$40);
	avr_sequence($13,chfuse);
	avr_sequence($37,$00);
	avr_sequence($35,$00);
	avr_sequence($37,$00);
	avr_sequence($37,$00);
	avr_sequence($37,$00);
end;

procedure wr_lfuse_avr;
begin

	avr_sequence($23,$40);
	avr_sequence($13,clfuse);
	avr_sequence($33,$00);
	avr_sequence($31,$00);
	avr_sequence($33,$00);
	avr_sequence($33,$00);
	avr_sequence($33,$00);
end;

procedure wr_efuse_avr;
begin

	avr_sequence($23,$40);
	avr_sequence($13,cefuse);
	avr_sequence($3B,$00);
	avr_sequence($39,$00);
	avr_sequence($3B,$00);
	avr_sequence($3B,$00);
	avr_sequence($37,$00);
end;

procedure wr_lock_avr;
begin

	avr_sequence($23,$20);
	avr_sequence($13,clbits or $C0 );
	avr_sequence($33,$00);
	avr_sequence($31,$00);
	avr_sequence($33,$00);
	avr_sequence($33,$00);
	repeat
            avr_sequence($33,$00);
       	until((tdo_buf[1] and $02)<>2);
end;


procedure rd_cal_bytel ;
begin

	avr_sequence($23,$08);
	avr_sequence($03,caddress);
	avr_sequence($36,$00);
	avr_sequence($37,$00);
end;



function chip_erase:boolean;
var
        d:word;

begin

	avr_sequence($23,$80);
	avr_sequence($31,$80);
	avr_sequence($33,$80);
	avr_sequence($33,$80);
        avr_sequence($23,$08);
        //wait awhile
        d:=0;
        while d<=20000 do inc(d);
        avr_sequence($33,$80);
	if (tdo_buf[1] and $02=2) then chip_erase:=false
        else
        chip_erase:=true;
end;




procedure wr_flash_page(bytecount:integer;address:word;p:pbyte);
var
        i:word;
        addr:longword;
        pb:pbyte;
begin

        addr:=address shr 1;
        if T_S_record.checked then
        begin
             str:='bytes='+inttohex(bytecount,4)+' addr='+inttohex(addr,4)+
             char(13)+char(10);
             str:=str+'write bytes='; pb:=p;
             for i:=0 to bytecount-1 do
             begin
                  str:=str+inttohex(pb^,2)+',';
                  inc(pb);
             end;
             T_M1.lines.add(str);

        end;
        //(1) instr = AVR_PRG_CMDS (0x5)
        //(2) data[tdi] = [0x10, 0x23], [high byte address, 0x07], [low byte address, 0x03]
	avr_prog_cmd();					//Prog Enable
	avr_sequence($23, $10);
        avr_sequence($07, (addr shr 8) and $FF);
        avr_sequence($03, addr and $FF );
        //(3) instr = AVR_PRG_PAGE_LOAD (0x6)
        avr_jtag_instr(AVR_PRG_PAGE_LOAD, 0);
        //(4) data[tdi] = [data_byte0, data_byte1], ...
        jtag_write_from_address(8*bytecount,p);
        //(5) instr = AVR_PRG_CMDS (0x5)
        avr_prog_cmd();					//Prog Enable
        //(6) data[tdi] = [0x00, 0x37], [0x00, 0x35], [0x00, 0x37], [0x00, 0x37]
        avr_sequence($37, $00);
	avr_sequence($35, $00);
	avr_sequence($37, $00);
	avr_sequence($37, $00);

        //8. Poll for Flash write complete using programming instruction 2h,
        //   or wait for tWLRH (refer to Table 112 on page 267).
        //0110111_00000000
        i:=0;
	repeat

		avr_sequence($37, $00);
                if i=1000 then tdo_buf[1]:=$20;
                inc(i);
	until((tdo_buf[1] and $20)=$20);

//9. Repeat steps 3 to 8 until all data have been programmed.
end;
procedure wr_eeprom_page(byteCount:integer; address:word;pb:pbyte) ;
var
        z,i:word;
begin
//1. Enter JTAG instruction PROG_COMMANDS.

     	avr_prog_cmd();					//Prog Enable
        //enter Eprom write 0100011_00010001
//2. Enable EEPROM write using programming instruction 4a.
	avr_sequence($23, $11);
//3. Load address high byte using programming instruction 4b.
        //load address high 0000111_aaaaaaaa
        z:=address;
        avr_sequence($07, hi(z) and $FF);

//9. Repeat steps 3 to 8 until all data have been programmed. }
        for i:= 0 to byteCount-1 do// i++, adress++)
	begin

//4. Load address low byte using programming instruction 4c.

              //load address low 0000111_aaaaaaaa
              avr_sequence($03, z  and $FF);
//5. Load data using programming instructions 4d and 4e.
              //load data byte
              avr_sequence($13, pb^);
              // jtag_write_from_address(8*bytecount,pb);
               //latch data
		avr_sequence($37, $00);
		avr_sequence($77, $00);
		avr_sequence($37, $00);
                inc(z) ;
//6. Repeat steps 4 and 5 for all data bytes in the page.
                inc(pb);
	end;
//7. Write the data using programming instruction 4f.
	avr_sequence($33, $00);
	avr_sequence($31, $00);
	avr_sequence($33, $00);
	avr_sequence($33, $00);
        i:=0;
//8. Poll for EEPROM write complete using programming instruction 4g, or wait for tWLRH
//(refer to Table Note: on page 299).
        repeat
		avr_sequence($33, $00);
                if i=2000 then tdo_buf[1]:=$20;
                inc(i);
	until((tdo_buf[1] and $20)=$20);
end;

procedure rd_eeprom_page(byteCount:integer; address:word);
var
        i:word;
begin
        avr_prog_cmd();	
	avr_sequence($23, $03);

	for i := 0 to byteCount-1 do//; i++)
	begin
		avr_sequence($07, (address shr 8) and $FF);
		avr_sequence($03, address and $FF);

		avr_sequence($33, address and $FF);
		avr_sequence($32, $00);
		avr_sequence($33, $00);
                data[i]:=tdo_buf[0];
                inc(address);

	end;
end;



end.
