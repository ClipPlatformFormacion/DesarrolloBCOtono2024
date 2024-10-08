table 50100 Course
{
    CaptionML = ENU = 'Course', ESP = 'Curso';

    fields
    {
        field(1; "No."; Code[20])
        {
            CaptionML = ENU = 'No.', ESP = 'Nº';

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
                    NoSeries.TestManual(ResSetup."Resource Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; Name; Text[100])
        {
            CaptionML = ENU = 'Name', ESP = 'Nombre';
        }
        field(3; "Content Description"; Text[2048])
        {
            CaptionML = ENU = 'Content Description', ESP = 'Temario';
        }
        field(4; "Duration (hours)"; Integer)
        {
            CaptionML = ENU = 'Duration (hours)', ESP = 'Duración (horas)';
        }
        field(5; Price; Decimal)
        {
            CaptionML = ENU = 'Price', ESP = 'Precio';
        }
        field(6; "Language Code"; Code[10])
        {
            CaptionML = ENU = 'Language Code', ESP = 'Cód. idioma';
            TableRelation = Language;
        }
        field(7; "Type (Option)"; Option)
        {
            CaptionML = ENU = 'Type (Option)', ESP = 'Tipo (Option)';
            OptionMembers = " ","Instructor-Lead","Video Tutorial";
            OptionCaptionML = ENU = ' ,Instructor-Lead,Video Tutorial', ESP = ' ,Con profesor,Vídeo Tutorial';
        }
        field(8; Type; Enum "Course Type")
        {
            CaptionML = ENU = 'Type', ESP = 'Tipo';
        }

        field(56; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
    }

    trigger OnInsert()
    var
        Resource: Record Resource;
#if not CLEAN24        
        NoSeriesMgt: Codeunit NoSeriesManagement;
#endif
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeOnInsert(Rec, IsHandled, xRec);
        if IsHandled then
            exit;

        if "No." = '' then begin
            ResSetup.Get();
            ResSetup.TestField("Resource Nos.");
#if not CLEAN24
            NoSeriesMgt.RaiseObsoleteOnBeforeInitSeries(ResSetup."Resource Nos.", xRec."No. Series", 0D, "No.", "No. Series", IsHandled);
            if not IsHandled then begin
#endif
                "No. Series" := ResSetup."Resource Nos.";
                if NoSeries.AreRelated("No. Series", xRec."No. Series") then
                    "No. Series" := xRec."No. Series";
                "No." := NoSeries.GetNextNo("No. Series");
                Resource.ReadIsolation(IsolationLevel::ReadUncommitted);
                Resource.SetLoadFields("No.");
                while Resource.Get("No.") do
                    "No." := NoSeries.GetNextNo("No. Series");
#if not CLEAN24
                NoSeriesMgt.RaiseObsoleteOnAfterInitSeries("No. Series", ResSetup."Resource Nos.", 0D, "No.");
            end;
#endif
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
        ResSetup.TestField("Resource Nos.");
        if NoSeries.LookupRelatedNoSeries(ResSetup."Resource Nos.", OldRes."No. Series", Res."No. Series") then begin
            Res."No." := NoSeries.GetNextNo(Res."No. Series");
            Rec := Res;
            exit(true);
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeValidateNo(var Resource: Record Course; xResource: Record Course; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeOnInsert(var Resource: Record Course; var IsHandled: Boolean; var xResource: Record Course)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeAssistEdit(var Resource: Record Course; xOldRes: Record Course; var IsHandled: Boolean; var Result: Boolean)
    begin
    end;

    var
        NoSeries: Codeunit "No. Series";
        ResSetup: Record "Resources Setup";
        Res: Record Course;
}