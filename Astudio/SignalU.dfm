object Signals: TSignals
  Left = 837
  Top = 80
  Width = 432
  Height = 641
  Caption = 'Signals'
  Color = 4210688
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PC2: TPageControl
    Left = 2
    Top = 2
    Width = 401
    Height = 603
    ActivePage = ts1
    TabIndex = 0
    TabOrder = 0
    object ts1: TTabSheet
      Caption = 'Signal to/from AVR Chip'
      object Button1: TButton
        Left = 16
        Top = 8
        Width = 75
        Height = 17
        Caption = 'Clear'
        TabOrder = 0
        OnClick = Button1Click
      end
      object M1: TMemo
        Left = 4
        Top = 32
        Width = 389
        Height = 541
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 1
      end
      object Raw: TCheckBox
        Left = 104
        Top = 8
        Width = 89
        Height = 17
        Caption = 'Raw Input off'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clYellow
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        OnClick = RawClick
      end
      object S_record: TCheckBox
        Left = 216
        Top = 8
        Width = 97
        Height = 17
        Caption = 'Recording off'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clYellow
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        OnClick = S_recordClick
      end
    end
    object ts2: TTabSheet
      Caption = 'JTAG Signals'
      ImageIndex = 1
      object Button2: TButton
        Left = 16
        Top = 8
        Width = 75
        Height = 17
        Caption = 'Clear'
        TabOrder = 0
        OnClick = Button2Click
      end
      object Show_TDI: TCheckBox
        Left = 104
        Top = 8
        Width = 97
        Height = 17
        Caption = 'Show TDI'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clYellow
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnClick = Show_TDIClick
      end
      object Show_TDO: TCheckBox
        Left = 196
        Top = 8
        Width = 97
        Height = 17
        Caption = 'Show TD0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clYellow
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        OnClick = Show_TDOClick
      end
      object Show_states: TCheckBox
        Left = 292
        Top = 8
        Width = 97
        Height = 17
        Caption = 'Show  States'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clYellow
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        OnClick = Show_statesClick
      end
      object JTM: TMemo
        Left = 4
        Top = 32
        Width = 387
        Height = 541
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 4
      end
    end
  end
end
