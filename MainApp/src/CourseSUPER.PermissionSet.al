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
        page "Courses Setup" = X;
}