defmodule SearcherTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  alias DellTestElixir.Searcher

  setup do
    data = [
      %{
        pmc_17_5_alc: Decimal.new("8.45"),
        product_type: "Similar",
        presentation: "TALQUEIRA C/ 100 G",
        laboratory: "LABORATORIO SIMOES LTDA.",
        pf_17_5: Decimal.new("7.03"),
        cap: false,
        pmc_0: Decimal.new("7.58"),
        product: "TALCO AL�VIO",
        pf_18_alc: Decimal.new("6.15"),
        hospital_restriction: false,
        tax_credit_grant_list: :negative,
        pf_12: Decimal.new("6.53"),
        substance: "SALICILATO DE FENILA;�CIDO SALIC�LICO;�XIDO DE ZINCO;ENXOFRE;MENTOL",
        pmc_20: Decimal.new("9.70"),
        pf_18: Decimal.new("7.08"),
        pmc_12: Decimal.new("8.72"),
        ean3: nil,
        therapeutic_class: "D10A - ANTIACNEICOS T�PICOS",
        price_regime: :regulated,
        pmc_18: Decimal.new("9.43"),
        appeal_analysis: "",
        pmc_18_alc: Decimal.new("8.50"),
        pf_0: Decimal.new("5.65"),
        pmc_17_5: Decimal.new("9.37"),
        pmc_17: Decimal.new("9.30"),
        pf_17_alc: Decimal.new("6.08"),
        confaz_87: false,
        cnpj: "33.379.884/0001-96",
        pmc_17_alc: Decimal.new("8.41"),
        pf_17_5_alc: Decimal.new("6.11"),
        pf_without_taxes: Decimal.new("5.04"),
        ean2: nil,
        commercialization_2020: false,
        stripe: "Tarja -(*)",
        ggrem_code: "520500901178410",
        pf_20: Decimal.new("7.29"),
        ean1: "7896210500354",
        record: "057600510011",
        icms_0: false,
        pf_17: Decimal.new("6.98")
      },
      %{
        pmc_17_5_alc: Decimal.new("54.52"),
        product_type: "Similar",
        presentation: "250 MG CAP GEL MOLE CT FR VD AMB X 100",
        laboratory: "BIOLAB SANUS FARMAC�UTICA LTDA",
        pf_17_5: Decimal.new("39.44"),
        cap: false,
        pmc_0: Decimal.new("44.98"),
        product: "�CIDO VALPR�ICO",
        pf_18_alc: Decimal.new("39.68"),
        hospital_restriction: false,
        tax_credit_grant_list: :positive,
        pf_12: Decimal.new("36.98"),
        substance: "VALPROATO DE S�DIO",
        pmc_20: Decimal.new("56.24"),
        pf_18: Decimal.new("39.68"),
        pmc_12: Decimal.new("51.12"),
        ean3: nil,
        therapeutic_class: "N3A - ANTIEPIL�PTICOS",
        price_regime: :regulated,
        pmc_18: Decimal.new("54.86"),
        appeal_analysis: "",
        pmc_18_alc: Decimal.new("54.86"),
        pf_0: Decimal.new("32.54"),
        pmc_17_5: Decimal.new("54.52"),
        pmc_17: Decimal.new("54.19"),
        pf_17_alc: Decimal.new("39.20"),
        confaz_87: false,
        cnpj: "49.475.833/0001-06",
        pmc_17_alc: Decimal.new("54.19"),
        pf_17_5_alc: Decimal.new("39.44"),
        pf_without_taxes: Decimal.new("32.54"),
        ean2: nil,
        commercialization_2020: true,
        stripe: "Tarja -(*)",
        ggrem_code: "504118100064506",
        pf_20: Decimal.new("40.68"),
        ean1: "7896112401247",
        record: "    -     ",
        icms_0: false,
        pf_17: Decimal.new("39.20")
      }
    ]
    [data: data]
  end

  describe "search_by_name/2" do
    test "return all matching substances", context do
      expected = """
      +--------------------+-----------------+----------------------------------------+-----------------------+
      | Nome               | Produto         | Apresentação                           | Valor Pf Sem Impostos |
      +--------------------+-----------------+----------------------------------------+-----------------------+
      | VALPROATO DE S�DIO | �CIDO VALPR�ICO | 250 MG CAP GEL MOLE CT FR VD AMB X 100 | 32.54                 |
      +--------------------+-----------------+----------------------------------------+-----------------------+

      """
      assert capture_io(fn ->
        Searcher.search_by_name(context[:data], "VALPROATO")
      end) == expected
    end

    test "return \"Item not found\" if no substance matches", context do

      expected = "Item not found\n"

      assert capture_io(fn ->
        Searcher.search_by_name(context[:data], "ANDERSON")
      end) == expected
    end
  end

  describe "search_by_barcode/2" do
    test "return the price matching code", context do

      expected = """
      +-----------------+------------------+--------------------+
      | Preço mais alto | Preço mais baixo | Diferença de preço |
      +-----------------+------------------+--------------------+
      | 9.70            | 7.58             | 2.12               |
      +-----------------+------------------+--------------------+

      """

      assert capture_io(fn ->
        Searcher.search_by_barcode(context[:data], "7896210500354")
      end) == expected
    end

    test "return \"Item not found\" if the code was not found", context do

      expected = "Item not found\n"

      assert capture_io(fn ->
        Searcher.search_by_barcode(context[:data], "1230127831273671236718273712378912739871263")
      end) == expected
    end
  end

  describe "compare_tax/1" do
    test "return the correct metrics", context do

      expected = """
      +---------------+------------+---------+
      | Classificação | Percentual | Grafico |
      +---------------+------------+---------+
      | Negativa      | 50.0%      | *****   |
      | Neutra        | 0.0%       |         |
      | Positiva      | 50.0%      | *****   |
      +---------------+------------+---------+

      """

      assert capture_io(fn ->
        Searcher.compare_tax(context[:data])
      end) == expected
    end
  end
end
