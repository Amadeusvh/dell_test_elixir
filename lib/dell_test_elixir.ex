defmodule DellTestElixir do
  @moduledoc """
  The main module of the application
  """
  alias DellTestElixir.Parser
  alias DellTestElixir.Searcher

  @doc """
  The fuction will load a menu on the terminal
  afther that the fuction for loading the CSV will be called
  and the choices of search
  """
  def main(args \\ []) do

    IO.puts """

    |==================================|
    |      Dell Medicine Searcher      |
    |==================================|

    =commands=

     >search <name>: Search a Medicine by the name of the substance. Ex: search anfetamina

     >barcode <barcode>: Search a Medicine price by the code. Ex: barcode 7897337703345

     >metrics: Get Metrics on the (PIS/COFINS).

     >exit: close the program.

    """

    filename = List.first(args)

    data = load_csv(filename)

    repl(data)

  end

  #Trimming the user input for not breaking
  #if the command have more spaces than needed
  defp get_user_input do
    ">"
    |> IO.gets()
    |> String.replace(~r/\n/, "")
    |> String.trim()
  end

  @doc """
  this function will let the user
  choice option for searching on the app
  """
  def repl(data) do
    case get_user_input() do
      "search" <> " " <> name ->
        Searcher.search_by_name(data, name)
      "barcode" <> " " <> code ->
        Searcher.search_by_barcode(data, code)
      "metrics" ->
        Searcher.compare_tax(data)
      "exit" ->
        exit(:shutdown)
      _ ->
        IO.puts("Command not found")
    end
    repl(data)
  end

  #calling the function to load the CSV
  defp load_csv(filename) do
    Parser.parse(filename)
  end

  #def search_by_name(name) do
  #  Searcher.search_by_name(load_csv(), name)
  #end

end
