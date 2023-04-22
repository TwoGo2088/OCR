object KeyForm: TKeyForm
  Left = 764
  Top = 387
  BorderStyle = bsDialog
  Caption = #35774#23450#24555#25463#38190
  ClientHeight = 118
  ClientWidth = 339
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object L_msg: TLabel
    Left = 48
    Top = 16
    Width = 31
    Height = 13
    Caption = 'L_msg'
  end
  object HotKey: THotKey
    Left = 48
    Top = 42
    Width = 121
    Height = 19
    HotKey = 32833
    TabOrder = 0
  end
  object bt_ok: TButton
    Left = 184
    Top = 39
    Width = 75
    Height = 25
    Caption = #30830#23450
    TabOrder = 1
    OnClick = bt_okClick
  end
end
