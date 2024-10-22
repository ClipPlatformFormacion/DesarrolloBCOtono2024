codeunit 50152 "Course Test"
{
    Subtype = Test;
    TestPermissions = Disabled;

    [Test]
    procedure SelectingACourseOnASalesLine()
    var
        Course: Record Course;
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        LibrarySales: Codeunit "Library - Sales";
        LibraryAssert: Codeunit "Library Assert";
        LibraryCourse: Codeunit "Library - Course";
    begin
        // [Scenario] Al seleccionar un curso en una línea de venta, el sistema rellena la información relacionada

        // [Given] Un curso. Un documento de venta con una línea de venta
        LibraryCourse.CreateCourse(Course);

        LibrarySales.CreateSalesHeader(SalesHeader, "Sales Document Type"::Order, '');
        LibrarySales.CreateSalesLineSimple(SalesLine, SalesHeader);

        // [When] Seleccionamos el curso en la línea de venta
        SalesLine.Validate(Type, SalesLine.Type::Course);
        SalesLine.Validate("No.", Course."No.");

        // [Then] La línea de venta tiene la Descripción, Grupos de Registro y Precio correctos
        LibraryAssert.AreEqual(Course.Name, SalesLine.Description, 'La descripción no es correcta');
        LibraryAssert.AreEqual(Course.Price, SalesLine."Unit Price", 'El precio no es correcto');
        LibraryAssert.AreEqual(Course."Gen. Prod. Posting Group", SalesLine."Gen. Prod. Posting Group", 'El Grupo Registro Producto no es correcto');
        LibraryAssert.AreEqual(Course."VAT Prod. Posting Group", SalesLine."VAT Prod. Posting Group", 'El grupo de IVA producto no es correcto');
    end;
}