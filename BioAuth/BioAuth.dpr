program BioAuth;

uses
  System.StartUpCopy,
  FMX.Forms,
  UBiometricAuthMain in 'UBiometricAuthMain.pas' {FBiometricAuthMain};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFBiometricAuthMain, FBiometricAuthMain);
  Application.Run;
end.
