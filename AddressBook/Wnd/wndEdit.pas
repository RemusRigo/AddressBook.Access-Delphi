unit wndEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Tabs, TabNotBk, ExtCtrls;

type
   TfrmEdit = class(TForm)
      btnOk: TButton;
    edID: TEdit;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    lblFirstName: TLabel;
    edBirthD: TEdit;
    edBirthM: TEdit;
    edBirthName: TEdit;
    edBirthY: TEdit;
    edFirstName: TEdit;
    edLastName: TEdit;
    lblBirthD: TLabel;
    lblBirthDate: TLabel;
    lblBirthM: TLabel;
    lblBirthY: TLabel;
    lblLastName: TLabel;
    lblBirthName: TLabel;
    procedure FormShow(Sender: TObject);
      private
      public
         IsNew : Boolean;
end;

var
  frmEdit: TfrmEdit;

implementation

uses wndAgenda;

{$R *.dfm}

procedure TfrmEdit.FormShow(Sender: TObject);
begin
   if not IsNew then
   begin
      with frmAgenda do
      begin
         edID.Text:=qryContactsID.AsString;
         edFirstName.Text:=qryContactsFirstName.AsString;
         edBirthName.Text:=qryContactsBirthName.AsString;
         edLastName.Text:=qryContactsLastName.AsString;
         edBirthY.Text:=qryContactsBirthY.AsString;
         edBirthM.Text:=qryContactsBirthM.AsString;
         edBirthD.Text:=qryContactsBirthD.AsString;
      end;
   end
end;

end.
