program OpenAIDemo1;

uses
  System.StartUpCopy,
  FMX.Forms,
  UAIDemo1Main in 'UAIDemo1Main.pas' {FOpenAIDemoMain};

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := true;
  Application.Initialize;
  Application.CreateForm(TFOpenAIDemoMain, FOpenAIDemoMain);
  Application.Run;
end.
