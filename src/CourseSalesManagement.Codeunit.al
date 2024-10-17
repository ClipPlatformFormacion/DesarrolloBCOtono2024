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
}