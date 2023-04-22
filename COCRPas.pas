unit COCRPas;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,wininet, Clipbrd,jpeg,superobject, PublicUnit,
  WinSkinData,  IdCoder,  IdCoderMIME,HotKeyRegister, DB, DBCtrls, Grids, DBGrids, ADODB, CheckLst, ComCtrls,
  aspr_api,MMSystem, WinSkinStore, Menus, vfw,StrUtils,Httpapp, IdBaseComponent,
  IdCoder3to4, shellAPI,TessAPI;

const WM_CUTIMAGE=WM_USER+$200;
const WM_GETCOLOR=WM_USER+$201;
const WM_SAMECOLOR=WM_USER+$202;
const WM_NEWCOLOR=WM_USER+$203;
const WM_NEWRANGE=WM_USER+$204;
const WM_PAPERLEFT=WM_USER+$205;
const WM_SHOWREGWND=WM_USER+$206;
const VIDEO_FORMAT_YUV2=844715353;
const VIDEO_FORMAT_MJPG=1196444237;

type
  TRGB=Record
   R,G,B:integer;
  end;

  PSheetInfo = ^TSheetInfo;
  TSheetInfo=Record
   ColorVal:integer;
   ColorXY:TPoint;
   ColorEnabled:boolean;
   RangeCount:integer;
  end;

  PRangeInfo = ^TRangeInfo;
  TRangeInfo=Record
   ImageRect:TRect;
   AppWndClassName:string;
   WriWndXY:TPoint;
   WriWnd,AppWnd:HWND;
  end;


  TActionStatus = (asNormal,asCutImage,asPoint, asRange,asRefresh);

  TCameraForm = class(TForm)
    ScrollBox: TScrollBox;
    VW_Panel: TPanel;
    IdEncoderMIME: TIdEncoderMIME;
    StatusBar: TStatusBar;
    OpenDialog: TOpenDialog;
    IniSaveDialog: TSaveDialog;
    pg_Main: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    GroupBox1: TGroupBox;
    LabelPoint: TLabel;
    Label1: TLabel;
    B_dot_set: TButton;
    B_Range_Set: TButton;
    B_Refresh: TButton;
    B_Range_Del: TButton;
    C_dot: TCheckBox;
    C_Range: TCheckBox;
    P_FileName: TPanel;
    B_Open: TButton;
    B_Save_ini: TButton;
    CL_Range: TListBox;
    PanelPoint: TPanel;
    B_Wriite_Wnd: TButton;
    GroupBox2: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    L_Color: TLabel;
    Label5: TLabel;
    L_Test: TLabel;
    R_high: TRadioButton;
    R_Normal: TRadioButton;
    C_Clb: TCheckBox;
    E_time: TEdit;
    UpDown_Time: TUpDown;
    E_Color: TEdit;
    UpDown_Color: TUpDown;
    C_Test: TCheckBox;
    TabSheet3: TTabSheet;
    Label6: TLabel;
    StringGrid: TStringGrid;
    B_save: TButton;
    B_Del: TButton;
    B_Test: TButton;
    M_Txt: TMemo;
    TxtSaveDialog: TSaveDialog;
    B_Camera: TButton;
    bt_ocr: TButton;
    P_OCR_Txt: TPanel;
    b_Save_txt: TButton;
    B_Clear: TButton;
    C_TopMost: TCheckBox;
    SkinData1: TSkinData;
    C_Wri: TCheckBox;
    C_Filp: TCheckBox;
    C_Sepator: TComboBox;
    C_Baidu: TCheckBox;
    bt_copy_b: TButton;
    bt_copy_a: TButton;
    HotKeyRegister: THotKeyRegister;
    P_OCR_Txt_B: TPanel;
    E_Test: TEdit;
    C_local: TCheckBox;
    S_A: TShape;
    S_B: TShape;
    procedure FormCreate(Sender: TObject);
    procedure B_CameraClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure bt_ocrClick(Sender: TObject);
    procedure B_OpenClick(Sender: TObject);
    procedure B_dot_setClick(Sender: TObject);
    procedure B_Range_SetClick(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure B_Save_iniClick(Sender: TObject);
    procedure B_RefreshClick(Sender: TObject);
    procedure E_timeChange(Sender: TObject);
    procedure C_dotClick(Sender: TObject);
    procedure C_RangeClick(Sender: TObject);
    procedure CL_RangeClick(Sender: TObject);
    procedure E_ColorChange(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure StatusBarDrawPanel(StatusBar: TStatusBar;
      Panel: TStatusPanel; const Rect: TRect);
    procedure StatusBarMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure C_TestClick(Sender: TObject);
    procedure B_Wriite_WndClick(Sender: TObject);
    procedure B_Range_DelClick(Sender: TObject);
    procedure B_DelClick(Sender: TObject);
    procedure B_saveClick(Sender: TObject);
    procedure b_Save_txtClick(Sender: TObject);
    procedure B_ClearClick(Sender: TObject);
    procedure B_TestClick(Sender: TObject);
    procedure C_TopMostClick(Sender: TObject);
    procedure C_FilpClick(Sender: TObject);
    procedure C_BaiduClick(Sender: TObject);
    procedure bt_copy_aClick(Sender: TObject);
    procedure bt_copy_bClick(Sender: TObject);
    procedure HotKeyRegisterHotKey(ID: THotKeyID; Sender: TObject);
    procedure bt_ocrMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure bt_copy_aMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure bt_copy_bMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure C_localClick(Sender: TObject);
  private
    token,CPath:string;
    hkIDA,hkIDB,hkIDC:integer;
    isSetKey:boolean;
    Api: TessBaseAPI;
    function getToken():string;
    procedure WMCutImage(var msg:TMessage);message WM_CUTIMAGE;
    procedure WMGetColor(var msg:TMessage);message WM_GETCOLOR;
    procedure WMSameColor(var msg:TMessage);message WM_SAMECOLOR;
    procedure WMNewColor(var msg:TMessage);message WM_NEWCOLOR;
    procedure WMNewRange(var msg:TMessage);message WM_NEWRANGE;
    procedure WMPaperLeft(var msg:TMessage);message WM_PAPERLEFT;
    procedure WMShowRegWnd(var msg:TMessage);message WM_SHOWREGWND;
    procedure DoOCR();
    procedure DrawRange();
    procedure DeleteRange(index: integer);
    function DoReplace(txt: string): string;
    procedure LinkToEditWnd;
    function CheckEditBox: boolean;
    procedure LoadSmartKey;
    procedure SaveSmartKey;
    procedure DoLocalOCR(FileName: string);
    procedure InitTessercat;
    function DelReplace(txt: string): string;
    function GetLocalOCRTxt(FileName: string): string;
    procedure DoLocalRangeOCR(FileName: string);

  public

    procedure LoadConfig(FileName:String);
    procedure SaveConfig(FileName:String);

  end;

var
  CameraForm: TCameraForm;
  BmpInfo:TBitmapInfoHeader;

  FrameBmp,RangeBmp:TBitmap;
  vwh:THandle;
  ImageB64:string;
  ReadyOut:integer;
  MStream:TMemoryStream;
  jpg:TJpegImage;
  MouseXY:TPoint;
  SheetInfo:TSheetInfo;
  Range:array of TRangeInfo;
  RangeEnabled,TestDifferentColor:boolean;
  RangeIndex:integer;
  ActionStatus:TActionStatus;
  ReadyCount:integer;
  ColorRange:integer;
  RRect,PRect,SRect:TRect;
  isImageFlip:boolean;
  hd:THandle;
const
  SleepTime=200;
  token_url='https://aip.baidubce.com/oauth/2.0/token?grant_type=client_credentials&client_id=ELOy2ofGIhOlRH0DhoVhP57B&client_secret=leN6HgCl1uUr203Mx2eiSDuPGKrkzD9i';

implementation

uses RegWnd, WriteWnd, smartKey;

{$R *.dfm}


function WebHttp(sURL,sPostData:string):string;
const
  HTTP_VERSION  = 'HTTP/1.1';
var
  dwFlag:DWORD;
  dwBytesRead:DWORD;
  hInte,hConnection,hRequest:HInternet;
  HostPort:Integer;
  RequestMethod:string;
  HostName,FileName,sHeader:String;
  Data:array[0..1024] of char;
  procedure ParseURL(URL: string;var HostName,FileName:string;var HostPort:Integer);
  var
    i,p,k: DWORD;
  begin

    dwFlag:=INTERNET_FLAG_NO_CACHE_WRITE or INTERNET_FLAG_RELOAD;

    if lstrcmpi('https://',PChar(Copy(URL,1,8))) = 0 then
    begin
     System.Delete(URL, 1, 8);
     HostPort := INTERNET_DEFAULT_HTTPS_PORT;
     dwFlag:=dwFlag or INTERNET_FLAG_SECURE;
    end
    else if lstrcmpi('http://',PChar(Copy(URL,1,7))) = 0 then
    begin
     System.Delete(URL, 1,7);
     HostPort := INTERNET_DEFAULT_HTTP_PORT ;
    end;

    HostName := URL;
    FileName := '/';

    i := Pos('/', URL);
    if i <> 0 then
    begin
      HostName := Copy(URL, 1, i-1);
      FileName := Copy(URL, i, Length(URL) - i + 1);
    end;

    p:=pos(':',HostName);
    if p <> 0 then
    begin
      k:=Length(HostName)-p;
      HostPort:=StrToIntDef(Copy(HostName,p+1,k),INTERNET_DEFAULT_HTTP_PORT);
      Delete(HostName,p,k+1);
    end;

  end;

begin

  Result :='';

  if sPostData='' then
   RequestMethod:='GET'
  else
   RequestMethod:='POST';

  ParseURL(sURL,HostName,FileName,HostPort);
  hInte := InternetOpen('',INTERNET_OPEN_TYPE_PRECONFIG,nil,nil,0);

  if hInte<>nil then
  begin
    hConnection := InternetConnect(hInte,
                                   PChar(HostName),
                                   HostPort,
                                   nil,
                                   nil,
                                   INTERNET_SERVICE_HTTP,
                                   0,
                                   0);
    if hConnection<>nil then
    begin
      hRequest := HttpOpenRequest(hConnection,
                                  PChar(RequestMethod),
                                  PChar(FileName),
                                  HTTP_VERSION,
                                   '',
                                  nil,
                                  dwFlag,
                                  0);

      if hRequest<>nil then
      begin
        sHeader := 'Content-Type:application/x-www-form-urlencoded' + #13#10;
        if HttpSendRequest(hRequest,PChar(sHeader),Length(sHeader),PChar(sPostData),Length(sPostData)) then
        begin
           FillChar(data,1025,0);
           while InternetReadFile(hRequest,@Data,1024,dwBytesRead) do
           begin
             if dwBytesRead>0 then
             begin
              Data[dwBytesRead]:=#0;
              result:=result+Data;
              FillChar(data,1025,0);
             end
             else
              break;
           end;
        end;
        InternetCloseHandle(hRequest);
      end;
      InternetCloseHandle(hConnection);
    end;
    InternetCloseHandle(hInte);
  end;

end;


function TCameraForm.getToken():string;
var
  io:ISuperobject;
begin
 result:=WebHttp(token_url,'');

 io:=so(result);

 if pos('error',result)>0 then
 begin
   if io['error_msg']<>nil then ShowMessage(io['error_msg'].asString);
   result:='';
   exit;
 end;

 result:=io['access_token'].asString;

end;

function GetChildWnd(AppWnd:HWND;pt:TPoint):HWND;
var
  ScrXY:TPoint;
begin
  result:=0;
  Windows.ClientToScreen(AppWnd,ScrXY);
  BringWindowToTop(AppWnd);
  SetCursorPos(ScrXY.X,ScrXY.Y);
end;

procedure ShortCutToKey(ShortCut: TShortCut; var Key: Word; var Shift:word);
begin
  Key:=0;
  Key := ShortCut and not (scShift + scCtrl + scAlt);
  Shift := 0;
  if ShortCut and scShift <> 0 then Shift:=MOD_SHIFT;
  if ShortCut and scCtrl <> 0 then Shift:=Shift or MOD_CONTROL;
  if ShortCut and scAlt <> 0 then Shift:=Shift or MOD_ALT;
end;

procedure TCameraForm.LoadSmartKey();
var
  key,shift:word;
begin

  if FileExists(CPath+'SmartKey.ini') then
  begin
    bt_copy_a.tag:=GetPrivateProfileInt('keys','A',0,PChar(CPath+'SmartKey.ini'));
    if bt_copy_a.tag<>0 then
    begin
     ShortCutToKey(bt_copy_a.tag,key,shift);
     hkIDA:=HotKeyRegister.AddHotKey(shift,key);
    end;

    bt_copy_b.tag:=GetPrivateProfileInt('keys','B',0,PChar(CPath+'SmartKey.ini'));
    if bt_copy_b.tag<>0 then
    begin
     ShortCutToKey(bt_copy_b.tag,key,shift);
     hkIDB:=HotKeyRegister.AddHotKey(shift,key);
    end;

    bt_ocr.tag:=GetPrivateProfileInt('keys','C',0,PChar(CPath+'SmartKey.ini'));
    if bt_ocr.tag<>0 then
    begin
     ShortCutToKey(bt_ocr.tag,key,shift);
     hkIDC:=HotKeyRegister.AddHotKey(shift,key);
    end;

  end;

end;

procedure TCameraForm.SaveSmartKey();
begin

  WritePrivateProfileString('keys','A',PChar(IntToStr(bt_copy_a.tag)),PChar(CPath+'SmartKey.ini'));
  WritePrivateProfileString('keys','B',PChar(IntToStr(bt_copy_b.tag)),PChar(CPath+'SmartKey.ini'));
  WritePrivateProfileString('keys','C',PChar(IntToStr(bt_ocr.tag)),PChar(CPath+'SmartKey.ini'));
end;

procedure TCameraForm.LoadConfig(FileName:String);
var
  r:integer;
  Val:array[0..127] of char;
  List:TStringList;
begin

  if FileExists(FileName) then
  begin

   SheetInfo.ColorVal:=GetPrivateProfileInt('Point','Value',0,PChar(FileName));
   SheetInfo.ColorXY.X:=GetPrivateProfileInt('Point','X',0,PChar(FileName));
   SheetInfo.ColorXY.Y:=GetPrivateProfileInt('Point','Y',0,PChar(FileName));
   SheetInfo.ColorEnabled:=C_Dot.Checked;

   if  SheetInfo.ColorVal>0 then SendMessage(handle,WM_GETCOLOR,SheetInfo.ColorVal,0);

   List:=TStringList.Create;

   r:=1;
   SheetInfo.RangeCount:=0;
   repeat
     FillChar(Val,128,0);
     GetPrivateProfileString('Range',PChar('R'+IntToStr(r)),'',@Val,128,PChar(FileName));
     if Val='' then break;
     list.DelimitedText:=Val;
     if List.Count>=4 then
     begin
      SetLength(Range,SheetInfo.RangeCount+1);

      Range[SheetInfo.RangeCount].AppWndClassName:='';
      Range[SheetInfo.RangeCount].WriWnd:=0;
      Range[SheetInfo.RangeCount].AppWnd:=0;

      Range[SheetInfo.RangeCount].ImageRect.Left:=StrToIntDef(List.Strings[0],0);
      Range[SheetInfo.RangeCount].ImageRect.Top:=StrToIntDef(List.Strings[1],0);
      Range[SheetInfo.RangeCount].ImageRect.right:=StrToIntDef(List.Strings[2],0);
      Range[SheetInfo.RangeCount].ImageRect.bottom:=StrToIntDef(List.Strings[3],0);

      if List.Count=7 then
      begin
       Range[SheetInfo.RangeCount].AppWndClassName:=List.Strings[4];
       Range[SheetInfo.RangeCount].AppWnd:=FindWindow(PChar(Range[SheetInfo.RangeCount].AppWndClassName),nil);
       Range[SheetInfo.RangeCount].WriWndXY.X:=StrToIntDef(List.Strings[5],0);
       Range[SheetInfo.RangeCount].WriWndXY.Y:=StrToIntDef(List.Strings[6],0);
       Range[SheetInfo.RangeCount].WriWnd:=GetChildWnd(Range[SheetInfo.RangeCount].AppWnd,Range[SheetInfo.RangeCount].WriWndXY);
      end;
      SheetInfo.RangeCount:=SheetInfo.RangeCount+1;
     end;
     r:=r+1;
   until false;

   C_dot.Checked:=false;
   RangeEnabled:=C_Range.Checked;
   DrawRange;

   C_Test.Checked:=GetPrivateProfileInt('param','diffColor',1,PChar(FileName))=1;
   UpDown_Time.Position:=GetPrivateProfileInt('param','Delay',30,PChar(FileName));
   UpDown_Color.Position:=GetPrivateProfileInt('param','ColorRange',20,PChar(FileName));

   FillChar(Val,128,0);
   GetPrivateProfileString('param','Sepator','，',@Val,128,PChar(FileName));
   C_Sepator.Text:=Val;

   for r:=1 to 15 do StringGrid.Rows[r].Clear;

   r:=1;
   repeat
     FillChar(Val,128,0);
     GetPrivateProfileString('Replace',PChar('R'+IntToStr(r)),'',@Val,128,PChar(FileName));
     if Val='' then break;
     list.DelimitedText:=Val;
     if List.Count=2 then
     begin
      StringGrid.Cells[1,r]:=List.Strings[0];
      StringGrid.Cells[2,r]:=List.Strings[1];
     end;
     r:=r+1;
   until false;
   List.Free;

  end;
end;

procedure TCameraForm.SaveConfig(FileName:String);
var
  i,r:integer;
  Val:string;
begin

  WritePrivateProfileString('Point','Value',PChar(IntToStr(SheetInfo.ColorVal)),PChar(FileName));
  WritePrivateProfileString('Point','X',PChar(IntToStr(SheetInfo.ColorXY.X)),PChar(FileName));
  WritePrivateProfileString('Point','Y',PChar(IntToStr(SheetInfo.ColorXY.Y)),PChar(FileName));

  WritePrivateProfileString('Range', nil, nil, PChar(FileName));
  for i:=0 to length(Range)-1 do
  begin
   Val:=IntToStr(Range[i].ImageRect.Left)+','+IntToStr(Range[i].ImageRect.Top)+',';
   Val:=Val+IntToStr(Range[i].ImageRect.Right)+','+IntToStr(Range[i].ImageRect.Bottom);
   if Range[i].AppWnd<>0 then Val:=Val+','+Range[i].AppWndClassName+','+IntToStr(Range[i].WriWndXY.X)+','+IntToStr(Range[i].WriWndXY.Y);
   WritePrivateProfileString('Range',PChar('R'+IntToStr(i+1)),PChar(Val),PChar(FileName));
  end;

  if C_Test.Checked then
   WritePrivateProfileString('param','diffColor','1',PChar(FileName))
  else
   WritePrivateProfileString('param','diffColor','0',PChar(FileName));

  WritePrivateProfileString('param','Delay',PChar(IntToStr(UpDown_Time.Position)),PChar(FileName));
  WritePrivateProfileString('param','ColorRange',PChar(IntToStr(UpDown_Color.Position)),PChar(FileName));
  WritePrivateProfileString('param','Sepator',PChar(C_Sepator.Text),PChar(FileName));

  r:=1;
  WritePrivateProfileString('Replace', nil, nil, PChar(FileName));
  for i:=1 to 15 do
   if StringGrid.Cells[1,i]<>'' then
   begin
     Val:=StringGrid.Cells[1,i]+','+StringGrid.Cells[2,i];
     WritePrivateProfileString('Replace',PChar('R'+IntToStr(r)),PChar(Val),PChar(FileName));
     r:=r+1;
   end;
end;


procedure TCameraForm.FormCreate(Sender: TObject);
begin

 hd:=0;
 vwh:=0;
 token:='';
 ReadyCount:=0;
 RangeIndex:=-1;
 isSetKey:=false;
 CPath:=ExtractFilePath(Application.ExeName);

 FrameBmp:=TBitmap.Create;
 Framebmp.PixelFormat:=pf24bit;

 RangeBmp:=TBitmap.Create;
 Rangebmp.PixelFormat:=pf24bit;
 RangeBmp.Canvas.Brush.Color:=clWhite;
 RangeBmp.Canvas.Brush.Style:=bsSolid;



 MStream:=TMemoryStream.Create;
 jpg:=TJpegImage.Create;
 FillChar(SheetInfo,0,sizeof(TSheetInfo));
 MouseXY.X:=0;

 ActionStatus:=asNormal;
 if SheetInfo.ColorVal>0 then PanelPoint.Color:=SheetInfo.ColorVal;

 RangeEnabled:=true;
 TestDifferentColor:=true;
 SheetInfo.ColorEnabled:=false;
 //IsSameEditBox:=false;
 isImageFlip:=false;
 StringGrid.Cells[1,0]:='原内容';
 StringGrid.Cells[2,0]:='新内容';

 LoadSmartKey();
 InitTessercat();

 Top:=0;
 Left:=Screen.Width-Width;

 SetWindowPos(Application.handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE)
end;

procedure TCameraForm.FormDestroy(Sender: TObject);
begin
  FrameBmp.Free;
  RangeBmp.Free;
  MStream.Free;
  IdEncoderMIME.Free;
  jpg.Free;
  SetLength(Range,0);
  
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

function GetRGB(Color:TColor):TRGB;
begin
  result.R:=Color and $000000FF;
  result.G:=(Color and $0000FF00) shr 8;
  result.B:=(Color and $00FF0000) shr 16;
end;

function TestColor(Color1,Color2:TColor):boolean;
var
  RGB1,RGB2:TRGB;
  R,G,B:integer;
begin
  RGB1:=GetRGB(Color1);
  RGB2:=GetRGB(Color2);
  R:=RGB1.R-RGB2.R;
  G:=RGB1.G-RGB2.G;
  B:=RGB1.B-RGB2.B;
  result:=TestDifferentColor;
  if (R<ColorRange) and (R>-ColorRange) then
    if (G<ColorRange) and (G>-ColorRange) then
      if (B<ColorRange) and (B>-ColorRange) then
       result:=not result;

end;

function CallBackProc(hWnd: HWND; lpVHdr: PVIDEOHDR): DWORD; stdcall;
var
  TimeStr:string;
  vwdc:HDC;
  vwRect:TRect;
  i:integer;  
begin
  if (lpVhdr^.dwBufferLength<>lpVhdr^.dwBytesUsed) and (lpVhdr^.dwBytesUsed>0) and
        (bmpInfo.biCompression=VIDEO_FORMAT_MJPG)  then // and ((lpVHdr.dwFlags and VHDR_KEYFRAME)<>0)
  begin
   MStream.Clear;
   MStream.Write(lpVhdr.lpData^,lpVhdr.dwBytesUsed);
   MStream.Position:=0;
   jpg.LoadFromStream(MStream);
   jpg.DIBNeeded;
   FrameBmp.Assign(jpg);
  end
  else
   drawdibDraw(hd,FrameBmp.Canvas.Handle,0,0,FrameBmp.Width,FrameBmp.Height,@bmpInfo,lpVhdr.lpData,0,0,FrameBmp.Width,FrameBmp.Height,0);

  if isImageFlip then
   StretchBlt(FrameBmp.Canvas.Handle,0,0,FrameBmp.Width,FrameBmp.Height,FrameBmp.Canvas.Handle,FrameBmp.Width,FrameBmp.Height,-FrameBmp.Width,-FrameBmp.Height,SRCCOPY);

  if  (ActionStatus=asCutImage)then
  begin
    ActionStatus:=asNormal;
    ReadyCount:=-1;
    SendMessage(CameraForm.Handle,WM_CUTIMAGE,0,0);
  end
  else
  begin

   if  (ActionStatus=asRefresh)then
   begin
     SheetInfo.ColorVal:=FrameBmp.Canvas.Pixels[SheetInfo.ColorXY.X,SheetInfo.ColorXY.Y];
     SendMessage(CameraForm.Handle,WM_NEWCOLOR,0,0);
     ActionStatus:=asNormal;
   end;

   if (SheetInfo.ColorVal>0) and (ActionStatus=asNormal) and (SheetInfo.ColorEnabled) then
   begin
     if (ReadyCount>0) or TestColor(FrameBmp.Canvas.Pixels[sheetInfo.ColorXY.X,sheetInfo.ColorXY.Y],sheetInfo.ColorVal) then
     begin
      if ReadyCount>=0 then
      begin
       ReadyCount:=ReadyCount+1;
       SendMessage(CameraForm.Handle,WM_SAMECOLOR,ReadyOut-ReadyCount+1,0);
       if ReadyCount>=ReadyOut then
       begin
        ReadyCount:=0;
        ActionStatus:=asCutImage;
       end;
      end;
     end
     else if (ReadyCount<0) then
     begin
      ReadyCount:=0;
      SendMessage(CameraForm.Handle,WM_PAPERLEFT,0,0);
     end;
   end;

   if ActionStatus=asNormal then
   begin

    if (SheetInfo.ColorVal>0) then
    begin
     if not SheetInfo.ColorEnabled then FrameBmp.Canvas.Pen.Style:=psDot;

     if ReadyCount>0 then
     begin
      FrameBmp.Canvas.Pen.Color:=rgb(255,128,64);
      FrameBmp.Canvas.Ellipse(SheetInfo.ColorXY.X-15,SheetInfo.ColorXY.Y-15,SheetInfo.ColorXY.X+15,SheetInfo.ColorXY.Y+15);
     end;

     FrameBmp.Canvas.MoveTo(SheetInfo.ColorXY.X,SheetInfo.ColorXY.Y-8);
     FrameBmp.Canvas.LineTo(SheetInfo.ColorXY.X,SheetInfo.ColorXY.Y+8);
     FrameBmp.Canvas.MoveTo(SheetInfo.ColorXY.X-8,SheetInfo.ColorXY.Y);
     FrameBmp.Canvas.LineTo(SheetInfo.ColorXY.X+8,SheetInfo.ColorXY.Y);

     if ReadyCount>0 then FrameBmp.Canvas.Pen.Color:=clblue;
     if not SheetInfo.ColorEnabled then FrameBmp.Canvas.Pen.Style:=psSolid
    end;

    for i:=0 to length(Range)-1 do
    begin
     if RangeIndex=i then FrameBmp.Canvas.Pen.Color:=clFuchsia ;
     if not RangeEnabled then FrameBmp.Canvas.Pen.Style:=psDot;
     FrameBmp.Canvas.Rectangle(Range[i].ImageRect);
     if RangeIndex=i then FrameBmp.Canvas.Pen.Color:=clblue;
     if not RangeEnabled  or not SheetInfo.ColorEnabled then FrameBmp.Canvas.Pen.Style:=psSolid;
    end;

   end; //asNormal

   if ActionStatus=asPoint then
   begin

    for i:=0 to length(Range)-1 do FrameBmp.Canvas.Rectangle(Range[i].ImageRect);

    GetCursorPos(MouseXY);
    GetwindowRect(vwh,vwRect);

    if ptInRect(vwRect,MouseXY) then
    begin
     ScreenToClient(vwh,MouseXY);
     if (MouseXY.X<FrameBmp.Width) and (MouseXY.Y<FrameBmp.Height) then
     begin

      FrameBmp.Canvas.Ellipse(MouseXY.X-10,MouseXY.Y-10,MouseXY.X+10,MouseXY.Y+10);
      SendMessage(CameraForm.Handle,WM_GETCOLOR,FrameBmp.Canvas.Pixels[MouseXY.X,MouseXY.Y],0);

      if GetKeyState(VK_LBUTTON)<0 then
      begin
        SheetInfo.ColorVal:=FrameBmp.Canvas.Pixels[MouseXY.X,MouseXY.Y];
        SheetInfo.ColorXY:=MouseXY;
        ActionStatus:=asNormal;
      end;

     end;
    end;

   end;//asPoint

   if  ActionStatus=asRange then
   begin

    for i:=0 to length(Range)-2 do FrameBmp.Canvas.Rectangle(Range[i].ImageRect);

    if GetKeyState(VK_LBUTTON)<0 then
    begin
      GetCursorPos(MouseXY);
      ScreenToClient(vwh,MouseXY);
      if Range[length(Range)-1].ImageRect.Left=0 then
      begin
        Range[length(Range)-1].ImageRect.Left:=MouseXY.X;
        Range[length(Range)-1].ImageRect.Top:=MouseXY.Y;
      end;
      Range[length(Range)-1].ImageRect.Right:=MouseXY.X;
      Range[length(Range)-1].ImageRect.Bottom:=MouseXY.Y;
      FrameBmp.Canvas.Pen.Style:=psDot;
      FrameBmp.Canvas.Rectangle(Range[length(Range)-1].ImageRect);
      FrameBmp.Canvas.Pen.Style:=psSolid;
    end
    else if Range[length(Range)-1].ImageRect.Left>0 then
    begin
      SendMessage(CameraForm.Handle,WM_NEWRANGE,0,0);
       ActionStatus:=asNormal;
    end
    else
    begin
      GetCursorPos(MouseXY);
      ScreenToClient(vwh,MouseXY);
      if (MouseXY.X<FrameBmp.Width) and (MouseXY.Y<FrameBmp.Height) then
       FrameBmp.Canvas.Rectangle(MouseXY.X-5,MouseXY.Y-5,MouseXY.X+5,MouseXY.Y+5);
    end;

  end;//asRange

  DatetimeToString(TimeStr,'yyyy-mm-dd hh:mm:ss',now());
  FrameBmp.Canvas.Pen.Color:=clYellow;
  Framebmp.Canvas.Rectangle(RRect);
  FrameBmp.Canvas.Pen.Color:=clblue;
  FrameBmp.Canvas.TextOut(20,20,TimeStr);
 end; //<>asCutImage

  vwdc:=GetDC(vwh);
  bitBlt(vwdc,0,0,FrameBmp.Width,FrameBmp.Height,FrameBmp.Canvas.Handle,0,0,SRCCOPY);
  ReleaseDC(vwh,vwdc);
  result:=dword(true);

end;

function BitCountPixelFormat(bmpih:TBitmapInfoHeader): TPixelFormat;
begin
  Result := pfDevice;
  with  bmpih do
   case biBitCount of
     1: Result := pf1Bit;
     4: Result := pf4Bit;
     8: Result := pf8Bit;
    16: case biCompression of
          BI_RGB : Result := pf15Bit;
          BI_BITFIELDS:Result := pf16Bit;
        end;
    24: Result := pf24Bit;
    32: if biCompression = BI_RGB then Result := pf32Bit;
   end;

end;

procedure TCameraForm.B_CameraClick(Sender: TObject);
var
  index:integer;
begin
  if (vwh<>0) and (Sender<>nil) then exit;

  vwh:=capCreateCaptureWindow('CameraWnd ',WS_CHILD or WS_VISIBLE ,0,0,VW_Panel.Width,VW_Panel.Height,VW_Panel.Handle,0);
  if vwh <> 0 then
  begin

   for index:=0 to 15 do
    if capDriverConnect(vwh,0) then break;

   if index=16 then
   begin
    MessageDlg('不能开启摄像头!', mtError ,[mbOK],0);
    vwh:=0;
    exit;
   end;

   capPreviewRate(vwh,33);

   capGetVideoFormat(vwh,@bmpInfo,sizeof(TBitmapInfoHeader));

   if  (Sender<>nil)  then
   begin
    bmpInfo.biCompression:=VIDEO_FORMAT_YUV2;
    bmpInfo.biBitCount:=16;
    bmpInfo.biWidth:=640;
    bmpInfo.biHeight:=480;
    bmpInfo.biSizeImage:=bmpInfo.biWidth*bmpInfo.biHeight*2;
    if  not capSetVideoFormat(vwh,@bmpInfo,sizeof(TBitmapInfoHeader)) then
     capGetVideoFormat(vwh,@bmpInfo,sizeof(TBitmapInfoHeader));
   end;

   if bmpInfo.biCompression=VIDEO_FORMAT_YUV2 then
    Statusbar.Panels[2].Text:=format('视频格式：%dX%d YUV2',[bmpinfo.biWidth,bmpinfo.biHeight])
   else if bmpInfo.biCompression=VIDEO_FORMAT_MJPG then
    Statusbar.Panels[2].Text:=format('视频格式：%dX%d MJPG',[bmpinfo.biWidth,bmpinfo.biHeight])
   else
    Statusbar.Panels[2].Text:=format('视频格式：%dX%d',[bmpinfo.biWidth,bmpinfo.biHeight]);


   VW_Panel.Width:=bmpInfo.biWidth;
   VW_Panel.Height:=bmpInfo.biHeight;


   Framebmp.Height:=bmpinfo.biHeight;
   Framebmp.Width:=bmpinfo.biWidth;
   Framebmp.Canvas.Brush.Style:=bsClear;
   Framebmp.Canvas.Font.Name:='宋体';
   Framebmp.Canvas.Font.Size:=9;
   Framebmp.Canvas.Font.Color:=clred;
   FrameBmp.Canvas.Pen.Color:=clRed;
   RRect:=Framebmp.Canvas.ClipRect;
   inflateRect(RRect,-10,-10);
   

   SetWindowPos(vwh,0,0,0,bmpInfo.biWidth,bmpInfo.biHeight,SWP_NOMOVE);

   hd:=drawdibopen;
   capSetCallbackOnFrame(vwh,@CallBackProc);

  end;

end;



procedure TCameraForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 drawdibClose(hd);
 capCaptureAbort(vwh);
 capDriverDisconnect(vwh);
 SaveSmartKey();
end;

procedure TCameraForm.DoOCR();
var
  io:ISuperobject;
  ia:TSuperArray;
  url,retVal:string;
  i,r:integer;
  ScrXY,OldXY:TPoint;
begin

  if token='' then token:=GetToken();

  if R_Normal.Checked then
   url:='https://aip.baidubce.com/rest/2.0/ocr/v1/general_basic?access_token='+token
  else
  begin
    if RegForm.IsRegistered then
     url:='https://aip.baidubce.com/rest/2.0/ocr/v1/accurate_basic?access_token='+token
    else
    begin
     url:='https://aip.baidubce.com/rest/2.0/ocr/v1/general_basic?access_token='+token;
     R_Normal.Checked;
    end;
  end;


  try
   retVal:=WebHttp(url,'image='+HTTPEncode(ImageB64));
   retVal:=DecodeUtf8Str(retval);

   io:=so(retVal);

   if pos('error',retval)>0 then
   begin
    if io['error_msg']<>nil then  MessageDlg(io['error_msg'].asString, mtError ,[mbOK],0);
    exit;
   end;

   P_OCR_Txt.Caption:='';
   P_OCR_Txt_B.Caption:='';

   io:=so(retVal);
   ia:=io['words_result'].asArray;

   if (C_Clb.Checked) and (ia.Length>0) then
   begin
    P_OCR_Txt.Caption:=DoReplace(ia[0]['words'].asString);
    if ia.Length>1 then P_OCR_Txt_B.Caption:=DoReplace(ia[1]['words'].asString);
    M_TXT.Lines.Insert(0,P_OCR_Txt.Caption+','+P_OCR_Txt_B.Caption);
   end;

   if P_OCR_Txt.Caption<>'' then
      S_A.Brush.Color:=clBlack
   else
      S_A.Brush.Color:=clWhite;

   if P_OCR_Txt_B.Caption<>'' then
      S_B.Brush.Color:=clBlack
   else
      S_B.Brush.Color:=clWhite;

   PlaySound('.Default',0,SND_ALIAS or SND_ASYNC );
  finally

  end;
end;

function GetWH():TPoint;
var
  i,m:integer;

begin
  result.X:=0;
  result.Y:=0;
  for i:= 0 to length(Range)-1 do
  begin
    m:=Range[i].ImageRect.Right-Range[i].ImageRect.Left;
    if m>result.X then result.X:=m;
    m:=Range[i].ImageRect.Bottom-Range[i].ImageRect.Top;
    result.Y:=result.Y+m;
  end;

end;


function min(a, b: integer): integer;
begin
  if a < b then
    result := a
  else
    result := b;
end;

function max(a, b: integer): integer;
begin
  if a > b then
    result := a
  else
    result := b;
end;

procedure sharpen(srcbmp: tbitmap);
var
  i, j: integer;
  srcrgb: prgbtriple;
  srcprergb: prgbtriple;
  value: integer;
begin
  srcbmp.pixelformat := pf24bit;
  for i := 0 to srcbmp.height - 1 do
  begin
    srcrgb := srcbmp.scanline[i];
    if i > 0 then
      srcprergb := srcbmp.scanline[i - 1]
    else
      srcprergb := srcbmp.scanline[i];
    for j := 0 to srcbmp.width - 1 do
    begin
      if j = 1 then
        dec(srcprergb);
      value := srcrgb.rgbtred + (srcrgb.rgbtred - srcprergb.rgbtred) div 2;
      value := max(0, value);
      value := min(255, value);
      srcrgb.rgbtred := value;
      value := srcrgb.rgbtgreen +
        (srcrgb.rgbtgreen - srcprergb.rgbtgreen) div 2;
      value := max(0, value);
      value := min(255, value);
      srcrgb.rgbtgreen := value;
      value := srcrgb.rgbtblue + (srcrgb.rgbtblue - srcprergb.rgbtblue) div 2;
      value := max(0, value);
      value := min(255, value);
      srcrgb.rgbtblue := value;
      inc(srcrgb);
      inc(srcprergb);
    end;
  end;
end;

procedure contrastchange(const srcbmp, destbmp: tbitmap; valuechange: integer);
var
  i, j: integer;
  srcrgb, destrgb: prgbtriple;
begin
  for i := 0 to srcbmp.height - 1 do
  begin
    srcrgb := srcbmp.scanline[i];
    destrgb := destbmp.scanline[i];
    for j := 0 to srcbmp.width - 1 do
    begin
      if valuechange >= 0 then
      begin
        if srcrgb.rgbtred >= 128 then
          destrgb.rgbtred := min(255, srcrgb.rgbtred + valuechange)
        else
          destrgb.rgbtred := max(0, srcrgb.rgbtred - valuechange);
        if srcrgb.rgbtgreen >= 128 then
          destrgb.rgbtgreen := min(255, srcrgb.rgbtgreen + valuechange)
        else
          destrgb.rgbtgreen := max(0, srcrgb.rgbtgreen - valuechange);
        if srcrgb.rgbtblue >= 128 then
          destrgb.rgbtblue := min(255, srcrgb.rgbtblue + valuechange)
        else
          destrgb.rgbtblue := max(0, srcrgb.rgbtblue - valuechange);
      end
      else
      begin
        if srcrgb.rgbtred >= 128 then
          destrgb.rgbtred := max(128, srcrgb.rgbtred + valuechange)
        else
          destrgb.rgbtred := min(128, srcrgb.rgbtred - valuechange);
        if srcrgb.rgbtgreen >= 128 then
          destrgb.rgbtgreen := max(128, srcrgb.rgbtgreen + valuechange)
        else
          destrgb.rgbtgreen := min(128, srcrgb.rgbtgreen - valuechange);
        if srcrgb.rgbtblue >= 128 then
          destrgb.rgbtblue := max(128, srcrgb.rgbtblue + valuechange)
        else
          destrgb.rgbtblue := min(128, srcrgb.rgbtblue - valuechange);
      end;
      inc(srcrgb);
      inc(destrgb);
    end;
  end;
end;

// 饱和度调整
procedure saturationchange(const srcbmp, destbmp: tbitmap;
  valuechange: integer);
var
  grays: array [0 .. 767] of integer;
  alpha: array [0 .. 255] of word;
  gray, x, y: integer;
  srcrgb, destrgb: prgbtriple;
  i: byte;
begin
  valuechange := valuechange + 255;
  for i := 0 to 255 do
    alpha[i] := (i * valuechange) shr 8;
  x := 0;
  for i := 0 to 255 do
  begin
    gray := i - alpha[i];
    grays[x] := gray;
    inc(x);
    grays[x] := gray;
    inc(x);
    grays[x] := gray;
    inc(x);
  end;
  for y := 0 to srcbmp.height - 1 do
  begin
    srcrgb := srcbmp.scanline[y];
    destrgb := destbmp.scanline[y];
    for x := 0 to srcbmp.width - 1 do
    begin
      gray := grays[srcrgb.rgbtred + srcrgb.rgbtgreen + srcrgb.rgbtblue];
      if gray + alpha[srcrgb.rgbtred] > 0 then
        destrgb.rgbtred := min(255, gray + alpha[srcrgb.rgbtred])
      else
        destrgb.rgbtred := 0;
      if gray + alpha[srcrgb.rgbtgreen] > 0 then
        destrgb.rgbtgreen := min(255, gray + alpha[srcrgb.rgbtgreen])
      else
        destrgb.rgbtgreen := 0;
      if gray + alpha[srcrgb.rgbtblue] > 0 then
        destrgb.rgbtblue := min(255, gray + alpha[srcrgb.rgbtblue])
      else
        destrgb.rgbtblue := 0;
      inc(srcrgb);
      inc(destrgb);
    end;
  end;
end;

// rgb调整
procedure rgbchange(srcbmp, destbmp: tbitmap;
  redchange, greenchange, bluechange: integer);
var
  srcrgb, destrgb: prgbtriple;
  i, j: integer;
begin
  for i := 0 to srcbmp.height - 1 do
  begin
    srcrgb := srcbmp.scanline[i];
    destrgb := destbmp.scanline[i];
    for j := 0 to srcbmp.width - 1 do
    begin
      if redchange > 0 then
        destrgb.rgbtred := min(255, srcrgb.rgbtred + redchange)
      else
        destrgb.rgbtred := max(0, srcrgb.rgbtred + redchange);
      if greenchange > 0 then
        destrgb.rgbtgreen := min(255, srcrgb.rgbtgreen + greenchange)
      else
        destrgb.rgbtgreen := max(0, srcrgb.rgbtgreen + greenchange);
      if bluechange > 0 then
        destrgb.rgbtblue := min(255, srcrgb.rgbtblue + bluechange)
      else
        destrgb.rgbtblue := max(0, srcrgb.rgbtblue + bluechange);
      inc(srcrgb);
      inc(destrgb);
    end;
  end;
end;

//[颜色调整]
// rgb<=>bgr
procedure rgb2bgr(const bitmap: tbitmap);
var
  x: integer;
  y: integer;
  prgb: prgbtriple;
  color: byte;
begin
  for y := 0 to (bitmap.height - 1) do
  begin
    prgb := bitmap.scanline[y];
    for x := 0 to (bitmap.width - 1) do
    begin
      color := prgb^.rgbtred;
      prgb^.rgbtred := prgb^.rgbtblue;
      prgb^.rgbtblue := color;
      inc(prgb);
    end;
  end
end;


procedure grayscale(const bitmap: tbitmap);
var
  x: integer;
  y: integer;
  prgb: prgbtriple;
  gray: byte;
begin
  for y := 0 to (bitmap.height - 1) do
  begin
    prgb := bitmap.scanline[y];

    for x := 0 to (bitmap.width - 1) do
    begin
      gray := (77 * prgb.rgbtBlue + 151 * prgb.rgbtGreen + 28 * prgb.rgbtRed) shr 8;
      prgb^.rgbtred := gray;
      prgb^.rgbtgreen := gray;
      prgb^.rgbtblue := gray;

      inc(prgb);

    end;
  end;
end;

// 亮度调整
procedure brightnesschange(const srcbmp, destbmp: tbitmap;
  valuechange: integer);
var
  i, j: integer;
  srcrgb, destrgb: prgbtriple;
begin
  for i := 0 to srcbmp.height - 1 do
  begin
    srcrgb := srcbmp.scanline[i];
    destrgb := destbmp.scanline[i];
    for j := 0 to srcbmp.width - 1 do
    begin
      if valuechange > 0 then
      begin
        destrgb.rgbtred := min(255, srcrgb.rgbtred + valuechange);
        destrgb.rgbtgreen := min(255, srcrgb.rgbtgreen + valuechange);
        destrgb.rgbtblue := min(255, srcrgb.rgbtblue + valuechange);
      end
      else
      begin
        destrgb.rgbtred := max(0, srcrgb.rgbtred + valuechange);
        destrgb.rgbtgreen := max(0, srcrgb.rgbtgreen + valuechange);
        destrgb.rgbtblue := max(0, srcrgb.rgbtblue + valuechange);
      end;
      inc(srcrgb);
      inc(destrgb);
    end;
  end;
end;

procedure negative(bmp: tbitmap);
var
  i, j: integer;
  prgb: prgbtriple;
begin
  bmp.pixelformat := pf24bit;
  for i := 0 to bmp.height - 1 do
  begin
    prgb := bmp.scanline[i];
    for j := 0 to bmp.width - 1 do
    begin
      prgb^.rgbtred := not prgb^.rgbtred;
      prgb^.rgbtgreen := not prgb^.rgbtgreen;
      prgb^.rgbtblue := not prgb^.rgbtblue;
      inc(prgb);
    end;
  end;
end;



procedure exposure(bmp: tbitmap);
var
  i, j: integer;
  prgb: prgbtriple;
begin
  bmp.pixelformat := pf24bit;
  for i := 0 to bmp.height - 1 do
  begin
    prgb := bmp.scanline[i];
    for j := 0 to bmp.width - 1 do
    begin
      if prgb^.rgbtred < 128 then
        prgb^.rgbtred := not prgb^.rgbtred;
      if prgb^.rgbtgreen < 128 then
        prgb^.rgbtgreen := not prgb^.rgbtgreen;
      if prgb^.rgbtblue < 128 then
        prgb^.rgbtblue := not prgb^.rgbtblue;
      inc(prgb);
    end;
  end;
end;

procedure blur(srcbmp: tbitmap);
var
  i, j: integer;
  srcrgb: prgbtriple;
  srcnextrgb: prgbtriple;
  srcprergb: prgbtriple;
  value: integer;
  procedure incrgb;
  begin
    inc(srcprergb);
    inc(srcrgb);
    inc(srcnextrgb);
  end;
  procedure decrgb;
  begin
    inc(srcprergb, -1);
    inc(srcrgb, -1);
    inc(srcnextrgb, -1);
  end;

begin
  srcbmp.pixelformat := pf24bit;
  for i := 0 to srcbmp.height - 1 do
  begin
    if i > 0 then
      srcprergb := srcbmp.scanline[i - 1]
    else
      srcprergb := srcbmp.scanline[i];
    srcrgb := srcbmp.scanline[i];
    if i < srcbmp.height - 1 then
      srcnextrgb := srcbmp.scanline[i + 1]
    else
      srcnextrgb := srcbmp.scanline[i];
    for j := 0 to srcbmp.width - 1 do
    begin
      if j > 0 then
        decrgb;
      value := srcprergb.rgbtred + srcrgb.rgbtred + srcnextrgb.rgbtred;
      if j > 0 then
        incrgb;
      value := value + srcprergb.rgbtred + srcrgb.rgbtred + srcnextrgb.rgbtred;
      if j < srcbmp.width - 1 then
        incrgb;
      value := (value + srcprergb.rgbtred + srcrgb.rgbtred +
        srcnextrgb.rgbtred) div 9;
      decrgb;
      srcrgb.rgbtred := value;
      if j > 0 then
        decrgb;
      value := srcprergb.rgbtgreen + srcrgb.rgbtgreen + srcnextrgb.rgbtgreen;
      if j > 0 then
        incrgb;
      value := value + srcprergb.rgbtgreen + srcrgb.rgbtgreen +
        srcnextrgb.rgbtgreen;
      if j < srcbmp.width - 1 then
        incrgb;
      value := (value + srcprergb.rgbtgreen + srcrgb.rgbtgreen +
        srcnextrgb.rgbtgreen) div 9;
      decrgb;
      srcrgb.rgbtgreen := value;
      if j > 0 then
        decrgb;
      value := srcprergb.rgbtblue + srcrgb.rgbtblue + srcnextrgb.rgbtblue;
      if j > 0 then
        incrgb;
      value := value + srcprergb.rgbtblue + srcrgb.rgbtblue +
        srcnextrgb.rgbtblue;
      if j < srcbmp.width - 1 then
        incrgb;
      value := (value + srcprergb.rgbtblue + srcrgb.rgbtblue +
        srcnextrgb.rgbtblue) div 9;
      decrgb;
      srcrgb.rgbtblue := value;
      incrgb;
    end;
  end;
end;



procedure TCameraForm.WMCutImage(var msg: TMessage);
var
  i:integer;
  wh:TPoint;
begin

  if (C_local.Checked) then
  begin
   if (length(Range)>1) and RangeEnabled then
     doLocalRangeOCR(CPath+'ocr.bmp')
   else
   begin
    if (length(Range)>0) and RangeEnabled then
    begin
     RangeBmp.Width:=Range[0].ImageRect.Right-Range[0].ImageRect.Left;
     RangeBmp.Height:=Range[0].ImageRect.Bottom-Range[0].ImageRect.Top;;
     RangeBmp.Canvas.FillRect(RangeBmp.Canvas.ClipRect);
     RangeBmp.Canvas.CopyRect(RangeBmp.Canvas.ClipRect,FrameBmp.Canvas,Range[0].ImageRect);
     RangeBmp.SaveToFile(CPath+'ocr.bmp'); 
    end
    else
     FrameBmp.SaveToFile(CPath+'ocr.bmp');
    DoLocalOCR(CPath+'ocr.bmp');
   end;
  end
  else
  begin
   if (length(Range)>0) and RangeEnabled then
   begin
    wh:=GetWH;
    RangeBmp.Width:=wh.X;
    RangeBmp.Height:=wh.Y;
    RangeBmp.Canvas.FillRect(RangeBmp.Canvas.ClipRect);

    wh.Y:=0;
    for i:=0 to length(Range)-1 do
    begin
     RangeBmp.Canvas.CopyRect(Rect(0,wh.Y,Range[i].ImageRect.Right-Range[i].ImageRect.Left,wh.Y+Range[i].ImageRect.bottom-Range[i].ImageRect.top),FrameBmp.Canvas,Range[i].ImageRect);
     wh.Y:=wh.Y+Range[i].ImageRect.Bottom-Range[i].ImageRect.Top;
    end;
    jpg.Assign(RangeBmp);
   end
   else
    jpg.Assign(FrameBmp);

   jpg.JPEGNeeded;
   MStream.Clear;
   jpg.SaveToStream(MStream);
   MStream.Position:=0;
   ImageB64:=IdEncoderMIME.Encode(MStream);
   DoOCR();

  end;
end;

procedure TCameraForm.InitTessercat();
var
  iRet: Integer;
begin
  Api:= TessBaseAPICreate;
  iRet:=TessBaseAPIInit3(Api,Pchar(CPath+'tessdata'),PChar('eng'));
  if iRet <> 0 then
  begin
   ShowMessage('初始化TESSERCAT环境失败！');
   Exit
  end;
end;

function TCameraForm.GetLocalOCRTxt(FileName:string):string;
var
  Image: PPix;
  text_utf8: PAnsiChar;
begin
  if FileExists(FileName) then
  begin
    Image:= pixRead(PAnsiChar(Ansistring(FileName)));
    TessBaseAPISetImage2(Api, Image);
    text_utf8:= TessBaseAPIGetUTF8Text(Api);
    result:= Utf8ToAnsi(text_utf8);
    result:=StringReplace(result,' ','',[rfreplaceall]);
    result:=StringReplace(result,':','.',[rfreplaceall]);
    TessDeleteText(text_utf8);
   end;
end;

procedure TCameraForm.DoLocalRangeOCR(FileName:string);
var
  text:string;
begin
  if (length(Range)>0) and RangeEnabled then
  begin

   //blur(rangebmp);

   RangeBmp.Width:=Range[0].ImageRect.Right-Range[0].ImageRect.Left;
   RangeBmp.Height:=Range[0].ImageRect.Bottom-Range[0].ImageRect.Top;;
   RangeBmp.Canvas.FillRect(RangeBmp.Canvas.ClipRect);
   RangeBmp.Canvas.CopyRect(RangeBmp.Canvas.ClipRect,FrameBmp.Canvas,Range[0].ImageRect);
   RangeBmp.SaveToFile(CPath+'ocr.bmp');
   text:=DoReplace(GetLocalOCRTxt(CPath+'ocr.bmp'));

   P_OCR_Txt.Caption:=text;

   if text<>'' then
     S_A.Brush.Color:=clBlack
   else
     S_A.Brush.Color:=clWhite;

  end;

  if (length(Range)>1) and RangeEnabled then
  begin

   RangeBmp.Width:=Range[1].ImageRect.Right-Range[1].ImageRect.Left;
   RangeBmp.Height:=Range[1].ImageRect.Bottom-Range[1].ImageRect.Top;;
   RangeBmp.Canvas.FillRect(RangeBmp.Canvas.ClipRect);
   RangeBmp.Canvas.CopyRect(RangeBmp.Canvas.ClipRect,FrameBmp.Canvas,Range[1].ImageRect);

   RangeBmp.SaveToFile(CPath+'ocr.bmp');
   text:=DoReplace(GetLocalOCRTxt(CPath+'ocr.bmp'));

   P_OCR_Txt_B.Caption:=text;

   if text<>'' then
     S_B.Brush.Color:=clBlack
   else
     S_B.Brush.Color:=clWhite;

  end;

  PlaySound('.Default',0,SND_ALIAS or SND_ASYNC );

end;

procedure TCameraForm.DoLocalOCR(FileName:string);
var
  text:string;
  i,c:integer;
  ocrStr:array[0..1] of string;
begin

  text:=GetLocalOCRTxt(FileName);

  ocrStr[0]:='';
  ocrStr[1]:='';

  if text<>'' then
  begin
    c:=0;
    for i:=1 to length(text) do
    begin
      if (text[i] in['.','0'..'9']) and (c<2)then
        ocrStr[c]:=ocrStr[c]+text[i]
      else if text[i-1] in ['0'..'9'] then
       c:=c+1;
    end;
    ocrStr[0]:=DoReplace(ocrStr[0]);
    ocrStr[1]:=DoReplace(ocrStr[1]);
    if C_Clb.Checked then M_TXT.Lines.Insert(0,ocrStr[0]+','+ocrStr[1]);
   end;

   P_OCR_Txt.Caption:=ocrStr[0];
   P_OCR_Txt_B.Caption:=ocrStr[1];

   if ocrStr[0]<>'' then
     S_A.Brush.Color:=clBlack
   else
     S_A.Brush.Color:=clWhite;

   if ocrStr[1]<>'' then
     S_B.Brush.Color:=clBlack
   else
     S_B.Brush.Color:=clWhite;

   PlaySound('.Default',0,SND_ALIAS or SND_ASYNC );

end;

procedure TCameraForm.bt_ocrClick(Sender: TObject);
var
  key,shift:word;
begin

if isSetKey then
begin
  keyForm.L_msg.Caption:='设置 复制A 快捷键：';
  keyForm.HotKey.HotKey:=bt_ocr.Tag;
  KeyForm.ShowModal();
  if keyForm.HotKey.HotKey<>bt_ocr.Tag then
  begin
  if hkIDC<>0 then HotKeyRegister.DelHotKey(hkIDC);
   bt_ocr.Tag:=keyForm.HotKey.HotKey;
   ShortCutToKey(bt_ocr.Tag,key,shift);
   hkIDC:=HotKeyRegister.AddHotKey(shift,key);
 end;
 isSetKey:=false;
end
else
begin
 if vwh=0 then exit;
 if C_Wri.Checked then LinkToEditWnd();
  ActionStatus:=asCutImage;
end;

end;              

procedure TCameraForm.WMGetColor(var msg: TMessage);
var
  rgb:TRGB;
begin
  PanelPoint.Color:=msg.WParam;
  RGB:=GetRGB(msg.WParam);
  LabelPoint.Caption:='['+IntToStr(RGB.R)+','+IntToStr(RGB.G)+','+IntToStr(RGB.B)+']'
end;

procedure TCameraForm.B_OpenClick(Sender: TObject);
begin
  if OpenDialog.Execute then
  begin
    P_FileName.Caption:=ExtractFileName(OpenDialog.FileName);
    LoadConfig(OpenDialog.FileName);
  end;
end;

procedure TCameraForm.B_dot_setClick(Sender: TObject);
begin
  if vwh=0 then
  begin
    MessageDlg('请先开启摄像头！', mtInformation ,[mbOK],0);
    exit;
  end;

  ActionStatus:=asPoint;
end;

procedure TCameraForm.B_Range_SetClick(Sender: TObject);
begin

  if vwh=0 then
  begin
    MessageDlg('请先开启摄像头！', mtInformation ,[mbOK],0);
    exit;
  end;

  SetLength(Range,length(Range)+1);
  Range[length(Range)-1].ImageRect.Left:=0;
  Range[length(Range)-1].AppWndClassName:='';
  Range[length(Range)-1].WriWnd:=0;
  Range[length(Range)-1].AppWnd:=0;
  ActionStatus:=asRange;
end;

procedure TCameraForm.WMSameColor(var msg: TMessage);
begin
  P_OCR_Txt.Caption:='识别倒计时:'+format('%.3d',[msg.WParam]);
end;

procedure TCameraForm.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
var
  zoomRatio:integer;
begin

  if ptInRect(scrollbox.ClientRect,scrollbox.ScreenToClient(MousePos)) then
  begin
   if GetKeyState(VK_CONTROL)<0 then
   begin
    if WheelDelta<0 then
     ZoomRatio:=-10
    else
     ZoomRatio:=10;
    vw_panel.Width:=Round(vw_panel.Width*(1+ZoomRatio / 100));
    vw_panel.Height:=Round(vw_panel.height*(1+ZoomRatio / 100));
   end
   else
    scrollbox.VertScrollBar.Position:=scrollbox.VertScrollBar.Position-WheelDelta;
   Handled:=true;
  end;
end;

procedure TCameraForm.B_Save_iniClick(Sender: TObject);
begin
  if OpenDialog.FileName<>'' then
  begin
   SaveConfig(OpenDialog.FileName);
   MessageDlg('配置文件已保存！', mtInformation ,[mbOK],0);
  end
  else
   if IniSaveDialog.Execute then
   begin
    SaveConfig(IniSaveDialog.FileName);
    OpenDialog.FileName:=IniSaveDialog.FileName;
    P_FileName.Caption:=ExtractFileName(IniSaveDialog.FileName);
    MessageDlg('配置文件已保存！', mtInformation ,[mbOK],0);
  end;
end;

procedure TCameraForm.B_RefreshClick(Sender: TObject);
begin
  if vwh=0 then
  begin
    MessageDlg('请先开启摄像头！', mtInformation ,[mbOK],0);
    exit;
  end;
  ActionStatus:=asRefresh;
end;

procedure TCameraForm.E_timeChange(Sender: TObject);
begin
  ReadyOut:=UpDown_Time.Position;
end;

procedure TCameraForm.DrawRange;
var
  i:integer;
  RStr:string;
begin
  CL_Range.Clear;
  for i:=0  to length(Range)-1 do
  begin
    if Range[i].WriWnd<>0 then
     RStr:=format('□ %d,%d,%d,%d √',[Range[i].ImageRect.Left,Range[i].ImageRect.Top,Range[i].ImageRect.Right,Range[i].ImageRect.Bottom])
    else if Range[i].AppWnd<>0 then
     RStr:=format('□ %d,%d,%d,%d /',[Range[i].ImageRect.Left,Range[i].ImageRect.Top,Range[i].ImageRect.Right,Range[i].ImageRect.Bottom])
    else
     RStr:=format('□ %d,%d,%d,%d',[Range[i].ImageRect.Left,Range[i].ImageRect.Top,Range[i].ImageRect.Right,Range[i].ImageRect.Bottom]);
    CL_Range.Items.Add(RStr);
  end;
end;

procedure TCameraForm.DeleteRange(index:integer);
var
  i:integer;
begin
  if length(Range)-1>index then
   for i:=index  to length(Range)-2 do
    Range[i]:=Range[i+1];
  SetLength(Range,Length(Range)-1);
end;

procedure TCameraForm.WMNewColor(var msg: TMessage);
begin
  PanelPoint.Color:=SheetInfo.ColorVal;
end;

procedure TCameraForm.C_dotClick(Sender: TObject);
begin
  SheetInfo.ColorEnabled:=C_dot.Checked;

  if C_dot.Checked then
  begin
    StatusBar.Panels[0].Text:='  点色自动检测识别模式';
    if C_Wri.Checked then LinkToEditWnd();
  end
  else
    StatusBar.Panels[0].Text:='  手动识别模式'

end;

procedure TCameraForm.C_RangeClick(Sender: TObject);
begin
  RangeEnabled:=C_Range.Checked
end;

procedure TCameraForm.WMNewRange(var msg: TMessage);
var
  rt:TRect;
begin
  RangeIndex:=CL_Range.ItemIndex;
  rt:=Range[length(Range)-1].ImageRect;
  if (rt.Left>rt.Right) or (rt.Top>rt.Bottom) then
  begin
    Range[length(Range)-1].ImageRect.TopLeft:=rt.BottomRight;
    Range[length(Range)-1].ImageRect.BottomRight:=rt.TopLeft;
  end;
  DrawRange;
end;

procedure TCameraForm.CL_RangeClick(Sender: TObject);
begin
  RangeIndex:=CL_Range.ItemIndex;
end;

procedure TCameraForm.E_ColorChange(Sender: TObject);
begin
  ColorRange:=UpDown_Color.Position;
end;

procedure TCameraForm.WMPaperLeft(var msg: TMessage);
begin
  P_OCR_Txt.Caption:='';
end;

procedure TCameraForm.FormResize(Sender: TObject);
begin
  statusBar.Panels[0].Width:=width-600;
end;

procedure TCameraForm.StatusBarDrawPanel(StatusBar: TStatusBar;
  Panel: TStatusPanel; const Rect: TRect);
begin
  if Panel.ID=2 then
  begin
   SRect:=Rect;
   DrawText(StatusBar.Canvas.Handle,PChar(Panel.Text),length(Panel.Text),SRect,DT_CENTER or DT_VCENTER or DT_SINGLELINE);
  end
  else if Panel.ID=3 then
  begin
   PRect:=Rect;
   if Panel.Text='已注册' then
    StatusBar.Canvas.Font.Color:=clBlue
   else
    StatusBar.Canvas.Font.Color:=clred;
   DrawText(StatusBar.Canvas.Handle,PChar(Panel.Text),length(Panel.Text),PRect,DT_CENTER or DT_VCENTER or DT_SINGLELINE);
   StatusBar.Canvas.Font.Color:=clBtnText;
  end;
end;

procedure TCameraForm.StatusBarMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  pt:TPoint;
begin
  pt.X:=X;
  pt.Y:=Y;

  if ptInRect(SRect,pt) then
  begin
   if vfw.capDlgVideoFormat(vwh) then
   begin
    capCaptureAbort(vwh);
    capDriverDisconnect(vwh);
    B_CameraClick(nil);
   end;
  end
  else if ptInRect(PRect,pt) then
  begin
   RegForm.ShowModal();
   FormShow(nil);
  end;

end;

procedure TCameraForm.FormShow(Sender: TObject);
  var
  total,left:cardinal;
begin
  if RegForm.IsRegistered then
  begin
   StatusBar.Panels[3].Text:='已注册';
   C_Clb.Enabled:=true;
   C_Clb.Checked:=true;
   C_Wri.Enabled:=true;
   C_Wri.Checked:=true;
   C_Baidu.Enabled:=true;
   R_high.Caption:='较高';
   R_high.Enabled:=true;
  end
  else
  begin
 {$I E:\Web\Inc\DelphiEnvelopeCheck.inc}
   if GetTrialDays(1,total,left) then
    if left>0 then
    begin
      C_Clb.Enabled:=true;
      C_Clb.Checked:=true;
      C_Wri.Enabled:=true;
      C_Wri.Checked:=true;
      C_Baidu.Enabled:=true;
      StatusBar.Panels[3].Text:='可试用'+IntToStr(left)+'天，点击注册'
    end
  end;
  
end;

procedure TCameraForm.WMShowRegWnd(var msg: TMessage);
begin
 RegForm.ShowModal();
end;

procedure TCameraForm.C_TestClick(Sender: TObject);
begin
  if C_Test.Checked then
   L_Test.Caption:='测不同'
  else
   L_Test.Caption:='测相同';

  TestDifferentColor:=C_Test.Checked;
end;

procedure TCameraForm.B_Wriite_WndClick(Sender: TObject);
begin
  if CL_Range.ItemIndex>=0 then
  begin
   self.WindowState:=wsMinimized;
   WriForm.Timer.Enabled:=true;
   WriForm.showModal();
   WriForm.Timer.Enabled:=false;
   self.WindowState:=wsNormal;
  end
  else if CL_Range.Items.Count>0 then
   MessageDlg('请先选定一个区域，再进行自动录入连接设定！', mtInformation ,[mbOK],0)
  else
   MessageDlg('请先添加区域，再进行自动录入连接设定！', mtInformation ,[mbOK],0);
end;

procedure TCameraForm.B_Range_DelClick(Sender: TObject);
begin
  if CL_Range.ItemIndex>=0 then
  begin
   DeleteRange(CL_Range.ItemIndex);
   DrawRange;
  end;

end;

procedure TCameraForm.B_saveClick(Sender: TObject);
begin
  B_save_iniClick(Sender);
end;

procedure TCameraForm.B_DelClick(Sender: TObject);
var
  i: Integer;
begin
  for i:= StringGrid.Row to StringGrid.RowCount - 2 do
    StringGrid.Rows[i].Assign(StringGrid.Rows[i + 1]);
  StringGrid.Rows[i].Clear;
end;


function TCameraForm.DoReplace(txt: string): string;
var
  i,xpos:integer;
begin
  result:=txt;
  for i:=1 to 15 do
  begin
    if StringGrid.Cells[1,i]<>'' then
     result:=StringReplace(result,StringGrid.Cells[1,i],StringGrid.Cells[2,i],[rfReplaceAll])
    else
     break;
  end;
  result:=DelReplace(result);
  xPos:=Pos('.',result);
  if (xPos>0) and (length(result)-xpos>3) then
  setlength(result,xpos+3);
end;

function TCameraForm.DelReplace(txt: string): string;
var
  i:integer;
begin
  result:='';
  for i:=1 to length(txt) do
   if (txt[i] in['.','0'..'9']) then
     result:=result+txt[i];

end;



procedure TCameraForm.b_Save_txtClick(Sender: TObject);
begin
 if M_Txt.Lines.Text<>'' then
 begin
  if TxtSaveDialog.Tag=1 then
  begin
   M_Txt.Lines.SaveToFile(TxtSaveDialog.FileName);
   MessageDlg('识别内容文件已保存！', mtInformation ,[mbOK],0);
  end
  else
   if (TxtSaveDialog.Execute) then
   begin
    TxtSaveDialog.Tag:=1;
    M_Txt.Lines.SaveToFile(TxtSaveDialog.FileName);
    MessageDlg('识别内容文件已保存！', mtInformation ,[mbOK],0);
   end;

 end;
end;

procedure TCameraForm.B_ClearClick(Sender: TObject);
begin
  M_Txt.Clear;
end;

procedure TCameraForm.B_TestClick(Sender: TObject);
begin
  MessageDlg('替换后内容为：'+DoReplace(E_Test.Text), mtInformation ,[mbOK],0);
end;

procedure TCameraForm.C_TopMostClick(Sender: TObject);
begin
 if C_TopMost.Checked then
  SetWindowPos(Application.handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE)
 else
  SetWindowPos(Application.handle, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE)
end;

procedure TCameraForm.LinkToEditWnd();
var
  i:integer;
  ScrXY,OldXY:TPoint;
begin
  GetCurSorPos(OldXY);
  for i:=0 to length(Range)-1 do
  begin
     if (Range[i].WriWnd=0)and(Range[i].WriWndXY.X>0)then
     begin

      if Range[i].AppWndClassName<>'' then
        Range[i].AppWnd:=FindWindow(PChar(Range[i].AppWndClassName),nil);

      if (Range[i].AppWnd<>0) then
      begin

       BringWindowToTop(Range[i].AppWnd);
       ScrXY:=Range[i].WriWndXY;
       Windows.ClientToScreen(Range[i].AppWnd,ScrXY);
       SetCursorPos(ScrXY.X,ScrXY.Y);
       mouse_event(MOUSEEVENTF_LEFTDOWN,0,0,0,0);
       mouse_event(MOUSEEVENTF_LEFTUP,0,0,0,0);
       Sleep(SleepTime);
       Range[i].WriWnd:=WindowFromPoint(ScrXY);

      end;
     end;
  end;
  SetCurSorPos(OldXY.X,OldXY.Y);
  DrawRange();
  //IsSameEditBox:=CheckEditBox;
end;

function TCameraForm.CheckEditBox():boolean;
var
  i,j:integer;
  H:HWND;
begin
  result:=false;
  for i:=0 to length(Range)-1 do
  begin
   H:=Range[i].WriWnd;
   for j:=i+1 to length(Range)-1 do
    if H=Range[j].WriWnd then
    begin
     result:=true;
     exit;
    end;
  end;
end;



procedure TCameraForm.C_FilpClick(Sender: TObject);
begin
  isImageFlip:=C_Filp.Checked;
end;

procedure TCameraForm.C_BaiduClick(Sender: TObject);
begin
  if C_Baidu.Checked and (P_OCR_Txt.Caption<>'') then
   ShellExecute(0,'open',PChar('https://www.baidu.com/s?wd='+utf8string(P_OCR_Txt.Caption)),nil,nil,SW_NORMAL);
end;

procedure TCameraForm.bt_copy_aClick(Sender: TObject);
var
  key,shift:word;
begin

if isSetKey then
begin
  keyForm.L_msg.Caption:='设置 复制A 快捷键：';
  keyForm.HotKey.HotKey:=bt_copy_a.Tag;
  KeyForm.ShowModal();
  if keyForm.HotKey.HotKey<>bt_copy_a.Tag then
  begin
   if hkIDA<>0 then HotKeyRegister.DelHotKey(hkIDA);
   bt_copy_a.Tag:=  keyForm.HotKey.HotKey;
   ShortCutToKey(bt_copy_a.Tag,key,shift);
   hkIDA:=HotKeyRegister.AddHotKey(shift,key);
 end;
 isSetKey:=false;
end
else if C_Clb.Checked then
  Clipboard.AsText:=P_OCR_Txt.Caption;

end;

procedure TCameraForm.bt_copy_bClick(Sender: TObject);
var
  key,shift:word;
begin

if isSetKey then
begin
  keyForm.L_msg.Caption:='设置 复制A 快捷键：';
  keyForm.HotKey.HotKey:=bt_copy_b.Tag;
  KeyForm.ShowModal();
  if keyForm.HotKey.HotKey<>bt_copy_b.Tag then
  begin
   if hkIDB<>0 then HotKeyRegister.DelHotKey(hkIDB);
   bt_copy_b.Tag:=  keyForm.HotKey.HotKey;
   ShortCutToKey(bt_copy_b.Tag,key,shift);
   hkIDB:=HotKeyRegister.AddHotKey(shift,key);
 end;
 isSetKey:=false;
end
else if C_Clb.Checked then
  Clipboard.AsText:=P_OCR_Txt_B.Caption;

end;

procedure TCameraForm.HotKeyRegisterHotKey(ID: THotKeyID; Sender: TObject);
begin
  if C_Clb.Checked then
  begin
   if ID=hkIDA then
    Clipboard.AsText:=P_OCR_Txt.Caption;
   if ID=hkIDB then
    Clipboard.AsText:=P_OCR_Txt_B.Caption;
  end;
  if ID=hkIDC then
   bt_ocrClick(Sender);

end;

procedure TCameraForm.bt_ocrMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if x>75 then isSetKey:=true;

end;

procedure TCameraForm.bt_copy_aMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if x>80 then isSetKey:=true;
end;

procedure TCameraForm.bt_copy_bMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if x>80 then isSetKey:=true;
end;

procedure TCameraForm.C_localClick(Sender: TObject);
begin
 if C_local.Checked then
   StatusBar.Panels[0].Text:='  本地识别模式'
 else
   StatusBar.Panels[0].Text:='  网络识别模式'
end;

end.
