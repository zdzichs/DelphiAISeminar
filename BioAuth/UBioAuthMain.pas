unit UBioAuthMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.BiometricAuth, FMX.DialogService, FMX.Controls.Presentation, FMX.StdCtrls;

type
  TForm9 = class(TForm)
    BiometricAuth1: TBiometricAuth;
    Button1: TButton;
    procedure BiometricAuth1AuthenticateSuccess(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form9: TForm9;

implementation

{$R *.fmx}

procedure TForm9.BiometricAuth1AuthenticateSuccess(Sender: TObject);
begin
 TDialogService.ShowMessage('Uda³o siê!!!');
end;

procedure TForm9.Button1Click(Sender: TObject);
begin
 BiometricAuth1.Authenticate;
end;

end.
