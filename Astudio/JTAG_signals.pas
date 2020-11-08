unit Jtag_Signals;

interface
uses
        Extctrls,sysutils,StdCtrls,zlportio, ddkint,Vars_const;

procedure jtag_init ;
function  JTAG_IS_TDO_SET:byte;
function jtag_read_tdo:byte;
function JTAG_SET_TMS:byte;
function JTAG_CLEAR_TMS:byte;
function JTAG_SET_TDI:byte;
function JTAG_CLEAR_TDI:byte;
procedure JTAG_CLK;
function jtag_reset:byte;
function jtag_read(numberofbits:integer):byte;
function  jtag_write(numberofbits:integer):integer;
function jtag_write_and_read(numberofbits:integer):integer;
procedure jtag_goto_state(STATE:byte) ;
function JTAG_SET_TCK:byte;
function JTAG_CLEAR_TCK:byte;
function  jtag_write_from_address(numberofbits:longword;p:pbyte):integer;



implementation
function  JTAG_IS_TDO_SET:byte;
begin

     if portreadb($379) and $20=$20 then
     begin
         JTAG_IS_TDO_SET:=1;
     end
     else
     begin
         JTAG_IS_TDO_SET:=0;
     end;
end;
function JTAG_SET_TMS:byte;
begin
     portrb:=portreadb($378);
     portwriteb($378,portrb or $10 ) ;
     JTAG_SET_TMS:=0;
end;
function JTAG_CLEAR_TMS:byte;
begin
     portrb:=portreadb($378);
     portwriteb($378,portrb and $EF ) ;
     JTAG_CLEAR_TMS:=0;
end;

function JTAG_SET_TDI:byte;
begin
     portrb:=portreadb($378);
     portwriteb($378,portrb or $20 ) ;
     JTAG_SET_TDI:=0;
end;
function JTAG_CLEAR_TDI:byte;
begin
     portrb:=portreadb($378);
     portwriteb($378,portrb and $DF ) ;
     JTAG_CLEAR_TDI:=0;
end;
function JTAG_SET_TCK:byte;
var
        t:longword;
begin
     portrb:=portreadb($378);
     portwriteb($378,portrb or 8 ) ;
     t:=0; while t<TbPos do inc(t);
     JTAG_SET_TCK:=0;
end;

function JTAG_CLEAR_TCK:byte;
var
        t:longword;
begin
     portrb:=portreadb($378);
     portwriteb($378,portrb and $f7 ) ;
     t:=0; while t<TbPos do inc(t);
     JTAG_CLEAR_TCK:=0;
end;

procedure JTAG_CLK;
begin
     JTAG_CLEAR_TCK;
     JTAG_SET_TCK;
     JTAG_CLEAR_TCK;
end;
function jtag_reset:byte;
var
        i:integer;
begin

	JTAG_SET_TMS;
	for i:=0 to 4 do
        begin
		JTAG_CLK;
	end;
	JTAG_CLEAR_TMS;
	tapstate:=TEST_LOGIC_RESET;

	Jtag_RESET:= 1;
        T_le2.text:=states[tapstate];
end;

procedure jtag_init ;
begin
     	JTAG_CLEAR_TCK();
     	JTAG_CLEAR_TMS();
     	JTAG_CLEAR_TDI();
     	JTAG_CLEAR_TCK();

    	jtag_reset();
end;

function jtag_read_tdo:byte;
begin
	if(JTAG_IS_TDO_SET)=1 then
		jtag_read_tdo:= 1
	else
		jtag_read_tdo:= 0;
end;

procedure show_TDI_TDO(num_TDI,Num_TDO:integer);
var
   zs:word;
   JStr:string;
begin
    Jstr:='';
    zs:=0 ;
    if Tshow_TDI.Checked then
    if num_TDI>0 then
    repeat
         jstr:=jstr+inttohex(tdi_buf[zs div 8],2)+' ';
         zs:=zs+8;
    until zs>num_TDI;
    if Jstr<>'' then
    T_JTM.lines.add('TDI='+Jstr);
    Jstr:='';
    zs:=0 ;
    if Tshow_TDO.Checked then
    if num_TDO>0 then
    repeat
         jstr:=jstr+inttohex(tdo_buf[zs div 8],2)+' ';
         zs:=zs+8;
    until zs>num_TDO;
    if Jstr<>'' then
    T_JTM.lines.add('TDO='+Jstr);
end;
function jtag_read(numberofbits:integer):byte;
var
   receivedbits:longword;
   z:longword;
begin
     receivedbits:=0;
	JTAG_CLEAR_TMS;
       //
        z:=1;
        tdo_buf[0]:=0;
      while numberofbits>0 do
      begin
                dec(numberofbits);
		if(numberofbits =0) then
                begin
	 		JTAG_SET_TMS;
			if(tapstate =SHIFT_IR) then
                        begin
				tapstate:=EXIT1_IR;
			end
                        else
                        begin
				tapstate:=EXIT1_DR;
			end;
		end;

		if(JTAG_IS_TDO_SET)=1 then
			tdo_buf[receivedbits div 8] :=tdo_buf[receivedbits div 8] + (z and $ff);

		inc(receivedbits);
                z:=z*2;
                if z=256 then z:=1;
                if receivedbits mod 8=0 then
                begin
                    tdo_buf[receivedbits div 8]:=0;
                 end;
		JTAG_CLK;
  end;

	jtag_read:=receivedbits;
        show_TDI_TDO(receivedbits,receivedbits);
end;

function  jtag_write(numberofbits:integer):integer;
var
        sendbits:integer;
begin
	sendbits:=0;

	// if numbers is not vaild
	if(numberofbits<=0) then
        begin
		jtag_write:= -1;exit;
        end;
	JTAG_CLEAR_TMS;

	//numberofbits--;
	while(numberofbits>0) do
	begin
                 dec(numberofbits);

		if(numberofbits =0) then
		begin
	 		JTAG_SET_TMS;
			if(tapstate =SHIFT_IR) then
			begin
				tapstate:=EXIT1_IR;
			end
			else
			begin
				tapstate:=EXIT1_DR;
			end;
		end;

		if(tdi_buf[sendbits div 8] shr (sendbits and 7) and 1)=1 then
		begin
			JTAG_SET_TDI

       		end
		else
		begin
			JTAG_CLEAR_TDI;
		end;

		inc(sendbits);
		JTAG_CLK;
	end;
	 jtag_write:=sendbits;
         show_TDI_TDO(sendbits,sendbits);
end;

function  jtag_write_from_address(numberofbits:longword;p:pbyte):integer;
var
        sendbits:longword;
begin
	sendbits:=0;

	// if numbers is not vaild
	if(numberofbits<=0) then
        begin
		jtag_write_from_address:= -1;exit;
        end;
	JTAG_CLEAR_TMS;

	//numberofbits--;
	while(numberofbits>0) do
	begin
                 dec(numberofbits);

		if(numberofbits =0) then
		begin
	 		JTAG_SET_TMS;
			if(tapstate =SHIFT_IR) then
			begin
				tapstate:=EXIT1_IR;
			end
			else
			begin
				tapstate:=EXIT1_DR;
			end;
		end;

		if(p^ shr (sendbits and 7) and 1)=1 then
		begin
			JTAG_SET_TDI

       		end
		else
		begin
			JTAG_CLEAR_TDI;
		end;

		inc(sendbits);
                if sendbits mod 8=0 then inc(p);
		JTAG_CLK;
	end;
	 jtag_write_from_address:=sendbits;
         show_TDI_TDO(sendbits,sendbits);
end;



function jtag_write_and_read(numberofbits:integer):integer;
var
        z,bits:longword;
begin
	bits:=0;

	// if numbers is not vaild
	if(numberofbits<=0) then
        begin
		jtag_write_and_read:=-1;exit;
        end;
        z:=1;
	JTAG_CLEAR_TMS;
         tdo_buf[0]:=0;
         while(numberofbits)>0 do
         begin
                dec(numberofbits);
		if(numberofbits =0) then
                begin
	 		JTAG_SET_TMS;
			if(tapstate =SHIFT_IR) then
                        begin
				tapstate:=EXIT1_IR;
			end
                        else
                        begin
				tapstate:=EXIT1_DR;
			end;
		end;
		if (tdi_buf[bits div 8] shr (bits and 7) and 1)=1 then
			JTAG_SET_TDI
		else
			JTAG_CLEAR_TDI;
		if(JTAG_IS_TDO_SET)=1 then
			tdo_buf[bits div 8] := tdo_buf[bits div 8] +(z and $ff);

		JTAG_CLK;



                z:=z*2;
                if z=256 then z:=1;
	        inc(bits);
                if bits mod 8 =0 then
                begin
                    tdo_buf[bits div 8]:=0;
                end;
          end;
	jtag_write_and_read:=bits;
        show_TDI_TDO(bits,bits);
end;


procedure jtag_goto_state(STATE:byte) ;
begin

  if( state > UPDATE_IR )then exit;

  while( tapstate <> state )do
  begin
     if Tshow_states.checked then
      T_JTM.lines.add('FState='+states[tapstate]);

		case( tapstate ) of
	        TEST_LOGIC_RESET:begin
			  JTAG_CLEAR_TMS;
	  		JTAG_CLK;
	  		tapstate:=RUN_TEST_IDLE;
                end;
                RUN_TEST_IDLE:begin
	  		JTAG_SET_TMS;
	  		JTAG_CLK;
	  		tapstate:=SELECT_DR_SCAN;
                end;
	  	SELECT_DR_SCAN:begin
	  		if( state < TEST_LOGIC_RESET ) then
                begin
	      	        JTAG_CLEAR_TMS;
	      	        JTAG_CLK;
	      	        tapstate:=CAPTURE_DR;
	    	end
                else
                begin
	      	        JTAG_SET_TMS;
	      	        JTAG_CLK;
	      	        tapstate:=SELECT_IR_SCAN;
	    	end;
	  	end;
                CAPTURE_DR:begin
	  		if( state  = SHIFT_DR ) then
                        begin
      		        JTAG_CLEAR_TMS;
      		        JTAG_CLK;
      		        tapstate:=SHIFT_DR;
    		        end
                        else
                        begin
	    		JTAG_SET_TMS;
	    		JTAG_CLK;
	    		tapstate:=EXIT1_DR;
                        end;
                end;
                SHIFT_DR:begin
	  		JTAG_SET_TMS;
	  		JTAG_CLK;
	  		tapstate:=EXIT1_DR;
	  	end;
                EXIT1_DR:begin
	  		if( state  = PAUSE_DR) or (state  = EXIT2_DR ) then
                        begin
	      	        JTAG_CLEAR_TMS;
	      	        JTAG_CLK;
	      	        tapstate:=PAUSE_DR;
	   	 	end
                        else
                        begin
	      	        JTAG_SET_TMS;
	      	        JTAG_CLK;
	      	        tapstate:=UPDATE_DR;
	    	        end;
	  	end;
                PAUSE_DR:begin
	  		JTAG_SET_TMS;
	  		JTAG_CLK;
	  		tapstate:=EXIT2_DR;
	  	end;
                EXIT2_DR:begin
	  		if( state  = SHIFT_DR) or (state  = EXIT1_DR)
                         or (state  = PAUSE_DR )then
                         begin
	      	        JTAG_CLEAR_TMS;
	      	        JTAG_CLK;
	      	        tapstate:=SHIFT_DR;
	    	        end
                        else
                        begin
	      	        JTAG_SET_TMS;
	      	        JTAG_CLK;
	      	        tapstate:=UPDATE_DR;
	    	        end;
	  	end;
                UPDATE_DR:begin
	  		if( state  = RUN_TEST_IDLE ) then
                        begin
	      	        JTAG_CLEAR_TMS;
	      	        JTAG_CLK;
	      	        tapstate:=RUN_TEST_IDLE;
	    	        end
                        else
                        begin
	      	        JTAG_SET_TMS;
	      	        JTAG_CLK;
	      	        tapstate:=SELECT_DR_SCAN;
	    	        end;
	  	end;
                SELECT_IR_SCAN:begin
	  		if( state <> TEST_LOGIC_RESET ) then
                        begin
	      	        JTAG_CLEAR_TMS;
	      	        JTAG_CLK;
	      	        tapstate:=CAPTURE_IR;
	    	        end
                        else
                        begin
	      	        JTAG_SET_TMS;
	      	        JTAG_CLK;
	      	        tapstate:=TEST_LOGIC_RESET;
	    	        end;
	  	end;
                CAPTURE_IR:begin
	  		if( state  = SHIFT_IR )then
                        begin
	      	        JTAG_CLEAR_TMS;
	      	        JTAG_CLK;
	      	        tapstate:=SHIFT_IR;
	    	        end
                        else
                        begin
	      	        JTAG_SET_TMS;
	      	        JTAG_CLK;
	      	        tapstate:=EXIT1_IR;
	    	        end;
	  	end;
                SHIFT_IR:begin
	  		JTAG_SET_TMS;
	  		JTAG_CLK;
	  		tapstate:=EXIT1_IR;
	  	end;
                EXIT1_IR:begin
	  		if( state  = PAUSE_IR) or (state  = EXIT2_IR )then
                        begin
	      	        JTAG_CLEAR_TMS;
	      	        JTAG_CLK;
	      	        tapstate:=PAUSE_IR;
	    	        end
                        else
                        begin
	      	        JTAG_SET_TMS;
	      	        JTAG_CLK;
	      	        tapstate:=UPDATE_IR;
	    	        end;
	  	end;
                PAUSE_IR:begin
	  		JTAG_SET_TMS;
	  		JTAG_CLK;
	  		tapstate:=EXIT2_IR;
	  	end;EXIT2_IR:begin
	  		if( state  = SHIFT_IR) or (state  = EXIT1_IR)
                        or (state  = PAUSE_IR ) then
                        begin
	      	        JTAG_CLEAR_TMS;
	      	        JTAG_CLK;
	      	        tapstate:=SHIFT_IR;
	        	end
                        else
                        begin
	      	        JTAG_SET_TMS;
	      	        JTAG_CLK;
	      	        tapstate:=UPDATE_IR;
	    	        end;
	  	end;UPDATE_IR:begin
	  		if( state  = RUN_TEST_IDLE ) then
                        begin
	      	        JTAG_CLEAR_TMS;
	      	        JTAG_CLK;
	      	        tapstate:=RUN_TEST_IDLE;
	    	        end
                        else
                        begin
	      	        JTAG_SET_TMS;
	      	        JTAG_CLK;
	      	        tapstate:=SELECT_DR_SCAN;
	    	        end;
	  	end
                else
		    exit;
		end;
  end;
  T_le2.Text:=states[tapstate];
  if Tshow_states.checked then
  T_JTM.lines.add('LState='+states[tapstate]);

end;

end.
