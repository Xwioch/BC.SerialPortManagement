page 61001 "SPM Serial Port Conn. Subform"
{
    Caption = 'Serial Port Connectionn Subform (SPM)';
    PageType = ListPart;
    UsageCategory = None;
    SourceTable = "SPM Serial Port Buffer";
    SourceTableTemporary = true;
    Editable = false;
    SourceTableView = sorting("Entry No.") order(descending);

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Direction; Rec.Direction)
                {
                    ToolTip = 'Specifies the direction of the message';
                    StyleExpr = LineStyle;
                    ApplicationArea = All;
                }
                field(Message; Rec.Message)
                {
                    ToolTip = 'Specifies the content of the message';
                    StyleExpr = LineStyle;
                    ApplicationArea = All;
                }
                field("Date-Time"; Rec."Date-Time")
                {
                    ToolTip = 'Specifies the date-time of the creation of the message';
                    StyleExpr = LineStyle;
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        LineStyle := '';

        case Rec.Direction of
            Rec.Direction::Inbound:
                LineStyle := 'StrongAccent';
        end;
    end;

    procedure AddMessage(Direction: Option "Inbound","Outbound"; Message: Text)
    var
        EntryNo: Integer;
        MessageToWrite: Text;
    begin
        if Message = '' then
            exit;

        EntryNo := 1;
        MessageToWrite := Message;

        Rec.Reset();
        IF Rec.FindLast() then
            EntryNo := Rec."Entry No." + 1;

        Rec.Init();
        Rec."Entry No." := EntryNo;
        Rec.Direction := Direction;

        repeat
            Rec.Message := CopyStr(MessageToWrite, 1, MaxStrLen(Rec.Message));
            Rec."Date-Time" := CurrentDateTime;
            Rec.Insert();

            if StrLen(MessageToWrite) > MaxStrLen(Rec.Message) then
                MessageToWrite := CopyStr(MessageToWrite, MaxStrLen(Rec.Message), StrLen(MessageToWrite))
            else
                MessageToWrite := '';
        until MessageToWrite = '';

        Rec.Reset();
        if Rec.FindSet() then;
    end;

    procedure ClearTerminal()
    begin
        Rec.Reset();
        Rec.DeleteAll();
    end;

    var
        LineStyle: Text;
}