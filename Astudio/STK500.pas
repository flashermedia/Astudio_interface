unit STK500;

interface
uses
        Comport,SysUtils,Vars_const,ISP_Communication,MicroController;


       

procedure Analyse_stk;

implementation
procedure Calc_crc(trx,str:string);
var
        x:word;bb:byte;
begin
     bb:=0;
     stk_val:='';
     for x:=1 to length(str) do
     begin
         stk_val:=stk_val+inttohex(ord(str[x]),2)+',';
         bb:=bb xor ord(str[x]);
     end;
     str:=str+char(bb);
     stk_val:=stk_val+inttohex(bb,2);
     T_CPortDrv.SendString( str);
     T_m1.lines.add(trx);
     if T_S_record.checked then
     begin
        T_sig2.lines.add(trx);
        T_sig2.Lines.add('OUTput='+stk_val);
     end;
     stk_val:='';
end;

procedure Analyse_stk;
var
        ISP_com,No_bytes,addr,x,r:word;
begin
     T_Talk.text:='Com ok';
     case STK_com of
     STK_CMD_SIGN_ON:begin
           calc_crc('STK_CMD_SIGN_ON',#$1b+char(stk_seq)+#0+#11+#14+char(STK_CMD_Sign_on)+#0+#8+'STK500_2');
           Read_Signature_bytes;
           for x:=0 to T_micro.Items.count-1 do
           if sig_str=micros[x].Code then
           Set_micro(x,0);

     end;
     STK_CMD_GET_PARAMETER:begin
           str:=#$1b+char(stk_seq)+#0+#3+#14+char(STK_CMD_GET_PARAMETER)+#0 ;
           case va[stk_st] of
                  PARAM_BUILD_NUMBER_LOW   :str:=str+v_PARAM_BUILD_NUMBER_LOW ; //$80;
                  PARAM_BUILD_NUMBER_HIGH  :str:=str+V_PARAM_BUILD_NUMBER_HIGH;  //$81;
                  PARAM_HW_VER             :str:=str+V_PARAM_HW_VER ;  //$90;
                  PARAM_SW_MAJOR           :str:=str+V_PARAM_SW_MAJOR;  //$91;
                  PARAM_SW_MINOR           :str:=str+V_PARAM_SW_MINOR;  //$92;
                  PARAM_VTARGET            :str:=str+V_PARAM_VTARGET;  //$94;
                  PARAM_VADJUST            :str:=str+V_PARAM_VADJUST;  //$95;
                  PARAM_OSC_PSCALE         :str:=str+V_PARAM_OSC_PSCALE;  //$96;
                  PARAM_OSC_CMATCH         :str:=str+V_PARAM_OSC_CMATCH  ; //$97;
                  PARAM_SCK_DURATION       :str:=str+V_PARAM_SCK_DURATION;  //$98;
                  PARAM_TOPCARD_DETECT     :str:=str+V_PARAM_TOPCARD_DETECT;  //$9A;
                  PARAM_STATUS             :str:=str+V_PARAM_STATUS;  //$9C;
                  PARAM_DATA               :str:=str+V_PARAM_DATA ;  //$9D;
                  PARAM_RESET_POLARITY     :str:=str+V_PARAM_RESET_POLARITY;  //$9E;
                  PARAM_CONTROLLER_INIT    :str:=str+V_PARAM_CONTROLLER_INIT ;  //$9F;
           else
           str:=str+#$00;
           end;
           calc_crc('STK_CMD_GET_PARAMETER',str);
           t_m1.lines.add( parstrs[va[stk_st]]);
           if T_S_record.checked then
           t_sig2.lines.add(parstrs[va[stk_st]]);
     end;
      STK_CMD_set_PARAMETER:begin
           case va[stk_st] of
                  PARAM_BUILD_NUMBER_LOW   :v_PARAM_BUILD_NUMBER_LOW :=char(va[stk_st+1]); //$80:=char(va[stk_st+1]);
                  PARAM_BUILD_NUMBER_HIGH  :V_PARAM_BUILD_NUMBER_HIGH:=char(va[stk_st+1]);  //$81:=char(va[stk_st+1]);
                  PARAM_HW_VER             :V_PARAM_HW_VER :=char(va[stk_st+1]);  //$90:=char(va[stk_st+1]);
                  PARAM_SW_MAJOR           :V_PARAM_SW_MAJOR:=char(va[stk_st+1]);  //$91:=char(va[stk_st+1]);
                  PARAM_SW_MINOR           :V_PARAM_SW_MINOR:=char(va[stk_st+1]);  //$92:=char(va[stk_st+1]);
                  PARAM_VTARGET            :V_PARAM_VTARGET:=char(va[stk_st+1]);  //$94:=char(va[stk_st+1]);
                  PARAM_VADJUST            :V_PARAM_VADJUST:=char(va[stk_st+1]);  //$95:=char(va[stk_st+1]);
                  PARAM_OSC_PSCALE         :V_PARAM_OSC_PSCALE:=char(va[stk_st+1]);  //$96:=char(va[stk_st+1]);
                  PARAM_OSC_CMATCH         :V_PARAM_OSC_CMATCH  :=char(va[stk_st+1]); //$97:=char(va[stk_st+1]);
                  PARAM_SCK_DURATION       :V_PARAM_SCK_DURATION:=char(va[stk_st+1]);  //$98:=char(va[stk_st+1]);
                  PARAM_TOPCARD_DETECT     :V_PARAM_TOPCARD_DETECT:=char(va[stk_st+1]);  //$9A:=char(va[stk_st+1]);
                  PARAM_STATUS             :V_PARAM_STATUS:=char(va[stk_st+1]);  //$9C:=char(va[stk_st+1]);
                  PARAM_DATA               :V_PARAM_DATA :=char(va[stk_st+1]);  //$9D:=char(va[stk_st+1]);
                  PARAM_RESET_POLARITY     :V_PARAM_RESET_POLARITY:=char(va[stk_st+1]);  //$9E:=char(va[stk_st+1]);
                  PARAM_CONTROLLER_INIT    :V_PARAM_CONTROLLER_INIT :=char(va[stk_st+1]);  //$9F:=char(va[stk_st+1]);
           end;
           calc_crc('STK_CMD_set_PARAMETER',#$1b+char(stk_seq)+#0+#2+#14+char(STK_com)+#0) ;
           t_m1.lines.add( parstrs[va[stk_st]]+'='+inttohex(va[stk_st+1],2));
           if T_S_record.checked then
           t_sig2.lines.add(parstrs[va[stk_st]]+'='+inttohex(va[stk_st+1],2));
      end;
      STK_CMD_ENTER_PROGMODE_ISP:begin
          Send_ISP_Command(va[STK_st+7],va[STK_st+8],va[STK_st+9],va[STK_st+10]);
          if r3=$53 then
          begin
              calc_crc('STK_CMD_ENTER_PROGMODE_ISP',#$1b+char(stk_seq)+#0+#2+#14+char(STK_com)+#0 );
              ISP_ok:=true;
          end
          else
          begin
            calc_crc('Fault STK_CMD_Enter_prog_mode', #$1b+char(stk_seq)+#0+#2+#14+char(STK_com)+#1 );
             ISP_ok:=false;
          end;
          signo:=0;
      end;
      STK_CMD_LEAVE_PROGMODE_ISP:begin
           calc_crc('STK_CMD_LEAVE_PROGMODE_ISP',#$1b+char(stk_seq)+#0+#2+#14+char(stk_com)+#0 );
           signo:=0;
      end;
      STK_CMD_READ_SIGNATURE_ISP:begin
          if ISP_ok then
          begin
              Read_Signature_bytes;
              inc(signo);
              calc_crc('STK_CMD_READ_SIGNATURE_ISP',#$1b+char(stk_seq)+#0+#4+#14+
              char(stk_com)+#0+char(Signature[signo])+#0);
               for x:=0 to T_micro.Items.count-1 do
              if sig_str=micros[x].Code then
              Set_micro(x,0);

          end
          else
          calc_crc('Fault Read Signature', #$1b+char(stk_seq)+#0+#2+#14+char(STK_com)+#1 );

      end ;
      STK_CMD_OSCCAL:begin             //  =$05  ;
           calc_crc('STK_CMD_LOAD_ADDRESS',#$1b+char(stk_seq)+#0+#2+#14+char(stk_com)+#0 );
      end;
      STK_CMD_LOAD_ADDRESS :begin       //  =$06  ;
           mwrite:=va[stk_st+3];
           mwrite:=mwrite+(va[stk_st+2] shl 8);
           mwrite:=mwrite+(va[stk_st+1] shl 16);
           mwrite:=mwrite+(va[stk_st] shl 24);
           mread:=mwrite;
           Ewrite:=va[stk_st+3];
           Ewrite:=Ewrite+(va[stk_st+2] shl 8);
           Ewrite:=Ewrite+(va[stk_st+1] shl 16);
           Ewrite:=Ewrite+(va[stk_st] shl 24);
           Eread:=Ewrite;
           calc_crc('STK_CMD_LOAD_ADDRESS',#$1b+char(stk_seq)+#0+#2+#14+char(stk_com)+#0 );
           signo:=0;
           if T_S_record.checked then
           t_sig2.lines.add('Address='+inttohex(Mwrite,8));
      end;
      STK_CMD_FIRMWARE_UPGRADE :begin   //  =$07  ;
          calc_crc('STK_CMD_FIRMWARE_UPGRADE',#$1b+char(stk_seq)+#0+#2+#14+char(stk_com)+#0 );
      end;
      STK_CMD_CHIP_ERASE_ISP    :begin   //    =$12   ;
           Send_ISP_Command(va[stk_st+2],va[stk_st+3],va[stk_st+4],va[stk_st+5]);
           calc_crc('STK_CMD_CHIP_ERASE_ISP',#$1b+char(stk_seq)+#0+#2+#14+char(stk_com)+#0 );
      end;

      STK_CMD_READ_FLASH_ISP    :begin   //    =$14   ;
                No_bytes:=(va[stk_st] shl 8)+va[stk_st+1]; //number of bytes to read
                r:=No_bytes+3;
                str:=#$1b+char(stk_seq)+char(hi(r))+char(lo(r))+#14+char(stk_com)+#0;
                 x:=0;
                 while x< No_bytes do
                 begin
                     Send_ISP_Command(va[stk_st+2],hi(mread),lo(mread),0);
                     str:=str+char(r4);
                     Send_ISP_Command(va[stk_st+2]+$8,hi(mread),lo(mread),0);
                     str:=str+char(r4);
                     inc(mread);
                     inc(x,2);
                  end;
                  calc_crc('STK_CMD_READ_FLASH_ISP',str+#0 );
      end;

      STK_CMD_READ_EEPROM_ISP    :begin   //   =$16   ;
                No_bytes:=(va[stk_st] shl 8)+va[stk_st+1]; //number of bytes to read
                r:=No_bytes+3;
                str:=#$1b+char(stk_seq)+char(hi(r))+char(lo(r))+#14+char(stk_com)+#0;
                 x:=0;
                 while x< No_bytes do
                 begin
                     Send_ISP_Command(va[stk_st+2],hi(eread),lo(eread),0);
                     str:=str+char(r4);
                     inc(eread);
                     inc(x);
                  end;
                  calc_crc('STK_CMD_READ_EEPROM_ISP',str+#0 );
      end;

      STK_CMD_READ_FUSE_ISP     :begin   //    =$18   ;
          Send_ISP_Command(va[stk_st+1],va[stk_st+2],va[stk_st+3],va[stk_st+4]);
          fbitsR:=r4;
          case va[stk_st+1] and $f of
          $0:begin
                 VFbitsL:=FBitsR;
                 Write_bits(1,T_CFB1,convertbits(VFbitsL));
          end;
          $8:begin
               VFbitsH:=FBitsR;
               Write_bits(1,T_CFB2,convertbits(VFbitsH));
          end;
          end;
          calc_crc('STK_CMD_READ_FUSE_ISP',#$1b+char(stk_seq)+#0+#4+#14+char(stk_com)+#0+char(FbitsR)+#0 );

      end;
      STK_CMD_READ_LOCK_ISP     :begin   //    =$1A   ;
          Send_ISP_Command(va[stk_st+1],va[stk_st+2],va[stk_st+3],va[stk_st+4]);
          VLbits:=r4;
          Write_bits(1,T_LBits,convertbits(VLbits));
          calc_crc('STK_CMD_READ_LOCK_ISP',#$1b+char(stk_seq)+#0+#4+#14+char(stk_com)
          +#0+char(Vlbits)+#0 );
      end;
      STK_CMD_READ_OSCCAL_ISP   :begin   //    =$1C   ;
          Send_ISP_Command(va[stk_st+1],va[stk_st+2],va[stk_st+3],va[stk_st+4]);
          VOSC:=r4;
          calc_crc('STK_CMD_READ_LOCK_ISP',#$1b+char(stk_seq)+#0+#4+#14+char(stk_com)
          +#0+char(VOSC)+#0 );      end;
      STK_CMD_PROGRAM_FLASH_ISP :begin   //    =$13   ;
                wd:=mwrite;
                No_bytes:=(va[stk_st] shl 8)+va[stk_st+1]; //number of bytes to read
               // mode:=va[stk_st+2];
              //  delay:=va[stk_st+3];
                ISP_com:=va[stk_st+4];
                addr:=stk_st+9;
                 x:=0;
                 while x<No_bytes do
                 begin
                     Send_ISP_Command(ISP_com,hi(mwrite),lo(mwrite),va[addr]);
                     inc(addr);
                     Send_ISP_Command(ISP_com+$8,hi(mwrite),lo(mwrite),va[addr]);
                     inc(addr);
                     inc(mwrite);
                     inc(x,2);
                 end;
                 Send_ISP_Command(va[stk_st+5],hi(wd),lo(wd),0);

                 calc_crc('STK_CMD_PROGRAM_FLASH_ISP',#$1b+char(stk_seq)+#0+#2+#14+char(stk_com)+#0 );
      end;
      STK_CMD_PROGRAM_EEPROM_ISP :begin   //   =$15   ;
                wd:=ewrite;
                No_bytes:=(va[stk_st] shl 8)+va[stk_st+1]; //number of bytes to read
              //  mode:=va[stk_st+2];
              //  delay:=va[stk_st+3];
                ISP_com:=va[stk_st+4];
                addr:=stk_st+9;
                x:=0;
                 while x<No_bytes do
                 begin
                     Send_ISP_Command(ISP_com,hi(mwrite),lo(mwrite),va[addr]);
                     inc(addr);
                     inc(ewrite);
                     inc(x);
                 end;
                // Write_Program_Memory_Page(wd   and ($10000-(r div 2)));
                 calc_crc('STK_CMD_PROGRAM_EEPROM_ISP',#$1b+char(stk_seq)+#0+#2+#14+char(stk_com)+#0 );
      end;
      STK_CMD_PROGRAM_FUSE_ISP   :begin   //   =$17   ;
          Send_ISP_Command(va[stk_st],va[stk_st+1],va[stk_st+2],va[stk_st+3]);
           calc_crc('STK_CMD_PROGRAM_FUSE_ISP',#$1b+char(stk_seq)+#0+#3+#14
           +char(stk_com)+#0+#$0 );
      end;
      STK_CMD_PROGRAM_LOCK_ISP  :begin   //    =$19   ;
          Send_ISP_Command(va[stk_st],va[stk_st+1],va[stk_st+2],va[stk_st+3]);
          calc_crc('STK_CMD_PROGRAM_LOCK_ISP',#$1b+char(stk_seq)+#0+#3+#14
          +char(stk_com)+#0+#0 );
      end;

      STK_CMD_SPI_MULTI         :begin   //    =$1D   ;
           calc_crc('STK_CMD_SPI_MULTI',#$1b+char(stk_seq)+#0+#2+#14+char(stk_com)+#0 );
      end;
      STK_CMD_SET_DEVICE_PARAMETERS:begin
           calc_crc('STK_CMD_SET_DEVICE_PARAMETERS',#$1b+char(stk_seq)+#0+#2+#14
           +char(stk_com)+#0 );
      end
      
      else
      calc_crc('Command Unknown', #$1b+char(stk_seq)+#0+#2+#14+char(STK_com)+#1 );


     end;

end;
end.
