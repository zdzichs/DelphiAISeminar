unit UAIDemo4Main;

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

uses OpenAI, OpenAI.Completions, System.Threading;

{$R *.fmx}

procedure TFOpenAIDemoMain.ButtonSendRequestClick(Sender: TObject);
const
 API_TOKEN = 'klucz_openai';
begin
 MemoResult.Lines.Clear;
 TTask.Run(
  procedure
  begin
    var OpenAI: IOpenAI := TOpenAI.Create(API_TOKEN);
    var Completions := OpenAI.Completion.Create(
                      procedure(Params: TCompletionParams)
                      begin
                        Params.Prompt(MemoQuestion.Text);
                        Params.MaxTokens(2048);
                        Params.Temperature(0);
                      end);
    TThread.Synchronize(nil,
           procedure
           begin
               try
                  for var Choice in Completions.Choices do
                    MemoResult.Lines.Add(Choice.Text.Trim);
               finally
                  Completions.Free;
               end;
           end
      );

  end
 );





end;

end.
