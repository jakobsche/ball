unit BALLDLG;

{$MODE Delphi}

interface

uses LCLIntf, LCLType, LMessages, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, Dialogs, ExtCtrls, BALLS;

type
  TBallDialog = class(TForm)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    HelpBtn: TBitBtn;
    Bevel1: TBevel;
    ColorDialog: TColorDialog;
    ButtonColor: TSpeedButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    EditPosX: TEdit;
    EditPosY: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    EditSpeedX: TEdit;
    EditSpeedY: TEdit;
    Label8: TLabel;
    EditInterval: TEdit;
    Label9: TLabel;
    Label7: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    EditRadius: TEdit;
    ColorDisplay: TShape;
    procedure ButtonColorClick(Sender: TObject);
  private
    { Private declarations }
    function GetBallColor: TColor;
    procedure SetBallColor(Value: TColor);
    function GetPos: TPoint;
    function GetRadius: Integer;
    function GetSpeed: TPoint;
  public
    { Public declarations }
    property BallColor: TColor read GetBallColor write SetBallColor;
    property Pos: TPoint read GetPos;
    property Radius: Integer read GetRadius;
    property Speed: TPoint read GetSpeed;
  end;

var
  BallDialog: TBallDialog;

implementation

uses SysUtils;

{$R *.lfm}

function TBallDialog.GetBallColor: TColor;
begin
  Result := ColorDisplay.Brush.Color;
end;

procedure TBallDialog.SetBallColor(Value: TColor);
begin
  ColorDisplay.Brush.Color := Value;
  ColorDisplay.Brush.Color := Value;
end;

function TBallDialog.GetPos: TPoint;
begin
  Result := Point(StrToInt(EditPosX.Text), StrToInt(EditPosY.Text));
end;

function TBallDialog.GetRadius: Integer;
begin
  Result := StrToInt(EditRadius.Text);
end;

function TBallDialog.GetSpeed: TPoint;
begin
  Result := Point(StrToInt(EditSpeedX.Text), StrToInt(EditSpeedY.Text))
end;

procedure TBallDialog.ButtonColorClick(Sender: TObject);
begin
  if ColorDialog.Execute then BallColor := ColorDialog.Color
end;

end.
