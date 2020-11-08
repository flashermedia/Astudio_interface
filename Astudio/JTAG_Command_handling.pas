unit JTAG_Command_handling;

interface
uses
        SysUtils,Vars_const,ISP_Communication,MicroController,avrrisc
        ,Jtag_AVR,JTAG_AVR_TAP,JTAG_signals,comport;



procedure Analyse_Jtag;

var
        tsd:byte=0;
implementation
procedure write_str;
var
        wx:string;
        x:word;
begin
     wx:='str=';
     for x:=1 to length(str) do
     wx:=wx+inttohex(ord(str[x]),2) +',';
     t_m1.lines.add(wx);
end;
procedure Calc_crc(trx,str:string);
var
        le,x:word;bb:word;
begin
     bb:=$ffff;
     T_m1.lines.add('str len='+inttostr(length(str)));
     write_str;
     J_val:='';
     le:=length(str)-8;
     str[4]:=char(lo(le));
     str[5]:=char(hi(le));
     for x:=1 to length(str) do
     begin
         stk_val:=stk_val+inttohex(ord(str[x]),2)+',';
         bb:=Hi(bb) XOR CRCTable[ ord(str[x]) XOR Lo(bb) ];
     end;
     str:=str+char(lo(bb))+char(hi(bb));
     stk_val:=stk_val+inttohex(bb,4);
     T_CPortDrv.SendString( str);
     if T_S_record.checked then
     begin
        T_sig2.lines.add(trx);
        T_sig2.Lines.add('OUTput='+stk_val);
     end
     else
     T_m1.lines.add(trx);
     stk_val:='';
end;
procedure RSP_OK(te:string);
begin
        str:=#$1b+char(lo(J_Seq))+char(hi(J_seq))+#0+#0+#0+#0+#14+#$80;
        Calc_crc(te,str);
end;
procedure RSP_FAIL(te:string);
begin
        str:=#$1b+char(lo(J_Seq))+char(hi(J_seq))+#0+#0+#0+#0+#14+#$A0;
        Calc_crc(te,str);
end;

procedure Analyse_Jtag;
var
        dx,fnd,p,d,pnum,x,te:longword;
begin
     fnd:=0;
     case J_com of

      CMND_SIGN_OFF:begin //                    $00;  // Sign off
       fnd:=1;
       RSP_OK('JTAG CMND_GET_SIGN_OFF');
       T_Baud.itemindex:=2;
       SetupComport('');
      end;
      CMND_GET_SIGN_ON:begin //                 $01;  // Check if Emulator is present
        fnd:=1;
        str:=#$1b+char(lo(J_Seq))+char(hi(J_seq))+#0+#0+#0+#0+#14+#$86;
        te:=paddress[$25];
        str:=str+char(Jparams[te]); //4,    {COMM_ID=}
        str:=str+char(Jparams[1]);   //4 ,   {M_MCU_BLDR=}
        str:=str+char(Jparams[3]);   //$21 , {M_MCU_FW_MIN=}
        str:=str+char(Jparams[4]);   //4,    {M_MCU_FW_MAJ=}
        str:=str+char(Jparams[1]);   //4,    {M_MCU_HW=}
        str:=str+char(Jparams[2]);   //4,    {S_MCU_BLDR=}
        str:=str+char(Jparams[5]);   //$21,  {S_MCU_FW_MIN=}
        str:=str+char(Jparams[6]);   //4,    {S_MCU_FW_MAJ=}
        str:=str+char(Jparams[2]);   //4     {S_MCU_HW=}  );
        for x:=$31 to $36 do
        str:=str+char(x);
        str:=str+'DELPHI_MK2'+#0 ;
        Calc_crc('JTAG CMND_GET_SIGN_ON',str);

      end;
      CMND_SET_PARAMETER:begin //               $02;  // Write Emulator Parameter
         fnd:=1;
         pnum:=va[J_st];
         dx:=va[J_st+1];
         p:=paddress[pnum]; //get address of parameter in params
         d:=ptable[pnum];   //get length of parameter
         inc(j_st);
         for x:=1 to d do
         begin
              jparams[p]:=va[J_st];
              inc(J_st);
              inc(p);
         end;


         RSP_OK('JTAG CMND_SET_PARAMETER');
         if pnum=5 then
         case dx of
         {9600
         14400
         19200
         38400
         57600
         115200
}
         1:begin
               SetupComport('');
         end;
         2:begin
               SetupComport('');
         end;
         3:begin
               T_Baud.itemindex:=0;
               SetupComport('');
         end;
         4:begin
               T_Baud.itemindex:=2;
               SetupComport('');
         end;
         5:begin
               T_Baud.itemindex:=3;
               SetupComport('');
         end;
         6:begin
               T_Baud.itemindex:=4;
               SetupComport('');
         end;
         7:begin
               T_Baud.itemindex:=5;
               SetupComport('');
         end;
         8:begin
               T_Baud.itemindex:=1;
               SetupComport('');
         end;
         end;         
      end;
      CMND_GET_PARAMETER:begin //               $03;  // Read Emulator Parameter
        fnd:=1;
        str:=#$1b+char(lo(J_Seq))+char(hi(J_seq))+#0+#0+#0+#0+#14+#$81;
         pnum:=va[J_st];
         p:=paddress[pnum]; //get address of parameter in params
         d:=ptable[pnum];   //get length of parameter
         T_m1.Lines.add('pnum='+inttostr(pnum)+',p='+inttostr(p)+',d='+inttostr(d));
         if pnum=14 then
         pnum:=14;
         for x:=1 to d do
         begin
              str:=str+char(jparams[p]) ;
              inc(p);
         end;
         calc_crc('JTAG CMND_GET_PARAMETER-'+Param_strs[pnum]
         +'='+inttohex(jparams[p],2),str);
      end;
      CMND_WRITE_MEMORY:begin //                $04;  // Write Memory
        dptr:=@va[J_st];
        p:=dptr^;inc(dptr);
        te:=dptr^;inc(dptr);
        te:=te+(dptr^ shl 8);inc(dptr);
        te:=te+(dptr^ shl 16);inc(dptr);
        te:=te+(dptr^ shl 24);inc(dptr);
        inc(tsd);
        if tsd=3 then
        str:='';
        d:=dptr^;inc(dptr);
        d:=d+(dptr^ shl 8);inc(dptr);
        d:=d+(dptr^ shl 16);inc(dptr);
        d:=d+(dptr^ shl 24);inc(dptr);
        case p of
        $30:begin   //shadow
        end;
        $20:begin   //SRAM
        end;
        $22:begin    //EEprom

        end;
        $60:begin    //Event
        end;
        $A0:begin    //SPM
        end;
        $B0:begin    //Flash
                fnd:=1;
                wr_flash_page(te,d,dptr);
            end;
        $B1:begin    //EEPROM page
              //fnd:=1;
              wr_eeprom_page(te,d,dptr);

        end;
        $B4:begin    //Sign_JTAG
                fnd:=1;
                rd_signature_avr ;
                str:=str+char(signature[1]);
                str:=str+char(signature[2]);
                str:=str+char(signature[3]);
        end;
        $B5:begin     //OCal Byte
        end;
        $b6:begin     //CAN

        end;
        $b2:begin
                fnd:=1;
                clfuse:=dptr^;inc(dptr);
                wr_lfuse_avr;
                str:=str+char(tdo_buf[0]);
                chfuse:=dptr^;
                rd_hfuse_avr;
                str:=str+char(tdo_buf[0]);
        end;
        $b3:begin   //Lock bits
                fnd:=1;
                clbits:=dptr^;
                wr_lock_avr;
                str:=str+char(tdo_buf[0]);
        end;
        end;
        if fnd=1 then
       RSP_OK('JTAG CMND_WRITE_MEMORY');
      end;
      CMND_READ_MEMORY:begin //                 $05;  // Read Memory
        str:=#$1b+char(lo(J_Seq))+char(hi(J_seq))+#0+#0+#0+#0+#14+#$82;
        dptr:=@va[J_st];
        p:=dptr^;inc(dptr);
        te:=dptr^;inc(dptr);
        te:=te+(dptr^ shl 8);inc(dptr);
        te:=te+(dptr^ shl 16);inc(dptr);
        te:=te+(dptr^ shl 24);inc(dptr);
        inc(tsd);
        if tsd=3 then
        str:='';
        d:=dptr^;inc(dptr);
        d:=d+(dptr^ shl 8);inc(dptr);
        d:=d+(dptr^ shl 16);inc(dptr);
        d:=d+(dptr^ shl 24);inc(dptr);
        case p of
        $30:begin   //shadow
        end;
        $20:begin   //SRAM
        end;
        $22:begin    //EEprom

        end;
        $60:begin    //Event
        end;
        $A0:begin    //SPM
        end;
        $B0:begin    //Flash
                fnd:=1;
                rd_flash_page(te,d div 2);
                for x:=0 to te-1 do
                str:=str+char(data[x]);
        end;
        $B1:begin    //EEPROM page
              write_str;
              fnd:=1;
              rd_eeprom_page(te,d);
              for x:=0 to te-1 do
              str:=str+char(data[x]);
              write_str;
        end;
        $B4:begin    //Sign_JTAG
                fnd:=1;
                rd_signature_avr ;
                str:=str+char(signature[1]);
                str:=str+char(signature[2]);
                str:=str+char(signature[3]);
        end;
        $B5:begin     //OCal Byte
        end;
        $b6:begin     //CAN

        end;
        $b2:begin
                fnd:=1;
                rd_lfuse_avr;
                clfuse:=tdo_buf[0];
                str:=str+char(tdo_buf[0]);
                rd_hfuse_avr;
                str:=str+char(tdo_buf[0]);
                chfuse:=tdo_buf[0];
        end;
        $b3:begin   //Lock bits
                fnd:=1;
                rd_lock_avr;
                clbits:=tdo_buf[0];
                str:=str+char(tdo_buf[0]);
        end;
        end;


        calc_crc('JTAG CMND_READ_MEMORY-',str);

      end;
      CMND_WRITE_PC:begin //                    $06;  // Write Program Counter
      end;
      CMND_READ_PC:begin //                     $07;  // Read Program Counter
      end;
      CMND_GO:begin //                          $08;  // Start Program Execution
      end;
      CMND_SINGLE_STEP:begin //                 $09;  // Single Step
      end;
      CMND_FORCED_STOP:begin //                 $0A;  // Stop Program Execution
                fnd:=1;
           	jtag_reset();
	        avr_jtag_instr(AVR_FORCE_BRK, 0);
                RSP_OK('JTAG CMND_FORCED_STOP');

      end;
      CMND_RESET:begin //                       $0B;  // Reset User Program
        fnd:=1;
        Pavr_reset(1);
        RSP_OK('JTAG CMND_FORCED_STOP');
      end;
      CMND_SET_DEVICE_DESCRIPTOR:begin //       $0C;  // Set Device Descriptor
        fnd:=1;
        move(va[j_st],dev_params,298);
        calc_crc('JTAG CMND_SET_DEVICE_DESCRIPTOR-',
        #$1b+char(lo(J_Seq))+char(hi(J_seq))+#0+#0+#0+#0+#14+#$80);
      end;
      CMND_ERASEPAGE_SPM:begin //               $0D;  // Erase Page SPM
      fnd:=1;
           RSP_OK('JTAG CMND_ERASEPAGE_SPM - NOT DONE');

      end;
      CMND_MISSING_0E:begin //                  $0E;   // No such Command Reserved
      end;
      CMND_GET_SYNC:begin //                    $0F;  // Get Sync
      end;
      CMND_SELFTEST:begin //                    $10;  // Self test
      end;
      CMND_SET_BREAK:begin //                   $11;  // Set Breakpoint
      fnd:=1;
           RSP_OK('JTAG SET_BREAK_POINT - NOT DONE');
      end;
      CMND_GET_BREAK:begin //                   $12;  // Get Breakpoint
      fnd:=1;
           RSP_OK('JTAG GET_BREAK_POINT - NOT DONE');

      end;
      CMND_CHIP_ERASE:begin //                  $13;  // Chip erase
        fnd:=1;
        if chip_erase then
        RSP_OK('JTAG CMND_CHIP ERASE-')
        else
        RSP_FAIL('JTAG CMND_CHIP ERASE FAILURE-');
      end;
      CMND_ENTER_PROGMODE:begin //              $14;  // Enter programming mode
        tsd:=0;
        fnd:=1;
        Enter_Prog_mode;
        calc_crc('JTAG CMND_ENTER_PROGMODE-',
        #$1b+char(lo(J_Seq))+char(hi(J_seq))+#0+#0+#0+#0+#14+#$80);
      end;
      CMND_LEAVE_PROGMODE:begin //              $15;  // Leave programming mode
        fnd:=1;
        Leave_Prog_mode;
        calc_crc('JTAG CMND_LEAVE_PROGMODE-',
        #$1b+char(lo(J_Seq))+char(hi(J_seq))+#0+#0+#0+#0+#14+#$80);
      end;
      CMND_SET_N_PARAMETERS:begin //            $16;  // Write Emulator Parameters
      end;
      CMND_MISSING_17:begin //                  $17;   // No such Command Reserved
      end;
      CMND_MISSING_18:begin //                  $18;   // No such Command Reserved
      end;
      CMND_MISSING_19:begin //                  $19;   // No such Command Reserved
      end;
      CMND_CLR_BREAK:begin //                   $1A;  // Clear Breakpoint
      end;
      CMND_MISSING_1B:begin //                  $1B;   // No such Command Reserved
      end;
      CMND_RUN_TO_ADDR:begin //                 $1C;  // Run to Address
      end;
      CMND_SPI_CMD:begin //                     $1D;  // Universal SPI command
      end;
      CMND_MISSING_1E:begin //                  $1E;   // No such Command Reserved
      end;
      CMND_MISSING_1F:begin //                  $1F;   // No such Command Reserved
      end;
      CMND_MISSING_20:begin //                  $20;   // No such Command Reserved
      end;
      CMND_MISSING_21:begin //                  $21;   // No such Command Reserved
      end;
      CMND_CLEAR_EVENTS:begin //                $22;  // Clear event memory
      end;
      CMND_RESTORE_TARGET:begin //              $23;  // Restore Target
           fnd:=1;
           Pavr_reset(0);
           RSP_OK('JTAG RESTORE_TARGET - NOT DONE');

      end;
      CMND_MISSING_24:begin //                  $24;   // No such Command Reserved
      end;
      CMND_MISSING_25:begin //                  $25;   // No such Command Reserved
      end;
      CMND_MISSING_26:begin //                  $26;   // No such Command Reserved
      end;
      CMND_MISSING_27:begin //                  $27;   // No such Command Reserved
      end;
      CMND_MISSING_28:begin //                  $28;   // No such Command Reserved
      end;
      CMND_MISSING_29:begin //                  $29;   // No such Command Reserved
      end;
      CMND_MISSING_2A:begin //                  $2A;   // No such Command Reserved
      end;
      CMND_MISSING_2B:begin //                  $2B;   // No such Command Reserved
      end;
      CMND_MISSING_2C:begin //                  $2C;   // No such Command Reserved
      end;
      CMND_MISSING_2D:begin //                  $2D;   // No such Command Reserved
      end;
      CMND_MISSING_2E:begin //                  $2E;   // No such Command Reserved
      end;
      CMND_ISP_PACKET:begin //                  $2F;  //Encapsulated ISP command
             fnd:=1;
             rm:=0;
             rp:=J_st+2;
             RiscCom:=va[rp];
             while rp<inp do
             begin
                  inc(rm);
                  r_buf[rm]:=va[rp];
                  inc(rp);
             end;
             do_CMND_ISP_PACKET;
             Calc_crc('ISP Command -'+Cstr,#$1b+char(lo(J_Seq))+char(hi(J_seq))+
             #0+#0+#0+#0+#14+#$88+Rstr );
      end
      else
      begin
              calc_crc('CMND_UNKNOWN -',
        #$1b+char(lo(J_Seq))+char(hi(J_seq))+#0+#0+#0+#0+#14+#$80);

      end;
      end;
      if fnd=0 then
      RSP_OK('CMND_NOT ***** WRITTEN ******');

end;


end.
