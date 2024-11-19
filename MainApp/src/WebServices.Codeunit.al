codeunit 50105 "WebServices"
{
    procedure UnMetodoSinParametrosNiValorDeRetorno()
    begin

    end;

    procedure UnMetodoConParametroDeTexto(TextoRecibido: Text): Text
    begin
        exit(StrSubstNo('Hola desde Business Central, empresa %1, su texto era %2', CompanyName(), TextoRecibido));
    end;

    procedure CrearCliente(): Text
    var
        Customer: Record Customer;
    begin
        if GuiAllowed() then
            if not Confirm('¿Estás seguro que quieres crear un nuevo cliente?', false) then
                Error('Operación cancelada por el usuario');

        Customer.Init();
        Customer.Name := 'Cliente creado desde WebService';
        Customer.Insert(true);
        exit(Customer."No.");
    end;

    procedure CrearClienteConParametros(Name: Text; Address: Text; PhoneNo: Text; CreditLimit: Decimal): Text
    var
        Customer: Record Customer;
    begin
        Customer.Init();
        Customer.Validate(Name, Name);
        Customer.Validate(Address, Address);
        Customer.Validate("Phone No.", PhoneNo);
        Customer.Validate("Credit Limit (LCY)", CreditLimit);
        Customer.Insert(true);
        exit(Customer."No.");
    end;

    procedure CrearCurso(XMLPortAImportar: XmlPort "Import Courses")
    begin
        XMLPortAImportar.Import();
    end;
}