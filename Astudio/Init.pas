unit Init;

interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, CommDrv, Spin, jpeg, ExtCtrls, ComCtrls, StdCtrls, Grids,

  Vars_const,MicroController,zlportio,ddkint;
procedure Load_Resource_data;
procedure init_data;
procedure set_params;
procedure set_STK_params;
procedure readportfile;


implementation
{$R zlportio.res}  //must read in zlportio.res to get zlportio.sys

procedure Load_Resource_data;
var
        fname:string;
        rStream: TResourceStream;
        fStream: TFileStream;
        dox,po:longint;
        pb:pchar;
        ww:string;
        inf,outf:textfile;
begin
     {this part extracts the sys from exe}

     //get the printer driver from the Resource file
     fname:=ExtractFileDir(PARAMstr(0))+'\zlportio.sys';
     rStream := TResourceStream.Create
               (hInstance, 'zlportio_sys', RT_RCDATA);
     try
      fStream := TFileStream.Create(fname, fmCreate);
      try
       fStream.CopyFrom(rStream, 0);
      finally
       fStream.Free;
      end;
     finally
      rStream.Free;
     end;
     fname:=exepath+'\ATmega128.txt';

     rStream := TResourceStream.Create
               (hInstance, 'ATmega128_regs', RT_RCDATA);
     portfile:='ATmega128.txt';
     try
        if fileexists(fname)=false then
        begin
            assignfile(outf,fname);
            {$i-}
            rewrite(outf);
            {$I+}
            if ioresult=0 then dox:=0 else dox:=1;
            pb:=rstream.Memory;
            for po:=0 to rstream.size-1 do
            begin
                case pb^ of
                char(13),char(10):begin
                     if ww<>'' then
                     begin
                         writeln(outf,ww);
                     end;
                     ww:='';
                end
                else
                ww:=ww+pb^;
                end;
                inc(pb);
            end;
            closefile(outf);
            
        end
        else
        begin

        end;

     finally
     rstream.Free;
     end;

     //get the micro data from the resource file
     fname:=exepath+'\Micro.dat';
     rStream := TResourceStream.Create
               (hInstance, 'micro_data', RT_RCDATA);
     try
        if fileexists(fname)=false then
        begin

            assignfile(outf,fname);
            {$i-}
            rewrite(outf);
            {$I+}
            if ioresult=0 then dox:=0 else dox:=1;

            pb:=rstream.Memory;
            for po:=0 to rstream.size-1 do
            begin

                case pb^ of
                char(13),char(10):begin
                     if ww<>'' then
                     begin
                         process_micro_line(ww);
                         if dox=0 then writeln(outf,ww);
                     end;
                     ww:='';
                end
                else
                ww:=ww+pb^;
                end;
                inc(pb);
            end;
            if dox=0 then closefile(outf);

        end
        else
        begin
            assignfile(inf,fname);
            {$i-}
            reset(inf);
            {$I+}
            if ioresult=0 then
            begin
                while not eof(inf) do
                begin
                     readln(inf,ww);
                     process_micro_line(ww);

                end;
                closefile(inf);
                T_micro.itemindex:=0;
            end;
        end;
     finally

      rStream.Free;
     end;
     //moved from initialization of zlportio to ensure zliport.sys is available
     //As loaded above from the Resource file which is complied into the Exe file
     // Then you can take the exe and have it unload the Micro.dat and zlportio.sys files
    IOCTL_ZLUNI_PORT_READ := CTL_CODE(FILE_DEVICE_KRNLDRVR, 1, METHOD_BUFFERED, FILE_ANY_ACCESS);
    IOCTL_ZLUNI_PORT_WRITE := CTL_CODE(FILE_DEVICE_KRNLDRVR, 2, METHOD_BUFFERED, FILE_ANY_ACCESS);
    IOCTL_ZLUNI_IOPM_ON := CTL_CODE(FILE_DEVICE_KRNLDRVR, 3, METHOD_BUFFERED, FILE_ANY_ACCESS);
    IOCTL_ZLUNI_IOPM_OFF := CTL_CODE(FILE_DEVICE_KRNLDRVR, 4, METHOD_BUFFERED, FILE_ANY_ACCESS);

     if Win32Platform<>VER_PLATFORM_WIN32_NT then
     begin
       zliostarted := true;
       zliodirect := true;
     end
     else
     begin
       if not zlioopen(HZLIO) then begin
        if zliostart then
         ZLIOStarted := zlioopen(HZLIO) or (Win32Platform<>VER_PLATFORM_WIN32_NT);
       end
       else
        ZLIOStarted := true;
     end;
    // ZLIOStarted in Initialization routine of zlportio
    if ZLIOStarted then
   showmessage('Printer Driver successfully started !')
  else
  begin
      showmessage('Could not start Printer driver. Something wrong !');
   end;

end;
procedure readportfile;
var
        inf:textfile;
        wx,ww:string;
        ro:integer;
        v:word;
        parts:array[1..100] of string;
        z,pm:word;
        cx:integer;
        strs:Array[1..500] of string;
        stx:word;
begin
        with T_bscan do
        begin
         for ro:=0 to rowcount-1 do
         begin
             cells[0,ro]:='';
             cells[1,ro]:='';
         end;
         ro:=0;
         rowcount:=10;
        assignfile(inf,portfile);
        {$i-}
        reset(inf);
        {$i+}
        if ioresult=0 then
        begin
            stx:=0;
            while not eof(inf) do
            begin
                readln(inf,ww);
                pm:=0;
                for z:=1 to length(ww) do
                case ww[z] of
                ' ':begin
                        if parts[pm]<>'' then
                        begin
                            inc(pm);
                            parts[pm]:='';
                        end;
                end
                else
                begin
                     if pm=0 then
                     begin
                          pm:=1;
                          parts[pm]:='';
                     end;
                     parts[pm]:=parts[pm]+ww[z];
                end;
                end;
                val(parts[1],v,cx);
                if cx=0 then
                begin
                    wx:=inttostr(v);
                    wx:=parts[2];
                     inc(stx);
                    strs[stx]:=wx;
                end;


            end;
            closefile(inf);
            rowcount:=stx;
            ro:=rowcount-1;
            maxports:=ro;
            for z:=1 to stx do
            begin
                 cells[0,ro]:=strs[z];
                 dec(ro);
            end;
        end;
        end;
end;
procedure init_data;
var
        inf:textfile;
        bz,bb:byte;
        ww:string;
        co:integer;
        te,vv,va:longint;
begin
     te:=0;
     assignfile(inf,exepath+'Interface.cfg');
     {$i-}
     reset(inf);
     {$i+}
     if ioresult=0 then
     begin
        bb:=0;
        while not eof(inf) do
        begin
             readln(inf,ww);
             val(ww,va,co);
             if co=0 then
             case bb of
             0:T_Controller.itemindex:=va;
             1:T_Comport.itemindex:=va;
             2:T_baud.itemindex:=va;
             3:T_Data_bits.itemindex:=va;
             4:T_Stop_bits.itemindex:=va;
             5:T_Parity.itemindex:=va;
             end;
             if bb=6 then
             begin
                 if ww='checked' then
                 begin
                     t_tabsheet1.tabvisible:=true;
                     T_display.Checked:=true;
                 end
                 else
                 begin
                     t_tabsheet1.tabvisible:=false;
                     T_display.Checked:=false;
                 end;
                 
             end;
             if bb=7 then
             begin
                  portfile:=copy(ww,pos('=',ww)+1,100);
                  
             end;
             inc(bb);
        end;
        closefile(inf);
        if T_comport.itemindex=-1 then
        T_comport.ItemIndex:=0;
        //ControllerChange(Sender);
     end
     else
     begin
         t_tabsheet1.tabvisible:=true;
         T_display.Checked:=true;
     end;
     assignfile(inf,exepath+'params.cfg');
     {$i-}
     reset(inf);
     {$i+}
     if ioresult=0 then
     begin
        bb:=0; bz:=0;
        while not eof(inf) do
        begin
             readln(inf,ww);
             if ww='JTICE' then
             begin
                 bz:=0;bb:=0;
             end

             else
             if ww='STK500' then
             begin
                 bz:=1;bb:=0;
             end
             else
             begin
                 if bz=0 then
                 begin
                     with T_JTAGrev do
                     begin
                         cells[0,bb]:=copy(ww,1,pos(#9,ww)-1);
                         cells[1,bb]:=copy(ww,pos(#9,ww)+1,20);
                         val('$'+cells[1,bb],vv,co);
                         case bb of
                         0: te:=1;
                         1: te:=2;
                         2: te:=3;
                         3: te:=4;
                         4: te:=5;
                         5: te:=6;
                         6: te:=paddress[$e];
                         7: te:=paddress[6];

                         end;
                         case bb of
                         0: Jparams[te]:=vv;
                         1: Jparams[te]:=vv;
                         2: Jparams[te]:=vv;
                         3: Jparams[te]:=vv;
                         4: Jparams[te]:=vv;
                         5: Jparams[te]:=vv;
                         6: begin
                              Jparams[te]:=(vv and $ff000000) shr 24;
                              Jparams[te+1]:=(vv and $ff0000) shr 16;
                              Jparams[te+2]:=(vv and $ff00) shr 8;
                              Jparams[te+3]:=(vv and $ff) ;
                         end;
                         7:begin
                             Jparams[te+1]:=(vv and $ff00) shr 8 ;
                             Jparams[te]:=vv and $ff;
                         end;
                         end;
                     end;
                     inc(bb);
                 end
                 else
                 begin
                     with T_STKGrid do
                     begin
                         cells[0,bb]:=copy(ww,1,pos(#9,ww)-1);
                         cells[1,bb]:=copy(ww,pos(#9,ww)+1,20);
                         val('$'+cells[1,bb],vv,co);
                         case bb of
                        0:V_paraM_BUILD_NUMBER_LOW   :=char(vv) ;          //$80;
                        1:V_paraM_BUILD_NUMBER_HIGH  :=char(vv) ;         //$81;
                        2:V_paraM_HW_VER             :=char(vv) ;           //$90;
                        3:V_paraM_SW_MAJOR           :=char(vv) ;            //$91;
                        4:V_paraM_SW_MINOR           :=char(vv) ;           //$92;
                        5:V_paraM_VTARGET            :=char(vv) ;          //$94;
                        6:V_paraM_VADJUST            :=char(vv) ;           //$95;
                        7:V_paraM_OSC_PSCALE         :=char(vv) ;            //$96;
                        8:V_paraM_OSC_CMATCH         :=char(vv) ;           //$97;
                        9:V_paraM_SCK_DURATION       :=char(vv) ;           //$98;
                        10:V_paraM_TOPCARD_DETECT     :=char(vv) ;            //$9A;
                        11:V_paraM_STATUS             :=char(vv) ;           //$9C;
                        12:V_paraM_DATA               :=char(vv) ;           //$9D;
                        13:V_paraM_RESET_POLARITY     :=char(vv) ;           //$9E;
                        14:V_paraM_CONTROLLER_INIT    :=char(vv) ;            //$9F;
                        end;
                     end;
                     inc(bb);
                 end;
             end;
        end;
        closefile(inf);
     end;
end;
procedure set_params;
var
        lx,te:word;
begin
        lx:=1;te:=1;
        //find parameter table length
        while te<=$45 do
        begin
             paddress[te]:=lx;
             lx:=lx+ptable[te];
             inc(te);

        end;
        te:=1;
        While te<lx do
        begin
            jparams[te]:=$7f;
            inc(te);
        end;
        Jparams[1]:=4;   {M_MCU_HW=}
        Jparams[2]:=4;   {S_MCU_HW=}
        Jparams[3]:=$21; {M_MCU_FW_MIN=}
        Jparams[4]:=4;    {M_MCU_FW_MAJ=}
        Jparams[5]:=$21;  {M_MCU_FW_MIN=}
        Jparams[6]:=4;    {M_MCU_FW_MAJ=}
        te:=paddress[6];    //OCD Vtarget
        Jparams[te+1]:=$13;
        Jparams[te]:=$80;
        te:=paddress[$e];
        Jparams[te]:=$3f;    //JTAGID string
        Jparams[te+1]:=$20;
        Jparams[te+2]:=$80;
        Jparams[te+3]:=$09;
        te:=paddress[$25];
        Jparams[te]:=4;  //COMM_ID
        te:=Paddress[7];
        Jparams[te]:=50;
        with T_JTAGRev do
        begin
             cells[1,0]:=inttohex(Jparams[1],2);
             cells[1,1]:=inttohex(Jparams[2],2);
             cells[1,2]:=inttohex(Jparams[3],2);
             cells[1,3]:=inttohex(Jparams[4],2);
             cells[1,4]:=inttohex(Jparams[5],2);
             cells[1,5]:=inttohex(Jparams[6],2);
             te:=paddress[6];
             cells[1,7]:=inttohex(Jparams[te+1],2)+inttohex(Jparams[te],2);
             te:=paddress[$e];
             cells[1,6]:=inttohex(Jparams[te],2)+inttohex(Jparams[te+1],2)
              +inttohex(Jparams[te+2],2)+inttohex(Jparams[te+3],2);
             cells[0,0]:='M_MCU_HW';
             cells[0,1]:='S_MCU_HW';
             cells[0,2]:='M_MCU_FW_MIN';
             cells[0,3]:='S_MCU_FW_MAJ';
             cells[0,4]:='M_MCU_FW_MIN';
             cells[0,5]:='M_MCU_FW_MAJ';
             cells[0,6]:='JTAGID';
             cells[0,7]:='OCD Target';
        end;




end;

procedure set_STK_params;
var
        rx:word;
begin
     with T_Stkgrid do
     begin
         for rx:=0 to 14 do
         cells[0,rx]:=stkvars[rx];
         for rx:=$80 to  $9f do
         begin
             case rx of
                      PARAM_BUILD_NUMBER_LOW   :T_STKGrid.cells[1,0]:=inttohex(ord(D_PARAM_BUILD_NUMBER_LOW ),2); //$80),2);
                      PARAM_BUILD_NUMBER_HIGH  :T_STKGrid.cells[1,1]:=inttohex(ord(D_PARAM_BUILD_NUMBER_HIGH),2);  //$81),2);
                      PARAM_HW_VER             :T_STKGrid.cells[1,2]:=inttohex(ord(D_PARAM_HW_VER ),2);  //$90),2);
                      PARAM_SW_MAJOR           :T_STKGrid.cells[1,3]:=inttohex(ord(D_PARAM_SW_MAJOR),2);  //$91),2);
                      PARAM_SW_MINOR           :T_STKGrid.cells[1,4]:=inttohex(ord(D_PARAM_SW_MINOR),2);  //$92),2);
                      PARAM_VTARGET            :T_STKGrid.cells[1,5]:=inttohex(ord(D_PARAM_VTARGET),2);  //$94),2);
                      PARAM_VADJUST            :T_STKGrid.cells[1,6]:=inttohex(ord(D_PARAM_VADJUST),2);  //$95),2);
                      PARAM_OSC_PSCALE         :T_STKGrid.cells[1,7]:=inttohex(ord(D_PARAM_OSC_PSCALE),2);  //$96),2);
                      PARAM_OSC_CMATCH         :T_STKGrid.cells[1,8]:=inttohex(ord(D_PARAM_OSC_CMATCH  ),2); //$97),2);
                      PARAM_SCK_DURATION       :T_STKGrid.cells[1,09]:=inttohex(ord(D_PARAM_SCK_DURATION),2);  //$98),2);
                      PARAM_TOPCARD_DETECT     :T_STKGrid.cells[1,10]:=inttohex(ord(D_PARAM_TOPCARD_DETECT),2);  //$9A),2);
                      PARAM_STATUS             :T_STKGrid.cells[1,11]:=inttohex(ord(D_PARAM_STATUS),2);  //$9C),2);
                      PARAM_DATA               :T_STKGrid.cells[1,12]:=inttohex(ord(D_PARAM_DATA ),2);  //$9D),2);
                      PARAM_RESET_POLARITY     :T_STKGrid.cells[1,13]:=inttohex(ord(D_PARAM_RESET_POLARITY),2);  //$9E),2);
                      PARAM_CONTROLLER_INIT    :T_STKGrid.cells[1,14]:=inttohex(ord(D_PARAM_CONTROLLER_INIT ),2);  //$9F;
             end;
         end;
     end;
end;

begin

end.
