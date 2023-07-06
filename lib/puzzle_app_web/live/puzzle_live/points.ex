defmodule PuzzleAppWeb.PuzzleLive.Points do
    use PuzzleAppWeb, :live_component

    alias PuzzleApp.Game

    @impl true
    def update(%{puzzle: puzzle} = assigns, socket) do
      {:ok,
       socket
       |> assign(assigns)
       |> assign_grid(puzzle)}
    end

    defp assign_grid(socket, puzzle) do
        points =
            Enum.map(puzzle.points, &{&1.x, &1.y})
        grid =
            for x <- 1..puzzle.width, y <- 1..puzzle.height, into: %{} do
                {{x,y}, {x, y} in points}
            end

        assign(socket, :grid, grid)
    end

    attr :x, :integer, required: true
    attr :y, :integer, required: true
    attr :alive, :boolean, default: false
    attr :myself, :any, required: true
    def rect(assigns) do
        ~H"""
        <rect
        x={@x*10}
        y={@y*10}
        width="10"
        height="10"
        rx="2"
        phx-click="toggle"
        phx-value-x={@x}
        phx-value-y={@y}
        phx-target={@myself}
        fill={fill_color(@alive)}
        class={hover_class()} />
        """
    end

    defp fill_color(true), do: "black"
    defp fill_color(false), do: "white"

    defp hover_class() do
        "hover:opacity-60"
    end

    @impl true
    def handle_event("toggle", %{"x" => x, "y" => y}, socket) do
        {:noreply, change_cell(socket, x, y)}
    end

    def handle_event("save", _meta, socket) do
        {:noreply, save(socket)}
    end

    def handle_event("toggle", _meta, socket) do
        {:noreply, toggle(socket)}
    end

    defp save(socket) do
      points =
        socket.assigns.grid
        |> Enum.filter(fn {_point, alive} -> alive end)
        |> Enum.map(fn {point, _alive} -> point end)

    puzzle = socket.assigns.puzzle

    Game.save_puzzle_points(puzzle, points)

    socket
        |> put_flash(:info, "Points saved successfully")
        |> push_patch(to: socket.assigns.patch)
    end

    defp toggle(socket) do
      toggled_grid =
        socket.assigns.grid
        |> Enum.map(fn {point, alive} ->
            {point, !alive}
        end)
        |> Enum.into(%{})

        assign(socket, :grid, toggled_grid)
    end
    def change_cell(socket, x, y) do
        x = String.to_integer(x)
        y = String.to_integer(y)
        grid = socket.assigns.grid
        new_grid = Map.put(grid, {x, y}, !grid[{x, y}])

        assign(socket, :grid, new_grid)
    end

end
