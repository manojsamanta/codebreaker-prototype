defmodule LiveViewDemoWeb.GameLive do
  use Phoenix.LiveView

  alias LiveViewDemo.CodeBreaker
  alias LiveViewDemo.CodeBreaker.Game
  alias LiveViewDemo.CodeBreaker.Turn

  def render(assigns) do
    Phoenix.View.render(LiveViewDemoWeb.GameView, "_game.html", assigns)
  end

  def mount(%{game: game}, socket) do
    {:ok, put_game(socket, game)}
  end

  def handle_event("advance-color", %{"pos" => pos}, socket) do
    new_game = handle_inc(socket.assigns[:game], pos, 1)

    {:noreply, put_game(socket, new_game)}
  end

  def handle_event("retreat-color", %{"pos" => pos}, socket) do
    new_game = handle_inc(socket.assigns[:game], pos, -1)

    {:noreply, put_game(socket, new_game)}
  end

  defp handle_inc(%{current_guess: current_guess} = game, pos, dir) do
    ind = String.to_integer(pos) - 1

    new_char =
      current_guess
      |> Enum.at(ind)
      |> Turn.increment_item(dir)

    new_current = List.replace_at(current_guess, ind, new_char)

    %Game{game | current_guess: new_current}
  end

  defp put_game(socket, game) do
    assign(socket, game: game)
  end
end
