unit WriteWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, HotKeyRegister, ExtCtrls, Clipbrd,publicUnit;

type
  TWriForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    P_AppWnd: TPanel;
    P_WriteWnd: TPanel;
    HotKeyRegister: THotKeyRegister;
    Timer: TTimer;
    E_Wri_Test: TEdit;
    Button1: TButton;
    Label4: TLabel;
    B_Close: TButton;
    Label5: TLabel;
    Label6: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure HotKeyRegisterHotKey(ID: THotKeyID; Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure B_CloseClick(Sender: TObject);
  private

  public
    WriWnd,AppWnd:HWND;
    XY:TPoint;
    procedure CreateParams(var Params: TCreateParams); override;
  end;

var
  WriForm: TWriForm;


implementation

uses COCRPas;

{$R *.dfm}

procedure TWriForm.Createparams(var Params: TCreateParams);
begin
  inherited;
  With Params do
  begin
    WndParent := Application.MainForm.Handle;
    Params.ExStyle := WS_EX_TOPMOST;
  end;
end;


procedure TWriForm.FormCreate(Sender: TObject);
begin
  HotKeyRegister.AddHotKey(MOD_CONTROL,Ord('D'));
end;

procedure TWriForm.HotKeyRegisterHotKey(ID: THotKeyID; Sender: TObject);
begin
 timer.Enabled:=not timer.Enabled;

 if not timer.Enabled then
 begin
   with CameraForm.CL_Range do
   begin
    Range[ItemIndex].WriWndXY:=XY;
    Range[ItemIndex].WriWnd:=WriWnd;
    Range[ItemIndex].AppWnd:=AppWnd;
    Range[ItemIndex].AppWndClassName:=P_AppWnd.Caption;
    Items[ItemIndex]:=format('¡õ %d,%d,%d,%d ¡Ì',[Range[ItemIndex].ImageRect.Left,
      Range[ItemIndex].ImageRect.top,Range[ItemIndex].ImageRect.Right,Range[ItemIndex].ImageRect.Bottom]);
    P_WriteWnd.Caption:=P_WriteWnd.Caption+' ¡Ì';
   end;
 end;
end;

procedure TWriForm.TimerTimer(Sender: TObject);
var
  Name:array[0..127] of char;
begin
  GetCursorPos(XY);
  WriWnd:=WindowFromPoint(XY);
  if WriWnd<>0 then
  begin
    FillChar(Name,128,0);
    GetClassName(WriWnd,@Name,128);
    P_WriteWnd.Caption:=Name;

    AppWnd:=windows.GetForegroundWindow();

    FillChar(Name,128,0);
    GetClassName(AppWnd,@Name,128);
    P_AppWnd.Caption:=Name;

    if windows.ScreenToClient(AppWnd,XY) then
     P_WriteWnd.Caption :=P_WriteWnd.Caption+format('-[%d,%d]-%d',[xy.X,xy.Y,WriWnd]);
  end;
end;


procedure TWriForm.Button1Click(Sender: TObject);
var
  OldXY,ScrXY:TPoint;
begin
  GetCurSorPos(OldXY);

  Clipbrd.Clipboard.AsText:= E_Wri_Test.Text;

  if not isWindow(AppWnd) then exit;
  if IsIconic(AppWnd) then
  begin
    ShowWindow(AppWnd,SW_NORMAL);
    Sleep(500);
  end;

  BringWindowToTop(AppWnd);

  ScrXY:=XY;

  windows.ClientToScreen(AppWnd,ScrXY);
  SetCursorPos(ScrXY.X,ScrXY.Y);

  mouse_event(MOUSEEVENTF_LEFTDOWN or MOUSEEVENTF_LEFTUP,0,0,0,0);
  mouse_event(MOUSEEVENTF_LEFTDOWN or MOUSEEVENTF_LEFTUP,0,0,0,0);
  Sleep(SleepTime);

  Ctl_V_Key();

  SetCurSorPos(OldXY.X,OldXY.Y);

end;

procedure TWriForm.B_CloseClick(Sender: TObject);
begin
  Close()
end;

end.
