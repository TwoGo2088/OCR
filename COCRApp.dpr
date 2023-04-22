program COCRApp;

uses
  Forms,
  COCRPas in 'COCRPas.pas' {CameraForm},
  RegWnd in '..\web\Share\RegWnd.pas' {RegForm},
  WriteWnd in 'WriteWnd.pas' {WriForm},
  PublicUnit in 'PublicUnit.pas',
  smartKey in 'smartKey.pas' {KeyForm},
  TessAPI in 'TessAPI.pas',
  HotKeyRegister in '..\program files\borland\delphi7\lib\HotKeyRegister.pas';

{$R *.res}
begin
  Application.Initialize;
  Application.Title := '文眼-摄像头数字识别录入 V8.90';
  Application.CreateForm(TCameraForm, CameraForm);
  Application.CreateForm(TRegForm, RegForm);
  Application.CreateForm(TWriForm, WriForm);
  Application.CreateForm(TKeyForm, KeyForm);
  Application.Run;
end.
