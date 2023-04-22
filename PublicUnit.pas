unit PublicUnit;

interface


uses
  Windows;

const

 VerName='版  本：文眼-摄像头数字识别录入 V8.90';
 PrjName='COCRApp-V';
 PrjVer=8.90;

procedure Ctl_V_Key();

implementation

procedure Ctl_V_Key();
var
  input:TInPut;
begin

//keybd_event
  input.Itype:=INPUT_KEYBOARD;

  with input.ki do
  begin
   wVk:=VK_CONTROL;
   wScan:=MapVirtualKey(wVK,0);
   dwFlags:=0;
   time:=windows.GetTickCount();
   dwExtraInfo:=windows.GetMessageExtraInfo;
  end;
  SendInput(1,input,sizeof(TInput));

  with input.ki do
  begin
   wVk:=ord('V');
   wScan:=MapVirtualKey(wVK,0);
   dwFlags:=0;
   time:=windows.GetTickCount();
   dwExtraInfo:=windows.GetMessageExtraInfo;
  end;
  SendInput(1,input,sizeof(TInput));

  with input.ki do
  begin
   wVk:=ord('V');
   dwFlags:=KEYEVENTF_KEYUP;
   wScan:=MapVirtualKey(wVK,0);
   time:=windows.GetTickCount();
   dwExtraInfo:=windows.GetMessageExtraInfo;
  end;
  SendInput(1,input,sizeof(TInput));

  with input.ki do
  begin
   wVk:=VK_CONTROL;
   dwFlags:=KEYEVENTF_KEYUP;
   wScan:=MapVirtualKey(wVK,0);
   time:=windows.GetTickCount();
   dwExtraInfo:=windows.GetMessageExtraInfo;
  end;
  SendInput(1,input,sizeof(TInput));

  with input.ki do
  begin
   wVk:=VK_RETURN;
   wScan:=MapVirtualKey(wVK,0);
   dwFlags:=0;
   time:=windows.GetTickCount();
   dwExtraInfo:=windows.GetMessageExtraInfo;
  end;
  SendInput(1,input,sizeof(TInput));

  with input.ki do
  begin
   wVk:=VK_RETURN;
   dwFlags:=KEYEVENTF_KEYUP;
   wScan:=MapVirtualKey(wVK,0);
   time:=windows.GetTickCount();
   dwExtraInfo:=windows.GetMessageExtraInfo;
  end;
  SendInput(1,input,sizeof(TInput));


end;

end.
