unit smartKey;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls;

type
  TKeyForm = class(TForm)
    HotKey: THotKey;
    bt_ok: TButton;
    L_msg: TLabel;
    procedure bt_okClick(Sender: TObject);
  private

  public
  end;

var
  KeyForm: TKeyForm;


implementation

{$R *.dfm}


procedure TKeyForm.bt_okClick(Sender: TObject);
begin
  close()
end;

end.
