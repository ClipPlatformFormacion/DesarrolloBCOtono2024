xmlport 50100 "Sales Order Export"
{
    Direction = Export;
    FormatEvaluate = Xml;

    schema
    {
        textelement(Root)
        {
            tableelement(SalesHeader; "Sales Header")
            {
                SourceTableView = where("Document Type" = const(Order));

                textattribute(DocumentType)
                {
                    trigger OnBeforePassVariable()
                    begin
                        DocumentType := Format(SalesHeader."Document Type");
                    end;
                }
                fieldelement(DocumentNo; SalesHeader."No.") { }
                fieldelement(Customer; SalesHeader."Sell-to Customer No.") { }
                fieldelement(Date; SalesHeader."Document Date") { }
                fieldelement(Currency; SalesHeader."Currency Code") { }

                tableelement(SalesLine; "Sales Line")
                {
                    LinkTable = SalesHeader;
                    LinkFields = "Document Type" = field("Document Type"), "Document No." = field("No.");

                    textelement(Type)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            Type := Format(SalesLine.Type);
                        end;
                    }
                    fieldelement(No; SalesLine."No.") { }
                    fieldelement(Quantity; SalesLine."Quantity") { }
                    fieldelement(UnitPrice; SalesLine."Unit Price") { }
                }
            }
        }
    }
}