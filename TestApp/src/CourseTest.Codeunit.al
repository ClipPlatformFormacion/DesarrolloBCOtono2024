#pragma warning disable AA0210
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

    [Test]
    procedure CourseSalesPosting()
    var
        Course: Record Course;
        CourseEdition: Record "Course Edition";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        SalesShipmentLine: Record "Sales Shipment Line";
        LibrarySales: Codeunit "Library - Sales";
        LibraryAssert: Codeunit "Library Assert";
        LibraryCourse: Codeunit "Library - Course";
        DocumentNo: Code[20];
    begin
        // [Scenario] Al registrar un documento de venta para un curso y edición, la edición se guarda correctamente en los documentos registrados

        // [Given] Un curso con edición. Un documento de venta para el curso y edición
        LibraryCourse.CreateCourse(Course);
        CourseEdition := LibraryCourse.CreateEdition(Course."No.");

        LibrarySales.CreateSalesHeader(SalesHeader, "Sales Document Type"::Order, '');
        LibrarySales.CreateSalesLineSimple(SalesLine, SalesHeader);
        SalesLine.Validate(Type, SalesLine.Type::Course);
        SalesLine.Validate("No.", Course."No.");
        SalesLine.Validate("Course Edition", CourseEdition.Edition);
        SalesLine.Validate(Quantity, 1);
        SalesLine.Modify(true);

        // [When] Registrar el documento de venta
        DocumentNo := LibrarySales.PostSalesDocument(SalesHeader, true, false);

        // [Then] La edición se ha guardado en los documentos registrados
        SalesShipmentLine.SetRange("Document No.", DocumentNo);
        SalesShipmentLine.FindFirst();

        LibraryAssert.AreEqual(CourseEdition.Edition, SalesShipmentLine."Course Edition", 'La edición en el albarán no es correcta');
    end;

    [Test]
    procedure CourseLedgerEntryCreation()
    var
        Course: Record Course;
        CourseEdition: Record "Course Edition";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        CourseLedgerEntry: Record "Course Ledger Entry";
        LibrarySales: Codeunit "Library - Sales";
        LibraryAssert: Codeunit "Library Assert";
        LibraryCourse: Codeunit "Library - Course";
        DocumentNo: Code[20];
    begin
        // [Scenario] El proceso de registro de un documento de venta genera movimientos de curso

        // [Given] Un curso con edición. Un documento de venta para el curso y edición
        LibraryCourse.CreateCourse(Course);
        CourseEdition := LibraryCourse.CreateEdition(Course."No.");

        LibrarySales.CreateSalesHeader(SalesHeader, "Sales Document Type"::Order, '');
        LibrarySales.CreateSalesLineSimple(SalesLine, SalesHeader);
        SalesLine.Validate(Type, SalesLine.Type::Course);
        SalesLine.Validate("No.", Course."No.");
        SalesLine.Validate("Course Edition", CourseEdition.Edition);
        SalesLine.Validate(Quantity, 1);
        SalesLine.Modify(true);

        // [When] Registrar el documento de venta (envío)
        DocumentNo := LibrarySales.PostSalesDocument(SalesHeader, true, false);

        // [Then] El albarán no genera movimiento de curso
        CourseLedgerEntry.SetRange("Document No.", DocumentNo);
        LibraryAssert.AreEqual(0, CourseLedgerEntry.Count(), 'El registro de un albarán no debería crear movimientos de curso');

        // [When] Registrar el documento de venta (factura)
        DocumentNo := LibrarySales.PostSalesDocument(SalesHeader, false, true);

        // [Then] Se ha generado un movimiento de curso
        CourseLedgerEntry.SetRange("Document No.", DocumentNo);
        LibraryAssert.AreEqual(1, CourseLedgerEntry.Count(), 'El número de movimientos generados por la factura es incorrecto');

        CourseLedgerEntry.FindFirst();
        LibraryAssert.AreEqual(SalesHeader."Posting Date", CourseLedgerEntry."Posting Date", 'Dato incorrecto');
        LibraryAssert.AreEqual(SalesLine."No.", CourseLedgerEntry."Course No.", 'Dato incorrecto');
        LibraryAssert.AreEqual(SalesLine."Course Edition", CourseLedgerEntry."Course Edition", 'Dato incorrecto');
        LibraryAssert.AreEqual(SalesLine.Description, CourseLedgerEntry.Description, 'Dato incorrecto');
        LibraryAssert.AreEqual(SalesLine."Qty. to Invoice", CourseLedgerEntry.Quantity, 'Dato incorrecto');
        LibraryAssert.AreEqual(SalesLine."Unit Price", CourseLedgerEntry."Unit Price", 'Dato incorrecto');
        LibraryAssert.AreEqual(SalesLine.Amount, CourseLedgerEntry."Total Price", 'Dato incorrecto');
        LibraryAssert.AreEqual('', CourseLedgerEntry."Journal Batch Name", 'Dato incorrecto');
        LibraryAssert.AreEqual(SalesHeader."Document Date", CourseLedgerEntry."Document Date", 'Dato incorrecto');
        LibraryAssert.AreEqual(SalesHeader."External Document No.", CourseLedgerEntry."External Document No.", 'Dato incorrecto');
    end;

    [Test]
    procedure CourseLedgerEntryCreation_CreditMemo()
    var
        Course: Record Course;
        CourseEdition: Record "Course Edition";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        CourseLedgerEntry: Record "Course Ledger Entry";
        LibrarySales: Codeunit "Library - Sales";
        LibraryAssert: Codeunit "Library Assert";
        LibraryCourse: Codeunit "Library - Course";
        DocumentNo: Code[20];
    begin
        // [Scenario] El proceso de registro de un documento de venta genera movimientos de curso

        // [Given] Un curso con edición. Un documento de venta para el curso y edición
        LibraryCourse.CreateCourse(Course);
        CourseEdition := LibraryCourse.CreateEdition(Course."No.");

        LibrarySales.CreateSalesHeader(SalesHeader, "Sales Document Type"::"Return Order", '');
        LibrarySales.CreateSalesLineSimple(SalesLine, SalesHeader);
        SalesLine.Validate(Type, SalesLine.Type::Course);
        SalesLine.Validate("No.", Course."No.");
        SalesLine.Validate("Course Edition", CourseEdition.Edition);
        SalesLine.Validate(Quantity, 1);
        SalesLine.Modify(true);

        // [When] Registrar el documento de venta (recepción)
        DocumentNo := LibrarySales.PostSalesDocument(SalesHeader, true, false);

        // [Then] El albarán no genera movimiento de curso
        CourseLedgerEntry.SetRange("Document No.", DocumentNo);
        LibraryAssert.AreEqual(0, CourseLedgerEntry.Count(), 'El registro de un albarán no debería crear movimientos de curso');

        // [When] Registrar el documento de venta (abono)
        DocumentNo := LibrarySales.PostSalesDocument(SalesHeader, false, true);

        // [Then] Se ha generado un movimiento de curso
        CourseLedgerEntry.SetRange("Document No.", DocumentNo);
        LibraryAssert.AreEqual(1, CourseLedgerEntry.Count(), 'El número de movimientos generados por la abono es incorrecto');

        CourseLedgerEntry.FindFirst();
        LibraryAssert.AreEqual(SalesHeader."Posting Date", CourseLedgerEntry."Posting Date", 'Dato incorrecto');
        LibraryAssert.AreEqual(SalesLine."No.", CourseLedgerEntry."Course No.", 'Dato incorrecto');
        LibraryAssert.AreEqual(SalesLine."Course Edition", CourseLedgerEntry."Course Edition", 'Dato incorrecto');
        LibraryAssert.AreEqual(SalesLine.Description, CourseLedgerEntry.Description, 'Dato incorrecto');
        LibraryAssert.AreEqual(-SalesLine."Qty. to Invoice", CourseLedgerEntry.Quantity, 'Dato incorrecto');
        LibraryAssert.AreEqual(SalesLine."Unit Price", CourseLedgerEntry."Unit Price", 'Dato incorrecto');
        LibraryAssert.AreEqual(-SalesLine.Amount, CourseLedgerEntry."Total Price", 'Dato incorrecto');
        LibraryAssert.AreEqual('', CourseLedgerEntry."Journal Batch Name", 'Dato incorrecto');
        LibraryAssert.AreEqual(SalesHeader."Document Date", CourseLedgerEntry."Document Date", 'Dato incorrecto');
        LibraryAssert.AreEqual(SalesHeader."External Document No.", CourseLedgerEntry."External Document No.", 'Dato incorrecto');
    end;

    [Test]
    [HandlerFunctions('MaxStudentsExceededMessage')]
    procedure NotificationWhenExceedingMaxStudents()
    var
        Course: Record Course;
        CourseEdition: Record "Course Edition";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        LibrarySales: Codeunit "Library - Sales";
        LibraryCourse: Codeunit "Library - Course";
    begin
        // [Scenario] Cuando con las ventas previas más el documento actual se supera el máximo de alumnos para una edición, tiene que salir una notificación

        // [Setup] Unas ventas previas: un curso, una edición, registros de facturas y abonos        
        LibraryCourse.CreateCourse(Course);
        CourseEdition := LibraryCourse.CreateEdition(Course."No.");
        CourseEdition."Max. Students" := 15;
        CourseEdition.Modify();

        LibrarySales.CreateSalesHeader(SalesHeader, "Sales Document Type"::Order, '');
        LibrarySales.CreateSalesLineSimple(SalesLine, SalesHeader);
        SalesLine.Validate(Type, SalesLine.Type::Course);
        SalesLine.Validate("No.", Course."No.");
        SalesLine.Validate("Course Edition", CourseEdition.Edition);
        SalesLine.Validate(Quantity, 10);
        SalesLine.Modify(true);
        LibrarySales.PostSalesDocument(SalesHeader, true, true);

        LibrarySales.CreateSalesHeader(SalesHeader, "Sales Document Type"::Order, '');
        LibrarySales.CreateSalesLineSimple(SalesLine, SalesHeader);
        SalesLine.Validate(Type, SalesLine.Type::Course);
        SalesLine.Validate("No.", Course."No.");
        SalesLine.Validate("Course Edition", CourseEdition.Edition);
        SalesLine.Validate(Quantity, 4);
        SalesLine.Modify(true);
        LibrarySales.PostSalesDocument(SalesHeader, true, true);

        LibrarySales.CreateSalesHeader(SalesHeader, "Sales Document Type"::"Return Order", '');
        LibrarySales.CreateSalesLineSimple(SalesLine, SalesHeader);
        SalesLine.Validate(Type, SalesLine.Type::Course);
        SalesLine.Validate("No.", Course."No.");
        SalesLine.Validate("Course Edition", CourseEdition.Edition);
        SalesLine.Validate(Quantity, 2);
        SalesLine.Modify(true);
        LibrarySales.PostSalesDocument(SalesHeader, true, true);

        //          Un nuevo documento de venta
        LibrarySales.CreateSalesHeader(SalesHeader, "Sales Document Type"::Order, '');
        LibrarySales.CreateSalesLineSimple(SalesLine, SalesHeader);

        // [When] Se seleccione la edición en el nuevo documento
        SalesLine.Validate(Type, SalesLine.Type::Course);
        SalesLine.Validate("No.", Course."No.");
        SalesLine.Validate("Course Edition", CourseEdition.Edition);
        SalesLine.Validate(Quantity, 4);

        // [Then] Tiene que salir una notificación
    end;

    [MessageHandler]
    procedure MaxStudentsExceededMessage(Message: Text[1024])
    var
    // LibraryAssert: Codeunit "Library Assert";
    begin
        // Message.Substring()
        // LibraryAssert.
    end;
}
#pragma warning restore