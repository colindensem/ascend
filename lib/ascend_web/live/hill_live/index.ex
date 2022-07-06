defmodule AscendWeb.HillLive.Index do
  use AscendWeb, :live_view

  alias Ascend.Hills
  alias AscendWeb.Forms.FilterForm
  alias AscendWeb.Forms.SortingForm
  alias AscendWeb.Forms.PaginationForm

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
    %{sorting: sorting, filter: filter, pagination: pagination} = socket.assigns

    %{}
    |> Map.merge(sorting)
    |> Map.merge(filter)
    |> Map.merge(pagination)
    |> Map.merge(overrides)
    |> Map.drop([:total_count])
    |> Enum.reject(fn {_key, value} -> is_nil(value) end)
    |> Map.new()
  end

  defp parse_params(socket, params) do
    with {:ok, sorting_opts} <- SortingForm.parse(params),
         {:ok, filter_opts} <- FilterForm.parse(params),
         {:ok, pagination_opts} <- PaginationForm.parse(params) do
      socket
      |> assign_filter(filter_opts)
      |> assign_sorting(sorting_opts)
      |> assign_pagination(pagination_opts)
    else
      _error ->
        socket
        |> assign_filter()
        |> assign_sorting()
        |> assign_pagination()
    end
  end

  defp assign_filter(socket, overrides \\ %{}) do
    assign(socket, :filter, FilterForm.default_values(overrides))
  end

  defp assign_sorting(socket, overrides \\ %{}) do
    opts = Map.merge(SortingForm.default_values(), overrides)
    assign(socket, :sorting, opts)
  end

  defp assign_pagination(socket, overrides \\ %{}) do
    assign(socket, :pagination, PaginationForm.default_values(overrides))
  end

  defp assign_hills(socket) do
    params = merge_and_sanitize_params(socket)
    %{hills: hills, total_count: total_count} = Hills.list_hills_with_total_count(params)

    socket
    |> assign(:hills, hills)
    |> assign_total_count(total_count)
  end

  defp assign_total_count(socket, total_count) do
    update(socket, :pagination, fn pagination ->
      %{
        pagination
        | total_count: total_count
      }
    end)
  end
end
