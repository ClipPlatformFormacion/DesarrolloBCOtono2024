xmlport 50102 "Sales Order Export - TextoFijo"
{
    Direction = Export;
    FormatEvaluate = Xml;
    Format = FixedText;

    schema
    {
        textelement(Root)
        {
            tableelement(SalesLine; "Sales Line")
            {
                SourceTableView = where("Document Type" = const(Order));

                textelement(Currency)
                {
                    Width = 10;
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
                    Width = 15;
                    trigger OnBeforePassVariable()
                    begin
                        Type := Format(SalesLine.Type);
                    end;
                }
                fieldelement(No; SalesLine."No.")
                {
                    Width = 20;
                }
                fieldelement(Quantity; SalesLine."Quantity")
                {
                    Width = 10;
                }
                fieldelement(UnitPrice; SalesLine."Unit Price")
                {
                    Width = 10;
                }
            }
        }
    }
}