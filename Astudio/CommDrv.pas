{
  CommDrv.pas

  COM Port Driver for Delphi 2.0

  © 1997 by Marco Cocco. All rights reserved.

  v1.00 - Feb 15th, 1997

  * This component built up on request of Mark Kuhnke.
}

unit CommDrv;

interface

uses
  Windows, Messages, SysUtils, Classes, Forms;

type
  // COM Port Baud Rates
  TComPortBaudRate = ( br110, br300, br600, br1200, br2400, br4800,
                       br9600, br14400, br19200, br38400, br56000,
                       br57600, br115200 );
  // COM Port Numbers
  TComPortNumber = ( pnCOM1, pnCOM2, pnCOM3, pnCOM4, pnCOM5, pnCOM6, pnCOM7, pnCOM8
                    ,pnCOM9, pnCOM10, pnCOM11, pnCOM12); 
  // COM Port Data bits
  TComPortDataBits = ( db5BITS, db6BITS, db7BITS, db8BITS );
  // COM Port Stop bits
  TComPortStopBits = ( sb1BITS, sb1HALFBITS, sb2BITS );
  // COM Port Parity
  TComPortParity = ( ptNONE, ptODD, ptEVEN, ptMARK, ptSPACE );
  // COM Port Hardware Handshaking
  TComPortHwHandshaking = ( hhNONE, hhRTSCTS );
  // COM Port Software Handshaing
  TComPortSwHandshaking = ( shNONE, shXONXOFF );

  TComPortReceiveDataEvent = procedure( Sender: TObject; DataPtr: pointer; DataSize: integer ) of object;

  TCommPortDriver = class(TComponent)
  protected
    FComPortHandle             : THANDLE; // COM Port Device Handle

    FComPort                   : TComPortNumber; // COM Port to use (1..4)
    FComPortBaudRate           : TComPortBaudRate; // COM Port speed (brXXXX)
    FComPortDataBits           : TComPortDataBits; // Data bits size (5..8)
    FComPortStopBits           : TComPortStopBits; // How many stop bits to use (1,1.5,2)
    FComPortParity             : TComPortParity; // Type of parity to use (none,odd,even,mark,space)
    FComPortHwHandshaking      : TComPortHwHandshaking; // Type of hw handshaking to use
    FComPortSwHandshaking      : TComPortSwHandshaking; // Type of sw handshaking to use
    FComPortInBufSize          : word; // Size of the input buffer
    FComPortOutBufSize         : word; // Size of the output buffer
    FComPortReceiveData        : TComPortReceiveDataEvent; // Event to raise on data reception
    FComPortPollingDelay       : word; // ms of delay between COM port pollings
    FNotifyWnd                 : HWND; // This is used for the timer
    FTempInBuffer              : pointer;

    procedure SetComPort( Value: TComPortNumber );
    procedure SetComPortBaudRate( Value: TComPortBaudRate );
    procedure SetComPortDataBits( Value: TComPortDataBits );
    procedure SetComPortStopBits( Value: TComPortStopBits );
    procedure SetComPortParity( Value: TComPortParity );
    procedure SetComPortHwHandshaking( Value: TComPortHwHandshaking );
    procedure SetComPortSwHandshaking( Value: TComPortSwHandshaking );
    procedure SetComPortInBufSize( Value: word );
    procedure SetComPortOutBufSize( Value: word );
    procedure SetComPortPollingDelay( Value: word );

    procedure ApplyCOMSettings;

    procedure TimerWndProc( var msg: TMessage );
  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;

    function Connect: boolean;
    procedure Disconnect;
    function Connected: boolean;

    function SendData( DataPtr: pointer; DataSize: integer ): boolean;
    function SendString( s: string ): boolean;
  published
    // Which COM Port to use
    property ComPort: TComPortNumber read FComPort write SetComPort default pnCOM2;
    // COM Port speed (bauds)
    property ComPortSpeed: TComPortBaudRate read FComPortBaudRate write SetComPortBaudRate default br9600;
    // Data bits to used (5..8, for the 8250 the use of 5 data bits with 2 stop bits is an invalid combination,
    // as is 6, 7, or 8 data bits with 1.5 stop bits)
    property ComPortDataBits: TComPortDataBits read FComPortDataBits write SetComPortDataBits default db8BITS;
    // Stop bits to use (1, 1.5, 2)
    property ComPortStopBits: TComPortStopBits read FComPortStopBits write SetComPortStopBits default sb1BITS;
    // Parity Type to use (none,odd,even,mark,space)
    property ComPortParity: TComPortParity read FComPortParity write SetComPortParity default ptNONE;
    // Hardware Handshaking Type to use:
    //  cdNONE          no handshaking
    //  cdCTSRTS        both cdCTS and cdRTS apply (** this is the more common method**)
    property ComPortHwHandshaking: TComPortHwHandshaking read FComPortHwHandshaking write SetComPortHwHandshaking default hhNONE;
    // Software Handshaking Type to use:
    //  cdNONE          no handshaking
    //  cdXONXOFF       XON/XOFF handshaking
    property ComPortSwHandshaking: TComPortSwHandshaking read FComPortSwHandshaking write SetComPortSwHandshaking default shNONE;
    // Input Buffer size
    property ComPortInBufSize: word read FComPortInBufSize write SetComPortInBufSize default 2048;
    // Output Buffer size
    property ComPortOutBufSize: word read FComPortOutBufSize write SetComPortOutBufSize default 2048;
    // ms of delay between COM port pollings
    property ComPortPollingDelay: word read FComPortPollingDelay write SetComPortPollingDelay default 100;
    // Event to raise when there is data available (input buffer has data)
    property OnReceiveData: TComPortReceiveDataEvent read FComPortReceiveData write FComPortReceiveData;
  end;

procedure Register;

implementation
{$WARN SYMBOL_DEPRECATED OFF}

constructor TCommPortDriver.Create( AOwner: TComponent );
begin
  inherited Create( AOwner );
  // Initialize to default values
  FComPortHandle             := 0;       // Not connected
  FComPort                   := pnCOM2;  // COM 2
  FComPortBaudRate           := br9600;  // 9600 bauds
  FComPortDataBits           := db8BITS; // 8 data bits
  FComPortStopBits           := sb1BITS; // 1 stop bit
  FComPortParity             := ptNONE;  // no parity
  FComPortHwHandshaking      := hhNONE;  // no hardware handshaking
  FComPortSwHandshaking      := shNONE;  // no software handshaking
  FComPortInBufSize          := 2048;    // input buffer of 512 bytes
  FComPortOutBufSize         := 2048;    // output buffer of 512 bytes
  FComPortReceiveData        := nil;     // no data handler
  GetMem( FTempInBuffer, FComPortInBufSize ); // Temporary buffer for received data
  // Allocate a window handle to catch timer's notification messages
  if not (csDesigning in ComponentState) then
    FNotifyWnd := AllocateHWnd( TimerWndProc );
end;

destructor TCommPortDriver.Destroy;
begin
  // Be sure to release the COM device
  Disconnect;
  // Free the temporary buffer
  FreeMem( FTempInBuffer, FComPortInBufSize );
  // Destroy the timer's window
  DeallocateHWnd( FNotifyWnd );
  inherited Destroy;
end;

procedure TCommPortDriver.SetComPort( Value: TComPortNumber );
begin
  // Be sure we are not using any COM port
  if Connected then
    exit;
  // Change COM port
  FComPort := Value;
end;

procedure TCommPortDriver.SetComPortBaudRate( Value: TComPortBaudRate );
begin
  // Set new COM speed
  FComPortBaudRate := Value;
  // Apply changes
  if Connected then
    ApplyCOMSettings;
end;

procedure TCommPortDriver.SetComPortDataBits( Value: TComPortDataBits );
begin
  // Set new data bits
  FComPortDataBits := Value;
  // Apply changes
  if Connected then
    ApplyCOMSettings;
end;

procedure TCommPortDriver.SetComPortStopBits( Value: TComPortStopBits );
begin
  // Set new stop bits
  FComPortStopBits := Value;
  // Apply changes
  if Connected then
    ApplyCOMSettings;
end;

procedure TCommPortDriver.SetComPortParity( Value: TComPortParity );
begin
  // Set new parity
  FComPortParity := Value;
  // Apply changes
  if Connected then
    ApplyCOMSettings;
end;

procedure TCommPortDriver.SetComPortHwHandshaking( Value: TComPortHwHandshaking );
begin
  // Set new hardware handshaking
  FComPortHwHandshaking := Value;
  // Apply changes
  if Connected then
    ApplyCOMSettings;
end;

procedure TCommPortDriver.SetComPortSwHandshaking( Value: TComPortSwHandshaking );
begin
  // Set new software handshaking
  FComPortSwHandshaking := Value;
  // Apply changes
  if Connected then
    ApplyCOMSettings;
end;

procedure TCommPortDriver.SetComPortInBufSize( Value: word );
begin
  // Free the temporary input buffer
  FreeMem( FTempInBuffer, FComPortInBufSize );
  // Set new input buffer size
  FComPortInBufSize := Value;
  // Allocate the temporary input buffer
  GetMem( FTempInBuffer, FComPortInBufSize );
  // Apply changes
  if Connected then
    ApplyCOMSettings;
end;

procedure TCommPortDriver.SetComPortOutBufSize( Value: word );
begin
  // Set new output buffer size
  FComPortOutBufSize := Value;
  // Apply changes
  if Connected then
    ApplyCOMSettings;
end;

procedure TCommPortDriver.SetComPortPollingDelay( Value: word );
begin
  // If new delay is not equal to previous value...
  if Value <> FComPortPollingDelay then
  begin
    // Stop the timer
    if Connected then
      KillTimer( FNotifyWnd, 1 );
    // Store new delay value
    FComPortPollingDelay := Value;
    // Restart the timer
    if Connected then
      SetTimer( FNotifyWnd, 1, FComPortPollingDelay, nil );
  end;
end;

const
  Win32BaudRates: array[br110..br115200] of DWORD =
    ( CBR_110, CBR_300, CBR_600, CBR_1200, CBR_2400, CBR_4800, CBR_9600,
      CBR_14400, CBR_19200, CBR_38400, CBR_56000, CBR_57600, CBR_115200 );

const
  dcb_Binary              = $00000001;
  dcb_ParityCheck         = $00000002;
  dcb_OutxCtsFlow         = $00000004;
  dcb_OutxDsrFlow         = $00000008;
  dcb_DtrControlMask      = $00000030;
    dcb_DtrControlDisable   = $00000000;
    dcb_DtrControlEnable    = $00000010;
    dcb_DtrControlHandshake = $00000020;
  dcb_DsrSensivity        = $00000040;
  dcb_TXContinueOnXoff    = $00000080;
  dcb_OutX                = $00000100;
  dcb_InX                 = $00000200;
  dcb_ErrorChar           = $00000400;
  dcb_NullStrip           = $00000800;
  dcb_RtsControlMask      = $00003000;
    dcb_RtsControlDisable   = $00000000;
    dcb_RtsControlEnable    = $00001000;
    dcb_RtsControlHandshake = $00002000;
    dcb_RtsControlToggle    = $00003000;
  dcb_AbortOnError        = $00004000;
  dcb_Reserveds           = $FFFF8000;

// Apply COM settings.
procedure TCommPortDriver.ApplyCOMSettings;
var dcb: TDCB;
begin
  // Do nothing if not connected
  if not Connected then
    exit;

  // Clear all
  fillchar( dcb, sizeof(dcb), 0 );
  // Setup dcb (Device Control Block) fields
  dcb.DCBLength := sizeof(dcb); // dcb structure size
  dcb.BaudRate := Win32BaudRates[ FComPortBaudRate ]; // baud rate to use
  dcb.Flags := dcb_Binary or // Set fBinary: Win32 does not support non binary mode transfers
                             // (also disable EOF check)
               dcb_DtrControlEnable; // Enables the DTR line when the device is opened and leaves it on

  case FComPortHwHandshaking of // Type of hw handshaking to use
    hhNONE:; // No hardware handshaking
    hhRTSCTS: // RTS/CTS (request-to-send/clear-to-send) hardware handshaking
      dcb.Flags := dcb.Flags or dcb_OutxCtsFlow or dcb_RtsControlHandshake;
  end;
  case FComPortSwHandshaking of // Type of sw handshaking to use
    shNONE:; // No software handshaking
    shXONXOFF: // XON/XOFF handshaking
      dcb.Flags := dcb.Flags or dcb_OutX or dcb_InX;
  end;
  dcb.XONLim := FComPortInBufSize div 4; // Specifies the minimum number of bytes allowed
                                         // in the input buffer before the XON character is sent
  dcb.XOFFLim := 1; // Specifies the maximum number of bytes allowed in the input buffer
                    // before the XOFF character is sent. The maximum number of bytes
                    // allowed is calculated by subtracting this value from the size,
                    // in bytes, of the input buffer
  dcb.ByteSize := 5 + ord(FComPortDataBits); // how many data bits to use
  dcb.Parity := ord(FComPortParity); // type of parity to use
  dcb.StopBits := ord(FComPortStopbits); // how many stop bits to use
  dcb.XONChar := #17; // XON ASCII char
  dcb.XOFFChar := #19; // XOFF ASCII char
  SetCommState( FComPortHandle, dcb );
  // Setup buffers size
  SetupComm( FComPortHandle, FComPortInBufSize, FComPortOutBufSize );
end;

function TCommPortDriver.Connect: boolean;
var comName: array[0..4] of char;
    tms: TCOMMTIMEOUTS;
begin
  // Do nothing if already connected
  Result := Connected;
  if Result then
    exit;
  // Open the COM port
  StrPCopy( comName, 'COM' );
  comName[3] := chr( ord('1') + ord(FComPort) );
  comName[4] := #0;
  FComPortHandle := CreateFile(
                                comName,
                                GENERIC_READ or GENERIC_WRITE,
                                0, // Not shared
                                nil, // No security attributes
                                OPEN_EXISTING,
                                FILE_ATTRIBUTE_NORMAL,
                                0 // No template
                              ) ;
  Result := Connected;
  if not Result then
    exit;
  // Apply settings
  ApplyCOMSettings;
  // Setup timeouts: we disable timeouts because we are polling the com port!
  tms.ReadIntervalTimeout := 1; // Specifies the maximum time, in milliseconds,
                                // allowed to elapse between the arrival of two
                                // characters on the communications line
  tms.ReadTotalTimeoutMultiplier := 0; // Specifies the multiplier, in milliseconds,
                                       // used to calculate the total time-out period
                                       // for read operations.
  tms.ReadTotalTimeoutConstant := 1; // Specifies the constant, in milliseconds,
                                     // used to calculate the total time-out period
                                     // for read operations.
  tms.WriteTotalTimeoutMultiplier := 0; // Specifies the multiplier, in milliseconds,
                                        // used to calculate the total time-out period
                                        // for write operations.
  tms.WriteTotalTimeoutConstant := 0; // Specifies the constant, in milliseconds,
                                      // used to calculate the total time-out period
                                      // for write operations.
  SetCommTimeOuts( FComPortHandle, tms );
  // Start the timer (used for polling)
  SetTimer( FNotifyWnd, 1, FComPortPollingDelay, nil );
end;

procedure TCommPortDriver.Disconnect;
begin
  if Connected then
  begin
    CloseHandle( FComPortHandle );
    FComPortHandle := 0;
    // Stop the timer (used for polling)
    KillTimer( FNotifyWnd, 1 );
  end;
end;

function TCommPortDriver.Connected: boolean;
begin
  Result := FComPortHandle > 0;
end;

function TCommPortDriver.SendData( DataPtr: pointer; DataSize: integer ): boolean;
var
   nsent:DWORD;
begin
  Result := WriteFile( FComPortHandle, DataPtr^, DataSize, nsent, nil );
  Result := Result and (nsent=Dword(DataSize));
end;

function TCommPortDriver.SendString( s: string ): boolean;
begin
  Result := SendData( pchar(s), length(s) );
end;

procedure TCommPortDriver.TimerWndProc( var msg: TMessage );
var nRead: dword;
begin
  if (msg.Msg = WM_TIMER) and Connected then
  begin
    nRead := 0;
    if ReadFile( FComPortHandle, FTempInBuffer^, FComPortInBufSize, nRead, nil ) then
      if (nRead <> 0) and Assigned(FComPortReceiveData) then
        FComPortReceiveData( Self, FTempInBuffer, nRead );
  end;
end;

procedure Register;
begin
  RegisterComponents('System', [TCommPortDriver]);
end;

end.
