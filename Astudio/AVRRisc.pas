unit AVRRisc;

interface
uses
     SysUtils,Vars_const,ISP_Communication,Microcontroller,Jtag_signals;

procedure do_CMND_ISP_PACKET;

implementation

procedure do_CMND_ISP_PACKET;
var
        zz,x:word;
begin
        Cstr:='xxxx';
        case RiscCom of
        CMD_SIGN_ON:begin
            Rstr:=#0;
            Rstr:=#10;
            Rstr:=Rstr+'AVRISP_MK2';
        end;
        CMD_SET_PARAMETER :begin        ///Sets a parameter
        Cstr:='CMD_SET_PARAMETER'+inttohex(R_buf[2],2)+'='+
        inttohex(R_buf[3],2);

        P_Pars[R_buf[2]]:=R_buf[3];
        Rstr:=char(Risccom)+#0;
        end;
        CMD_GET_PARAMETER :begin        ///Reads back a parameter value
        Cstr:='CMD_GET_PARAMETER'+inttohex(R_buf[2],2)+'='+
        inttohex(P_Pars[R_buf[2]],2);
        Rstr:=char(Risccom)+#0+char(P_pars[R_buf[2]]);
        end;
        CMD_OSCCAL :begin        ///Performs OSCCAL calibration sequence
        end;
        CMD_LOAD_ADDRESS :begin        ///Loads an address for programming functions
           mwrite:=R_buf[5];
           mwrite:=mwrite+(R_buf[4] shl 8);
           mwrite:=mwrite+(R_buf[3] shl 16);
           mwrite:=mwrite+(R_buf[2] shl 24);
           mread:=mwrite;
           Ewrite:=R_buf[5];
           Ewrite:=Ewrite+(R_buf[4] shl 8);
           Ewrite:=Ewrite+(R_buf[3] shl 16);
           Ewrite:=Ewrite+(R_buf[2] shl 24);
           Eread:=Ewrite;
           Cstr:='CMD_LOAD_ADDRESS -'+inttohex(Mwrite,8);
           RStr:=char(RiscCom)+#0 ;
           signo:=0;
        end;
        CMD_ENTER_PROGMODE_ISP :begin        ///Puts the target device into programming mode
            Cstr:='CMD_ENTER_PROGMODE_ISP';
            for zz:=1 to 20 do
            begin
                Send_ISP_Command(R_buf[9],R_buf[10],R_buf[11],R_buf[12]);
                if r3=$53 then
                begin
                    RStr:=char(RiscCom)+#0 ;
                    ISP_ok:=true;
                    break;
                end
                else
                begin
                  Reset_one;
                  jtag_init;
                  jtag_goto_state(RUN_TEST_IDLE);
                  Cstr:='Fault CMD_Enter_prog_mode';
                  Rstr:=char(Risccom)+#1 ;
                  ISP_ok:=false;
                  x:=0;while x<40000 do inc(x);
                  Reset_zero;
                  x:=0;while x<40000 do inc(x);
                end;
            end;
            signo:=0;
        end;
          CMD_LEAVE_PROGMODE_ISP :begin        ///Target device leaves programming mode
                Cstr:='CMD_LEAVE_PROGMODE_ISP';
                RStr:=char(RiscCom)+#0 ;
        end;
        CMD_CHIP_ERASE_ISP :begin        ///Perform a chip erase on the target device
           Send_ISP_Command(R_buf[4],R_buf[5],R_buf[6],R_buf[7]);
           Cstr:='CMD_CHIP_ERASE_ISP';
           RStr:=char(RiscCom)+#0 ;
        end;
        CMD_PROGRAM_FLASH_ISP :begin        ///Programs the flash memory on the target device
                wd:=mwrite;
                No_bytes:=(R_buf[2] shl 8)+R_buf[3]; //number of bytes to read
                mode:=R_buf[4];
                delay:=R_buf[5];
                ISP_com:=R_buf[6];
                addr:=11;
                 x:=0;
                 while x<No_bytes do
                 begin
                     Send_ISP_Command(ISP_com,hi(mwrite),lo(mwrite),R_buf[addr]);
                     inc(addr);

                     Send_ISP_Command(ISP_com+$8,hi(mwrite),lo(mwrite),R_buf[addr]);
                     inc(addr);
                     inc(mwrite);
                     inc(x,2);
                 end;
                 Send_ISP_Command(R_buf[7],hi(wd),lo(wd),0);
                  x:=wd ;
                 while X< wd+no_bytes do
                 begin
                     if R_Buf[x]<>$ff then
                     begin
                          zz:=200;
                          repeat
                               Send_ISP_Command($20,hi(mwrite),lo(mwrite),0);
                               dec(zz); if zz<10 then r4:=$00;
                          until r4<>$ff;
                          x:= wd+no_bytes;
                     end;
                     inc(x);
                 end;
                 Cstr:='CMD_PROGRAM_FLASH_ISP';
                 Rstr:=char(RiscCom)+#0 ;

        end;
        CMD_READ_FLASH_ISP :begin        ///Reads the flash memory on the target device
                No_bytes:=(R_buf[2] shl 8)+R_buf[3]; //number of bytes to read
                Rstr:=char(CMD_READ_FLASH_ISP)+#0;
                 x:=0;
                 while x< No_bytes do
                 begin
                     Send_ISP_Command(R_buf[4],hi(mread),lo(mread),0);
                     Rstr:=Rstr+char(r4);
                     Send_ISP_Command(R_buf[4]+$8,hi(mread),lo(mread),0);
                     Rstr:=Rstr+char(r4);
                     inc(mread);
                     inc(x,2);
                  end;
                  Rstr:=Rstr+#0;
                  Cstr:=('CMD_READ_FLASH_ISP' );

        end;
        CMD_PROGRAM_EEPROM_ISP :begin        ///Programs the EEPROM on the target device
                wd:=ewrite;
                No_bytes:=(R_buf[2] shl 8)+R_buf[3]; //number of bytes to read
                mode:=R_buf[4];
                delay:=R_buf[5];
                ISP_com:=R_buf[6];
                addr:=11;
                 x:=0;
                 while x<No_bytes do
                 begin
                     Send_ISP_Command(ISP_com,hi(ewrite),lo(ewrite),R_buf[addr]);
                     if R_Buf[addr]<>$ff then
                     begin
                          zz:=200;
                          repeat
                               Send_ISP_Command($A0,hi(ewrite),lo(ewrite),0);
                               dec(zz); if zz<10 then r4:=00;
                          until r4<>$ff;
                     end;
                     inc(addr);
                     inc(ewrite);
                     inc(x);
                 end;
                 Cstr:='CMD_PROGRAM_EEPROM_ISP';
                 Rstr:=char(RiscCom)+#0 ;

        end;
        CMD_READ_EEPROM_ISP :begin        ///Reads the EEPROM on the target device
                No_bytes:=(R_buf[2] shl 8)+R_buf[3]; //number of bytes to read
                 Rstr:=char(CMD_READ_EEPROM_ISP)+#0;
                 x:=0;
                 while x< No_bytes do
                 begin
                     Send_ISP_Command(R_buf[4],hi(eread),lo(eread),0);
                     Rstr:=Rstr+char(r4);
                     inc(eread);
                     inc(x);
                  end;
                  Rstr:=Rstr+#0;
                  Cstr:=('CMD_READ_EPROM_ISP' );
        end;
        CMD_PROGRAM_FUSE_ISP :begin        ///Programs fuses on the target device
          Send_ISP_Command(R_buf[2],R_buf[3],R_buf[4],R_buf[5]);
           Cstr:='CMD_PROGRAM_FUSE_ISP';
           Rstr:=char(RiscCom)+#0 ;
        end;
        CMD_READ_FUSE_ISP :begin        ///Reads fuses on the target device
          Cstr:='CMD_READ_FUSE_ISP';
          Send_ISP_Command(R_buf[3],R_buf[4],R_buf[5],R_buf[6]);
          fbitsR:=r4;
          case R_buf[3] and $f of
          $0:begin
                 VFbitsL:=FBitsR;
                 Write_bits(1,T_FB1,convertbits(VFbitsL));
          end;
          $8:begin
               VFbitsH:=FBitsR;
               Write_bits(1,T_FB2,convertbits(VFbitsH));
          end;
          end;
          Rstr:=char(RiscCom)+#0+char(FbitsR)+#0 ;
        end;
        CMD_PROGRAM_LOCK_ISP :begin        ///Programs lock bits on the target device
          Send_ISP_Command(R_buf[2],R_buf[3],R_buf[4],R_buf[5]);
           Cstr:='CMD_PROGRAM_LOCK_ISP';
           Rstr:=char(RiscCom)+#0 ;
        end;
        CMD_READ_LOCK_ISP :begin        ///Reads lock bits on the target device
          Cstr:='CMD_READ_LOCK_ISP';
          Send_ISP_Command(R_buf[3],R_buf[4],R_buf[5],R_buf[6]);
          VLbits:=r4;
          Write_bits(1,T_LBits,convertbits(VLbits));
          Rstr:=char(RiscCom)+#0+char(Vlbits)+#0 ;


        end;
        CMD_READ_SIGNATURE_ISP :begin        ///Reads the signature bytes on the target device
          Cstr:='CMD_READ_SIGNATURE_ISP';
          if ISP_ok then
          begin
              Read_Signature_bytes;
              inc(signo);
              Rstr:=char(RiscCom)+#0+Char(Signature[Signo])+#0;
              for x:=0 to T_micro.Items.count-1 do
              if sig_str=micros[x].Code then
              Set_micro(x,0);
          end ;

                 


        end;
        CMD_READ_OSCCAL_ISP :begin        ///Reads the OSCCAL byte on the target device
          Send_ISP_Command(R_buf[3],R_buf[4],R_buf[5],R_buf[6]);
          VOSC:=r4;
          Cstr:='CMD_READ_LOCK_ISP';
          Rstr:=char(RiscCom)+#0+char(VOSC)+#0 ;

        end;
        end;

end;
Initialization
     z:=$80;
     while z<=$af do
     begin
         P_pars[z]:=0;
         inc(z);
     end;
     p_pars[$98]:=$20;
     p_pars[$94]:=$50;
end.
