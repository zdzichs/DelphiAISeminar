unit UAIDemo1Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Memo.Types,
  REST.Types, REST.Client, Data.Bind.Components, Data.Bind.ObjectScope,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo,
  System.JSON;

type
  TFOpenAIDemoMain = class(TForm)
    MemoQuestion: TMemo;
    MemoResult: TMemo;
    ButtonSendRequest: TButton;
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    ToolBar1: TToolBar;
    Label1: TLabel;
    procedure ButtonSendRequestClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FOpenAIDemoMain: TFOpenAIDemoMain;

implementation

{$R *.fmx}

procedure TFOpenAIDemoMain.ButtonSendRequestClick(Sender: TObject);
var
  LJsonValue, LJsonValueCh:TJsonValue;
  LJsonArray:TJsonArray;
  LJSonString:TJsonString;
begin
 var PostData :=
    '{"model":"text-davinci-003",'+
    '"prompt":"' + MemoQuestion.Text + '",'+
    '"max_tokens":2048,'+
    '"temperature":0}';
 RESTRequest1.Params.Clear;
 RESTRequest1.Params.AddItem('Authorization', 'Bearer ' + 'klucz_z_openai' , pkHTTPHEADER, [poDoNotEncode]);
 RESTRequest1.Body.ClearBody;
 RESTRequest1.AddBody(PostData, DefaultRESTContentType.ctAPPLICATION_JSON);
 Showmessage(PostData);
 RESTRequest1.Execute;
 MemoResult.Text:='';
 LJsonValue:=TJSonObject.ParseJSONValue(RESTResponse1.Content);
 LJsonValueCh:=LJsonValue.GetValue<TJSonValue>('choices');
 if LJsonValueCh is TJSonArray then
  begin
    LJSonArray := LJsonValueCh as TJSonArray;
    LJSonString:=LJSonArray.Items[0].GetValue<TJSONString>('text');
    MemoResult.Lines.Add(LJSonString.Value.Trim);
  end;
  FreeAndNil(LJsonValue);
end;

end.
