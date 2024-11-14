page 50100 "Course List"
{
    Caption = 'Courses', Comment = 'ESP="Cursos"';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Course;
    Editable = false;
    CardPageId = "Course Card";

    layout
    {
        area(Content)
        {
            repeater(RepeaterControl)
            {
                field("No."; Rec."No.") { }
                field(Name; Rec.Name) { }
                field("Duration (hours)"; Rec."Duration (hours)") { }
                field(Price; Rec.Price) { }
                field("Language Code"; Rec."Language Code") { }
                field(Type; Rec.Type) { }
            }
        }
        area(FactBoxes)
        {
            part(CourseEditions; "Course Editions Factbox")
            {
                SubPageLink = "Course No." = field("No.");
            }
        }
    }
    actions
    {
        area(Navigation)
        {
            action(Editions)
            {
                Caption = 'Editions', Comment = 'ESP="Ediciones"';
                RunObject = page "Course Editions";
                RunPageLink = "Course No." = field("No.");
                Image = ListPage;
            }
            group(History)
            {
                Caption = 'History';
                Image = History;
                action("Ledger E&ntries")
                {
                    ApplicationArea = All;
                    Caption = 'Ledger E&ntries';
                    Image = ResourceLedger;
                    RunObject = Page "Course Ledger Entries";
                    RunPageLink = "Course No." = field("No.");
#pragma warning disable AL0254
                    RunPageView = sorting("Course No.")
                                  order(descending);
#pragma warning restore
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'View the history of transactions that have been posted for the selected record.';
                }
            }
        }
    }
}