permissionset 50100 "Course - SUPER"
{
    Caption = 'Course SUPER', Comment = 'ESP="Curso SUPER"';
    Assignable = true;
    Permissions = tabledata Course = RIMD,
        tabledata "Course Edition" = RIMD,
        tabledata "Courses Setup" = RIMD,
        table Course = X,
        table "Course Edition" = X,
        table "Courses Setup" = X,
        page "Course Card" = X,
        page "Course Editions" = X,
        page "Course Editions FactBox" = X,
        page "Course List" = X,
        page "Courses Setup" = X,
        table "Course Ledger Entry" = X,
        tabledata "Course Ledger Entry" = RMID,
        codeunit "Course Sales Management" = X,
        table "Course Journal Line" = X,
        tabledata "Course Journal Line" = RMID,
        codeunit "Course Journal-Post Line" = X,
        page "Course Ledger Entries" = X;
}