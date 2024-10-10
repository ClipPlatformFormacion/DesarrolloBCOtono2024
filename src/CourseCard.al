page 50101 "Course Card"
{
    CaptionML = ENU = 'Course Card', ESP = 'Ficha curso';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = None;
    SourceTable = Course;

    layout
    {
        area(Content)
        {
            group(General)
            {
                CaptionML = ENU = 'General', ESP = 'General';
                field("No."; Rec."No.")
                {
                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
                }
                field(Name; Rec.Name) { }
                field(Type; Rec.Type) { }
            }
            part(CourseEditions; "Course Editions Factbox")
            {
                SubPageLink = "Course No." = field("No.");
            }
            group(TrainingDetails)
            {
                CaptionML = ENU = 'Training Details', ESP = 'Detalles formativos';
                field("Content Description"; Rec."Content Description") { }
                field("Duration (hours)"; Rec."Duration (hours)") { }
                field("Language Code"; Rec."Language Code") { }
            }
            group(Invoicing)
            {
                CaptionML = ENU = 'Invoicing', ESP = 'Facturación';
                field(Price; Rec.Price) { }
            }
        }
    }
    actions
    {
        area(Navigation)
        {
            action(Editions)
            {
                CaptionML = ENU = 'Editions', ESP = 'Ediciones';
                RunObject = page "Course Editions";
                RunPageLink = "Course No." = field("No.");
            }
        }
    }
}