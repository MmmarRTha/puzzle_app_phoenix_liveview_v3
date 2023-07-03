defmodule PuzzleApp.GameFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PuzzleApp.Game` context.
  """

  @doc """
  Generate a puzzle.
  """
  def puzzle_fixture(attrs \\ %{}) do
    {:ok, puzzle} =
      attrs
      |> Enum.into(%{
        name: "some name",
        width: 42,
        height: 42
      })
      |> PuzzleApp.Game.create_puzzle()

    puzzle
  end
end
