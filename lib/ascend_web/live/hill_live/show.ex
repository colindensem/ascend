defmodule AscendWeb.HillLive.Show do
  use AscendWeb, :live_view

  alias Ascend.Hills

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:hill, Hills.get_hill!(id))}
  end

  defp page_title(:show), do: "Show Hill"
end
