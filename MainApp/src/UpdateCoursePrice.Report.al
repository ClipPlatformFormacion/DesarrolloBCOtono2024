report 50100 "Update Course Price"
{
    Caption = 'Update Course Price', comment = 'ESP="Actualizar Precio de Curso"';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Course; Course)
        {
            RequestFilterFields = "No.", Price, "Duration (hours)";

            trigger OnAfterGetRecord()
            begin
                Counter += 1;
                Course.Validate(Price, Course.Price * (1 + Percentaje / 100));
                Course.Modify();
            end;

            trigger OnPostDataItem()
            var
                UpdatedCourseMsg: Label '%1 courses have been updated', Comment = 'ESP="Se han actualizado %1 cursos"';
            begin
                Message(UpdatedCourseMsg, Counter);
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options', comment = 'ESP="Opciones"';
                    field(PercentajeControl; Percentaje)
                    {
                        Caption = 'Percentaje', comment = 'ESP="Porcentaje"';
                        ApplicationArea = All;
                    }
                }
            }
        }

        trigger OnOpenPage()
        begin
            Percentaje := 10;
        end;
    }

    trigger OnPreReport()
    begin
        if Percentaje = 0 then
            Error('The percentage cannot be zero');
    end;

    trigger OnPostReport()
    begin
        UpdatePriceLog.Init();
        UpdatePriceLog.Percentaje := Percentaje;
        UpdatePriceLog."Filters Used" := CopyStr(Course.GetFilters(), 1, MaxStrLen(UpdatePriceLog."Filters Used"));
        UpdatePriceLog.Insert(true);
    end;

    var
        UpdatePriceLog: Record "Update Price Log";
        Counter: Integer;
        Percentaje: Decimal;
}