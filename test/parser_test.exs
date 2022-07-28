defmodule ParserTest do
  use ExUnit.Case
  alias DellTestElixir.Parser

  describe "parse_row/1" do
    test "return the correct value when all columns are given" do
      input_data = [
        "ABATACEPTE",
        "56.998.982/0001-07",
        "BRISTOL-MYERS SQUIBB FARMAC�UTICA LTDA",
        "505107701157215",
        "1018003900019",
        "7896016806469",
        "-",
        "-",
        "ORENCIA",
        "250 MG PO LIOF SOL INJ CT 1 FA + SER DESCART�VEL",
        "M1C - AGENTES ANTI-REUM�TICOS ESPEC�FICOS",
        "-(*)",
        "Regulado",
        "1652,52",
        "1652,52",
        "877,86",
        "1990,99",
        "1990,99",
        "2003,05",
        "2003,05",
        "2015,27",
        "2015,27",
        "2065,65",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "Sim",
        "N�o",
        "N�o",
        "N�o",
        "",
        "Positiva",
        "Sim",
        "Tarja Vermelha(*)"
      ]

      expected = %{
        substance: "ABATACEPTE",
        cnpj: "56.998.982/0001-07",
        laboratory: "BRISTOL-MYERS SQUIBB FARMAC�UTICA LTDA",
        ggrem_code: "505107701157215",
        record: "1018003900019",
        ean1: "7896016806469",
        ean2: nil,
        ean3: nil,
        product: "ORENCIA",
        presentation: "250 MG PO LIOF SOL INJ CT 1 FA + SER DESCART�VEL",
        therapeutic_class: "M1C - AGENTES ANTI-REUM�TICOS ESPEC�FICOS",
        product_type: "-(*)",
        price_regime: :regulated,
        pf_without_taxes: Decimal.new("1652.52"),
        pf_0: Decimal.new("1652.52"),
        pf_12: Decimal.new("877.86"),
        pf_17: Decimal.new("1990.99"),
        pf_17_alc: Decimal.new("1990.99"),
        pf_17_5: Decimal.new("2003.05"),
        pf_17_5_alc: Decimal.new("2003.05"),
        pf_18: Decimal.new("2015.27"),
        pf_18_alc: Decimal.new("2015.27"),
        pf_20: Decimal.new("2065.65"),
        pmc_0: nil,
        pmc_12: nil,
        pmc_17: nil,
        pmc_17_alc: nil,
        pmc_17_5: nil,
        pmc_17_5_alc: nil,
        pmc_18: nil,
        pmc_18_alc: nil,
        pmc_20: nil,
        hospital_restriction: true,
        cap: false,
        confaz_87: false,
        icms_0: false,
        appeal_analysis: "",
        tax_credit_grant_list: :positive,
        commercialization_2020: true,
        stripe: "Tarja Vermelha(*)",
      }

      assert expected == Parser.parse_row(input_data)

    end
  end

end
