codeunit 50150 "Framework Test"
{
    Subtype = Test;

    [Test]
    procedure Test001()
    begin

    end;

    [Test]
    procedure Test002()
    begin
        Error('Un error');
    end;

    [Test]
    procedure Test003()
    var
        GetMin: Codeunit "Get Min";
        Value1, Value2 : Decimal;
        Result: Decimal;
    begin
        // [Scenario] Si el primero de los parámetros pasados es el más pequeño, la función devuelve ese valor

        // [Given] 2 valores numéricos (1,2)
        Value1 := 1;
        Value2 := 2;

        // [When] Llamemos a la función GetMin
        Result := Getmin.GetMin(Value1, Value2);

        // [Then] El resultado es el Valor1
        if Result <> Value1 then
            Error('el resultado no es correcto');
    end;

    [Test]
    procedure Test004()
    var
        GetMin: Codeunit "Get Min";
        Value1, Value2 : Decimal;
        Result: Decimal;
    begin
        // [Scenario] Si el segundo de los parámetros pasados es el más pequeño, la función devuelve ese valor

        // [Given] 2 valores numéricos (2,1)
        Value1 := 2;
        Value2 := 1;

        // [When] Llamemos a la función GetMin
        Result := Getmin.GetMin(Value1, Value2);

        // [Then] El resultado es el Valor2
        if Result <> Value2 then
            Error('el resultado no es correcto');
    end;
}