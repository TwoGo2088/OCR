unit RegWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,aspr_api, jpeg, ExtCtrls, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdMessageClient, IdSMTP,IdMessage,
  IdIOHandler, IdIOHandlerSocket, IdSSLOpenSSL, IdPOP3, IdCoder3to4,
  IdCoderMIME, IdCoder, IdCoderQuotedPrintable,ShellAPI,Clipbrd;

type
  TRegForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    E_RCode: TEdit;
    bt_reg: TButton;
    Image1: TImage;
    Label3: TLabel;
    bt_mail: TButton;
    Label4: TLabel;
    E_Mail: TEdit;
    Label5: TLabel;
    P_MCode: TPanel;
    IdSMTP: TIdSMTP;
    Label6: TLabel;
    bt_Ver: TButton;
    IdDecoderQuotedPrintable1: TIdDecoderQuotedPrintable;
    IdDecoderMIME1: TIdDecoderMIME;
    IdMessage: TIdMessage;
    IdPOP3: TIdPOP3;
    IdSSLIOHandlerSocket: TIdSSLIOHandlerSocket;
    bt_Copy: TButton;
    procedure FormCreate(Sender: TObject);
    procedure bt_regClick(Sender: TObject);
    procedure bt_mailClick(Sender: TObject);
    procedure bt_VerClick(Sender: TObject);
    procedure bt_CopyClick(Sender: TObject);
  private
   FileName:string;
    function DecodeMailText(txt: string): string;
    function CheckNewVer: string;
  public
    function IsRegistered():boolean;
  end;

var
  RegForm: TRegForm;

implementation

{$R *.dfm}

procedure TRegForm.FormCreate(Sender: TObject);
var
  UserKey, UserName:PChar;
  mail:array[0..127] of char;
begin
  P_MCode.Caption:=StrPas(aspr_api.GetHardwareID);

  FileName:=ExtractFilePath(Application.ExeName)+'config.ini';
  GetPrivateProfileString('User','Mail','',PChar(@mail),128,PChar(FileName));
  E_Mail.Text:=Mail;

  if GetRegistrationInformation( 0, UserKey, UserName ) then
  begin
    E_RCode.Text:=StrPas(UserKey);
    if CheckKey(UserKey, PChar(P_MCode.Caption),nil) then
    begin
      P_MCode.Enabled:=false;
      E_RCode.Enabled:=false;
      bt_mail.Enabled:=false;
      E_Mail.Enabled:=false;
    end;
  end;

end;

procedure TRegForm.bt_regClick(Sender: TObject);
begin
  {$I E:\Web\Inc\DelphiEnvelopeCheck.inc}
  if CheckKeyAndDecrypt(PChar(E_RCode.Text),PChar(P_MCode.Caption),true) then
  begin
    E_RCode.Enabled:=false;
    bt_mail.Enabled:=false;
    E_Mail.Enabled:=false;
    MessageDlg('�����ע�ᣬ��лע��֧�֣�', mtInformation ,[mbOK],0);
    close;
  end
  else
    MessageDlg('��Ч��ע���룡', mtInformation ,[mbOK],0);
end;

function TRegForm.IsRegistered: boolean;
begin
  {$I E:\Web\Inc\DelphiEnvelopeCheck.inc}
  result:=CheckKey(PChar(E_RCode.Text),PChar(P_MCode.Caption),nil);

end;

procedure TRegForm.bt_mailClick(Sender: TObject);

begin

  if (Pos('@',E_Mail.Text)>0) and (Pos('.',E_Mail.Text)>0) then
  begin

   IdMessage.Clear;

   idsmtp.Connect;

   IdMessage.Body.Clear;
   IdMessage.Subject:= 'ע���ʼ�';
   IdMessage.Body.Add(P_MCode.Caption) ;
   IdMessage.Body.Add(E_Mail.Text) ;
   IdMessage.From.Address:= 'liyue_2088@126.com';
   IdMessage.Recipients.EMailAddresses:='liyue_2088@126.com'; //�ռ��˵ĵ�ַ �����ַ��Ӣ��;�ֺŸ���
   idsmtp.Send(IdMessage);
   idsmtp.Disconnect;
   MessageDlg('�������估�������ѷ��͸����ߣ��뾡��ɨ�����֧�����Ա���ע���룬лл��', mtInformation ,[mbOK],0);
   WritePrivateProfileString('user','Mail',PChar(E_Mail.Text),PChar(FileName));

  end
  else
  begin
    MessageDlg('����д��ȷ�����䣡', mtInformation ,[mbOK],0);
    E_Mail.SetFocus;
  end;
end;

function DecodeUtf8Str(const S: UTF8String): WideString;
 var lenSrc, lenDst  : Integer;
 begin
   lenSrc  := Length(S);
   if(lenSrc=0)then Exit;
   lenDst  := MultiByteToWideChar(CP_UTF8, 0, Pointer(S), lenSrc, nil, 0);
   SetLength(Result, lenDst);
   MultiByteToWideChar(CP_UTF8, 0, Pointer(S), lenSrc, Pointer(Result), lenDst);
 end;

function TRegForm.DecodeMailText(txt:string):string;
var
  charset,Encode,Next:string;
  APos:integer;
begin
  result:=Txt;
  APos:=Pos('=?',result);

  if APos>0 then
   result:=Copy(result,APos+2,length(result))
  else
   exit;

  APos:=Pos('?',result);
  charset:=Copy(result,1,APos-1);

  result:=Copy(result,APos+1,length(result));
  Encode:=Copy(result,1,1);
  result:=Copy(result,3,length(result));

  APos:=Pos('?=',result);
  Next:=Copy(result,APos+2,length(result));
  result:=Copy(result,1,APos-1);

  if UpperCase(Encode)='B' then
   result:=IdDecoderMIME1.DecodeToString(result)
  else if UpperCase(Encode)='Q' then
   result:=IdDecoderQuotedPrintable1.DecodeToString(result);

  if Pos('UTF',UpperCase(charset))>0 then
   result:=DecodeUtf8Str(result);

  result:=result+DecodeMailText(Next);
end;

const

  PrjName='COCR-V';
  PrjVer=8.85;
  PrjFrom='<liyue_2088@126.com>';


function TRegForm.CheckNewVer:string;
var
  i,c:integer;
  PrjNewVer:Single;
begin

  PrjNewVer:=0;
  result:='';
  if not IdPOP3.Connected then IdPOP3.Connect(5000);
  c:=IdPOP3.CheckMessages;
  for i:=1 to c do
  begin
    IdMessage.Clear;
    IdPOP3.RetrieveHeader(i,IdMessage);
    if (Pos(PrjName,IdMessage.Subject)>0) and (Pos(PrjFrom,IdMessage.From.Text)>0) then
    begin
     PrjNewVer:=StrTofloatDef(Copy(IdMessage.Subject,7,4),0);
     result:=IdMessage.Subject;
    end;
  end;

  if PrjNewVer<=PrjVer then result:='';
  IdPOP3.Disconnect;
end;


procedure TRegForm.bt_VerClick(Sender: TObject);
var
  Ver:string;
begin
 Ver:=CheckNewVer;
 if Ver<>'' then
 begin
  if MessageBox(0,'�����°汾���Ƿ�����������','��ʾ', MB_YESNO or MB_ICONINFORMATION)=6 then
  begin
   ShellExecute(0,'open',PChar(ExtractFilePath(Application.ExeName)+'MUpgrade.exe'),PChar(Ver+' '+ExtractFileName(Application.ExeName)),nil,SW_SHOW);
   Application.Terminate;
  end
  else
   Close();
 end
 else
 begin
  MessageBox(0,'δ�����°汾��','��ʾ', MB_OK or MB_ICONINFORMATION);
  Close;
 end;

end;

procedure TRegForm.bt_CopyClick(Sender: TObject);
begin
  Clipboard.AsText:=P_MCode.Caption;
end;

end.
