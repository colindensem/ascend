defmodule AscendWeb.HillLive.Index do
  use AscendWeb, :live_view

  alias Ascend.Hills
  alias AscendWeb.Forms.SortingForm
  alias AscendWeb.Forms.FilterForm

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
    params = merge_and_sanitize_params(socket, opts)
    path = Routes.hill_index_path(socket, :index, params)
    {:noreply, push_patch(socket, to: path, replace: true)}
  end

  defp merge_and_sanitize_params(socket, overrides \\ %{}) do
    %{sorting: sorting, filter: filter} = socket.assigns

    %{}
    |> Map.merge(sorting)
    |> Map.merge(filter)
    |> Map.merge(overrides)
    |> Enum.reject(fn {_key, value} -> is_nil(value) end)
    |> Map.new()
  end

  defp parse_params(socket, params) do
    with {:ok, sorting_opts} <- SortingForm.parse(params),
         {:ok, filter_opts} <- FilterForm.parse(params) do
      socket
      |> assign_filter(filter_opts)
      |> assign_sorting(sorting_opts)
    else
      _error ->
        socket
        |> assign_filter()
        |> assign_sorting()
    end
  end

  defp assign_filter(socket, overrides \\ %{}) do
    assign(socket, :filter, FilterForm.default_values(overrides))
  end

  defp assign_sorting(socket, overrides \\ %{}) do
    opts = Map.merge(SortingForm.default_values(), overrides)
    assign(socket, :sorting, opts)
  end

  defp assign_hills(socket) do
    params = merge_and_sanitize_params(socket)
    assign(socket, :hills, Hills.list_hills(params))
  end
end
