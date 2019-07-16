{
Zur VCL kompatible grafische Objekte, die keine Windows-Ressourcen brauchen und
intern Vektorgrafiken anlegen, die man auch als Dateien speichern kann
}
unit DRAWINGS;

{$MODE Delphi}

interface

uses Classes, Graphics, SysUtils;

type

  TVectorBrush = class(TPersistent)
  private
    FBitmap: TBitmap;
    FColor: TColor;
    FStyle: TBrushStyle;
    function GetBitmap: TBitmap;
    procedure SetBitmap(Value: TBitmap);
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    destructor Destroy; override;
    property Bitmap: TBitmap read GetBitmap write SetBitmap;
  published
    property Color: TColor read FColor write FColor;
    property Style: TBrushStyle read FStyle write FStyle;
  end;

  TVectorCanvas = class(TPersistent)
  private
    FBrush: TVectorBrush;
    FOnChange, FOnChanging: TNotifyEvent;
    function GetBrush: TVectorBrush;
    procedure SetBrush(Value: TVectorBrush);
  protected
    procedure Changed; virtual;
    procedure Changing; virtual;
  public
    destructor Destroy; override;
  published
    property Brush: TVectorBrush read GetBrush write SetBrush;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnChanging: TNotifyEvent read FOnChanging write FOnChanging;
  end;

implementation

function TVectorBrush.GetBitmap: TBitmap;
begin
  if not Assigned(FBitmap) then FBitmap := TBitmap.Create;
  Result := FBitmap;
end;

procedure TVectorBrush.SetBitmap(Value: TBitmap);
begin
  GetBitmap.Assign(Value)
end;

procedure TVectorBrush.AssignTo(Dest: TPersistent);
begin
  try
    (Dest as TVectorBrush).Bitmap := Bitmap;
    (Dest as TVectorBrush).Color := Color;
    (Dest as TVectorBrush).Style := Style;
  except
    on EInvalidCast do
      try
       (Dest as TBrush).Bitmap := Bitmap;
       (Dest as TBrush).Color := Color;
       (Dest as TBrush).Style := Style;
      except
        on EInvalidCast do inherited AssignTo(Dest)
      end
  end
end;

destructor TVectorBrush.Destroy;
begin
  FBitmap.Free;
  inherited Destroy
end;

function TVectorCanvas.GetBrush: TVectorBrush;
begin
  if not Assigned(FBrush) then FBrush := TVectorBrush.Create;
  Result := FBrush;
end;

procedure TVectorCanvas.SetBrush(Value: TVectorBrush);
begin
  GetBrush.Assign(Value)
end;

procedure TVectorCanvas.Changed;
begin
  if Assigned(FOnChange) then FOnChange(Self)
end;

procedure TVectorCanvas.Changing;
begin
  if Assigned(FOnChanging) then FOnChanging(Self)
end;

destructor TVectorCanvas.Destroy;
begin
  FBrush.Free;
  inherited Destroy;
end;

end.
