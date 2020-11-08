unit SignalU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls,

  vars_const;


type
  TSignals = class(TForm)
    PC2: TPageControl;
    ts1: TTabSheet;
    ts2: TTabSheet;
    Button1: TButton;
    M1: TMemo;
    Raw: TCheckBox;
    S_record: TCheckBox;
    Button2: TButton;
    Show_TDI: TCheckBox;
    Show_TDO: TCheckBox;
    Show_states: TCheckBox;
    JTM: TMemo;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure RawClick(Sender: TObject);
    procedure S_recordClick(Sender: TObject);
    procedure Show_TDIClick(Sender: TObject);
    procedure Show_TDOClick(Sender: TObject);
    procedure Show_statesClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Signals: TSignals;

implementation

{$R *.dfm}

procedure TSignals.FormShow(Sender: TObject);
begin
     top:=0;
     left:=screen.WorkAreaWidth-width;
     T_Show_signals.checked:=true;
     pc2.ActivePageIndex:=0;
     Tshow_states:=Show_States;
end;

procedure TSignals.FormClose(Sender: TObject; var Action: TCloseAction);
begin
     T_Show_signals.checked:=false;
end;

procedure TSignals.FormResize(Sender: TObject);
var
        wx,wh:word;
begin
     wx:=signals.ClientWidth;
     wh:=signals.clientheight;
     with  Pc2 do
     begin
         width:=wx-(left);
         height:=wh-(top);
     end;
     with m1 do
     begin
          width:=ts1.Width-left;
          height:=ts1.Height-top;
     end;
     with JTM do
     begin
          width:=ts1.Width-left;
          height:=ts1.Height-top;
     end;
end;

procedure TSignals.FormCreate(Sender: TObject);
begin
    T_m1:=m1;
    T_Sig2:=m1;
    T_S_Record:=S_record;
    T_Raw:=Raw;
    T_JTM:=JTM;
    TShow_TDO:=Show_TDO;
    TShow_TDI:=Show_TDI;
    Tshow_states:=Show_states;
    pc2.ActivePageIndex:=0;

end;

procedure TSignals.Button2Click(Sender: TObject);
begin
    Jtm.clear;
end;

procedure TSignals.Button1Click(Sender: TObject);
begin
     M1.clear;
end;

procedure TSignals.RawClick(Sender: TObject);
begin
    if raw.Checked then
    raw.Caption:='Raw Input on'
    else
    raw.Caption:='Raw Input off';

end;

procedure TSignals.S_recordClick(Sender: TObject);
begin
    if S_record.Checked then
    S_record.Caption:='Recording on'
    else
    S_record.Caption:='Recording off';

end;

procedure TSignals.Show_TDIClick(Sender: TObject);
begin
    if Show_TDI.Checked then
    Show_TDI.Caption:='TDI out on'
    else
    Show_TDI.Caption:='TDI out off';
end;

procedure TSignals.Show_TDOClick(Sender: TObject);
begin
    if Show_TDO.Checked then
    Show_TDO.Caption:='TDO out on'
    else
    Show_TDO.Caption:='TDO out off';
end;

procedure TSignals.Show_statesClick(Sender: TObject);
begin
    if Show_states.Checked then
    Show_states.Caption:='states show on'
    else
    Show_states.Caption:='States show off';
end;

end.
