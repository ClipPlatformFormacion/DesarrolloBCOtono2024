page 50106 "Update Price Log"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Update Price Log";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Entry No."; Rec."Entry No.") { }
                field(Percentaje; Rec.Percentaje) { }
                field("Filters Used"; Rec."Filters Used") { }
            }
        }
    }
}