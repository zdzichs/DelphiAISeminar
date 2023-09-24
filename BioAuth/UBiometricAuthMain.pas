unit UBiometricAuthMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit, FMX.Objects,
  FMX.Platform, FMX.Memo.Types, FMX.ScrollBox, FMX.Memo, FMX.BiometricAuth;

type
  TFBiometricAuthMain = class(TForm)
    ButtonGo: TButton;
    RoundRect1: TRoundRect;
    EditPassword: TEdit;
    MemoLog: TMemo;
    PanelBottom: TPanel;
    BiometricAuth1: TBiometricAuth;
    Image1: TImage;
    Label1: TLabel;
    Image2: TImage;
    procedure ButtonGoClick(Sender: TObject);
    procedure RequestBiometricAuth;
    procedure HideSecret;
    procedure ShowSecret;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    function HandleAppEvent(AAppEvent: TApplicationEvent;  AContext: TObject): Boolean;
    procedure BiometricAuth1AuthenticateSuccess(Sender: TObject);
    procedure BiometricAuth1AuthenticateFail(Sender: TObject;
      const FailReason: TBiometricFailReason; const ResultMessage: string);
  private
    { Private declarations }
  public
    { Public declarations }
    NeedBiometricAuth : Boolean;
  end;

var
  FBiometricAuthMain: TFBiometricAuthMain;

implementation

{$R *.fmx}


uses
{$IFDEF IOS}
    FMX.Platform.iOS, iOSapi.UIKit, FMX.Helpers.iOS;
{$ELSE}
    FMX.Platform.Android;
{$ENDIF}


function TFBiometricAuthMain.HandleAppEvent(AAppEvent: TApplicationEvent;
  AContext: TObject): Boolean;
begin
 case AAppEvent of
    TApplicationEvent.FinishedLaunching:;
    TApplicationEvent.BecameActive:;
    TApplicationEvent.WillBecomeInactive :
    begin
      HideSecret;
{$IFDEF IOS}
      WindowHandleToPlatform(Handle).View.setNeedsDisplay;
{$ENDIF}
      //https://stackoverflow.com/questions/68075106/hide-screenshot-for-app-switcher-in-fmx-ios-app
    end;
    TApplicationEvent.EnteredBackground:
    ;
    TApplicationEvent.WillBecomeForeground:
    begin
      //MemoLog.Lines.Add('WillBecomeForeground');
      RequestBiometricAuth;
    end;
    TApplicationEvent.WillTerminate: ;
    TApplicationEvent.LowMemory: ;
    TApplicationEvent.TimeChange: ;
    TApplicationEvent.OpenURL: ;
  end;

  Result := True;

end;


procedure TFBiometricAuthMain.BiometricAuth1AuthenticateFail(Sender: TObject;
  const FailReason: TBiometricFailReason; const ResultMessage: string);
begin
  NeedBiometricAuth := false;
end;

procedure TFBiometricAuthMain.BiometricAuth1AuthenticateSuccess(
  Sender: TObject);
begin
 TThread.Synchronize(nil, ShowSecret);
end;

procedure TFBiometricAuthMain.ButtonGoClick(Sender: TObject);
begin
  if EditPassword.Text.Trim = 'blebok' then
  begin
    ShowSecret;
  end
   else
  begin
    EditPassword.Text := '';
    NeedBiometricAuth := true;
    RequestBiometricAuth;
  end;
end;

procedure TFBiometricAuthMain.FormCreate(Sender: TObject);
var
{$IFDEF IOS}
  KeyWindow: UIWindow;
{$ENDIF}
  aFMXApplicationEventService: IFMXApplicationEventService;
begin
  if TPlatformServices.Current.SupportsPlatformService(IFMXApplicationEventService, IInterface(aFMXApplicationEventService)) then
  begin
    aFMXApplicationEventService.SetApplicationEventHandler(HandleAppEvent);
  end;
  //WindowManager.LayoutParams.FLAG_SECURE = 8192
  //MainActivity.getWindow.setFlags( 8192 ,  8192 );

{$IFDEF IOS}
  KeyWindow := SharedApplication.keyWindow;
  if (KeyWindow <> nil) and (KeyWindow.rootViewController <> nil) then
  begin
      PanelBottom.Visible := TOSVersion.Check(11) and (KeyWindow.safeAreaInsets.bottom > 0);
  end;
{$ENDIF}
end;

procedure TFBiometricAuthMain.FormShow(Sender: TObject);
begin
  //MemoLog.Lines.Add('FormShow');
  HideSecret;
  RequestBiometricAuth;
end;

procedure TFBiometricAuthMain.ShowSecret;
begin
  RoundRect1.Visible := true;
  NeedBiometricAuth := false;
end;



procedure TFBiometricAuthMain.HideSecret;
begin
  NeedBiometricAuth := true;
  RoundRect1.Visible := false;
end;



procedure TFBiometricAuthMain.RequestBiometricAuth;
begin
  if NeedBiometricAuth then
    BiometricAuth1.Authenticate;
end;



end.
