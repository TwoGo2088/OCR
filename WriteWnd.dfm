object WriForm: TWriForm
  Left = 657
  Top = 174
  BorderStyle = bsDialog
  Caption = #36830#25509#24405#20837#31383#21475
  ClientHeight = 227
  ClientWidth = 383
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object Label1: TLabel
    Left = 51
    Top = 16
    Width = 312
    Height = 12
    Caption = #35831#23558#40736#26631#25351#21521#25509#21463#27492#25968#25454#30340#36755#20837#26694#65292#28857#20987#19968#19979#24182#20445#25345#19981#21160#65292
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object Label2: TLabel
    Left = 35
    Top = 72
    Width = 48
    Height = 12
    Caption = #20027#31383#21475#65306
  end
  object Label3: TLabel
    Left = 35
    Top = 107
    Width = 48
    Height = 12
    Caption = #36755#20837#26694#65306
  end
  object Label4: TLabel
    Left = 23
    Top = 161
    Width = 60
    Height = 12
    Caption = #36755#20837#27979#35797#65306
  end
  object Label5: TLabel
    Left = 52
    Top = 35
    Width = 228
    Height = 12
    Caption = #28982#21518#25353'CTRL+D'#36873#23450#65292#24314#31435#36215#33258#21160#24405#20837#36830#25509#12290
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
  end
  object Label6: TLabel
    Left = 88
    Top = 134
    Width = 180
    Height = 12
    Caption = #65288#35831#19981#35201#35753#20854#20182#31383#21475#36974#25377#36755#20837#26694#65289
  end
  object P_AppWnd: TPanel
    Left = 91
    Top = 67
    Width = 257
    Height = 26
    BevelOuter = bvLowered
    TabOrder = 0
  end
  object P_WriteWnd: TPanel
    Left = 91
    Top = 102
    Width = 257
    Height = 26
    BevelOuter = bvLowered
    TabOrder = 1
  end
  object E_Wri_Test: TEdit
    Left = 91
    Top = 153
    Width = 185
    Height = 20
    TabOrder = 2
  end
  object Button1: TButton
    Left = 284
    Top = 148
    Width = 65
    Height = 25
    Caption = #36755#20837
    TabOrder = 3
    OnClick = Button1Click
  end
  object B_Close: TButton
    Left = 155
    Top = 183
    Width = 75
    Height = 25
    Caption = #20851#38381
    TabOrder = 4
    OnClick = B_CloseClick
  end
  object HotKeyRegister: THotKeyRegister
    OnHotKey = HotKeyRegisterHotKey
    Left = 98
    Top = 183
  end
  object Timer: TTimer
    Enabled = False
    Interval = 500
    OnTimer = TimerTimer
    Left = 243
    Top = 183
  end
end
