program OpenAIDemo3;

uses
  System.StartUpCopy,
  FMX.Forms,
  UAIDemo3Main in 'UAIDemo3Main.pas' {FAIDemo3Main};

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := true;
  Application.Initialize;
  Application.CreateForm(TFAIDemo3Main, FAIDemo3Main);
  Application.Run;
end.
