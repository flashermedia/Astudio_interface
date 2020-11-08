unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, CommDrv, Spin, jpeg, ExtCtrls, ComCtrls, StdCtrls, Grids,
  SHELLAPI,

  Vars_const,MicroController,Init,ISP_communication,Comport,
  Jtag_signals,Jtag_avr,JTAG_AVR_TAP,STK500,Jtag_command_handling;

type
  TAVR = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    PC1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    Memo1: TMemo;
    GroupBox5: TGroupBox;
    CPSet: TGroupBox;
    Baud: TComboBox;
    Comport: TComboBox;
    Data_bits: TComboBox;
    Stop_bits: TComboBox;
    Parity: TComboBox;
    Update: TButton;
    Com_status: TLabeledEdit;
    GroupBox3: TGroupBox;
    Talk: TEdit;
    Controller: TComboBox;
    GroupBox6: TGroupBox;
    LBits: TStringGrid;
    Prog_Lbits: TButton;
    Read_Lbits: TButton;
    GroupBox10: TGroupBox;
    Label2: TLabel;
    Prog_fuseE: TButton;
    Button2: TButton;
    Prog_fuseH: TButton;
    Prog_FuseL: TButton;
    Button6: TButton;
    Button7: TButton;
    GroupBox7: TGroupBox;
    E_PSize: TLabeledEdit;
    E_PS: TLabeledEdit;
    BRead_Flash: TButton;
    Button3: TButton;
    Address: TLabeledEdit;
    GroupBox11: TGroupBox;
    E_EPSize: TLabeledEdit;
    E_EPS: TLabeledEdit;
    BRead_EEprom: TButton;
    Button8: TButton;
    Eaddress: TLabeledEdit;
    GroupBox16: TGroupBox;
    Read_Chip_Data: TButton;
    Chip: TComboBox;
    E_Sig: TLabeledEdit;
    Erase_chip: TButton;
    BEnter_Prog_Mode: TButton;
    GroupBox13: TGroupBox;
    Sg89: TStringGrid;
    Button9: TButton;
    GroupBox9: TGroupBox;
    SCK_Adj: TTrackBar;
    SCK_Val: TLabeledEdit;
    TabSheet6: TTabSheet;
    Image1: TImage;
    Circuit: TTabSheet;
    Image3: TImage;
    TabSheet7: TTabSheet;
    Memo2: TMemo;
    GroupBox12: TGroupBox;
    JTAGRev: TStringGrid;
    GroupBox14: TGroupBox;
    STKGrid: TStringGrid;
    Restore_defaults: TButton;
    Save_params: TButton;
    GroupBox17: TGroupBox;
    Scan: TButton;
    Bscan: TStringGrid;
    Scan_on: TCheckBox;
    GroupBox18: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    SPE4: TSpinEdit;
    Edit3: TEdit;
    JTAG_send_IR: TButton;
    Gb7: TGroupBox;
    Label1: TLabel;
    Label3: TLabel;
    Label7: TLabel;
    SPE1: TSpinEdit;
    Edit2: TEdit;
    JTAG_Send_DR: TButton;
    Image2: TImage;
    LE2: TLabeledEdit;
    TabSheet8: TTabSheet;
    GroupBox19: TGroupBox;
    GroupBox20: TGroupBox;
    Label10: TLabel;
    Add_micro: TButton;
    Button13: TButton;
    Gadd: TGroupBox;
    Edit5: TEdit;
    Badd_micro: TButton;
    Button15: TButton;
    Showsignals1: TMenuItem;
    TabSheet5: TTabSheet;
    GroupBox8: TGroupBox;
    GroupBox1: TGroupBox;
    P_Mosi: TCheckBox;
    P_SCK: TCheckBox;
    R_Mosi: TCheckBox;
    Edit1: TEdit;
    GroupBox2: TGroupBox;
    P_TDI: TCheckBox;
    P_TMS: TCheckBox;
    R_TDO: TCheckBox;
    Edit4: TEdit;
    P_TCK: TCheckBox;
    GroupBox4: TGroupBox;
  //  Reset: TCheckBox;
    Resetbox: TCheckBox;
    GroupBox21: TGroupBox;
    Micro: TComboBox;
    Sig: TLabeledEdit;
    PS_p_size: TLabeledEdit;
    PS_size: TLabeledEdit;
    E_PG_Size: TLabeledEdit;
    EP_size: TLabeledEdit;
    E6: TEdit;
    PS_read: TLabeledEdit;
    E_readsize: TLabeledEdit;
    ReadhexPS1: TMenuItem;
    ReadeepEP1: TMenuItem;
    Opd1: TOpenDialog;
    Compare: TButton;
    Button16: TButton;
    M3: TMemo;
    Button17: TButton;
    Button18: TButton;
    Show_signals: TMenuItem;
    Display: TMenuItem;
    Ecompare: TButton;
    Resetbox2: TCheckBox;
    Timer1: TTimer;
    Memo3: TMemo;
    Memo4: TMemo;
    GroupBox22: TGroupBox;
    GroupBox23: TGroupBox;
    GroupBox24: TGroupBox;
    Jtag_super_init: TButton;
    BJtag_init: TButton;
    BRun_test_idle: TButton;
    Chip_ID: TButton;
    B_Lck_Fuses: TButton;
    Jtag_Read_flash: TButton;
    Jtag_Read_eprom: TButton;
    Jtag_Write_Eprom: TButton;
    Jtag_Leave_Prog: TButton;
    Jtag_Write_Program: TButton;
    B_WF_L: TButton;
    SGF_L: TStringGrid;
    cfbe: TStringGrid;
    Cfb2: TStringGrid;
    Cfb1: TStringGrid;
    lb: TStringGrid;
    fbe: TStringGrid;
    fb2: TStringGrid;
    fb1: TStringGrid;
    Label8: TLabel;
    PGsize: TLabeledEdit;
    BProgram_mode: TButton;
    Jtag_erase: TButton;
    B_Signature: TButton;
    EPSize: TLabeledEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Label9: TLabel;
    Label11: TLabel;
    ReadJTAGpins1: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure Read_Chip_DataClick(Sender: TObject);
    procedure MicroChange(Sender: TObject);
    procedure ChipChange(Sender: TObject);
    procedure ResetboxClick(Sender: TObject);
    procedure Erase_chipClick(Sender: TObject);
    procedure BRead_FlashClick(Sender: TObject);
    procedure BEnter_Prog_ModeClick(Sender: TObject);
    procedure BRead_EEpromClick(Sender: TObject);
    procedure ReadhexPS1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure CompareClick(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Read_LbitsClick(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button17Click(Sender: TObject);
    procedure Button18Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Show_signalsClick(Sender: TObject);
    procedure DisplayClick(Sender: TObject);
    procedure Save_paramsClick(Sender: TObject);
    procedure Restore_defaultsClick(Sender: TObject);
    procedure ControllerChange(Sender: TObject);
    procedure UpdateClick(Sender: TObject);
    procedure Add_microClick(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Edit5KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Edit5KeyPress(Sender: TObject; var Key: Char);
    procedure Badd_microClick(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure SCK_AdjChange(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure ReadeepEP1Click(Sender: TObject);
    procedure EcompareClick(Sender: TObject);
    procedure Prog_LbitsClick(Sender: TObject);
    procedure Prog_fuseEClick(Sender: TObject);
    procedure Prog_fuseHClick(Sender: TObject);
    procedure Prog_FuseLClick(Sender: TObject);
    procedure Image2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Jtag_super_initClick(Sender: TObject);
    procedure BJtag_initClick(Sender: TObject);
    procedure BRun_test_idleClick(Sender: TObject);
    procedure Chip_IDClick(Sender: TObject);
    procedure BProgram_modeClick(Sender: TObject);
    procedure B_Lck_FusesClick(Sender: TObject);
    procedure B_SignatureClick(Sender: TObject);
    procedure Jtag_Read_epromClick(Sender: TObject);
    procedure Jtag_Leave_ProgClick(Sender: TObject);
    procedure Jtag_eraseClick(Sender: TObject);
    procedure Jtag_Read_flashClick(Sender: TObject);
    procedure Jtag_Write_ProgramClick(Sender: TObject);
    procedure Jtag_Write_EpromClick(Sender: TObject);
    procedure ScanClick(Sender: TObject);
    procedure JTAG_send_IRClick(Sender: TObject);
    procedure JTAG_Send_DRClick(Sender: TObject);
    procedure Resetbox2Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure CPortDrvReceiveData(Sender: TObject; DataPtr: Pointer;
      DataSize: Integer);
    procedure PC1Change(Sender: TObject);
    procedure B_WF_LClick(Sender: TObject);
    procedure Scan_onClick(Sender: TObject);
    procedure ReadJTAGpins1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
const
        revision:string='Rev 1.0.0.1 04/08/08';
var
  AVR: TAVR;

implementation

uses SignalU;

{$R *.dfm}


procedure TAVR.FormShow(Sender: TObject);
begin
    // top:=0;
    // left:=0;
     pc1.ActivePageIndex:=0;
     exepath:=extractfilepath(application.ExeName);
     T_application:=application;
     Micro.Items.Clear;
     T_Micro:=Micro;T_E_Psize:=E_psize;T_Sig:=Sig;T_PS_p_size:=PS_P_size;
     T_PS_size:=PS_Size;T_E_PG_Size:=E_PG_Size;T_EP_size:=EP_size;
     T_LB:=lb;T_Fbe:=fbe;T_Fb2:=fb2;T_Fb1:=Fb1;T_chip:=chip;T_e6:=e6;
     T_S89:=Sg89;T_m1:=Signals.m1;T_E_PS:=E_PS;T_Resetbox:=Resetbox;
     T_address:=address;T_eaddress:=eaddress;
     Load_Resource_data;
     T_display:=display;
  /////    T_controller:=controller;T_CPortDrv:=CPortDrv;T_Baud:= Baud;T_Comport:= Comport;

      T_Data_bits:= Data_bits;T_Stop_bits:= Stop_bits;T_Parity:= Parity;
      T_com_status:=com_status;T_JTAGrev:=JTAGrev;T_STKGrid:=STKgrid;
      T_tabsheet1:=tabsheet1;T_talk:=talk;T_Show_signals:=Show_signals;
      T_le2:=le2;T_JTM:=signals.JTM;
      T_lbits:=lbits;T_Cfbe:=Cfbe;T_CFb2:=Cfb2;T_Cfb1:=Cfb1;
      T_Bscan:=Bscan;
      set_PARAMs ;
      set_STK_PARAMs;
      Init_data;
      ControllerChange(Sender);
      Sck_adj.position:=TbPos;
      Signals.show;
      reset_port;
      with SGF_L do
      begin
          cells[0,0]:='LB';cells[0,1]:='FBE';cells[0,2]:='FBH';cells[0,3]:='FBL';
      end;
      label8.caption:=revision;
      readportfile;   
end;


procedure TAVR.Read_Chip_DataClick(Sender: TObject);
var
        x:word;

begin
     Reset_one;
     Reset_zero;
     Reset_one;
     Reset_zero;
     Enter_program_mode;
     if isp_ok then
     begin
         T_chip.ItemIndex:=-1;
         T_E_sig.text:='';
       //  application.processmessages;
         Read_Signature_bytes;
         T_E6.text:='Signature returned';
         E_sig.text:=Sig_str;
         if micro.Items.count>=0 then
         for x:=0 to micro.Items.count-1 do
         begin
             if sig_Str=micros[x].code then
             begin
                 micro.itemindex:=x;
                 chip.ItemIndex:=x;
                 ChipChange(Sender);
                 Read_Lock_Bits;
                 Set_Tstr(lbits,r4);
                 Read_Fuse_Bits;
                 Set_Tstr(Cfb1,r4);
                 Read_Fuse_High_Byte;
                 Set_Tstr(Cfb2,r4);
                 Read_Extended_Fuse_bits;
                 Set_Tstr(Cfbe,r4);
                 break;
             end;
         end;
     end
     else
     begin
          T_E_sig.text:='Chip not active';
          T_chip.ItemIndex:=-1;
          Set_micro(-1,0);

     end;
     


end;


procedure TAVR.MicroChange(Sender: TObject);
begin
     set_micro(Micro.ItemIndex,0);
end;

procedure TAVR.ChipChange(Sender: TObject);
var
        ro:word;
begin
     set_micro(Chip.ItemIndex,0);
     micro.itemindex:=chip.itemindex;
     //have now set all parameters on Specify micro
     //copy them to these tab page fields
     E_PS.Text:= PS_size.text;
    // E_Pages.Text:=
     E_PSize.Text:=PS_P_size.text;
     E_sig.text:=sig.Text;
     E_EPsize.Text:=E_PG_size.text ;
   //  E_EPages.Text:=
     E_EPS.Text:= EP_size.text;
     for ro:=0 to 7 do
     begin
        Lbits.cells[1,ro]:=lb.cells[1,ro];
        Cfbe.cells[1,ro]:=fbe.Cells[1,ro];
        Cfb2.cells[1,ro]:=fb2.Cells[1,ro];
        Cfb1.cells[1,ro]:=fb1.Cells[1,ro];
     end;

end;

procedure TAVR.ResetboxClick(Sender: TObject);
begin
    if resetbox.checked then
    begin
         Reset_one;
         Resetbox.Caption:='Reset (1)';
         Resetbox2.Caption:='Reset (1)';
         Resetbox2.state:=cbchecked;

    end
    else
    begin
         Reset_zero;
         Resetbox.Caption:='Reset (0)';
         Resetbox2.Caption:='Reset (0)';
         Resetbox2.state:=cbunchecked;

    end;
end;
procedure TAVR.Resetbox2Click(Sender: TObject);
begin
     if resetbox2.checked then Resetbox.checked:=true
     else
     resetbox.checked:=false;;
end;

procedure TAVR.Erase_chipClick(Sender: TObject);
begin
     if application.messagebox('Really Erase chip','Chip message',mb_Yesno)=idyes then
     begin
         Reset_zero;
         Enter_program_mode;
         if isp_ok then
         begin
            Erase_chip_isp;
            
         end;
     end;
end;

procedure TAVR.BRead_FlashClick(Sender: TObject);
var
        sz:longword;
        c:integer;
begin
     Enter_program_mode;
     if isp_ok then
     begin
         begin
             Signals.visible:=true;
             //Signals.m1.clear;
             showSignals1.Checked:=true;
             application.processmessages;
             Val(Ps_read.text,sz,c);
             if c=0 then
             Read_flash(sz)
             else
             begin
                Ps_read.text:='256';
                 read_flash(256);
             end;
         end;
     end
     else
     ShowMessage('Chip not responding');
end;

procedure TAVR.BEnter_Prog_ModeClick(Sender: TObject);
begin
     Read_Chip_DataClick(Sender);
     Enter_Program_mode;

end;

procedure TAVR.BRead_EEpromClick(Sender: TObject);
var
        sz:longword;
        c:integer;
begin
     Read_Chip_DataClick(Sender);
     if E_sig.text<>'' then
     begin
         if isp_ok then
         begin
             Signals.visible:=true;
             //Signals.m1.clear;
             showSignals1.Checked:=true;
             application.processmessages;
             Val(E_readsize.text,sz,c);
             if c=0 then
             Read_Eprom(sz)
             else
             begin
                Val(E_readsize.text,sz,c);
                if c=0 then
                begin
                    Read_Eprom(sz);
                end
                else
                begin
                    E_readsize.text:='16';
                    Read_Eprom(16);
                end;
             end;
         end
         else
         begin
             ShowMessage('Chip not responding');
         end;
     end
     else
     ShowMessage('No Valid Signature received');
end;

procedure TAVR.ReadhexPS1Click(Sender: TObject);
var
        inf:textfile;
        sz,addr,cc,data,dtype,ww:string;
        vsz,vaddr:word;
        dd:byte;
        lz,cz:integer;
begin
     with opd1 do
     begin
            filter:='micro data (*.hex)|*.HEX';
            if execute then
            if filename<>'' then
            begin
                if (pc1.activepageindex=0) or (pc1.activepageindex>2) then
                pc1.ActivePageIndex:=1;
                Signals.visible:=true;
                Signals.m1.clear;
                showSignals1.Checked:=true;
                application.processmessages;                 //hex file format
                 //:10    0000 00        37C055C055C055C055C055C055C055C0 66
                 //:bytes addr data-rec   bytes                           cc
                 //            00 - data record
                 //            01 - end-of-file record
                 //            02 - extended segment address record
                 //            04 - extended linear address record
                 assignfile(inf,filename);
                 {$i-}
                 reset(inf);
                 {$i+}
                 if ioresult=0 then
                 begin
                     for vsz:=0 to 65535 do
                     ISP_Program_data[vsz]:=$ff;
                     ISP_program_max:=0;
                     while not eof(inf) do
                     begin
                         readln(inf,ww);
                         //split line
                         if length(ww)>=9 then
                         if ww[1]=':' then
                         begin
                             sz:=copy(ww,2,2);
                             val('$'+sz,vsz,cz);
                             if cz=0 then   //valid number read
                             if vsz>0 then  //some data to deal with
                             begin
                                 vsz:=vsz*2;
                                 addr:=copy(ww,4,4);
                                 val('$'+addr,vaddr,cz);
                                 if cz=0 then
                                 begin
                                     dtype:=copy(ww,8,2);
                                     if dtype='00' then
                                     begin
                                          data:=copy(ww,10,vsz);cc:='';
                                          //we now have the address to add the data too
                                          // and the data
                                          lz:=1;
                                          ISP_program_max:=vaddr;
                                          while lz<=length(data) do
                                          begin
                                               val('$'+copy(data,lz,2),dd,cz);
                                               if cz=0 then
                                               begin
                                                    ISP_Program_data[ISP_program_Max]:=dd;
                                                    inc(ISP_program_max);
                                               end;
                                               inc(lz,2);
                                          end;
                                          ISP_program_max:=ISP_program_max-1;
                                          ps_read.Text:=inttostr(ISP_program_max);
                                     end;
                                 end;
                             end;
                         end;

                     end;
                     closefile(inf);
                     ww:='0000 ';
                     for vaddr:=0 to isp_program_max do
                     begin
                          ww:=ww+inttohex(ISP_Program_data[vaddr],2);
                          if vaddr mod 2=1 then ww:=ww+',';
                          if vaddr mod 16=15 then
                          begin
                              t_m1.Lines.add(ww);
                              ww:=inttohex(((vaddr+1) div 2),5)+' ';
                          end;
                     end;
                     if length(ww)>5 then
                     t_m1.Lines.add(ww);
                 end;

            end;
        end;

end;

procedure TAVR.Button3Click(Sender: TObject);

begin
     if ISP_program_max>0 then
     begin
         if E_sig.text<>'' then
         if E_sig.text<>'FFFFFF' then
         begin

                 Signals.visible:=true;
                 Signals.m1.clear;
                 showSignals1.Checked:=true;
                 application.processmessages;
                 Enter_program_mode;
                 if ISP_ok then
                 begin
                        Flash_PS(0,ISP_program_max);
                        //validate chip program

                        showmessage('Programming done');

                 end;

         end;
     end
     else
     showmessage('No hex file loaded');
end;

procedure TAVR.CompareClick(Sender: TObject);
var
        w,x:word;
begin
     If ISP_program_max>0 then
     begin
         Enter_program_mode;
         if ISP_ok then
         begin
             
             begin
                Signals.visible:=true;
                Signals.m1.clear;
                signals.m1.text:='Validating programmed data';
                application.processmessages;
                x:=0;
                while x<=ISP_program_max do
                begin
                     address.text:=inttostr(x);
                     application.processmessages;
                     w:=x div 2;
                     Send_ISP_Command($20,hi(w),lo(w),0);
                     if r4<>Isp_program_data[x] then
                     signals.m1.lines.add('error at '+inttohex((x div 2),4));

                     Send_ISP_Command($28,hi(w),lo(w),0);
                     if r4<>Isp_program_data[x+1] then
                     signals.m1.lines.add('error at '+inttohex((x div 2),4));
                     inc(x,2);

                end;
                signals.m1.lines.add('Validation complete');
             end;
         end;
     end
     else
     showmessage('No hex file loaded');

end;

procedure TAVR.Button16Click(Sender: TObject);
var
        ro,cx:integer;
        ll:integer;
        tlb,tfb3,tfb2,tfb1:string;
begin
     ll:=micro.ItemIndex;
     m3.clear;
     if ll>=0 then
     begin
            micros[ll].Code:=T_sig.text;
            val(T_PS_p_size.Text,micros[ll].Page_size,cx);
            if cx<>0 then
            m3.lines.add('PS page size not number')
            else
            val(T_PS_size.text,micros[ll].PS,cx);
             if cx<>0 then
            m3.lines.add('PS page size not number')
            else
             val(T_E_PG_Size.Text,micros[ll].EP_Pge_size,cx);
             if cx<>0 then
            m3.lines.add('PS page size not number')
            else
            val(T_EP_size.text,micros[ll].ES,cx);
             if cx<>0 then
            m3.lines.add('PS page size not number')
            else
            begin
                 tlb:='';tfb3:='';tfb2:='';tfb1:='';
                 for ro:=7 downto 0 do
                 begin
                      if lb.cells[1,ro]='' then lb.cells[1,ro]:='-';
                      tlb:=tlb+lb.cells[1,ro]+',';
                      micros[ll].LB:=tlb;
                      if fbe.cells[1,ro]='' then fbe.cells[1,ro]:='-';
                      tfb3:=tfb3+fbe.cells[1,ro]+',';
                      micros[ll].Fb3:=tfb3;
                      if fb2.cells[1,ro]='' then fb2.cells[1,ro]:='-';
                      tfb2:=tfb2+fb2.cells[1,ro]+',';
                      micros[ll].Fb2:=tfb2;
                      if fb1.cells[1,ro]='' then fb1.cells[1,ro]:='-';
                      tfb1:=tfb1+fb1.cells[1,ro]+',';
                      micros[ll].Fb1:=tfb1;


                 end;
                 Write_micro_data;
            end;

     end
     else
     showmessage('no Micropcontroller selected');
end;

procedure TAVR.Button6Click(Sender: TObject);
begin
     Read_Fuse_High_Byte;
     Set_Tstr(Cfb2,r4);

end;

procedure TAVR.Button7Click(Sender: TObject);
begin
     Read_Fuse_Bits;
     Set_Tstr(Cfb1,r4);

end;

procedure TAVR.Button2Click(Sender: TObject);
begin
     Read_Extended_Fuse_bits;
     Set_Tstr(Cfbe,r4);

end;

procedure TAVR.Read_LbitsClick(Sender: TObject);
begin
     Read_Lock_Bits;
     Set_Tstr(lbits,r4);

end;

procedure TAVR.Button9Click(Sender: TObject);
var
        c1,c2,c3,c4:byte;
        cx:integer;
begin
    c2:=0;c3:=0;c4:=0;
    val('$'+sg89.Cells[1,0],c1,cx);
    if cx=0 then
    val('$'+sg89.Cells[2,0],c2,cx);
    if cx=0 then
    val('$'+sg89.Cells[3,0],c3,cx);
    if cx=0 then
    val('$'+sg89.Cells[4,0],c4,cx);
    if cx=0 then
    Send_ISP_command(c1,c2,c3,c4)   ;
    if cx<>0 then
    showmessage('Please enter valid hex numbers');

end;

procedure TAVR.Button17Click(Sender: TObject);
begin
      with sender as Tbutton do
      ShellExecute(Application.Handle,
             PChar('open'),
             PChar(Hint),
             PChar(0),
             nil,
             SW_NORMAL);
end;

procedure TAVR.Button18Click(Sender: TObject);
begin
with sender as Tbutton do
      ShellExecute(Application.Handle,
             PChar('open'),
             PChar(Hint),
             PChar(0),
             nil,
             SW_NORMAL);

end;

procedure TAVR.FormClose(Sender: TObject; var Action: TCloseAction);
var
        outf:textfile;

begin
   {  assignfile(outf,Exepath+'Interface.cfg');
     {$i-}
  {   rewrite(outf);
     {$i+}
  {   if ioresult=0 then
     begin

         Writeln(outf,inttostr(controller.itemindex));
         Writeln(outf,inttostr(Comport.itemindex));
         Writeln(outf,inttostr(Baud.itemindex));
         Writeln(outf,inttostr(Data_bits.itemindex));
         Writeln(outf,inttostr(Stop_bits.itemindex));
         Writeln(outf,inttostr(Parity.itemindex));
         if display.checked then
         Writeln(outf,'checked') else Writeln(outf,'unchecked');
         writeln(outf,'portfile=',portfile);
         closefile(outf);
     end;
     Save_paramsClick(Sender);
     Write_micro_data;    }
end;


procedure TAVR.Show_signalsClick(Sender: TObject);
begin
     if show_Signals.Checked then
     begin
          Signals.visible:=false;
          show_Signals.Checked:=false;
     end
     else
     begin
          Signals.visible:=true;
          show_Signals.Checked:=true;
     end;
end;

procedure TAVR.DisplayClick(Sender: TObject);
begin
     if Display.Checked then
     begin
          Tabsheet1.tabvisible:=false;
          Display.Checked:=false;
     end
     else
     begin
          Tabsheet1.tabvisible:=true;
          Display.Checked:=true;
          pc1.activepage:=tabsheet1;
     end;
end;


procedure TAVR.Save_paramsClick(Sender: TObject);
var
        y1:word;
        outf:textfile;
        vv,te,co:integer;
        loz:array[1..4] of string;
begin

        Val('$'+JTAGRev.cells[1,0],jPARAMs[1],co);   {M_MCU_HW=}
        Val('$'+JTAGRev.cells[1,1],jPARAMs[2],co);   {S_MCU_HW=}
        Val('$'+JTAGRev.cells[1,2],jPARAMs[3],co); {M_MCU_FW_MIN=}
        Val('$'+JTAGRev.cells[1,3],jPARAMs[4],co);    {M_MCU_FW_MAJ=}
        Val('$'+JTAGRev.cells[1,4],jPARAMs[5],co);  {M_MCU_FW_MIN=}
        Val('$'+JTAGRev.cells[1,5],jPARAMs[6],co);    {M_MCU_FW_MAJ=}
        te:=paddress[6];    //OCD Vtarget
        loz[1]:=copy(JTAGRev.cells[1,7],1,2);
        loz[2]:=copy(JTAGRev.cells[1,7],3,2);
        Val('$'+loz[1],jPARAMs[te+1],co);
        Val('$'+loz[2],jPARAMs[te],co);
        te:=paddress[$e];
        loz[1]:=copy(JTAGRev.cells[1,6],1,2);
        loz[2]:=copy(JTAGRev.cells[1,6],3,2);
        loz[3]:=copy(JTAGRev.cells[1,6],5,2);
        loz[4]:=copy(JTAGRev.cells[1,6],7,2);
        Val('$'+loz[1],jPARAMs[te],co);    //'$'+JTAGID string
        Val('$'+loz[2],jPARAMs[te+1],co);
        Val('$'+loz[3],jPARAMs[te+2],co);
        Val('$'+loz[4],jPARAMs[te+3],co);

       // PARAMs[te]:=4;  //COMM_ID
     //   te:=Paddress[7];
     //   PARAMs[te]:=50;
        with T_JTAGRev do
        begin
             cells[1,0]:=inttohex(jPARAMs[1],2);
             cells[1,1]:=inttohex(jPARAMs[2],2);
             cells[1,2]:=inttohex(jPARAMs[3],2);
             cells[1,3]:=inttohex(jPARAMs[4],2);
             cells[1,4]:=inttohex(jPARAMs[5],2);
             cells[1,5]:=inttohex(jPARAMs[6],2);
             te:=paddress[6];
             cells[1,7]:=inttohex(jPARAMs[te+1],2)+inttohex(jPARAMs[te],2);
             te:=paddress[$e];
             cells[1,6]:=inttohex(jPARAMs[te],2)+inttohex(jPARAMs[te+1],2)
              +inttohex(jPARAMs[te+2],2)+inttohex(jPARAMs[te+3],2);
             cells[0,0]:='M_MCU_HW';
             cells[0,1]:='S_MCU_HW';
             cells[0,2]:='M_MCU_FW_MIN';
             cells[0,3]:='S_MCU_FW_MAJ';
             cells[0,4]:='M_MCU_FW_MIN';
             cells[0,5]:='M_MCU_FW_MAJ';
             cells[0,6]:='JTAGID';
             cells[0,7]:='OCD Target';
        end;
    assignfile(outf,exepath+'PARAMs.cfg');
    rewrite(outf);
    writeln(outf,'JTICE');
    for y1:=0 to 7 do
    with Jtagrev do
    begin
        writeln(outf,cells[0,y1]+#9+cells[1,y1]);

    end;
        val('$'+STKgrid.cells[1,0],vv,co);
        V_PARAM_BUILD_NUMBER_LOW   :=char(vv) ;          //$80;
        val('$'+STKgrid.cells[1,1],vv,co);
        V_PARAM_BUILD_NUMBER_HIGH  :=char(vv) ;         //$81;
        val('$'+STKgrid.cells[1,2],vv,co);
        V_PARAM_HW_VER             :=char(vv) ;          //$90;
        val('$'+STKgrid.cells[1,3],vv,co);
        V_PARAM_SW_MAJOR           :=char(vv) ;          //$91;
        val('$'+STKgrid.cells[1,4],vv,co);
        V_PARAM_SW_MINOR           :=char(vv) ;        //$92;
        val('$'+STKgrid.cells[1,5],vv,co);
        V_PARAM_VTARGET            :=char(vv) ;         //$94;
        val('$'+STKgrid.cells[1,6],vv,co);
        V_PARAM_VADJUST            :=char(vv) ;          //$95;
        val('$'+STKgrid.cells[1,7],vv,co);
        V_PARAM_OSC_PSCALE         :=char(vv) ;         //$96;
        val('$'+STKgrid.cells[1,8],vv,co);
        V_PARAM_OSC_CMATCH         :=char(vv) ;           //$97;
        val('$'+STKgrid.cells[1,9],vv,co);
        V_PARAM_SCK_DURATION       :=char(vv) ;         //$98;
        val('$'+STKgrid.cells[1,10],vv,co);
        V_PARAM_TOPCARD_DETECT     :=char(vv) ;          //$9A;
        val('$'+STKgrid.cells[1,11],vv,co);
        V_PARAM_STATUS             :=char(vv) ;          //$9C;
        val('$'+STKgrid.cells[1,12],vv,co);
        V_PARAM_DATA               :=char(vv) ;          //$9D;
        val('$'+STKgrid.cells[1,13],vv,co);
        V_PARAM_RESET_POLARITY     :=char(vv) ;          //$9E;
        val('$'+STKgrid.cells[1,14],vv,co);
         V_PARAM_CONTROLLER_INIT    :=char(vv) ;         //$9F;
    writeln(outf,'STK500');
    for y1:=0 to 14 do
    with STKgrid do
    begin
        writeln(outf,cells[0,y1]+#9+cells[1,y1]);
    end;
    closefile(outf);
end;


procedure TAVR.Restore_defaultsClick(Sender: TObject);
begin
     set_STK_PARAMs;
     set_PARAMs;

end;

procedure TAVR.ControllerChange(Sender: TObject);
begin
     if pos('STK',Controller.Items[Controller.itemindex])>0 then
     begin
         Baud.itemindex:=5;
         P_type:=STK ;
     end
     else
     begin
         Baud.itemindex:=2;
         P_Type:=J_TAG;
     end;
     SetupComport(Controller.items[Controller.itemindex]);

end;

procedure TAVR.UpdateClick(Sender: TObject);
begin
        SetupComport(Controller.items[Controller.itemindex]);

end;

procedure TAVR.Add_microClick(Sender: TObject);
begin
     Gadd.Visible:=true;
     Edit5.SetFocus;
end;

procedure TAVR.Button15Click(Sender: TObject);
begin
     Gadd.Visible:=false;
end;

procedure TAVR.Edit5KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     if (key>=65) and (key<=90) then
     key:=key-$20;

end;

procedure TAVR.Edit5KeyPress(Sender: TObject; var Key: Char);
var
        ww:string;
begin
     ww:=key;
     ww:=uppercase(ww);
     key:=ww[1];
end;

procedure TAVR.Badd_microClick(Sender: TObject);
var
        f,ii:word;
begin
     f:=0;
     m3.Clear;
     if micro.Items.count>-1 then
     for ii:=0 to micro.items.count-1 do
     begin
          if micro.Items[ii]=edit5.text then
          begin
              f:=1;
              micro.ItemIndex:=ii;
              MicroChange(Sender);
              
          end;
     end;
     if f=1 then
     showmessage('This microcontroller is already defined')
     else
     begin

          micros[micro.Items.count]:=bmicro;
          micros[micro.Items.Count].Micro:=edit5.text;
          micro.Items.add(edit5.text);
          micro.ItemIndex:=micro.Items.count-1;
          MicroChange(Sender);
          m3.Text:=('Now please specify page sizes, bits etc as per the PDF for this microcontroller');
          Write_micro_data;

     end;
     Gadd.Visible:=false;
end;

procedure TAVR.Button13Click(Sender: TObject);
var
        ll,ii:integer;
begin
     if micro.itemindex>-1 then
     begin
          if idyes=application.MessageBox(
          pchar('delete micro '+micro.Items[micro.itemindex]),
          'Delete Micro',mb_yesno) then
          begin
               ii:=micro.ItemIndex;
               for ll:=ii to micro.Items.count-2 do
               begin
                   micros[ll]:=micros[ll+1];
               end;
               micro.Items.Delete(ii);
               if ii>=micro.Items.count then
               micro.ItemIndex:=micro.Items.count-1;
               microchange(sender);
          end;
     end;
end;

procedure TAVR.SCK_AdjChange(Sender: TObject);
begin
     Tbpos:=SCK_Adj.position;
     sck_val.text:=inttostr(SCK_Adj.position);

end;

procedure TAVR.FormResize(Sender: TObject);
var
        wv:integer;
        ww,wh:word;
begin
     ww:=avr.ClientWidth;
     wh:=avr.clientheight;
     wv:=(ww-pc1.Width) div 2;
     if wv>0 then
     pc1.Left:=wv;
     wv:=(wh-pc1.Height) div 2;
     if wv>0 then
     pc1.top:=wv;

end;

procedure TAVR.Button8Click(Sender: TObject);

begin
     if ISP_Eprogram_max>0 then
     begin
         Read_Chip_DataClick(Sender);
         if E_sig.text<>'' then
         begin
             if isp_ok then
             begin
                 Signals.visible:=true;
                 Signals.m1.clear;
                 showSignals1.Checked:=true;
                 application.processmessages;
                 Enter_program_mode;
                 if ISP_ok then
                 begin
                        Flash_Eprom(ISP_Eprogram_max);
                        //validate chip program

                        showmessage('EProgramming done');

                 end;
             end;
         end;
     end
     else
     showmessage('No eep file loaded');
end;
procedure TAVR.ReadeepEP1Click(Sender: TObject);
var
        inf:textfile;
        sz,addr,cc,data,dtype,ww:string;
        vsz,vaddr:word;
        dd:byte;
        lz,cz:integer;
begin
     with opd1 do
     begin
            filter:='Eprom micro data (*.eep)|*.EEP';
            if execute then
            if filename<>'' then
            begin
                if (pc1.activepageindex=0) or (pc1.activepageindex>2) then
                pc1.ActivePageIndex:=1;
                Signals.visible:=true;
                Signals.m1.clear;
                showSignals1.Checked:=true;
                application.processmessages;                 //hex file format
                 //:10    0000 00        37C055C055C055C055C055C055C055C0 66
                 //:bytes addr data-rec   bytes                           cc
                 //            00 - data record
                 //            01 - end-of-file record
                 //            02 - extended segment address record
                 //            04 - extended linear address record
                 assignfile(inf,filename);
                 {$i-}
                 reset(inf);
                 {$i+}
                 if ioresult=0 then
                 begin
                     for vsz:=0 to 16000 do
                     ISP_EProgram_data[vsz]:=$ff;
                     ISP_Eprogram_max:=0;
                     while not eof(inf) do
                     begin
                         readln(inf,ww);
                         //split line
                         if length(ww)>=9 then
                         if ww[1]=':' then
                         begin
                             sz:=copy(ww,2,2);
                             val('$'+sz,vsz,cz);
                             if cz=0 then   //valid number read
                             if vsz>0 then  //some data to deal with
                             begin
                                 vsz:=vsz*2;
                                 addr:=copy(ww,4,4);
                                 val('$'+addr,vaddr,cz);
                                 if cz=0 then
                                 begin
                                     dtype:=copy(ww,8,2);
                                     if dtype='00' then
                                     begin
                                          data:=copy(ww,10,vsz);cc:='';
                                          //we now have the address to add the data too
                                          // and the data
                                          lz:=1;
                                          ISP_Eprogram_max:=vaddr;
                                          while lz<=length(data) do
                                          begin
                                               val('$'+copy(data,lz,2),dd,cz);
                                               if cz=0 then
                                               begin
                                                    ISP_EProgram_data[ISP_Eprogram_Max]:=dd;
                                                    inc(ISP_Eprogram_max);
                                               end;
                                               inc(lz,2);
                                          end;
                                          ISP_Eprogram_max:=ISP_Eprogram_max-1;
                                          E_readsize.Text:=inttostr(ISP_Eprogram_max);
                                     end;
                                 end;
                             end;
                         end;

                     end;
                     closefile(inf);
                     ww:='0000 ';
                     for vaddr:=0 to isp_Eprogram_max do
                     begin
                          ww:=ww+inttohex(ISP_EProgram_data[vaddr],2);
                          if vaddr mod 16=15 then
                          begin
                              t_m1.Lines.add(ww);
                              ww:=inttohex(((vaddr+1) div 2),4)+' ';
                          end
                          else
                          ww:=ww+',';
                     end;
                     if length(ww)>5 then
                     t_m1.Lines.add(ww);
                 end;

            end;
        end;

end;

procedure TAVR.EcompareClick(Sender: TObject);
var
        x:word;
begin
     If ISP_Eprogram_max>0 then
     begin
         Read_Chip_DataClick(Sender);
         if E_sig.text<>'' then
         begin
             if isp_ok then
             begin
                Signals.visible:=true;
                Signals.m1.clear;
                signals.m1.text:='Validating programmed data';
                application.processmessages;
                x:=0;
                while x<=ISP_Eprogram_max do
                begin
                     address.text:=inttostr(x);
                     application.processmessages;

                     Send_ISP_Command($a0,hi(x),lo(x),0);
                     if r4<>Isp_Eprogram_data[x] then
                     signals.m1.lines.add('error at '+inttohex((x),4));
                     inc(x);

                end;
                signals.m1.lines.add('Validation complete');
             end;
         end;
     end
     else
     showmessage('No hex file loaded');

end;

procedure TAVR.Prog_LbitsClick(Sender: TObject);
var
        p,bb:word; z:integer;
begin
     bb:=0;
     p:=1;
     z:=0;
     while z<= 7 do
     with Cfb1 do
     begin
         if cells[2,z]='1' then
         bb:=bb +p;
         p:=p*2;
         inc(z);
     end;
     Send_ISP_Command($ac,$e0,00,bb);
end;


procedure TAVR.Prog_fuseEClick(Sender: TObject);
var
        p,bb:word; z:integer;
begin
     bb:=0;
     p:=1;
     z:=0;
     while z<= 7 do
     with Cfbe do
     begin
         if cells[2,z]='1' then
         bb:=bb +p;
         p:=p*2;
         inc(z);
     end;
     Send_ISP_Command($ac,$a4,00,bb);
end;

procedure TAVR.Prog_fuseHClick(Sender: TObject);
var
        p,bb:word; z:integer;
begin
     bb:=0;
     p:=1;
     z:=0;
     while z<= 7 do
     with Cfb2 do
     begin
         if cells[2,z]='1' then
         bb:=bb +p;
         p:=p*2;
         inc(z);
     end;
     Send_ISP_Command($ac,$a8,00,bb);
end;


procedure TAVR.Prog_FuseLClick(Sender: TObject);
var
        p,bb:word; z:integer;
begin
     bb:=0;
     p:=1;
     z:=0;
     while z<= 7 do
     with Cfb1 do
     begin
         if cells[2,z]='1' then
         bb:=bb +p;
         p:=p*2;
         inc(z);
     end;
     Send_ISP_Command($ac,$a0,00,bb);
end;


procedure TAVR.Image2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
        col:word;
begin
    // e3.text:=inttostr(x)+' '+inttostr(y);
     //y =3,21  44,61  85,101  125,142 165,183  206,222  245,263  287,303
     //x = 25,78 115,168  217,269
     case x of
     25..78:col:=1;
     115..168:col:=2;
     217..269:col:=3
     else
     col:=0;
     end;
     case y of
     3..21:case col of
                1:jtag_goto_state(TEST_LOGIC_RESET);

     end;
     44..61:case col of
                1:jtag_goto_state(RUN_TEST_IDLE);
                2:jtag_goto_state(SELECT_DR_SCAN);
                3:jtag_goto_state(SELECT_IR_SCAN);
     end;
     85..101:case col of
                2:jtag_goto_state(CAPTURE_DR);
                3:jtag_goto_state(CAPTURE_IR);
     end;
     125..142:case col of
                2:jtag_goto_state(SHIFT_DR);
                3:jtag_goto_state(SHIFT_IR);
     end;
     165..183:case col of
                2:jtag_goto_state(EXIT1_DR);
                3:jtag_goto_state(EXIT1_IR);
     end;
     206..222:case col of
                2:jtag_goto_state(PAUSE_DR);
                3:jtag_goto_state(PAUSE_IR);
     end;
     245..263:case col of
                2:jtag_goto_state(EXIT2_DR);
                3:jtag_goto_state(EXIT2_IR);
     end;
     287..303:case col of
                2:jtag_goto_state(UPDATE_DR);
                3:jtag_goto_state(UPDATE_IR);
     end;
     end;

end;

procedure TAVR.Jtag_super_initClick(Sender: TObject);
begin
        The_Jtag_super_init;

end;

procedure TAVR.BJtag_initClick(Sender: TObject);
begin
    jtag_init;
     Le2.Text:=states[tapstate];
end;
procedure outstate;
begin
    AVR.Le2.Text:=states[tapstate];
end;

procedure TAVR.BRun_test_idleClick(Sender: TObject);
begin
     	jtag_goto_state(RUN_TEST_IDLE);
        outstate;

end;
procedure write_tdo_to_T_JTM(no_bytes:word);
var
        x:word;

begin
    // if TShow_TDO.checked then
     begin
         str:='';
         if no_bytes=0 then
         no_bytes:=1;
         for  x:=no_bytes-1 downto 0 do
         begin
             str:=str+inttohex(tdo_buf[x],2);
         end;
         T_JTM.lines.add(str);
         AVR.Edit6.text:=str;
         AVR.Edit7.text:=str;

     end;

end;

procedure TAVR.Chip_IDClick(Sender: TObject);
begin
     idcode;
     write_tdo_to_T_JTM(4);

end;

procedure TAVR.BProgram_modeClick(Sender: TObject);
begin
    reset_one;
    Enter_Prog_mode;
    outstate;
    T_JTM.Lines.add('Entered Program mode');
end;

procedure TAVR.B_Lck_FusesClick(Sender: TObject);
begin
    with SGF_L do
    begin
    rd_lock_avr;
    cells[1,0]:=inttohex(tdo_buf[0],2);
    rd_hfuse_avr;
    cells[1,2]:=inttohex(tdo_buf[0],2);
    rd_lfuse_avr;
    cells[1,3]:=inttohex(tdo_buf[0],2);
    end;


end;

procedure TAVR.B_SignatureClick(Sender: TObject);
var
        x:word;
        f,v:word;
begin
     BProgram_modeClick(Sender);
     rd_signature_avr ;
     PGsize.text:='0';
     EPsize.Text:='0';
     sig_str:=inttohex(signature[1],2)+
     inttohex(signature[2],2)+
     inttohex(signature[3],2);
     T_JTM.lines.add('Signature='+sig_str);
     f:=0;
     if micro.Items.count>=0 then
     begin
         for x:=0 to micro.Items.count-1 do
         begin
             if sig_Str=micros[x].code then
             begin
                 micro.itemindex:=x;
                 chip.ItemIndex:=x;
                 T_JTM.lines.add('Chip is '+micros[x].Micro);
                 v:=micros[x].Page_size;
                 PGsize.text:=inttostr(v);
                 v:=micros[x].EP_Pge_size;
                 EPsize.text:=inttostr(v);
                 f:=1;
                 break;
             end;
         end;
     end;
     if f=0 then
     T_JTM.lines.add('no chip found in records');
end;

procedure TAVR.Jtag_Read_epromClick(Sender: TObject);
var
        vstr:string;
        x,no,Taddr:word;
        co:integer;

begin
     B_SignatureClick(Sender);
     mmax:=0;
     vstr:='';
     if ISP_Eprogram_max=0 then
     val(Epsize.text,no,co)
     else
     no:=ISP_Eprogram_max+1;
     taddr:=0;
     if no=0 then no:=16;
     //bytes.text:=inttostr(no);
   // add r.text:=inttostr(Taddr);
     rd_eeprom_page(no,Taddr);
     for x:=0 to no-1 do
     begin
         inc(mmax);
        if x mod 16=0 then
        begin
             if vstr<>'' then
             vstr:=vstr+char(13)+char(10);
             vstr:=vstr+inttohex(x,4)+'  ';
        end;
        vstr:=vstr+inttohex(data[x],2)+',';

     end;
     T_JTM.Lines.add(vstr);

end;


procedure TAVR.Jtag_Leave_ProgClick(Sender: TObject);
begin
     Leave_prog_mode;
     T_JTM.Lines.add('Left Program mode');
end;

procedure TAVR.Jtag_eraseClick(Sender: TObject);
begin
     if application.MessageBox('Do you really want to Erase the PS & Eprom','Write words',mb_yesno)=
     idyes then
     chip_erase;
     T_JTM.Lines.add('Chip Erased');
end;

procedure TAVR.Jtag_Read_flashClick(Sender: TObject);
var
        vstr:string;
        Vmax,x,no,Taddr:word;
        co:integer;

begin
     B_SignatureClick(Sender);
     val(PGsize.text,no,co);
     T_JTM.Lines.add('Reading Flash');
     if no=0 then no:=16;
     taddr:=0;
     vmax:=ISP_program_max;
     if vmax=0 then vmax:=no;
     x:=0;
     vstr:=inttohex(((taddr+x) div  2),5)+' ';
     while taddr<vmax do
     begin
         rd_flash_page(no,Taddr div 2);
         mmax:=0;
         for x:=0 to no-1 do
         begin
            mem[mmax]:=data[x];
            if x mod 2=0 then
            if length(vstr)>6 then vstr:=vstr+',';
            inc(Mmax);
            if x mod 16=0 then
            begin
                 if length(vstr)>6 then
                 T_JTM.Lines.add(vstr);
                 vstr:=inttohex(((taddr+x) div  2),5)+' ';
            end;
            vstr:=vstr+inttohex(data[x],2);
         end;
         inc(Taddr,no);
     end;
     if length(vstr)>6 then T_JTM.Lines.add(vstr);
     T_JTM.Lines.add('Flash read words='+inttostr(vmax));
end;



procedure TAVR.Jtag_Write_ProgramClick(Sender: TObject);
var
        vaddr,y,x,no:longword;
        pb:pbyte;
        co:integer;

begin
     if ISP_program_max>0 then
     begin
         if application.MessageBox('Do you really want to Write to PS','Write words',mb_yesno)=
         idyes then
         begin
             B_SignatureClick(Sender);
             val(pgsize.text,no,co);
             if (co>0) or (no=0) then
             begin
                 Showmessage('No Page Size set');
                 exit;
             end;
             pb:=@ISP_Program_data;
             vaddr:=0;
             for x:=0 to ISP_program_max div 128 do
             begin
                //wr_flash_page(bytecount:integer;address:word;p:pbyte);
                wr_flash_page(no,vaddr,pb);
                for y:=1 to no do inc(pb);
                vaddr:=vaddr+no;
             end;
             t_JTM.Lines.Add('Program written to Flash');
         end;
     end
     else
     showmessage('No hex file loaded');
     

end;

procedure TAVR.Jtag_Write_EpromClick(Sender: TObject);
var
        y,x,vaddr,no:word;
        co:integer;
        pb:Pbyte;
begin
     B_SignatureClick(Sender);


     if ISP_Eprogram_max>0 then
     begin
         if application.MessageBox('Do you really want to Write to the EPROM','Write words',mb_yesno)=
         idyes then
         begin
             val(EPsize.text,no,co);
             if (co>0) or (no=0) then
             begin
                 Showmessage('No Page Size set');
                 exit;
             end;
             pb:=@ISP_EProgram_data;
             vaddr:=0;
             for x:=0 to ISP_Eprogram_max div no do
             begin
                //wr_flash_page(bytecount:integer;address:word;p:pbyte);
                wr_eeprom_page(no,Vaddr,pb);
                for y:=1 to no do inc(pb);
                vaddr:=vaddr+no;
             end;
             t_JTM.Lines.Add('Program written to EPROM');
         end;
     end
     else
     showmessage('No EPROM hex file loaded');
end;

procedure TAVR.ScanClick(Sender: TObject);
var
        te:integer;
        ro,z:word;
        sh:word;pu:byte;

begin
    avr_jtag_instr(2,0);
    jtag_read(maxports);
    str:='';
    ro:=0;te:=0;
    for z:=0 to maxports div 8 do
    begin
        pu:=tdo_buf[z];
        sh:=1;
        while sh<256 do
        begin
            if pu and sh=sh then
            Bscan.cells[1,ro]:='1'
            else
            Bscan.cells[1,ro]:='0';
            sh:=sh*2;
            inc(ro);
        end;

    end;

end;



procedure TAVR.JTAG_send_IRClick(Sender: TObject);
var
        ll:longword;
        co:integer;
begin
      val('$'+edit3.text,ll,co);
      if co>0 then ll:=0;
      edit3.text:=inttohex(ll,8);
      tdi_buf[0]:=ll and $ff;
      tdi_buf[1]:=(ll shr 8) and $ff;
      tdi_buf[2]:=(ll shr 16) and $ff;
      tdi_buf[3]:=(ll shr 24) and $ff;
      jtag_write_and_read( SPE4.Value);
      outstate;
      write_tdo_to_T_JTM(SPE4.Value div 8);

end;


procedure TAVR.JTAG_Send_DRClick(Sender: TObject);
var
        ll:longword;
        co:integer;
begin
      val('$'+edit2.text,ll,co);
      if co>0 then ll:=0;
      edit2.text:=inttohex(ll,8);
      tdi_buf[0]:=ll and $ff;
      tdi_buf[1]:=(ll shr 8) and $ff;
      tdi_buf[2]:=(ll shr 16) and $ff;
      tdi_buf[3]:=(ll shr 24) and $ff;
      jtag_write_and_read( SPE1.Value);
      outstate;
      write_tdo_to_T_JTM(SPE1.Value div 8);
end;




procedure TAVR.Timer1Timer(Sender: TObject);
begin
     if time_tick=true then time_tick:=false
     else time_tick:=true;
     if P_SCK.checked then
     begin
         if p_sck.tag=0 then
         begin
             clr_sck;
             p_sck.tag:=1;
             P_sck.caption:='Pulse SCK (0)';
         end
         else
         begin
             set_sck;
             p_sck.tag:=0;
             P_sck.caption:='Pulse SCK (1)';
         end;
     end;
     if P_Mosi.checked then
     begin
         if p_Mosi.tag=0 then
         begin
             clr_Mosi;
             p_Mosi.tag:=1;
             P_MOSi.caption:='Pulse MOSI (0)';
         end
         else
         begin
             set_MOSI;
              p_Mosi.tag:=0;
             P_Mosi.caption:='Pulse MOSI (1)';
         end;
     end;
     if P_TCK.checked then
     begin
         if p_tck.tag=0 then
         begin
             JTAG_CLEAR_TCK;
             p_tck.tag:=1;
             P_tck.caption:='Pulse TCK (0)';
         end
         else
         begin
             JTAG_SET_TCK;
             p_tck.tag:=0;
             P_tck.caption:='Pulse TCK (1)';
         end;
     end;
     if P_TMS.checked then
     begin
         if p_TMS.tag=0 then
         begin
             JTAG_CLEAR_TMS;
             p_TMS.tag:=1;
             P_TMS.caption:='Pulse TMS (0)';
         end
         else
         begin
             JTAG_SET_TMS;
              p_TMS.tag:=0;
             P_TMS.caption:='Pulse TMS (1)';
         end;
     end;
     if P_TDI.checked then
     begin
         if p_TDI.tag=0 then
         begin
             JTAG_CLEAR_TDI;
             p_TDI.tag:=1;
             P_TDI.caption:='Pulse TDI (0)';
         end
         else
         begin
             JTAG_SET_TDI;
              p_TDI.tag:=0;
             P_TDI.caption:='Pulse TDI (1)';
         end;
     end;
     if R_TDO.Checked then
     begin
          if JTAG_IS_TDO_SET=1 then Edit4.text:='1'
          else
          Edit4.text:='0';
     end;
     if R_Mosi.Checked then
     begin
          if read_moso=1 then Edit1.text:='1'
          else
          Edit1.text:='0';
     end;
     if scan_on.checked then
     ScanClick(Sender);
end;

procedure TAVR.CPortDrvReceiveData(Sender: TObject; DataPtr: Pointer;
  DataSize: Integer);
var
        pbst,pb:pbyte;
        Ds:Integer;
        t:word;
        sz:string;

begin
     //here we receive comport signals from AVR studio
     pb:=Dataptr;
     pbst:=pb;
     Ds:=datasize;
     if T_raw.checked then
     begin
          sz:='Data Size='+inttohex(ds,2)+'=';
          for t:=1 to dataSize do
          begin
              sz:=sz+inttohex(pb^,2)+',';inc(pb);
          end;
          T_sig2.lines.add(sz);
     end;
     pb:=pbst;
     while DS>0 do
     begin
        inc(inp);
        va[inp]:=pb^;
        inc(le);
        if pb=pbst then
        if pb^=27 then
        begin
         m_ok:=true;
         inp:=1;
         Istr:='';
        end;
         Istr:=istr+inttohex(pb^,2)+',';
         case inp of
         1:begin
                 Istr:=inttohex(27,2)+',';
                 if pb^=27 then
                 if m_ok then
                 begin
                     le:=1;
                     STK_tok:=0;
                     J_tok:=0;
                     m_ok:=false;
                 end;
         end;
         2:begin J_seq:=pb^;STK_seq:=pb^; end;
         3:begin J_seq:=J_seq+ (pb^ shl 8);STK_len:=pb^ shl 8; end;
         4:begin J_Len:=pb^;STK_len:=STK_len+pb^; end;
         5:begin J_len:=J_len+(pb^ shl 8); if va[inp]=14 then STK_tok:=1 end;
         6:begin J_len:=J_len+(pb^ shl 16);STK_com:=pb^;end;
         7:begin J_len:=J_len+(pb^ shl 24);STK_st:=inp end;
         8:begin if va[inp]=14 then J_tok:=1;end;
         9:begin  J_com:=pb^ end;
         10:J_st:=inp;
         end;


          if P_type=STK then
          begin
              if le=STK_len+6 then
              begin
                  stk_crc:=0;
                  for t:=1 to le-1 do
                  begin
                       stk_crc:=stk_crc xor va[t];
                  end;
                  if T_S_record.checked then
                  begin
                       T_sig2.lines.add('------------------------------------------');
                       T_sig2.lines.add('INput='+Istr);
                  end;
                  if stk_crc=pb^ then Analyse_stk;
                  m_ok:=true;  //can start another message
                  inp:=0;
                  Istr:='';
              end;
          end
          else
          begin
              if le=J_len+9 then
              TJ_CRC:=pb^ ;
              if le=J_len+10 then
              begin
                  TJ_CRC:=TJ_CRC+(pb^ shl 8);
                  J_crc:=$ffff;
                  for t:=1 to le-2 do
                  begin
                       J_crc:=Hi(J_CRC) XOR CRCTable[ va[t] XOR Lo(J_crc) ];
                  end;
                  if T_S_record.checked then
                  begin
                       T_sig2.lines.add('------------------------------------------');
                       T_sig2.lines.add('INput='+Istr);
                  end;
                  if J_CRC=TJ_CRC then
                   Analyse_Jtag;
                   signals.m1.lines.add('Jtag Command responded to');
                  m_ok:=true;  //can start another message
                  inp:=0;
                  Istr:='';
              end;
          end;



         dec(ds);
         inc(pb);
     end;
end;

procedure TAVR.PC1Change(Sender: TObject);
begin
    if pc1.activepageindex=1 then
    signals.pc2.activepageindex:=0;
    if pc1.activepageindex=2 then
    begin
         signals.pc2.activepageindex:=1;
         if pgsize.text='' then pgsize.text:='0';
         if EPsize.text='' then EPsize.text:='0';
    end;

end;

procedure TAVR.B_WF_LClick(Sender: TObject);
var
        cx:integer;
begin
     if application.MessageBox('Do you really want to write Fuse & Lock Bits','Write bits',mb_yesno)=
     idyes then
     with SGF_l do
     begin
         val('$'+cells[1,3],clfuse,cx);
         if cx=0 then
         wr_lfuse_avr;
         val('$'+cells[1,2],chfuse,cx);
         if cx=0 then
         wr_hfuse_avr;
         val('$'+cells[1,1],cefuse,cx);
         if cx=0 then
         wr_efuse_avr;
         val('$'+cells[1,0],clbits,cx);
         if cx=0 then
         wr_lock_avr;
     end;
end;

procedure TAVR.Scan_onClick(Sender: TObject);
begin
     if Scan_on.checked then timer1.interval:=10
     else
     timer1.interval:=1000;
end;

procedure TAVR.ReadJTAGpins1Click(Sender: TObject);

begin
     with opd1 do
     begin
         filter:='Port data (*.txt)|*.TXT';
         if execute then
         begin
             if filename<>'' then
             begin
                 portfile:=filename;
                 Readportfile;

             end;
         end;
     end;
end;

end.
