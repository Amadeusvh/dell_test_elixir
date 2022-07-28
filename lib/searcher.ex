defmodule DellTestElixir.Searcher do
  @moduledoc """
  the search module, with 2
  functions for the research
  and one for the metrics
  """
  alias TableRex.Table

  @table_1_headers ["Nome", "Produto", "Apresentação", "Valor Pf Sem Impostos"]
  @table_1_fields [:substance, :product, :presentation, :pf_without_taxes]
  @table_2_headers ["Preço mais alto", "Preço mais baixo", "Diferença de preço"]
  @table_2_fields [:pmc_20, :pmc_0, :diference]
  @table_3_headers ["Classificação", "Percentual", "Grafico"]
  @table_3_fields [:classification, :percentage, :graph]

  @incidence 10

  #function used on map bellow to get the values
  #on 1 item on the list of the CSV
  defp get_fields(map, keys),
    do: Enum.map(keys, &Map.get(map, &1))

  #get the right fields passed by the argument fields
  #and if passed a criteria, will be filtered (like the 2020 sold
  #medicine) if not, only return into a list
  #the found fields with the values of it
  defp filter_and_format(data, criteria_fun, fields) do
    data
    |> Stream.filter(criteria_fun)
    |> Stream.map(&get_fields(&1, fields))
    |> Enum.to_list()
  end

  defp filter_and_format(data, fields) do
    data
    |> Stream.map(&get_fields(&1, fields))
    |> Enum.to_list()
  end

  #if the argument rows is a empty list,
  #the first function return a error
  #if not, return a proper response for the user
  defp format_results_table(rows, _headers) when is_list(rows) and length(rows) == 0,
    do: IO.puts("Item not found")

  defp format_results_table(rows, headers) do
    rows
    |>Table.new(headers)
    |>Table.render!
    |>IO.puts
  end

  #creates a regex for the search and returns
  #a closure for returning the state of the
  #function
  defp search_by_name_filter(name) do
    pattern = Regex.compile!(name, "i")

    fn %{substance: substance} ->
      String.match?(substance, pattern)
    end
  end

  @doc """
  Recieves the CSV on memory and a argument
  for the search, and return all content
  needed
  """
  def search_by_name(data, name) do
    data
    |> Stream.filter(&(&1.commercialization_2020))
    |> filter_and_format(search_by_name_filter(name), @table_1_fields)
    |> Enum.map(&Enum.map(&1, fn v -> to_string(v) end))
    |> format_results_table(@table_1_headers)
  end

  #return a list with the values to be
  #displayed, with the diference of price
  defp barcode_table_row([highiest, lowest, _]) do
    difference = Decimal.sub(highiest, lowest)
    [
      to_string(highiest),
      to_string(lowest),
      to_string(difference)
    ]
  end

  @doc """
  Recieves the CSV on memory and a argument
  for the search, and return a table with
  the result
  """
  def search_by_barcode(data, code) do
    data
    |> filter_and_format(&(&1.ean1 == code), @table_2_fields)
    |> Enum.map(&barcode_table_row/1)
    |> format_results_table(@table_2_headers)
  end

  #reducer used to groupd negative, neutral and positive values on list
  #to be counted after
  defp comparation_reducer(row, %{negative: negative, neutral: neutral, positive: positive} = acc) do
    case row.tax_credit_grant_list do
      :negative ->
        %{acc | negative: [row | negative]}
      :neutral ->
        %{acc | neutral: [row | neutral]}
      :positive ->
        %{acc | positive: [row | positive]}
    end
  end

  #get metrics will be passed on to
  #the map on get_metrics function
  defp get_metric({name, value}, total) do
    value = Decimal.new("#{value}")
    total = Decimal.new("#{total}")

    percentage =
      value
      |> Decimal.div(total)
      |> Decimal.mult(100)

    incidence =
      percentage
      |> Decimal.div(@incidence)
      |> Decimal.to_float()
      |> Float.round()
      |> trunc()

    graph = String.duplicate("*", incidence)

    percentage =
      percentage
      |> Decimal.to_float()
      |> Float.round(2)
      |> to_string()
      |> Kernel.<>("%")

    %{
      classification: name,
      percentage: percentage,
      graph: graph
    }
  end
  #get_metrics will recive get_metric
  #to use on a map function to
  #return the metrics

  defp get_metrics(%{negative: negative, neutral: neutral, positive: positive}) do
    [negative_count, neutral_count, positive_count] =
      Enum.map([negative, neutral, positive], &Enum.count/1)

    total_count = negative_count + neutral_count + positive_count

    metrics =
      [
        {"Negativa", negative_count},
        {"Neutra", neutral_count},
        {"Positiva", positive_count}
      ]

    Enum.map(metrics, &get_metric(&1, total_count))

  end

  @doc """
  the metrics function
  first will be used a reducer to create a list for
  all 3 values be separated
  after that the filter_and_format the value
  will be passed to the function format_results_table
  to print the result.
  """
  def compare_tax(data) do
    data
    |> Enum.reduce(%{negative: [], neutral: [], positive: []}, &comparation_reducer/2)
    |> get_metrics()
    |> filter_and_format(@table_3_fields)
    |> format_results_table(@table_3_headers)
  end
end
