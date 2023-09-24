unit UAIDemo3Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Memo.Types,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo,
  FMX.DialogService.Async, FMX.Objects;

type
  TFAIDemo3Main = class(TForm)
    AniIndicator1: TAniIndicator;
    Memo1: TMemo;
    ToolBar1: TToolBar;
    Label1: TLabel;
    Button1: TButton;
    Image1: TImage;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FAIDemo3Main: TFAIDemo3Main;

implementation

{$R *.fmx}
uses
 REST.Types, REST.Client,System.JSON, System.Net.HttpClientComponent,
 FMX.Surfaces;

procedure LoadBitmapHttpFromURL(const AUrl: string; const ABitmap: TBitmap; const AAniIndicator : TAniIndicator = nil);
begin
  TThread.CreateAnonymousThread(
  procedure()
  var
    HTTP: TNetHTTPClient;
    Stream: TStream;

  begin
      HTTP := TNetHTTPClient.Create(nil);
      Http.UserAgent:='Mozilla/3.0 (compatible; zdzichs)';
      try
        Stream := TMemoryStream.Create;
        try
          HTTP.Get(AUrl, Stream);
          Stream.Position := 0;
          //RAWBitmap := TBitmap.Create(0, 0);
          TThread.Synchronize(TThread.CurrentThread,
           procedure ()
           begin
             ABitmap.LoadFromStream(Stream);
             if Assigned( AAniIndicator ) then
             begin
              AAniIndicator.Enabled := false;
              AAniIndicator.Visible := false;
             end;
           end
          );
          //Result := True;
        finally
          Stream.Free
        end
      finally
        HTTP.Free
      end;
  end).Start;
end;




procedure TFAIDemo3Main.Button1Click(Sender: TObject);
var
   RESTClient1       : TRESTClient;
   RESTRequest1      : TRESTRequest;
   RESTResponse1     : TRESTResponse;
   LJsonValue, LJsonValueD:TJsonValue;
   LJsonArray:TJsonArray;
   LJSonString:TJsonString;
begin
 RESTClient1:= TRESTClient.Create('https://api.openai.com/v1/images/generations');
 RESTClient1.Accept := 'application/json, text/plain; q=0.9, text/html;q=0.8,';
 RESTClient1.Accept := 'utf-8, *;q=0.8';
 RESTClient1.ContentType := 'application/x-www-form-urlencoded';
 RESTRequest1:=TRESTRequest.Create(self);
 RESTRequest1.Client := RESTClient1;
 RESTRequest1.Method := rmPOST;
 RESTResponse1:=TRESTResponse.Create(self);
 RESTRequest1.Response := RESTResponse1;

// var PostData :=
//    '{"prompt":"' + Memo1.Text.Replace(#13#10,'\n') + '",'+
//    '"n": 1,'+
//    '"size": "512x512"}';
 var PostData := '';
 var jso := TJSONObject.Create;
 try
   jso.AddPair( 'prompt', Memo1.Text );
   jso.AddPair( 'n', 1 );
   jso.AddPair( 'size', '512x512');
   PostData := jso.ToJSON;
 finally
   FreeAndNil(jso);
 end;



 RESTRequest1.Params.Clear;
 RESTRequest1.Params.AddItem('Authorization', 'Bearer ' + 'klucz_openai' , pkHTTPHEADER, [poDoNotEncode]);
 RESTRequest1.Body.ClearBody;
 RESTRequest1.AddBody(PostData, DefaultRESTContentType.ctAPPLICATION_JSON);
 FAIDemo3Main.AniIndicator1.Enabled := true;
 FAIDemo3Main.AniIndicator1.Visible := true;
 Image1.Bitmap.Clear(TAlphaColorRec.Null);
 RESTRequest1.ExecuteAsync(
 procedure()
 begin

    if RESTResponse1.StatusCode = 200 then
    begin

       LJsonValue:=TJSonObject.ParseJSONValue(RESTResponse1.Content);
       LJsonValueD:=LJsonValue.GetValue<TJSonValue>('data');
       if LJsonValueD is TJSonArray then
        begin
          LJSonArray := LJsonValueD as TJSonArray;
          LJSonString:=LJSonArray.Items[0].GetValue<TJSONString>('url');
          LoadBitmapHttpFromURL(LJSonString.Value.Trim, Image1.Bitmap, FAIDemo3Main.AniIndicator1);
        end;
       FreeAndNil(LJsonValue);
    end
     else
    begin
     FAIDemo3Main.AniIndicator1.Enabled := false;
     FAIDemo3Main.AniIndicator1.Visible := false;
    end;
    FreeAndNil(RESTResponse1);
    FreeAndNil(RESTRequest1);
    FreeAndNil(RESTClient1);
 end,
 True,
 True,
  procedure(Exception : TObject)
  begin
    FAIDemo3Main.AniIndicator1.Enabled := false;
    FAIDemo3Main.AniIndicator1.Visible := false;
    TDialogServiceAsync.ShowMessage('Sprawdü po≥πczenie sieciowe!')

  end
  );

end;

end.
