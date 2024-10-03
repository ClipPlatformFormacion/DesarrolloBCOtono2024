page 50101 "Course Card"
{
    CaptionML = ENU = 'Course Card', ESP = 'Ficha curso';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = Course;

    layout
    {
        area(Content)
        {
            group(General)
            {
                CaptionML = ENU = 'General', ESP = 'General';
                field("No."; Rec."No.") { }
                field(Name; Rec.Name) { }
                field(Type; Rec.Type) { }
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
}