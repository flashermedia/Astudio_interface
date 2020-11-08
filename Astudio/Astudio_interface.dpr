program Astudio_interface;

uses
  Forms,
  Main in 'Main.pas' {AVR},
  zlportio in 'zlportio.pas',
  Comport in 'Comport.pas',
  ddkint in 'ddkint.pas',
  ISP_Communication in 'ISP_Communication.pas',
  Vars_Const in 'Vars_Const.pas',
  SignalU in 'SignalU.pas' {Signals},
  Init in 'Init.pas',
  Jtag_Signals in 'JTAG_signals.pas',
  JTAG_AVR in 'JTAG_AVR.pas',
  JTAG_AVR_TAP in 'JTAG_AVR_TAP.pas',
  STK500 in 'STK500.pas',
  AVRRisc in 'AVRRisc.pas',
  JTAG_Command_handling in 'JTAG_Command_handling.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Astudio Interface';
  Application.CreateForm(TAVR, AVR);
  Application.CreateForm(TSignals, Signals);
  Application.Run;
end.
