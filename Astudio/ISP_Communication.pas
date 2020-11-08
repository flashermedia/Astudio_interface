unit ISP_Communication;

interface
uses
        MicroController,zlportio,vars_const,sysutils;

Procedure Send_ISP_command(c1,c2,c3,c4:byte);
procedure Set_SCK;
procedure Clr_SCK;
procedure Set_MOSi;
procedure Clr_MOSi;
procedure Reset_one;
procedure Reset_zero;
function  read_moso:byte;
procedure Read_Signature_bytes;
procedure Read_Lock_Bits;
procedure Read_Fuse_Bits;
procedure Read_Fuse_High_Byte;
procedure Read_Calibration_Byte ;
procedure Read_Extended_Fuse_bits;
procedure Enter_Program_mode;
Function  Flash_PS(addr:word;num:word):string;
procedure Read_flash(num:word);
procedure Flash_Eprom(num:word);//bytes
procedure Read_Eprom(num:word);//bytes
procedure Erase_chip_isp;
procedure reset_port;


implementation
procedure reset_port;
begin
    portwriteb($378,0 ) ;
end;
procedure Set_SCK;
var
        t:longword;
begin
     t:=0; while t<TbPos do inc(t);
     portrb:=portreadb($378);
     portwriteb($378,portrb or 2 ) ;
     t:=0; while t<TbPos do inc(t);

end;
procedure Clr_SCK;
var
        t:longword;
begin
     t:=0; while t<TbPos do inc(t);
     portrb:=portreadb($378);
     portwriteb($378,portrb and $fd ) ;
     t:=0; while t<TbPos do inc(t);
end;
procedure Set_MOSi;
begin
     portrb:=portreadb($378);
     portwriteb($378,portrb or 1 ) ;

end;
procedure Clr_MOSi;
begin
     portrb:=portreadb($378);
     portwriteb($378,portrb and $fe ) ;

end;
procedure Reset_one;
begin
     portrb:=portreadb($378);
     portwriteb($378,portrb or $014 ) ;
     T_Resetbox.Caption:='Reset (1)';
     T_resetbox.checked:=true;
end;

procedure Reset_zero;
begin
     portrb:=portreadb($378);
     portwriteb($378,portrb and $fb {11111011}) ;
     T_Resetbox.Caption:='Reset (0)';
     T_resetbox.checked:=false;

end;
function read_moso:byte;
begin
     if portreadb($379) and $40=$40 then
     read_moso:=1 else read_moso:=0;

end;
function Write_avr(dd:byte):byte;
var
        dx:word;v,r:byte;
begin
      dx:=dd; r:=0;
      for v:=1 to 8 do  //write 8 bits
      begin
        dx:=dx shl 1;  //shift the bit into 9
        if dx and $100 =$100 then
        begin
            set_mosi;
        end
        else
        begin
            clr_mosi;
        end;
        set_sck;
        r:=(r shl 1) or read_moso;
        clr_sck;
      end;
      Write_avr:=r;
end;
Procedure Send_ISP_command(c1,c2,c3,c4:byte);
begin
     r1:=Write_avr(c1);
     r2:=Write_avr(c2);
     r3:=Write_avr(c3);
     r4:=Write_avr(c4);
     with T_S89 do
     begin
         cells[0,0]:='Sent';
         cells[0,1]:='Received';

         cells[1,1]:=Inttohex(r1,2);
         cells[2,1]:=Inttohex(r2,2);
         cells[3,1]:=Inttohex(r3,2);
         cells[4,1]:=Inttohex(r4,2);
         cells[1,0]:=Inttohex(c1,2);
         cells[2,0]:=Inttohex(c2,2);
         cells[3,0]:=Inttohex(c3,2);
         cells[4,0]:=Inttohex(c4,2);

     end;

end;
procedure Erase_chip_ISP;
begin
     Send_ISP_command($Ac,$80,00,00);
     T_E6.text:='Chip Erase';
end;
procedure Enter_Program_mode;
begin
     reset_zero;
     Send_ISP_command($ac,$53,0,0);

     if r3=$53 then
     ISP_OK:=true else ISP_OK:=false;
     T_E6.text:='Enter program mode result';

end;

procedure Read_Signature_bytes;
begin
         Send_ISP_command($30,00,00,00);
         Signature[1]:=r4;
         Send_ISP_command($30,00,01,00);
         Signature[2]:=r4;
         Send_ISP_command($30,00,02,00);
         Signature[3]:=r4;
         Sig_str:=inttohex(Signature[1],2)+
         inttohex(Signature[2],2)+
         inttohex(Signature[3],2);
 end;
procedure Read_Fuse_Bits;
begin   //50 00 00 oo
     Send_ISP_command($50,00,00,00);
     VFBitsL:=r4;
end;
procedure Read_Fuse_High_Byte;
begin //58 08 00 oo
     Send_ISP_command($58,08,00,00);
     VFBitsH:=r4;
end;
procedure Read_Extended_Fuse_bits;
begin //50 08 00 oo
     Send_ISP_command($50,08,00,00);
     VFBitsE:=r4;
end;
procedure Read_Calibration_Byte ;
begin  //50 00 0b oo
end;
procedure Read_Lock_Bits;
        //58 00 00 oo
begin
     Send_ISP_command($58,00,00,00);
     VLBits:=r4;
end;


procedure Write_Fuse_High_Byte;
begin //AC A8 00 ii
end;



procedure Program_Whole_Mem (addr:word;num:word);
// like 8535
// data is in ISP_data
//num is number of bytes to program usually ISP_max
var
        z,bb,pp:word;

begin
    pp:=addr;
    bb:=addr;
    while bb< addr+num   do
    begin
        T_address.Text:=inttostr(bb);
        T_application.processmessages;
        if ISP_Program_data[bb]<>$ff then
        begin
            Send_ISP_command($40,hi(pp ),lo(pp ),ISP_Program_data[bb]);
            z:=0;
            repeat
                Send_ISP_Command($20,hi(pp),lo(pp),0);
                inc(z);
                if z=5000 then r4:=$00;
            until r4<>$ff;
        end;
        inc(bb);
        if ISP_Program_data[bb]<>$ff then
        begin
            Send_ISP_command($48,hi(pp),lo(pp ),ISP_Program_data[bb]);
            z:=0;
            repeat
                Send_ISP_Command($28,hi(pp),lo(pp),0);
                inc(z);
                if z=5000 then r4:=$00;
            until r4<>$ff;
        end;
        inc(bb);
        inc(pp);
    end;


end;
procedure program_Pages(addr:word;num:word);
// write page of bytes then write page
//Psize gives page size
var
    pl,z,naddr,page,pg,pgm,paddr:word;
begin

    //determine start page address
    pg:=addr div Psize;
    pgm:=pg+((num div 2) div Psize)+1;
    Paddr:=0;
    page:=0;
    pl:=32000;
    while pg<=pgm do
    begin
        naddr:=page+paddr;
        T_address.Text:=inttostr(paddr*2);
        T_application.processmessages;
        Send_ISP_command($40,hi(paddr),lo(paddr),ISP_Program_data[naddr*2]);
        if pl=32000 then
        if ISP_Program_data[naddr*2]<>$ff then
        pl:=naddr;

        Send_ISP_command($48,hi(paddr),lo(paddr),ISP_Program_data[(naddr*2)+1]);
        if pl=32000 then
        if ISP_Program_data[naddr*2]<>$ff then
        pl:=naddr;
        inc(paddr);//point to next word
        if paddr=Psize then
        begin
             Send_ISP_command($4c,hi(page),lo(page),00);
             if pl<>32000 then
             begin
                  z:=0;
                  repeat
                      Send_ISP_Command($20,hi(pl),lo(pl),0);
                      inc(z);
                      if z=1000 then r4:=$00;
                  until r4<>$ff;
              end;
             page:=page+Psize;
             paddr:=0;
             inc(pg);
             pl:=32000;

        end;

    end;
end;
Function Flash_PS(addr:word;num:word):string;
// program dependant on page size (E_Psize) and number of pages E_pages
// if only 1 page (Epages)then just load the address's
// if more than one then load a page at a time then write page

begin
     Flash_PS:='';
     val(T_E_Psize.text,Psize,cc);
     if cc=0 then
     begin
         val(T_E_PS.text,Pages,cc);
         if cc=0 then
         begin
             if Pages=Psize then Program_Whole_Mem (addr,num)
             else
             program_Pages(addr,num);
         end
         else
         begin
              Flash_PS:='No Page value given';
         end;
     end
     else
     begin
          Flash_PS:='No Page size value given';
     end;
end;
procedure Read_flash(num:word);//bytes
var
        Rstr:string;x,no_bytes:longint;
begin
     mread:=0000;
     Rstr:='';
     No_bytes:=num;
     x:=0;
     Rstr:=inttohex(mread,5)+' ';
     while x< No_bytes do
     begin
         T_address.Text:=inttostr(mread*2);
         Send_ISP_Command($20,hi(mread),lo(mread),0);
         Rstr:=Rstr+inttohex(r4,2);
         Send_ISP_Command($28,hi(mread),lo(mread),0);
         Rstr:=Rstr+inttohex(r4,2)+',';
         inc(mread);
         inc(x,2);
         if x mod 16=0 then
         begin
              Rstr:=rstr+#13+#10+inttohex(mread,5)+' ';
              T_application.processmessages;

         end;
      end;
      T_M1.lines.add(Rstr);
end;
procedure Read_Eprom(num:word);//bytes
var
        Rstr:string;x,no_bytes:longint;
begin
     mread:=0000;
     Rstr:='';
     No_bytes:=num;
     x:=0;
     Rstr:=inttohex(mread,4)+' ';
     while x< No_bytes do
     begin
         T_eaddress.Text:=inttostr(mread);
         Send_ISP_Command($a0,hi(mread),lo(mread),0);
         Rstr:=Rstr+inttohex(r4,2)+',';
         inc(mread);
         inc(x);
         if x mod 16=0 then
         begin
              Rstr:=rstr+#13+#10+inttohex(mread,4)+' ';
              T_application.processmessages;
         end;
      end;
      T_M1.lines.add(Rstr);
end;
procedure Flash_Eprom(num:word);//bytes
var
    z,x:word;
begin
     x:=0;
     while x<= num do
     begin
         if ISP_EProgram_data[x]<>$ff then
         begin
             T_eaddress.Text:=inttostr(mread);
             T_application.processmessages;
             Send_ISP_Command($c0,hi(x),lo(x),ISP_EProgram_data[x]);
             z:=0;
             repeat
                  Send_ISP_Command($a0,hi(x),lo(x),0);
                  inc(z);
                  if z=5000 then r4:=$00;
             until r4<>$ff;
         end;
         inc(x);
      end;
end;
end.
