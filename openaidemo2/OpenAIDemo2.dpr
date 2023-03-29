program OpenAIDemo2;

uses
  System.StartUpCopy,
  FMX.Forms,
  UAIDemo2Main in 'UAIDemo2Main.pas' {FAIDemo2Main};

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := true;
  Application.Initialize;
  Application.CreateForm(TFAIDemo2Main, FAIDemo2Main);
  Application.Run;
end.
