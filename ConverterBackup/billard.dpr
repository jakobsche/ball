program Billard;

uses
  Forms,
  Unit1 in 'UNIT1.PAS' {Form1},
  Balldlg in 'BALLDLG.PAS' {BallDialog},
  Drawings in 'DRAWINGS.PAS';

{$R *.RES}

begin
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TBallDialog, BallDialog);
  Application.Run;
end.
