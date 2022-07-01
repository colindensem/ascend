defmodule AscendWeb.HillLive.Index do
  use AscendWeb, :live_view

  alias Ascend.Hills
  alias AscendWeb.Forms.SortingForm

  @impl true
  def mount(_params, _session, socket), do: {:ok, socket}

  @impl true
  def handle_params(params, _url, socket) do
    socket =
      socket
      |> assign(:page_title, "Listing Hills")
      |> parse_params(params)
      |> assign_hills()

    {:noreply, socket}
  end

  @impl true
  def handle_info({:update, opts}, socket) do
    path = Routes.hill_index_path(socket, :index, opts)
    {:noreply, push_patch(socket, to: path, replace: true)}
  end

  defp parse_params(socket, params) do
    with {:ok, sorting_opts} <- SortingForm.parse(params) do
      assign_sorting(socket, sorting_opts)
    else
      _error ->
        assign_sorting(socket)
    end
  end

  defp assign_sorting(socket, overrides \\ %{}) do
    opts = Map.merge(SortingForm.default_values(), overrides)
    assign(socket, :sorting, opts)
  end

  defp assign_hills(socket) do
    %{sorting: sorting} = socket.assigns

    assign(socket, :hills, Hills.list_hills(sorting))
  end
end
