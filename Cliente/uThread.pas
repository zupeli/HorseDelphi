unit uThread;

interface

uses System.SysUtils, System.UITypes, Vcl.Forms, Vcl.Graphics, Vcl.WinXCtrls,
  Vcl.StdCtrls, System.Classes, Vcl.Dialogs;

type
  TMyThreadMethod = procedure(Sender: TObject) of object;

  TMyThread = class
    private
    public
      class procedure ExecuteThread(proc: TProc;
                                    procTerminate: TMyThreadMethod);
      class procedure Terminate(Sender: TObject); static;
    end;

implementation

class procedure TMyThread.ExecuteThread(proc: TProc;
                                       procTerminate: TMyThreadMethod);
var
  vTread: TThread;
begin
  vTread := TThread.CreateAnonymousThread(proc);

  if Assigned(procTerminate) then
      vTread.OnTerminate := procTerminate;

  vTread.Start;
end;

class procedure TMyThread.Terminate(Sender: TObject);
begin

  if Sender is TThread then
    if Assigned(TThread(sender).FatalException) then
    begin
      showmessage(Exception(TThread(sender).FatalException).Message);
      exit;
    end;

end;

end.
