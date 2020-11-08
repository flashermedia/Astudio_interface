unit MicroController;

interface
uses
        Grids,Vars_const,Sysutils;
        
//procedure T_ChipChange;
Function Set_micro(Chip_no:integer;tx:word):boolean;
procedure process_micro_line(ww:string);
procedure Read_micro_data;
procedure write_micro_data;
procedure Set_tstr(Tgrid:Tstringgrid;bb:byte);

procedure Write_bits(cx:word;T:Tstringgrid;ww:string);
function convertbits(bb:byte):string;

        //************** Inside the Chip
        
implementation
function convertbits(bb:byte):string;
var
        z:integer;
        zx:string;
begin
     // get a byte and send out bits as x,x,x,x,x,x,x x= 0 or 1
     zx:='';
     z:=128;
     while z>0 do
     begin
         case z of
         128:if bb and z<>0 then zx:=zx+'1,' else zx:=zx+'0,';
         64:if bb and z<>0 then zx:=zx+'1,' else zx:=zx+'0,';
         32:if bb and z<>0 then zx:=zx+'1,' else zx:=zx+'0,';
         16:if bb and z<>0 then zx:=zx+'1,' else zx:=zx+'0,';
         8:if bb and z<>0 then zx:=zx+'1,' else zx:=zx+'0,';
         4:if bb and z<>0 then zx:=zx+'1,' else zx:=zx+'0,';
         2:if bb and z<>0 then zx:=zx+'1,' else zx:=zx+'0,';
         1:if bb and z<>0 then zx:=zx+'1,' else zx:=zx+'0,';

         end;
         z:=z div 2;
     end;
     convertbits:=zx;
end;
procedure Write_bits(cx:word;T:Tstringgrid;ww:string);
var
       ss,ro:integer;
       parts:array[0..10] of string;
       pm:byte;

begin
        if length(ww)>1 then
        if ww[length(ww)]=',' then ww:=copy(ww,1,length(ww)-1);
        with t do
        begin
             for ro:=0 to 7 do parts[ro]:='';
             pm:=0;
             for ss:=length(ww) downto 1 do
             begin
                  case ww[ss] of
                  ',':begin
                         inc(pm);
                  end
                  else
                  begin
                      parts[pm]:=ww[ss]+parts[pm];
                  end;
                  end;
             end;
             for ro:=0 to pm do
             begin
             cells[0,ro]:=inttostr(ro);
             cells[1,ro]:=parts[ro];
             end;


        end;

end;


procedure clear_grid(T:Tstringgrid);
var
        ro,co:word;
begin
     for ro:=0 to 7 do
     for co:=0 to 2 do T.cells[co,ro]:='';
end;
Function Set_micro(Chip_no:integer;tx:word):boolean;
var
        r,i:integer;
        
begin
       Set_micro:=true;
      i:=Chip_no;
      begin
          //clear all  fields
          T_Sig.text:='';
          T_PS_p_size.text:='';
          T_PS_size.text:='';
          T_EP_size.text:='';
          T_E_PG_Size.text:='';
          for r:=7 downto 0 do
          begin
               T_lb.cells[0,r]:=inttostr(r+1);
               T_fbe.cells[0,r]:=inttostr(r+1);
               T_fb2.cells[0,r]:=inttostr(r+1);
               T_fb1.cells[0,r]:=inttostr(r+1);
               T_lb.cells[1,r]:='';
               T_fbe.cells[1,r]:='';
               T_fb2.cells[1,r]:='';
               T_fb1.cells[1,r]:='';
          end;
      end;
      if i>=0 then
      begin

           T_sig.text:=micros[i].Code;
            T_PS_p_size.Text:=inttostr(micros[i].Page_size);
            T_PS_size.text:=inttostr(micros[i].PS);
            T_E_PG_Size.Text:=inttostr(micros[i].EP_Pge_size);
            T_EP_size.text:=inttostr(micros[i].ES);

            Write_bits(0,T_LB,micros[i].lb);
            Write_bits(0,T_fbe,micros[i].fb3);
            Write_bits(0,T_fb2,micros[i].fb2);
            Write_bits(0,T_fb1,micros[i].fb1);
      end ;


end;


function getPARAM(wm:string;VAR XNA:word):string;
var
        partype:string;
begin
        partype:='';
        while (wm[XNA]<>';') and (XNA<=length(wm)) do
        begin
             case wm[XNA] of
             ' ':begin
             end
             else
             partype:=partype+upcase(wm[XNA]);
             end;
             inc(XNA);
        end;
        getPARAM:=partype;
end;

procedure process_micro_line(ww:string);
var
        miptr,XNA:word;
        mlx:word;ch:char;
        partype,comtype:string;
begin
     ww:=ww+';';
     comtype:='';
     XNA:=1;
     miptr:=$ffff;
     while XNA<= length(ww) do
     begin
         ch:=upcase(ww[XNA]);
         case ch of
         ' ':begin end;
         ':':begin
                 inc(XNA);
                 partype:=getPARAM(ww,XNA);

                 if comtype='MICRO' then
                 begin
                       if partype='' then exit;
                      if T_Micro.Items.count<>-1 then
                      if T_micro.items.count<>0 then
                      for mlx:=0 to T_Micro.Items.count-1 do
                      begin
                         if T_Micro.Items[mlx]=partype then miptr:=mlx;
                      end;
                      if miptr=$ffff then
                      begin
                          T_Micro.Items.add(partype);
                          T_chip.Items.add(partype);
                          Miptr:=T_Micro.items.count-1;
                          Micros[miptr].Micro:=partype;
                      end;

                 end
                 else
                 if comtype='CODE' then Micros[miptr].Code:=partype
                 else
                 if comtype='PAGE_SIZE' then Micros[miptr].Page_size:=strtoint(partype)
                 else
                 if comtype='PS' then Micros[miptr].PS:=strtoint(partype)
                 else
                 if comtype='ES' then Micros[miptr].ES:=strtoint(partype)
                 else
                 if comtype='ESPS' then Micros[miptr].EP_Pge_size:=strtoint(partype)
                 else
                 if comtype='LB' then Micros[miptr].LB:=(partype)
                 else
                 if comtype='FB3' then Micros[miptr].FB3:=(partype)
                 else
                 if comtype='FB2' then Micros[miptr].FB2:=(partype)
                 else
                 if comtype='FB1' then Micros[miptr].FB1:=(partype);
                 comtype:='';
         end
         else
         comtype:=comtype+ch;
         end;
         inc(XNA);
     end;
end;

procedure Read_micro_data;
var
        inf:textfile;
        ww:string;
begin
    assignfile(inf,exepath+'Micro.dat');
    {$i-}
    reset(inf);
    {$I+}
    if ioresult=0 then
    begin
        while not eof(inf) do
        begin
             readln(inf,ww);
             ww:=trim(ww);
             if ww<>'' then process_micro_line(ww);
        end;
        closefile(inf);
    end;
end;
procedure Write_micro_data;
var
        outf:textfile;
        ww:string;
        ll:word;
begin
    assignfile(outf,exepath+'Micro.dat');
    {$i-}
    rewrite(outf);
    {$I+}
    if ioresult=0 then
    begin
        for ll:=0 to T_micro.items.count do
        if micros[ll].Micro<>'' then
        begin
            ww:='';
            //micro:ATTiny26   ;Code:1E9109;Page_size:16  ;PS:1024; ES:512;  ESps:4;  lb:lb2,lb1; fb2:RSTDISBL,SPIEN,EESAVE,BODLEVEL,BODEN;
            writeln(outf,'micro:'+micros[ll].micro+';'+
            'Code:'+micros[ll].code+';'+
            'Page_size:'+inttostr(micros[ll].Page_size)+';'+
            'PS:'+inttostr(micros[ll].PS)+';'+
            'ES:'+inttostr(micros[ll].ES)+';'+
            'Esps:'+inttostr(micros[ll].EP_Pge_size)+';'+
             'LB:'+micros[ll].lb+';'+
             'FB3:'+micros[ll].fb3+';'+
             'FB2:'+micros[ll].fb2+';'+
             'FB1:'+micros[ll].fb1+';');
        end;
        closefile(outf);
    end;
end;
procedure Set_tstr(Tgrid:Tstringgrid;bb:byte);
var
        ro:word;
begin
     with Tgrid do
     begin
          ro:=0;
          while ro<=7 do
          begin
          cells[2,ro]:='0';
          inc(ro);
          end;
          ro:=1;
          while  ro<256 do
          begin
              if bb and ro =ro then
              case ro of
              1:Cells[2,0]:='1';
              2:Cells[2,1]:='1';
              4:Cells[2,2]:='1';
              8:Cells[2,3]:='1';
              16:Cells[2,4]:='1';
              32:Cells[2,5]:='1';
              64:Cells[2,6]:='1';
              128:Cells[2,7]:='1';

              end;
              case ro of
              1:Cells[0,0]:='0';
              2:Cells[0,1]:='1';
              4:Cells[0,2]:='2';
              8:Cells[0,3]:='3';
              16:Cells[0,4]:='4';
              32:Cells[0,5]:='5';
              64:Cells[0,6]:='6';
              128:Cells[0,7]:='7';

              end;
              ro:=ro*2;
          end;
     end;
end;

end.
