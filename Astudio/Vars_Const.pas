unit Vars_Const;

interface
uses
        Commdrv,forms,Grids,stdctrls,extctrls,menus,comctrls;
type
        MRecord=Record
        Micro:string;
        Code:string;
        Page_size:word;
        PS:longword;
        ES:word;
        EP_Pge_size:word;
        LB:String;
        Fb3:string;
        Fb2:string;
        Fb1:string;
        end;

const
   bmicro:mrecord=
        (Micro:'';
        Code:'-------';
        Page_size:0;
        PS:0;
        ES:0;
        EP_Pge_size:0;
        LB:'-,-,-,-,-,-,-,-';
        Fb3:'-,-,-,-,-,-,-,-';
        Fb2:'-,-,-,-,-,-,-,-';
        Fb1:'-,-,-,-,-,-,-,-'; );
  //******16 bit CRC table from ATMEL JTAG Signal description
  CRCtable: ARRAY[0..255] OF WORD =
      ($0000, $1189, $2312, $329b, $4624, $57ad, $6536, $74bf,
      $8c48, $9dc1, $af5a, $bed3, $ca6c, $dbe5, $e97e, $f8f7,
      $1081, $0108, $3393, $221a, $56a5, $472c, $75b7, $643e,
      $9cc9, $8d40, $bfdb, $ae52, $daed, $cb64, $f9ff, $e876,
      $2102, $308b, $0210, $1399, $6726, $76af, $4434, $55bd,
      $ad4a, $bcc3, $8e58, $9fd1, $eb6e, $fae7, $c87c, $d9f5,
      $3183, $200a, $1291, $0318, $77a7, $662e, $54b5, $453c,
      $bdcb, $ac42, $9ed9, $8f50, $fbef, $ea66, $d8fd, $c974,
      $4204, $538d, $6116, $709f, $0420, $15a9, $2732, $36bb,
      $ce4c, $dfc5, $ed5e, $fcd7, $8868, $99e1, $ab7a, $baf3,
      $5285, $430c, $7197, $601e, $14a1, $0528, $37b3, $263a,
      $decd, $cf44, $fddf, $ec56, $98e9, $8960, $bbfb, $aa72,
      $6306, $728f, $4014, $519d, $2522, $34ab, $0630, $17b9,
      $ef4e, $fec7, $cc5c, $ddd5, $a96a, $b8e3, $8a78, $9bf1,
      $7387, $620e, $5095, $411c, $35a3, $242a, $16b1, $0738,
      $ffcf, $ee46, $dcdd, $cd54, $b9eb, $a862, $9af9, $8b70,
      $8408, $9581, $a71a, $b693, $c22c, $d3a5, $e13e, $f0b7,
      $0840, $19c9, $2b52, $3adb, $4e64, $5fed, $6d76, $7cff,
      $9489, $8500, $b79b, $a612, $d2ad, $c324, $f1bf, $e036,
      $18c1, $0948, $3bd3, $2a5a, $5ee5, $4f6c, $7df7, $6c7e,
      $a50a, $b483, $8618, $9791, $e32e, $f2a7, $c03c, $d1b5,
      $2942, $38cb, $0a50, $1bd9, $6f66, $7eef, $4c74, $5dfd,
      $b58b, $a402, $9699, $8710, $f3af, $e226, $d0bd, $c134,
      $39c3, $284a, $1ad1, $0b58, $7fe7, $6e6e, $5cf5, $4d7c,
      $c60c, $d785, $e51e, $f497, $8028, $91a1, $a33a, $b2b3,
      $4a44, $5bcd, $6956, $78df, $0c60, $1de9, $2f72, $3efb,
      $d68d, $c704, $f59f, $e416, $90a9, $8120, $b3bb, $a232,
      $5ac5, $4b4c, $79d7, $685e, $1ce1, $0d68, $3ff3, $2e7a,
      $e70e, $f687, $c41c, $d595, $a12a, $b0a3, $8238, $93b1,
      $6b46, $7acf, $4854, $59dd, $2d62, $3ceb, $0e70, $1ff9,
      $f78f, $e606, $d49d, $c514, $b1ab, $a022, $92b9, $8330,
      $7bc7, $6a4e, $58d5, $495c, $3de3, $2c6a, $1ef1, $0f78);
      stk=1;
      J_TAG=2;

      //*********** STK500
// *****************[ STK general command constants ]**************************

                  STK_CMD_SIGN_ON              =$01  ;
                  STK_CMD_SET_PARAMETER        =$02  ;
                  STK_CMD_GET_PARAMETER        =$03  ;
                  STK_CMD_SET_DEVICE_PARAMETERS=$04  ;
                  STK_CMD_OSCCAL               =$05  ;
                  STK_CMD_LOAD_ADDRESS         =$06  ;
                  STK_CMD_FIRMWARE_UPGRADE     =$07  ;


// *****************[ STK ISP command constants ]******************************

                  STK_CMD_ENTER_PROGMODE_ISP   =$10   ;
                  STK_CMD_LEAVE_PROGMODE_ISP   =$11   ;
                  STK_CMD_CHIP_ERASE_ISP       =$12   ;
                  STK_CMD_PROGRAM_FLASH_ISP    =$13   ;
                  STK_CMD_READ_FLASH_ISP       =$14   ;
                  STK_CMD_PROGRAM_EEPROM_ISP   =$15   ;
                  STK_CMD_READ_EEPROM_ISP      =$16   ;
                  STK_CMD_PROGRAM_FUSE_ISP     =$17   ;
                  STK_CMD_READ_FUSE_ISP        =$18   ;
                  STK_CMD_PROGRAM_LOCK_ISP     =$19   ;
                  STK_CMD_READ_LOCK_ISP        =$1A   ;
                  STK_CMD_READ_SIGNATURE_ISP   =$1B   ;
                  STK_CMD_READ_OSCCAL_ISP      =$1C   ;
                  STK_CMD_SPI_MULTI            =$1D   ;

// *****************[ STK PP command constants ]*******************************

                  STK_CMD_ENTER_PROGMODE_PP    =$20   ;
                  STK_CMD_LEAVE_PROGMODE_PP    =$21   ;
                  STK_CMD_CHIP_ERASE_PP        =$22   ;
                  STK_CMD_PROGRAM_FLASH_PP     =$23   ;
                  STK_CMD_READ_FLASH_PP        =$24   ;
                  STK_CMD_PROGRAM_EEPROM_PP    =$25   ;
                  STK_CMD_READ_EEPROM_PP       =$26   ;
                  STK_CMD_PROGRAM_FUSE_PP      =$27   ;
                  STK_CMD_READ_FUSE_PP         =$28   ;
                  STK_CMD_PROGRAM_LOCK_PP      =$29   ;
                  STK_CMD_READ_LOCK_PP         =$2A   ;
                  STK_CMD_READ_SIGNATURE_PP    =$2B   ;
                  STK_CMD_READ_OSCCAL_PP       =$2C   ;

                  STK_CMD_SET_CONTROL_STACK    =$2D   ;

// *****************[ STK HVSP command constants ]*****************************

                  STK_CMD_ENTER_PROGMODE_HVSP  =$30    ;
                  STK_CMD_LEAVE_PROGMODE_HVSP  =$31    ;
                  STK_CMD_CHIP_ERASE_HVSP      =$32    ;
                  STK_CMD_PROGRAM_FLASH_HVSP   =$33    ;
                  STK_CMD_READ_FLASH_HVSP      =$34    ;
                  STK_CMD_PROGRAM_EEPROM_HVSP  =$35    ;
                  STK_CMD_READ_EEPROM_HVSP     =$36    ;
                  STK_CMD_PROGRAM_FUSE_HVSP    =$37    ;
                  STK_CMD_READ_FUSE_HVSP       =$38    ;
                  STK_CMD_PROGRAM_LOCK_HVSP    =$39    ;
                  STK_CMD_READ_LOCK_HVSP       =$3A    ;
                  STK_CMD_READ_SIGNATURE_HVSP  =$3B    ;
                  STK_CMD_READ_OSCCAL_HVSP     =$3C    ;


                  PARAM_BUILD_NUMBER_LOW   =$80;
                  PARAM_BUILD_NUMBER_HIGH  =$81;
                  PARAM_HW_VER             =$90;
                  PARAM_SW_MAJOR           =$91;
                  PARAM_SW_MINOR           =$92;
                  PARAM_VTARGET            =$94;
                  PARAM_VADJUST            =$95;
                  PARAM_OSC_PSCALE         =$96;
                  PARAM_OSC_CMATCH         =$97;
                  PARAM_SCK_DURATION       =$98;
                  PARAM_TOPCARD_DETECT     =$9A;
                  PARAM_STATUS             =$9C;
                  PARAM_DATA               =$9D;
                  PARAM_RESET_POLARITY     =$9E;
                  PARAM_CONTROLLER_INIT    =$9F;

      
        //****** AVR RISC
       CMD_SIGN_ON = $01 ;
       CMD_SET_PARAMETER = $02 ;
       CMD_GET_PARAMETER = $03 ;
       CMD_OSCCAL = $05        ;
       CMD_LOAD_ADDRESS = $06  ;
       CMD_FIRMWARE_UPGRADE = $07;
       CMD_RESET_PROTECTION = $0A;
      // *** [ ISP command constants ] ***
       CMD_ENTER_PROGMODE_ISP = $10;
       CMD_LEAVE_PROGMODE_ISP = $11;
       CMD_CHIP_ERASE_ISP = $12    ;
       CMD_PROGRAM_FLASH_ISP = $13 ;
       CMD_READ_FLASH_ISP = $14    ;
       CMD_PROGRAM_EEPROM_ISP = $15;
       CMD_READ_EEPROM_ISP = $16   ;
       CMD_PROGRAM_FUSE_ISP = $17  ;
       CMD_READ_FUSE_ISP = $18     ;
       CMD_PROGRAM_LOCK_ISP = $19  ;
       CMD_READ_LOCK_ISP = $1A     ;
       CMD_READ_SIGNATURE_ISP = $1B;
       CMD_READ_OSCCAL_ISP = $1C   ;
       CMD_SPI_MULTI = $1D         ;
      // *** [ Status constants ] ***
      // Success
        STATUS_CMD_OK = $00     ;

        //***** JTAG AVR
           EXTEST                     =     0   ;
           AVR_IDCODE                 =     1   ;
           AVR_PRG_ENABLE             =     4   ;
           AVR_PRG_CMDS               =     5   ;
           AVR_PRG_PAGE_LOAD          =     6   ;
           AVR_PRG_PAGE_READ          =     7   ;
           AVR_FORCE_BRK              =     8   ;
           AVR_RUN                    =     9   ;
           AVR_INSTR                  =     10  ;
           AVR_OCD                    =     11  ;
           AVR_RESET                  =     12  ;
           BYPASS                     =     15  ;

           //**JTAG_SIGNALS

	SELECT_DR_SCAN=0 ;
	CAPTURE_DR=1 ;
	SHIFT_DR=2 ;
	EXIT1_DR=3 ;
	PAUSE_DR=4 ;
	EXIT2_DR=5 ;
	UPDATE_DR=6 ;
	TEST_LOGIC_RESET=7 ;
	RUN_TEST_IDLE=8 ;
	SELECT_IR_SCAN=9 ;
	CAPTURE_IR=10;
	SHIFT_IR=11;
	EXIT1_IR=12;
	PAUSE_IR=13;
	EXIT2_IR=14;
	UPDATE_IR=15;

        states:array[0..15] of string=(
	'SELECT_DR_SCAN',       //0 ;
	'CAPTURE_DR',       //1 ;
	'SHIFT_DR',       //2 ;
	'EXIT1_DR',       //3 ;
	'PAUSE_DR',       //4 ;
	'EXIT2_DR',       //5 ;
	'UPDATE_DR',       //6 ;
	'TEST_LOGIC_RESET',       //7 ;
	'RUN_TEST_IDLE',       //8 ;
	'SELECT_IR_SCAN',       //9 ;
	'CAPTURE_IR',       //10;
	'SHIFT_IR',       //11;
	'EXIT1_IR',       //12;
	'PAUSE_IR',       //13;
	'EXIT2_IR',       //14;
	'UPDATE_IR' );      //15;);
        //******* JTAG Command Handling

      CMND_SIGN_OFF=                    $00;  // Sign off
      CMND_GET_SIGN_ON=                 $01;  // Check if Emulator is present
      CMND_SET_PARAMETER=               $02;  // Write Emulator Parameter
      CMND_GET_PARAMETER=               $03;  // Read Emulator Parameter
      CMND_WRITE_MEMORY=                $04;  // Write Memory
      CMND_READ_MEMORY=                 $05;  // Read Memory
      CMND_WRITE_PC=                    $06;  // Write Program Counter
      CMND_READ_PC=                     $07;  // Read Program Counter
      CMND_GO=                          $08;  // Start Program Execution
      CMND_SINGLE_STEP=                 $09;  // Single Step
      CMND_FORCED_STOP=                 $0A;  // Stop Program Execution
      CMND_RESET=                       $0B;  // Reset User Program
      CMND_SET_DEVICE_DESCRIPTOR=       $0C;  // Set Device Descriptor
      CMND_ERASEPAGE_SPM=               $0D;  // Erase Page SPM
      CMND_MISSING_0E=                  $0E;   // No such Command Reserved
      CMND_GET_SYNC=                    $0F;  // Get Sync
      CMND_SELFTEST=                    $10;  // Self test
      CMND_SET_BREAK=                   $11;  // Set Breakpoint
      CMND_GET_BREAK=                   $12;  // Get Breakpoint
      CMND_CHIP_ERASE=                  $13;  // Chip erase
      CMND_ENTER_PROGMODE=              $14;  // Enter programming mode
      CMND_LEAVE_PROGMODE=              $15;  // Leave programming mode
      CMND_SET_N_PARAMETERS=            $16;  // Write Emulator Parameters
      CMND_MISSING_17=                  $17;   // No such Command Reserved
      CMND_MISSING_18=                  $18;   // No such Command Reserved
      CMND_MISSING_19=                  $19;   // No such Command Reserved
      CMND_CLR_BREAK=                   $1A;  // Clear Breakpoint
      CMND_MISSING_1B=                  $1B;   // No such Command Reserved
      CMND_RUN_TO_ADDR=                 $1C;  // Run to Address
      CMND_SPI_CMD=                     $1D;  // Universal SPI command
      CMND_MISSING_1E=                  $1E;   // No such Command Reserved
      CMND_MISSING_1F=                  $1F;   // No such Command Reserved
      CMND_MISSING_20=                  $20;   // No such Command Reserved
      CMND_MISSING_21=                  $21;   // No such Command Reserved
      CMND_CLEAR_EVENTS=                $22;  // Clear event memory
      CMND_RESTORE_TARGET=              $23;  // Restore Target
      CMND_MISSING_24=                  $24;   // No such Command Reserved
      CMND_MISSING_25=                  $25;   // No such Command Reserved
      CMND_MISSING_26=                  $26;   // No such Command Reserved
      CMND_MISSING_27=                  $27;   // No such Command Reserved
      CMND_MISSING_28=                  $28;   // No such Command Reserved
      CMND_MISSING_29=                  $29;   // No such Command Reserved
      CMND_MISSING_2A=                  $2A;   // No such Command Reserved
      CMND_MISSING_2B=                  $2B;   // No such Command Reserved
      CMND_MISSING_2C=                  $2C;   // No such Command Reserved
      CMND_MISSING_2D=                  $2D;   // No such Command Reserved
      CMND_MISSING_2E=                  $2E;   // No such Command Reserved
      CMND_ISP_PACKET=                  $2F;  //Encapsulated ISP command
     max_params=$45;
     Param_strs:array[1..max_params] of string=
      ('HardwareVersion',
      'FWversion',
      'EmulatorMODE',
      'Ireg',
      'Baudrate',
      'OCDVtarget',
      'OCDJTAGClock',
      'OCDBreakCause',
      'TimersRunning',
      'BreakonChangeofFlow',
      'BreakAddr1',
      'BreakAddr2',
      'CombBreakCtrl',
      'JTAG_string',
      'UnitsBefore',

      'UnitsAfter',         //$10
      'BitBefore',
      'BitAfter',
      'ExternalReset',
      'FlashPageSize',
      'EEPROMPageSize',
      'Not Allocated',
      'PSB0',
      'PSB1',
      'ProtocolDebugEvent',
      'TargetMCUSTATE',
      'Daisychaininfo',
      'Bootaddress',
      'TargetSignature',
      'DebugWirebaudrate',
      'Programentrypoint',

      'Not Allocated',    // 20
      'Not Allocated',
      'CAN_FLAG',
      'PAR_ENABLE_IDR_IN_RUN_MODE',
      'PAR_ALLOW_PAGEPROGRAMMING_IN_SCANCHAIN',
      'COMM_ID',         //25
      'Not Allocated',
      'Not Allocated',
      'Not Allocated',
      'Not Allocated',
      'Not Allocated',
      'Not Allocated',
      'Not Allocated',
      'Not Allocated',
      'Not Allocated',
      'Not Allocated',

      'Not Allocated',
      'Not Allocated',
      'Not Allocated',
      'Not Allocated',
      'Not Allocated',
      'Not Allocated',
      'Not Allocated',
      'Not Allocated',
      'Not Allocated',
      'Not Allocated',
      'Not Allocated',
      'Not Allocated',
      'Not Allocated',
      'Not Allocated',
      'Not Allocated',
      'Not Allocated',

      'Packetparsingerrors',
      'Validpacketsreceived',
      'IntercommunicationTXfailures',
      'IntercommunicationRXfailures',
      'CRCerrors',
      'Powersource');
       Sign_on_serial:array[1..6] of byte=($31,$32,$33,$34,$35,$36);
       DEVICE_ID_STR:array[1..11] of char=('A','X','R','I','S','P','_','M','K','2',#0 );

        ptable:array[1..$45] of word= //array of the parameters
        //gives the number of bytes for each param
        (2,4,1,2,1,2,1,1,1,1,2,2,1,4,1,1  //01
        ,1,1,1,2,1,1,2,2,1,1,4,4,3,4,4,1  //11
        ,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1  //21
        ,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,4  //31
        ,4,4,4,4,4); //=110               //41
        maxparams=130;
        //********** STK500
          stkseqp=1;
          stklenp=2;
          stkmessp=5;
          stktokenp=4;
          stkvars:array[0..14] of string=
        ( 'PARAM_BUILD_NUMBER_LOW   ',   //$80;
          'PARAM_BUILD_NUMBER_HIGH  ',   //$81;
          'PARAM_HW_VER             ',   //$90;
          'PARAM_SW_MAJOR           ',   //$91;
          'PARAM_SW_MINOR           ',   //$92;
          'PARAM_VTARGET            ',   //$94;
          'PARAM_VADJUST            ',   //$95;
          'PARAM_OSC_PSCALE         ',   //$96;
          'PARAM_OSC_CMATCH         ',   //$97;
          'PARAM_SCK_DURATION       ',   //$98;
          'PARAM_TOPCARD_DETECT     ',   //$9A;
          'PARAM_STATUS             ',   //$9C;
          'PARAM_DATA               ',   //$9D;
          'PARAM_RESET_POLARITY     ',   //$9E;
          'PARAM_CONTROLLER_INIT    ');   //$9F;
        parstrs:array[$80..$9f] of string=
        ( 'PARAM_BUILD_NUMBER_LOW   ',   //$80;
          'PARAM_BUILD_NUMBER_HIGH  ',   //$81;
          'Unkown Parameter',
          'Unkown Parameter',
          'Unkown Parameter',
          'Unkown Parameter',
          'Unkown Parameter',
          'Unkown Parameter',
          'Unkown Parameter',
          'Unkown Parameter',
          'Unkown Parameter',
          'Unkown Parameter',
          'Unkown Parameter',
          'Unkown Parameter',
          'Unkown Parameter',
          'Unkown Parameter',
          'PARAM_HW_VER             ',   //$90;
          'PARAM_SW_MAJOR           ',   //$91;
          'PARAM_SW_MINOR           ',   //$92;
          'Unkown Parameter',
          'PARAM_VTARGET            ',   //$94;
          'PARAM_VADJUST            ',   //$95;
          'PARAM_OSC_PSCALE         ',   //$96;
          'PARAM_OSC_CMATCH         ',   //$97;
          'PARAM_SCK_DURATION       ',   //$98;
          'Unkown Parameter',
          'PARAM_TOPCARD_DETECT     ',   //$9A;
          'Unkown Parameter',
          'PARAM_STATUS             ',   //$9C;
          'PARAM_DATA               ',   //$9D;
          'PARAM_RESET_POLARITY     ',   //$9E;
          'PARAM_CONTROLLER_INIT    ');   //$9F;
          progmax=(24*16)-1;
          WRITESIZE=(20*16)-1;

simpleProg:array[0..progmax] of byte=
(
$30,$C0,$52,$C0,$52,$C0,$52,$C0,$52,$C0,$52,$C0,$52,$C0,$5D,$C0,
$5E,$C0,$5F,$C0,$60,$C0,$61,$C0,$62,$C0,$63,$C0,$64,$C0,$6F,$C0,
$70,$C0,$60,$91,$60,$00,$70,$91,$60,$00,$76,$17,$E1,$F3,$B3,$95,
$B2,$30,$59,$F0,$30,$91,$62,$00,$33,$95,$30,$93,$62,$00,$3B,$BB,

$00,$27,$08,$BB,$05,$BB,$02,$BB,$EC,$CF,$B0,$E0,$30,$91,$62,$00,
$33,$95,$30,$93,$62,$00,$3B,$BB,$03,$E0,$08,$BB,$05,$BB,$90,$9A,
$E0,$CF,$04,$E0,$0E,$BF,$0F,$E5,$0D,$BF,$03,$D0,$0E,$D0,$12,$D0,
$D8,$CF,$E0,$E4,$EF,$BD,$ED,$E0,$EE,$BD,$EF,$E3,$EB,$BD,$EF,$EF,

$EA,$BD,$DD,$27,$DD,$BD,$DC,$BD,$08,$95,$E0,$E1,$E8,$BF,$E9,$BF,
$78,$94,$08,$95,$9F,$EF,$9A,$BB,$9F,$EE,$91,$BB,$93,$E0,$97,$BB,
$94,$BB,$AA,$27,$BB,$27,$08,$95,$18,$95,$18,$95,$18,$95,$18,$95,
$18,$95,$00,$91,$60,$00,$01,$30,$21,$F0,$01,$E0,$00,$93,$60,$00,

$18,$95,$00,$27,$00,$93,$60,$00,$18,$95,$00,$00,$18,$95,$00,$00,
$18,$95,$00,$00,$18,$95,$00,$00,$18,$95,$00,$00,$18,$95,$00,$00,
$18,$95,$00,$00,$18,$95,$00,$91,$60,$00,$01,$30,$21,$F0,$01,$E0,
$00,$93,$60,$00,$18,$95,$00,$27,$00,$93,$60,$00,$18,$95,$00,$00,

$18,$95,$00,$00,$18,$95,$9F,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,
$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,
$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,
$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,

$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,
$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,
$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,
$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF);



var
        params:array[1..maxparams] of byte;
        paddress:array[1..max_params] of word; //address of parameters
        
        Psize:longword;
        Pages:word;
        cc:integer;
        Istr,
        exepath:string;
        T_E6:Tedit;
        T_S89:TStringgrid;
        micros:array[0..200] of MRecord;
        micromax:word;
        T_application:Tapplication;
        T_M1:Tmemo;
        T_display:TMenuItem;
        mem:array[0..1024] of byte;
        mmax:word;
        wd,wr,mwrite,Mread,Ewrite,Eread:longword;
        dptr:pbyte;
        T_S_record:Tcheckbox;
        T_JTM,
        T_sig2:Tmemo;
        T_eaddress,
        T_address:TLabeledEdit;
        T_Raw:TCheckbox;
        time_tick:boolean=false;
        Tshow_TDO,TShow_TDI,TShow_states:Tcheckbox;
        ISP_program_data:array[0..65535] of byte;
        ISP_program_max:word=0;
        ISP_Eprogram_data:array[0..16000] of byte;
        ISP_Eprogram_max:word=0;

        T_Micro:TCombobox;
        T_Resetbox:Tcheckbox;
        T_tabsheet1:Ttabsheet;
        T_show_signals:Tmenuitem;
        

        //******* Message Vars ************
        m_ok:boolean=true;
        inp:word=0;
        va:array[1..1024] of byte;
        le:word=0;
        //***** STK500 vars
        stk_tok,J_tok,stk_seq,STK_com,J_com,STK_CRC:byte;
        J_seq,STK_len,STK_st,J_st,J_CRC,TJ_CRC:word;
        Stk_val:string;
        J_val:string;
        J_len:longword;
        P_type:byte=1;
        //******** ISP Control vars
        TbPos:longword=10000;
        //************** Inside the Chip
        T_chip:TCombobox;
        // Pointers values for object
        // allows the objects to be accessed from any Unit
        T_E_EPpages,T_E_EPS,T_E_EPSize,T_E_EPages,T_E_Psize,
        T_E_PS,T_E_Sig,T_E_pages:TLabeledEdit;
        T_talk:Tedit;
        T_STKGrid,T_JTAGRev,T_lbits,
        T_Cfbe,T_CFb2,T_Cfb1:TStringgrid;
        Page_size:word;
        VLbits,VFBitsL,VFBitsE,VFBitsH,FbitsR,VOsc:byte;


        T_Sig: TLabeledEdit;
        T_PS_p_size: TLabeledEdit;
        T_PS_size: TLabeledEdit;
        T_E_PG_Size: TLabeledEdit;
        T_EP_size: TLabeledEdit;
        T_LB,T_Fbe,T_Fb2,T_Fb1: TStringGrid;
        //****** ISP Communication
        ISP_OK:boolean=false;
        r1,r2,r3,r4:byte;
        Signature:array[1..3] of byte;
        Sig_str:string;
        signo:byte=0;



        //*********** AVR_RISC
        R_Buf:array[0..65536] of byte;
        NO_bytes,z,rp,rm:word;
        mode,delay,addr:word;
        ISP_Com,RiscCom:byte;
        str:string;
        Cstr,
        RStr:string;
        P_pars:array[$80..$af] of byte;

        //***** Comport vars
        T_controller:Tcombobox;
        T_CPortDrv:TCommportDriver;
        T_Baud: TComboBox;
        T_Comport: TComboBox;
        T_Data_bits: TComboBox;
        T_Stop_bits: TComboBox;
        T_Parity: TComboBox;
        T_com_status:TLabeledEdit;

        //*****JTAG AVR TAP

        caddress,cefuse,chfuse,clfuse,clbits:byte;
        Portfile:string='';
        maxports:word=0;
        T_bscan:Tstringgrid;

        //*******JTAG SIGNALS

        Tm1:Tmemo;
        tapstate:word;
        tdi_buf:array[0..1024] of byte;
        tdo_buf:array[0..1024] of byte;
        data:array[0..2047] of byte;
        T_LE2:TlabeledEdit;

        //**JTAG COMMAND HANDLING

        Jparams:array[1..maxparams] of byte;
        dev_params:array[1..298] of byte;

        //**** ISP COMMUNICATION

        portrb:byte;

        //******** STK500

        V_PARAM_BUILD_NUMBER_LOW   :char=#$2 ;          //$80;
        V_PARAM_BUILD_NUMBER_HIGH  :char=#$3 ;          //$81;
        V_PARAM_HW_VER             :char=#$15 ;          //$90;
        V_PARAM_SW_MAJOR           :char=#$2 ;          //$91;
        V_PARAM_SW_MINOR           :char=#$7 ;          //$92;
        V_PARAM_VTARGET            :char=#50 ;          //$94;
        V_PARAM_VADJUST            :char=#50 ;          //$95;
        V_PARAM_OSC_PSCALE         :char=#$4 ;          //$96;
        V_PARAM_OSC_CMATCH         :char=#$20 ;          //$97;
        V_PARAM_SCK_DURATION       :char=#$30 ;          //$98;
        V_PARAM_TOPCARD_DETECT     :char=#$55 ;          //$9A;
        V_PARAM_STATUS             :char=#$2 ;          //$9C;
        V_PARAM_DATA               :char=#$2 ;          //$9D;
        V_PARAM_RESET_POLARITY     :char=#$1 ;          //$9E;
         V_PARAM_CONTROLLER_INIT    :char=#$0 ;          //$9F;
        
        D_PARAM_BUILD_NUMBER_LOW   :char=#$2 ;          //$80;
        D_PARAM_BUILD_NUMBER_HIGH  :char=#$3 ;          //$81;
        D_PARAM_HW_VER             :char=#$15 ;          //$90;
        D_PARAM_SW_MAJOR           :char=#$2 ;          //$91;
        D_PARAM_SW_MINOR           :char=#$7 ;          //$92;
        D_PARAM_VTARGET            :char=#50 ;          //$94;
        D_PARAM_VADJUST            :char=#50 ;          //$95;
        D_PARAM_OSC_PSCALE         :char=#$4 ;          //$96;
        D_PARAM_OSC_CMATCH         :char=#$20 ;          //$97;
        D_PARAM_SCK_DURATION       :char=#$30 ;          //$98;
        D_PARAM_TOPCARD_DETECT     :char=#$55 ;          //$9A;
        D_PARAM_STATUS             :char=#$2 ;          //$9C;
        D_PARAM_DATA               :char=#$2 ;          //$9D;
        D_PARAM_RESET_POLARITY     :char=#$1 ;          //$9E;
         D_PARAM_CONTROLLER_INIT    :char=#$0 ;          //$9F;

implementation

end.
