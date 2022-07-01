defmodule AscendWeb.HillLive.Index do
  use AscendWeb, :live_view

  alias Ascend.Hills
  alias Ascend.Hills.Hill

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :hills, list_hills())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Hill")
    |> assign(:hill, Hills.get_hill!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Hill")
    |> assign(:hill, %Hill{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Hills")
    |> assign(:hill, nil)
  end

  defp list_hills do
    Hills.list_hills()
  end
end
