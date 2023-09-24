unit UAIDemo2Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Memo.Types,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo,
  System.JSON, REST.Types, REST.Client, Data.Bind.Components,
  Data.Bind.ObjectScope, FMX.DialogService.Async;

type
  TFAIDemo2Main = class(TForm)
    Memo1: TMemo;
    Memo2: TMemo;
    Button1: TButton;
    RESTResponse1: TRESTResponse;
    RESTRequest1: TRESTRequest;
    RESTClient1: TRESTClient;
    AniIndicator1: TAniIndicator;
    ToolBar1: TToolBar;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FAIDemo2Main: TFAIDemo2Main;

implementation

{$R *.fmx}

procedure TFAIDemo2Main.Button1Click(Sender: TObject);
var
  LJsonValue, LJsonValueCh:TJsonValue;
  LJsonArray:TJsonArray;
  LJSonString, QJSonString:TJsonString;
begin
 QJSonString := TJsonString.Create(Memo1.Text);
 var PostData :=
    '{"model":"text-davinci-003",'+       //code-davinci-002
//    '"prompt":"##### Translate this function from Basic into Delphi\n### BASIC\n' + QJSonString.ToJSON.Replace('\r','').TrimLeft(['"']).TrimRight(['"'])+ '\n### Delphi\n",'+
      '"prompt":"Translate this function from Basic into Delphi:\n' + QJSonString.ToJSON.Replace('\r','').TrimLeft(['"']).TrimRight(['"'])+ '\n",'+
//    '"top_p": 1,'+
//    '"frequency_penalty":0,'+
//    '"presence_penalty":0,'+
//    '"stop":["###"],'+
    '"max_tokens":54,'+
    '"temperature":0}';
 QJSonString.Free;
 RESTRequest1.Params.Clear;
 RESTRequest1.Params.AddItem('Authorization', 'Bearer ' + 'klucz_openai' , pkHTTPHEADER, [poDoNotEncode]);
 RESTRequest1.Body.ClearBody;
 RESTRequest1.AddBody(PostData, DefaultRESTContentType.ctAPPLICATION_JSON);
 Showmessage(PostData);
 FAIDemo2Main.AniIndicator1.Enabled := true;
 FAIDemo2Main.AniIndicator1.Visible := true;
 RESTRequest1.ExecuteAsync(
 procedure()
 begin
    FAIDemo2Main.AniIndicator1.Enabled := false;
    FAIDemo2Main.AniIndicator1.Visible := false;
    Memo2.Text:=RESTResponse1.StatusCode.ToString;
    if RESTResponse1.StatusCode = 200 then
    begin
       Showmessage(RESTResponse1.Content);
       Memo2.Text := '';
       LJsonValue:=TJSonObject.ParseJSONValue(RESTResponse1.Content);
       LJsonValueCh:=LJsonValue.GetValue<TJSonValue>('choices');
       if LJsonValueCh is TJSonArray then
        begin
          LJSonArray := LJsonValueCh as TJSonArray;
          LJSonString:=LJSonArray.Items[0].GetValue<TJSONString>('text');
          Showmessage(LJSonString.Value);
          var strtmp := LJSonString.Value;
//          strtmp := strtmp.Substring(strtmp.IndexOf('```pascal')+10);
//          strtmp := strtmp.Substring(0,strtmp.IndexOf('```')-1);
          Memo2.Text:=(strtmp.Replace('\n',sLinebreak).Trim);
          //Memo2.SelectAll;Memo2.CutToClipboard;Memo2.PasteFromClipboard;
        end;
        FreeAndNil(LJsonValue);
    end;
 end,
 True,
 True,
  procedure(Exception : TObject)
  begin
    FAIDemo2Main.AniIndicator1.Enabled := false;
    FAIDemo2Main.AniIndicator1.Visible := false;
    TDialogServiceAsync.ShowMessage('Sprawdü po≥πczenie sieciowe!')

  end
  );

end;


end.
