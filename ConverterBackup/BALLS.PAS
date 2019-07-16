unit Balls;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls;

type

{ Gruppe für Bälle, enthält gemeinsam genutzte Systemressourcen für alle
  darin enthaltenen TBall-Objekte }
  TBall = class;
  TBallStatus = (bsNormal, bsStopped);
  TBallGroup = class(TComponent)
  private
    FBallList: TList;
    FParent: TWinControl;
    FTimer: TTimer;
    FStopped: Boolean;
    function GetBallList: TList;
    function GetBalls(I: Integer): TBall;
    function GetTimer: TTimer;
    function GetInterval: Integer;
    procedure SetInterval(Value: Integer);
    procedure TimerEvent(Sender: TObject);
    property BallList: TList read GetBallList;
    property Timer: TTimer read GetTimer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Go;
    procedure InsertBall(ABall: TBall);
    function NewBall(ARadius: Integer; APos, ASpeed: TPoint;
      AStatus: TBallStatus; AColor: TColor): Integer;
    procedure RemoveBall(ABall: TBall);
    procedure Stop;
    property Balls[I: Integer]: TBall read GetBalls;
    property Stopped: Boolean read FStopped;
  published
    property Interval: Integer read GetInterval write SetInterval;
    property Parent: TWinControl read FParent write FParent;
  end;

{ Klasse für Kugeln }

  TBall = class(TShape)
  private
    { Private-Deklarationen }
    FRadius: Integer;
    FStatus: TBallStatus;
    FPos, FInitialSpeed: TPoint;
    FTimer: TTimer;
    FOnMouseOver: TMouseMoveEvent;
    {XPlace, YPlace: TBallPlace;}
    function GetTimer: TTimer;
    procedure SetTimer(Value: TTimer);
    procedure SetPos(Value: TPoint);
    function GetInterval: Integer;
    procedure SetInterval(Value: Integer);
    procedure SetRadius(Value: Integer);
    procedure TimerEvent(Sender: TObject);
  protected
    { Protected-Deklarationen }
    procedure AssignTo(Dest: TPersistent); override;
  public
    { Public-Deklarationen }
    Speed: TPoint;
    constructor Create(AOwner: TComponent); override;
    procedure Step;
    property InitialSpeed: TPoint read FInitialSpeed write FInitialSpeed;
    property Pos: TPoint read FPos write SetPos;
  published
    { Published-Deklarationen }
    property Interval: Integer read GetInterval write SetInterval;
    property Radius: Integer read FRadius write SetRadius;
    property Status: TBallStatus read FStatus write FStatus;
    property Timer: TTimer read GetTimer write SetTimer;
    property OnMouseOver: TMouseMoveEvent read FOnMouseOver write FOnMouseOver;
  end;

procedure Register;

implementation

function TBallGroup.GetBallList: TList;
begin
  if not Assigned(FBallList) then FBallList := TList.Create;
  Result := FBallList
end;

function TBallGroup.GetBalls(I: Integer): TBall;
begin
  Result := BallList[I]
end;

function TBallGroup.GetTimer: TTimer;
begin
  if not Assigned(FTimer) then begin
    FTimer := TTimer.Create(Self);
    FTimer.OnTimer := TimerEvent;
  end;
  Result := FTimer;
end;

function TBallGroup.GetInterval: Integer;
begin
  Result := Timer.Interval
end;

procedure TBallGroup.SetInterval(Value: Integer);
begin
  Timer.Interval := Value
end;

constructor TBallGroup.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Interval := 40;
end;

destructor TBallGroup.Destroy;
begin
  Stop;
  FBallList.Free;
  inherited Destroy
end;

procedure TBallGroup.Go;
begin
  FStopped := False;
end;

procedure TBallGroup.InsertBall(ABall: TBall);
begin
  ABall.Timer := Timer;
  InsertComponent(ABall);
  ABall.Parent := Parent;
  BallList.Add(ABall);
end;

function TBallGroup.NewBall(ARadius: Integer; APos, ASpeed: TPoint;
      AStatus: TBallStatus; AColor: TColor): Integer;
var
  Ball: TBall;
begin
  Ball := TBall.Create(Self);
  Ball.Parent := Parent;
  with Ball do begin
    Radius := ARadius;
    Pos := APos;
    Speed := ASpeed;
    Status := AStatus;
    Brush.Color := AColor;
    Timer.OnTimer := nil;
  end;
  Result := BallList.Add(Ball)
end;

procedure TBallGroup.RemoveBall(ABall: TBall);
begin
  BallList.Remove(ABall);
  BallList.Pack;
  ABall.Free
end;

procedure TBallGroup.Stop;
begin
  FStopped := True;
end;

procedure TBallGroup.TimerEvent(Sender: TObject);
var
  i: Integer;
begin
  if not Stopped then for i := 0 to BallList.Count - 1 do Balls[i].Step
end;

procedure TBall.SetPos(Value: TPoint);
begin
  FPos := Value;
  Left := FPos.X - Radius;
  Top := FPos.Y - Radius;
end;

function TBall.GetInterval: Integer;
begin
  Result := Timer.Interval
end;

procedure TBall.SetInterval(Value: Integer);
begin
  if Timer.Owner = Self then Timer.Interval := Value
end;

procedure TBall.SetRadius(Value: Integer);
begin
  FRadius := Value;
  Width := 2 * Value;
  Height := 2 * Value;
end;

function TBall.GetTimer: TTimer;
begin
    if not Assigned(FTimer) then begin
      FTimer := TTimer.Create(Self);
      FTimer.Interval := 40;
      FTimer.OnTimer := TimerEvent;
    end;
    Result := FTimer
end;

procedure TBall.SetTimer(Value: TTimer);
begin
  if FTimer <> Value then begin
    if FTimer.Owner = Self then FTimer.Free;
    FTimer := Value
  end
end;

procedure TBall.TimerEvent(Sender: TObject);
begin
  Step;
end;

procedure TBall.AssignTo(Dest: TPersistent);
begin
  (Dest as TBall).Brush := Brush;
  (Dest as TBall).Pos := Pos;
  (Dest as TBall).Radius := Radius;
  (Dest as TBall).Speed := Speed;
  (Dest as TBall).Brush := Brush
end;

constructor TBall.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Shape := stCircle;
  Interval := 40;
  Pos := Point(Radius + 1, Radius + 1);
  Timer.OnTimer := TimerEvent;
  Font.Size := 24;
  Font.Color := clBlack;
end;

procedure TBall.Step;
var PosLeft, PosRight, PosTop, PosBottom: Boolean;
begin
  if Parent <> nil then begin
    Pos := Point(Pos.X + Speed.X, Pos.Y + Speed.Y);
    PosLeft := Pos.X < Radius;
    PosRight := Pos.X > Parent.ClientWidth - Radius;
    PosTop := Pos.Y < Radius;
    PosBottom := Pos.Y > Parent.ClientHeight - Radius;
    if (Status <> bsStopped) then begin
      if (Speed.X = 0) and (Speed.Y = 0) then Speed := InitialSpeed
    end
    else if (Speed.X <> 0) or (Speed.Y <> 0) then Speed := Point(0, 0);
    if PosLeft and (Speed.X < 0) or PosRight and (Speed.X > 0) then
      Speed.X := -Speed.X;
    if PosTop and (Speed.Y < 0) or PosBottom and (Speed.Y > 0) then
      Speed.Y := -Speed.Y;
  end
end;

procedure Register;
begin
  RegisterComponents('Jakobsche', [TBall, TBallGroup]);
end;

end.
