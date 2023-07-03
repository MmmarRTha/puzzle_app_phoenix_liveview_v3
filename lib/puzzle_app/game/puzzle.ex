defmodule PuzzleApp.Game.Puzzle do
  use Ecto.Schema
  import Ecto.Changeset

  schema "puzzles" do
    field :name, :string
    field :width, :integer
    field :height, :integer

    timestamps()
  end

  @doc false
  def changeset(puzzle, attrs) do
    puzzle
    |> cast(attrs, [:name, :height, :width])
    |> validate_required([:name, :height, :width])
  end
end
