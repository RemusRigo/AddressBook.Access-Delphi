unit wndAgenda;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, ComCtrls, DB, ADODB, Grids, DBGrids, DBTables, ToolWin,
  ActnList, System.Actions, System.ImageList;

type
   TfrmAgenda = class(TForm)
      DataSource      : TDataSource;
      ADOConnection   : TADOConnection;
      qryContacts     : TADOQuery;
      qryAux          : TADOQuery;
      StatusBar       : TStatusBar;
      lvContacts      : TListView;
      tbMain          : TToolBar;
      tbMain_New      : TToolButton;
      tbMain_Alarm    : TToolButton;
      imgLstSmall     : TImageList;
      imgLstButtons   : TImageList;
      ActionList      : TActionList;
      acContact_New   : TAction;
      acGeneral_Alarm : TAction;
    qryContactsID: TAutoIncField;
    qryContactsFirstName: TWideStringField;
    qryContactsBirthName: TWideStringField;
    qryContactsLastName: TWideStringField;
    qryContactsBirthY: TSmallintField;
    qryContactsBirthM: TWordField;
    qryContactsBirthD: TWordField;
    qryAuxID: TAutoIncField;
    qryAuxFirstName: TWideStringField;
    qryAuxBirthName: TWideStringField;
    qryAuxLastName: TWideStringField;
    qryAuxBirthY: TSmallintField;
    qryAuxBirthM: TWordField;
    qryAuxBirthD: TWordField;
    acContact_Edit: TAction;
    ToolButton1: TToolButton;
      procedure FormCreate(Sender: TObject);
      procedure ListView_ResizeColumns;
      procedure lvContacts_ColumnClick(Sender: TObject; Column: TListColumn);
      procedure FormShow(Sender: TObject);
      procedure acContact_NewExecute(Sender: TObject);
      procedure acGeneral_AlarmExecute(Sender: TObject);
      procedure lvContactsDblClick(Sender: TObject);
    procedure acContact_EditExecute(Sender: TObject);
      private
      public
         function GetNextID(table : string): integer;
         procedure LoadContacts;
   end;

var
  frmAgenda : TfrmAgenda;

implementation

uses
   wndEdit, wndContact, wndAlarm;

var
   srtAsc         : Boolean;
   lastSortCol    : Integer;

{$R *.dfm}

//-------------------------------------------------------------------------------------------------

function SortByColumn(Item1, Item2: TListItem; Data: integer): integer; stdcall;
begin
   if Data = 0 then
      Result:=AnsiCompareText(Item1.Caption, Item2.Caption)
   else
      Result:=AnsiCompareText(Item1.SubItems[Data-1], Item2.SubItems[Data-1]);
   if not srtAsc then
      Result:=-Result;
end;

//-------------------------------------------------------------------------------------------------

function TfrmAgenda.GetNextID(table : string) : Integer;
begin
   qryAux.Close;
   qryAux.SQL.Text:='SELECT MAX(ID) AS MID FROM '+table;
   qryAux.Open;
   Result:=qryAux.Fields[0].AsInteger+1;
end;

//-------------------------------------------------------------------------------------------------

procedure TfrmAgenda.LoadContacts;
var
   li : TListItem;
begin
   lvContacts.Clear;
   qryContacts.Close;
   qryContacts.SQL.Text:='SELECT * FROM tblContacts ORDER BY LastName, FirstName ASC';
   qryContacts.Active:=TRUE;
   qryContacts.Open;
   if qryContacts.FindFirst then
   repeat
      li:=lvContacts.Items.Add;
      li.ImageIndex:=-1;
      li.Caption:=qryContacts.FieldByName('ID').AsString;
      li.SubItems.Add(qryContacts.FieldByName('FirstName').AsString);
      li.SubItems.Add(qryContacts.FieldByName('LastName').AsString);
      li.SubItems.Add(qryContacts.FieldByName('BirthY').AsString+'.'+
         qryContacts.FieldByName('BirthM').AsString+'.'+
         qryContacts.FieldByName('BirthD').AsString);
   until not qryContacts.FindNext;
   ListView_ResizeColumns;
end;

//-------------------------------------------------------------------------------------------------

procedure TfrmAgenda.ListView_ResizeColumns;
var
   i, j : Integer;
   newWidth : Integer;
   oldWidth : Integer;
   li   : TListItem;
   dc   : HDC;
   tm   : TTextMetric;
begin
   dc:=GetDC(lvContacts.Handle);
   GetTextMetrics(dc, tm);
   for i:=0 to lvContacts.Columns.Count-1 do
      for j:=0 to lvContacts.Items.Count-1 do
      begin
         li:=lvContacts.Items.Item[j];
         if i=0 then
         begin
            oldWidth:=lvContacts.Columns[0].Width;
            newWidth:=Length(li.Caption)*tm.tmAveCharWidth;
            if newWidth>oldWidth then
               lvContacts.Columns[0].Width:=newWidth;
         end
         else
         begin
            oldWidth:=lvContacts.Columns[i].Width;
            newWidth:=Length(li.SubItems.Strings[i-1])*tm.tmAveCharWidth;
            if newWidth>oldWidth then
               lvContacts.Columns[i].Width:=newWidth;
         end;
      end;
end;

procedure TfrmAgenda.lvContactsDblClick(Sender: TObject);
var
   li : TListItem;
begin
   li:=lvContacts.Items[lvContacts.ItemIndex];
   frmContact:=TfrmContact.Create(Self);
   frmContact.Show;

   qryAux.Close;
//   qryAux.SQL.Text:='SELECT * FROM tblContacts WHERE ID='''+li.Caption+'''';
   qryAux.SQL.Text:='SELECT * FROM tblContacts';
   qryAux.Open;
   while not qryContacts.Eof do
   begin
      if qryContacts.FieldByName('FirstName').AsString=li.Caption then
         ShowMessage('ok');
      qryContacts.Next;
   end;

end;

procedure TfrmAgenda.lvContacts_ColumnClick(Sender: TObject;
  Column: TListColumn);
begin
   if lvContacts.Columns[Column.ID].ImageIndex=-1  then
      lvContacts.Columns[Column.ID].ImageIndex:=0
   else if lvContacts.Columns[Column.ID].ImageIndex=0 then
      lvContacts.Columns[Column.ID].ImageIndex:=1
   else if lvContacts.Columns[Column.ID].ImageIndex=1 then
      lvContacts.Columns[Column.ID].ImageIndex:=0;

   case Column.ID of

      0:
      begin
         lvContacts.Columns[1].ImageIndex:=-1;
         lvContacts.Columns[2].ImageIndex:=-1;
         lvContacts.Columns[3].ImageIndex:=-1;
      end;

      1:
      begin
         lvContacts.Columns[0].ImageIndex:=-1;
         lvContacts.Columns[2].ImageIndex:=-1;
         lvContacts.Columns[3].ImageIndex:=-1;
      end;

      2:
      begin
         lvContacts.Columns[0].ImageIndex:=-1;
         lvContacts.Columns[1].ImageIndex:=-1;
         lvContacts.Columns[3].ImageIndex:=-1;
      end;

      3:
      begin
         lvContacts.Columns[0].ImageIndex:=-1;
         lvContacts.Columns[1].ImageIndex:=-1;
         lvContacts.Columns[2].ImageIndex:=-1;
      end;
   end;
   if Column.Index=lastSortCol then
      srtAsc:=not srtAsc
   else
      lastSortCol:=Column.Index;
   TListView(Sender).CustomSort(@SortByColumn, Column.Index);
end;

//-------------------------------------------------------------------------------------------------

procedure TfrmAgenda.acContact_NewExecute(Sender: TObject);
var
   nextID : Integer;
begin
   nextID:=GetNextID('tblContacts');
   ShowMessage(IntToStr(nextID));
   frmEdit:=TfrmEdit.Create(Self);
   frmEdit.IsNew:=True;
   if frmEdit.ShowModal=mrOK then
   begin
//      qryAux.Close;
      qryAux.SQL.Text:='INSERT INTO tblContacts (ID, FirstName, BirthName, LastName'+
         ', BirthY, BirthM, BirthD) Values('''+
         IntToStr(nextID)+''','''+
         frmEdit.edFirstName.Text+''','''+
         frmEdit.edBirthName.Text+''','''+
         frmEdit.edLastName.Text+''','''+
         frmEdit.edBirthY.Text+''','''+
         frmEdit.edBirthM.Text+''','''+
         frmEdit.edBirthD.Text+''''+
//         ', BirthY, BirthM, BirthD) Values('+
//         QuotedStr(IntToStr(GetNextID('tblContacts')))+
//         QuotedStr(frmEdit.edFirstName.Text)+
//         QuotedStr(frmEdit.edBirthName.Text)+
//         QuotedStr(frmEdit.edLastName.Text)+
//         QuotedStr(frmEdit.edBirthY.Text)+
//         QuotedStr(frmEdit.edBirthM.Text)+
//         QuotedStr(frmEdit.edBirthD.Text)+
         ')';
      qryAux.ExecSQL;
      qryAux.Close;
      LoadContacts;
   end;
   frmEdit.Free;
end;

//-------------------------------------------------------------------------------------------------

procedure TfrmAgenda.acContact_EditExecute(Sender: TObject);
var
   li : TListItem;
   id : Integer;
begin
   li:=lvContacts.Items[lvContacts.ItemIndex];
   qryContacts.Locate('ID', li.Caption, [loCaseInsensitive]);
   frmEdit:=TfrmEdit.Create(Self);
   frmEdit.IsNew:=False;
   if frmEdit.ShowModal=mrOk then
   begin
      id:=StrToInt(frmEdit.edID.Text);
      qryAux.SQL.Text:='UPDATE tblContacts SET FirstName='+
         QuotedStr(frmEdit.edFirstName.Text)+
         ' , BirthName='+
         QuotedStr(frmEdit.edBirthName.Text)+
         ' , LastName='+
         QuotedStr(frmEdit.edLastName.Text)+
         ' , BirthY='+
         QuotedStr(frmEdit.edBirthY.Text)+
         ' , BirthM='+
         QuotedStr(frmEdit.edBirthM.Text)+
         ' , BirthD='+
         QuotedStr(frmEdit.edBirthD.Text)+
         'WHERE ID='+IntToStr(id);
      qryAux.ExecSQL;
      qryAux.Close;
      LoadContacts;
   end;
   frmEdit.Free;
end;

//-------------------------------------------------------------------------------------------------

procedure TfrmAgenda.acGeneral_AlarmExecute(Sender: TObject);
begin
   frmAlarm:=TfrmAlarm.Create(Self);
   frmAlarm.ShowModal;
   FreeAndNil(frmAlarm);
end;

//-------------------------------------------------------------------------------------------------

procedure TfrmAgenda.FormShow(Sender: TObject);
begin
   LoadContacts;
end;

//-------------------------------------------------------------------------------------------------

procedure TfrmAgenda.FormCreate(Sender: TObject);
begin

end;

//-------------------------------------------------------------------------------------------------

end.
