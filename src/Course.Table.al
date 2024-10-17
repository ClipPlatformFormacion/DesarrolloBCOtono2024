namespace ClipPlatform.Course.MasterData;

using System.Globalization;
using Microsoft.Foundation.NoSeries;
using ClipPlatform.Course.Setup;
using Microsoft.Finance.VAT.Setup;
using Microsoft.Finance.GeneralLedger.Setup;

table 50100 Course
{
    Caption = 'Course', Comment = 'ESP="Curso"';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.', Comment = 'ESP="Nº"';
            ToolTip = 'una ayuda', Comment = 'ESP="Número identificativo del registro"';

            trigger OnValidate()
            var
                IsHandled: Boolean;
            begin
                IsHandled := false;
                OnBeforeValidateNo(Rec, xRec, IsHandled);
                if IsHandled then
                    exit;

                if "No." <> xRec."No." then begin
                    ResSetup.Get();
                    NoSeries.TestManual(ResSetup."Course Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; Name; Text[100])
        {
            Caption = 'Name', Comment = 'ESP="Nombre"';
            ToolTip = 'A name', Comment = 'ESP="Nombre del curso"';
        }
        field(3; "Content Description"; Text[2048])
        {
            Caption = 'Content Description', Comment = 'ESP="Temario"';
        }
        field(4; "Duration (hours)"; Integer)
        {
            Caption = 'Duration (hours)', Comment = 'ESP="Duración (horas)"';
        }
        field(5; Price; Decimal)
        {
            Caption = 'Price', Comment = 'ESP="Precio"';
        }
        field(6; "Language Code"; Code[10])
        {
            Caption = 'Language Code', Comment = 'ESP="Cód. idioma"';
            TableRelation = Language;
        }
        field(7; "Type (Option)"; Option)
        {
            Caption = 'Type (Option)', Comment = 'ESP="Tipo (Option)"';
            OptionMembers = " ","Instructor-Lead","Video Tutorial";
            OptionCaption = ' ,Instructor-Lead,Video Tutorial', Comment = 'ESP=" ,Con profesor,Vídeo Tutorial"';
        }
        field(8; Type; Enum "Course Type")
        {
            Caption = 'Type', Comment = 'ESP="Tipo"';
        }

        field(56; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(51; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group', Comment = 'ESP="Grupo registro prod."';
            TableRelation = "Gen. Product Posting Group";

            trigger OnValidate()
            var
                GenProdPostingGrp: Record "Gen. Product Posting Group";
            begin
                if xRec."Gen. Prod. Posting Group" <> "Gen. Prod. Posting Group" then
                    if GenProdPostingGrp.ValidateVatProdPostingGroup(GenProdPostingGrp, "Gen. Prod. Posting Group") then
                        Validate("VAT Prod. Posting Group", GenProdPostingGrp."Def. VAT Prod. Posting Group");
            end;
        }
        field(58; "VAT Prod. Posting Group"; Code[20])
        {
            Caption = 'VAT Prod. Posting Group', Comment = 'ESP="Grupo registro IVA Prod."';
            TableRelation = "VAT Product Posting Group";
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", Name, Type, "Language Code") { }
    }

    trigger OnInsert()
    var
        Course: Record Course;
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeOnInsert(Rec, IsHandled, xRec);
        if IsHandled then
            exit;

        if "No." = '' then begin
            ResSetup.Get();
            ResSetup.TestField("Course Nos.");
            "No. Series" := ResSetup."Course Nos.";
            if NoSeries.AreRelated("No. Series", xRec."No. Series") then
                "No. Series" := xRec."No. Series";
            "No." := NoSeries.GetNextNo("No. Series");
            Course.ReadIsolation(IsolationLevel::ReadUncommitted);
            Course.SetLoadFields("No.");
            while Course.Get("No.") do
                "No." := NoSeries.GetNextNo("No. Series");
        end;
    end;

    procedure AssistEdit(OldRes: Record Course) Result: Boolean
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeAssistEdit(Rec, OldRes, IsHandled, Result);
        if IsHandled then
            exit(Result);

        Res := Rec;
        ResSetup.Get();
        ResSetup.TestField("Course Nos.");
        if NoSeries.LookupRelatedNoSeries(ResSetup."Course Nos.", OldRes."No. Series", Res."No. Series") then begin
            Res."No." := NoSeries.GetNextNo(Res."No. Series");
            Rec := Res;
            exit(true);
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeValidateNo(var Course: Record Course; xCourse: Record Course; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeOnInsert(var Course: Record Course; var IsHandled: Boolean; var xCourse: Record Course)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeAssistEdit(var Course: Record Course; xOldRes: Record Course; var IsHandled: Boolean; var Result: Boolean)
    begin
    end;

    var
        ResSetup: Record "Courses Setup";
        Res: Record Course;
        NoSeries: Codeunit "No. Series";
}