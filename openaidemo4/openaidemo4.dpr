program openaidemo4;

uses
  System.StartUpCopy,
  FMX.Forms,
  UAIDemo4Main in 'UAIDemo4Main.pas' {FOpenAIDemoMain};

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := true;
  Application.Initialize;
  Application.CreateForm(TFOpenAIDemoMain, FOpenAIDemoMain);
  Application.Run;
end.
