defmodule PuzzleAppWeb.PuzzleLive.Index do
  use PuzzleAppWeb, :live_view

  alias PuzzleApp.Game
  alias PuzzleApp.Game.Puzzle

  # TODO: Subscribe
  # TODO: Respond to topic-changed
  @impl true
  def mount(_params, _session, socket) do
    Game.subscribe_puzzle_changed()
    {:ok, stream(socket, :puzzles, Game.list_puzzles())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :points, %{"id" => id}) do
    socket
    |> load_points(id)
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Puzzle")
    |> load_points(id)
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Puzzle")
    |> assign(:puzzle, %Puzzle{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Puzzles")
    |> assign(:puzzle, nil)
  end

  def load_points(socket, id) do
    socket
    |> assign(:puzzle, Game.get_puzzle!(id))
  end
  @impl true
  def handle_info({PuzzleAppWeb.PuzzleLive.FormComponent, {:saved, puzzle}}, socket) do
    {:noreply, stream_insert(socket, :puzzles, puzzle)}
  end

  def handle_info({:points_changed, id}, %{assigns: %{puzzle: %{id: id}}}=socket) do
    {:noreply, load_points(socket, id)}
  end

  def handle_info({:points_changed, _}, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    puzzle = Game.get_puzzle!(id)
    {:ok, _} = Game.delete_puzzle(puzzle)

    {:noreply, stream_delete(socket, :puzzles, puzzle)}
  end
end
