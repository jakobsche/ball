unit UNIT1;

{$MODE Delphi}

interface

uses
  SysUtils, LCLIntf, LCLType, LMessages, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls, BALLS, StdCtrls, Menus;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    MenuBall: TMenuItem;
    Neu1: TMenuItem;
    N1: TMenuItem;
    Beenden1: TMenuItem;
    ItemDelete: TMenuItem;
    Box: TPanel;
    StopItem: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure Beenden1Click(Sender: TObject);
    procedure ItemDeleteClick(Sender: TObject);
    procedure Neu1Click(Sender: TObject);
    procedure StopItemClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    Ball1, Ball2: TBall;
    BallGroup: TBallGroup;
    procedure BallMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CancelDelete;
  end;

var
  Form1: TForm1;

implementation

uses BALLDLG;

{$R *.lfm}

procedure TForm1.BallMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Box.Cursor = crCross then begin
    (Sender as TBall).Free;
    CancelDelete;
  end
end;

procedure TForm1.CancelDelete;
begin
    Box.Cursor := crDefault;
    ItemDelete.Caption := '&Löschen'
end;

procedure TForm1.FormCreate(Sender: TObject);
var Ball: TBall;
begin
  BallGroup := TBallGroup.Create(Self);
  BallGroup.Parent := Box;
  Ball := BallGroup.Balls[BallGroup.NewBall(15, Point(80, 80), Point(15, 5),
    bsNormal, clWhite)];
  Ball.OnMouseDown := BallMouseDown;
  Ball := BallGroup.Balls[BallGroup.NewBall(8, Point(20, 80), Point(-30, 10),
    bsNormal, clRed)];
  Ball.OnMouseDown := BallMouseDown;
end;

procedure TForm1.Beenden1Click(Sender: TObject);
begin
  Close
end;

procedure TForm1.ItemDeleteClick(Sender: TObject);
begin
  if Box.Cursor = crDefault then begin
    Box.Cursor := crCross;
    ItemDelete.Caption := '&Löschen abbrechen';
  end
  else CancelDelete
end;

procedure TForm1.Neu1Click(Sender: TObject);
var Ball: TBall;
begin
  with BallDialog do
    if ShowModal = mrOK then begin
      Ball := BallGroup.Balls[BallGroup.NewBall(
        Radius, Pos, Speed, bsNormal, BallColor)];
      Ball.OnMouseDown := BallMouseDown;
    end
end;

procedure TForm1.StopItemClick(Sender: TObject);
begin
  if BallGroup.Stopped then begin
    BallGroup.Go;
    StopItem.Caption := '&Stop'
  end
  else begin
    BallGroup.Stop;
    StopItem.Caption := '&Weiter'
  end
end;

end.
