unit Comport;

interface
uses
        Vars_const,Commdrv,Stdctrls,Extctrls;


Procedure SetupComport(Controller:string);

implementation
Procedure SetupComport(controller:string);
begin
     T_com_status.text:=Controller;
     T_CportDrv.Disconnect;
     T_Talk.Text:='Serial Disconected';
     case T_comport.itemindex of
     0:T_CportDrv.ComPort:= pnCOM1;
     1:T_CportDrv.ComPort:= pnCOM2;
     2:T_CportDrv.ComPort:= pnCOM3;
     3:T_CportDrv.ComPort:= pnCOM4;
     4:T_CportDrv.ComPort:= pnCOM5;
     5:T_CportDrv.ComPort:= pnCOM6;
     6:T_CportDrv.ComPort:= pnCOM7;
     7:T_CportDrv.ComPort:= pnCOM8;
     8:T_CportDrv.ComPort:= pnCOM9;
     9:T_CportDrv.ComPort:= pnCOM10;
     10:T_CportDrv.ComPort:= pnCOM11;
     11:T_CportDrv.ComPort:= pnCOM12;

     else
     T_CportDrv.ComPort:=pnCom1;
     end;
     case T_Baud.itemindex of
     0:T_CportDrv.ComportSpeed:=br9600;
     1:T_CportDrv.ComportSpeed:=br14400 ;
     2:T_CportDrv.ComportSpeed:=br19200;
     3:T_CportDrv.ComportSpeed:=br38400;
     4:T_CportDrv.ComportSpeed:=br57600;
     5:T_CportDrv.ComportSpeed:=br115200;
     else
     T_CportDrv.ComportSpeed:=br19200;
     end;
     case T_data_bits.itemindex of
     0:T_CportDrv.ComPortDataBits:= db6BITS;
     1:T_CportDrv.ComPortDataBits:= db7BITS;
     2:T_CportDrv.ComPortDataBits:= db8BITS;
     else
     T_CportDrv.ComPortDataBits:=db8BITS;
     end;
     case T_stop_bits.itemindex of
     0:T_CportDrv.ComPortStopBits:= sb1BITS;
     1:T_CportDrv.ComPortStopBits:= sb1BITS;
     2:T_CportDrv.ComPortStopBits:= sb1HALFBITS;
     3:T_CportDrv.ComPortStopBits:=sb2BITS;
     else
     T_CportDrv.ComPortStopBits:=sb1BITS;
     end;
     case T_parity.itemindex of
     0:T_CportDrv.ComPortParity:= ptNONE;
     1:T_CportDrv.ComPortParity:= ptODD;
     2:T_CportDrv.ComPortParity:=ptEVEN;
     else
     T_CportDrv.ComPortParity:=ptNone;
     end;
     T_CportDrv.Connect;
     if not T_CportDrv.Connected then
     T_Talk.Text:='Serial Disconected'
     else
     T_Talk.Text:='Serial Connected';

     

end;

end.
