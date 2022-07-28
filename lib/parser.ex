defmodule DellTestElixir.Parser do
  @moduledoc """
  This is the parser module, here is where the CSV will be
  parsed using some of elixir types and returned into a list
  of maps
  """
  alias Decimal
  NimbleCSV.define(CSVParser, separator: ";", escape: "\"")

  #all the functions bellow are made to pass
  #certain values on the table to booleans
  #and atoms.
  defp parse_tax_grant("Positiva"),
    do: :positive

  defp parse_tax_grant("Neutra"),
    do: :neutral

  defp parse_tax_grant("Negativa"),
    do: :negative

  defp parse_price_regime("Regulado"),
    do: :regulated

  defp parse_price_regime("Liberado"),
    do: :liberated

  defp parse_boolean("N�o"),
    do: false

  defp parse_boolean("Sim"),
    do: true

  #In this function, the code is trimmed
  #and if matches the string "-", will be null
  #otherwise, will be passed as a string.
  defp parse_code(str) do
    str
    |> String.trim()
    |> case do
      "-" -> nil
      otherwise -> otherwise
    end
  end

  #makes empty string go to nil type
  defp parse_decimal(""),
    do: nil

  #replace "," to "." to use the decimal value
  defp parse_decimal(string) do
    string
    |> String.replace(~r/,/, ".")
    |> Decimal.new()
  end

  @doc """
  Function for using on the map,
  for creating each item on the list.
  """
  def parse_row([
    substance,
    cnpj,
    laboratory,
    ggrem_code,
    record,
    ean1,
    ean2,
    ean3,
    product,
    presentation,
    therapeutic_class,
    product_type,
    price_regime,
    pf_without_taxes,
    pf_0,
    pf_12,
    pf_17,
    pf_17_alc,
    pf_17_5,
    pf_17_5_alc,
    pf_18,
    pf_18_alc,
    pf_20,
    pmc_0,
    pmc_12,
    pmc_17,
    pmc_17_alc,
    pmc_17_5,
    pmc_17_5_alc,
    pmc_18,
    pmc_18_alc,
    pmc_20,
    hospital_restriction,
    cap,
    confaz_87,
    icms_0,
    appeal_analysis,
    tax_credit_grant_list,
    commercialization_2020,
    stripe,
  ]) do
    %{
      substance: substance,
      cnpj: cnpj,
      laboratory: laboratory,
      ggrem_code: ggrem_code,
      record: record,
      ean1: parse_code(ean1),
      ean2: parse_code(ean2),
      ean3: parse_code(ean3),
      product: product,
      presentation: presentation,
      therapeutic_class: therapeutic_class,
      product_type: product_type,
      price_regime: parse_price_regime(price_regime),
      pf_without_taxes: parse_decimal(pf_without_taxes),
      pf_0: parse_decimal(pf_0),
      pf_12: parse_decimal(pf_12),
      pf_17: parse_decimal(pf_17),
      pf_17_alc: parse_decimal(pf_17_alc),
      pf_17_5: parse_decimal(pf_17_5),
      pf_17_5_alc: parse_decimal(pf_17_5_alc),
      pf_18: parse_decimal(pf_18),
      pf_18_alc: parse_decimal(pf_18_alc),
      pf_20: parse_decimal(pf_20),
      pmc_0: parse_decimal(pmc_0),
      pmc_12: parse_decimal(pmc_12),
      pmc_17: parse_decimal(pmc_17),
      pmc_17_alc: parse_decimal(pmc_17_alc),
      pmc_17_5: parse_decimal(pmc_17_5),
      pmc_17_5_alc: parse_decimal(pmc_17_5_alc),
      pmc_18: parse_decimal(pmc_18),
      pmc_18_alc: parse_decimal(pmc_18_alc),
      pmc_20: parse_decimal(pmc_20),
      hospital_restriction: parse_boolean(hospital_restriction),
      cap: parse_boolean(cap),
      confaz_87: parse_boolean(confaz_87),
      icms_0: parse_boolean(icms_0),
      appeal_analysis: appeal_analysis,
      tax_credit_grant_list: parse_tax_grant(tax_credit_grant_list),
      commercialization_2020: parse_boolean(commercialization_2020),
      stripe: stripe,
    }
  end

 @doc """
 This fuction recieve the path of the CSV
 and return the parsed list of the table
 now with the better types for the all itens.
 """
  def parse(filename) do

    #file = "TA_PRECO_MEDICAMENTO.csv"

    filename
    |> File.stream!()
    |> CSVParser.parse_stream()
    |> Stream.map(&parse_row/1)
    |> Enum.to_list()
  end
end
