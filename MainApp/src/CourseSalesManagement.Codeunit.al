codeunit 50100 "Course Sales Management"
{
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnAfterAssignFieldsForNo, '', false, false)]
    local procedure OnAfterAssignFieldsForNo_SalesLine(var SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header")
    begin
        if SalesLine.Type <> SalesLine.Type::Course then
            exit;

        CopyFromCourse(SalesLine, SalesHeader);
    end;

    local procedure CopyFromCourse(var SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header")
    var
        Res: Record Course;
    begin
        Res.Get(SalesLine."No.");
        Res.TestField("Gen. Prod. Posting Group");
        SalesLine.Description := Res.Name;
        SalesLine."Unit Price" := Res.Price;
        SalesLine."Gen. Prod. Posting Group" := Res."Gen. Prod. Posting Group";
        SalesLine."VAT Prod. Posting Group" := Res."VAT Prod. Posting Group";
        SalesLine."Allow Item Charge Assignment" := false;
        OnAfterAssignResourceValues(SalesLine, Res, SalesHeader);
    end;

    [IntegrationEvent(false, false)]
    procedure OnAfterAssignResourceValues(var SalesLine: Record "Sales Line"; Res: Record Course; SalesHeader: Record "Sales Header")
    begin
    end;

    [EventSubscriber(ObjectType::Table, Database::"Option Lookup Buffer", OnBeforeIncludeOption, '', false, false)]
    local procedure "Option Lookup Buffer_OnBeforeIncludeOption"(OptionLookupBuffer: Record "Option Lookup Buffer" temporary; LookupType: Option; Option: Integer; var Handled: Boolean; var Result: Boolean; RecRef: RecordRef)
    begin
        if LookupType <> Enum::"Option Lookup Type"::Sales.AsInteger() then
            exit;

        if Option <> Enum::"Sales Line Type"::Course.AsInteger() then
            exit;

        Handled := true;
        Result := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnAfterValidateEvent, Quantity, false, false)]
    local procedure SalesLine_OnAfterValidateEvent_Quantity(var Rec: Record "Sales Line")
    begin
        CheckSalesForCourseEdition(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnAfterValidateEvent, "Course Edition", false, false)]
    local procedure SalesLine_OnAfterValidateEvent_CourseEdition(var Rec: Record "Sales Line")
    begin
        CheckSalesForCourseEdition(Rec);
    end;

    local procedure CheckSalesForCourseEdition(var SalesLine: Record "Sales Line")
    var
        CourseEdition: Record "Course Edition";
        // MaxStudentsEceeded: TextConst ESP = 'Con la venta actual (%2) más las ventas previas (%3) se superará el número máximo de alumnos permitos (%1) para este curso', ENU = 'With the current sale (%2) plus the previous sales (%3) the maximum number of students allowed (%1) for this course will be exceeded';
        MaxStudentsEceededMsg: Label 'With the current sale (%2) plus the previous sales (%3) the maximum number of students allowed (%1) for this course will be exceeded', Comment = 'ESP="Con la venta actual (%2) más las ventas previas (%3) se superará el número máximo de alumnos permitos (%1) para este curso"';
    begin
        if SalesLine.Type <> SalesLine.Type::Course then
            exit;
        if (SalesLine.Quantity = 0) or (SalesLine."Course Edition" = '') then
            exit;

        CourseEdition.SetLoadFields("Max. Students", "Sales (Qty.)");
        CourseEdition.Get(SalesLine."No.", SalesLine."Course Edition");
        CourseEdition.CalcFields("Sales (Qty.)");

        if (CourseEdition."Sales (Qty.)" + SalesLine.Quantity) > CourseEdition."Max. Students" then
            Message(MaxStudentsEceededMsg, CourseEdition."Max. Students", SalesLine.Quantity, CourseEdition."Sales (Qty.)");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnPostSalesLineOnBeforePostSalesLine, '', false, false)]
    local procedure "Sales-Post_OnPostSalesLineOnBeforePostSalesLine"(SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; GenJnlLineDocNo: Code[20]; GenJnlLineExtDocNo: Code[35]; GenJnlLineDocType: Enum "Gen. Journal Document Type"; SrcCode: Code[10]; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; var IsHandled: Boolean; SalesLineACY: Record "Sales Line")
    begin
        if SalesLine.Type <> SalesLine.Type::Course then
            exit;

        PostCourseJournalLine(SalesHeader, SalesLine, GenJnlLineDocNo, GenJnlLineExtDocNo, SrcCode);
    end;

    local procedure PostCourseJournalLine(var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; GenJnlLineDocNo: Code[20]; GenJnlLineExtDocNo: Code[35]; SrcCode: Code[10])
    var
        CourseJournalLine: Record "Course Journal Line";
        CourseJournalPostLine: Codeunit "Course Journal-Post Line";
        ShouldExit: Boolean;
    begin
        ShouldExit := SalesLine."Qty. to Invoice" = 0;
        if ShouldExit then
            exit;

        CourseJournalLine.Init();
        CourseJournalLine.CopyFromSalesHeader(SalesHeader);
        CourseJournalLine.CopyDocumentFields(GenJnlLineDocNo, GenJnlLineExtDocNo, SrcCode, SalesHeader."Posting No. Series");
        CourseJournalLine.CopyFromSalesLine(SalesLine);

        CourseJournalPostLine.RunWithCheck(CourseJournalLine);
    end;
}