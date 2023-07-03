defmodule PuzzleApp.Repo do
  use Ecto.Repo,
    otp_app: :puzzle_app,
    adapter: Ecto.Adapters.Postgres
end
