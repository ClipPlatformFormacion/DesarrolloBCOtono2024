xmlport 50101 "Sales Order Export - csv"
{
    Direction = Export;
    FormatEvaluate = Xml;
    Format = VariableText;
    FieldSeparator = ';';
    FieldDelimiter = '"';

    schema
    {
        textelement(Root)
        {
            tableelement(SalesLine; "Sales Line")
            {
                SourceTableView = where("Document Type" = const(Order));

                textelement(Currency)
                {
                    trigger OnBeforePassVariable()
                    var
                        SalesHeader: Record "Sales Header";
                    begin
                        SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.");
                        Currency := SalesHeader."Currency Code";
                    end;
                }

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