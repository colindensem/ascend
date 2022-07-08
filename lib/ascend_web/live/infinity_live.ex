defmodule AscendWeb.InfinityLive do
  use AscendWeb, :live_view

  alias Ascend.Hills
  alias AscendWeb.Forms.FilterForm
  alias AscendWeb.Forms.SortingForm

  def render(assigns) do
    ~H"""
    <h1>Listing <%= @count %> Hills</h1>
    <.live_component
      module={AscendWeb.Live.FilterComponent}
      id="filter"
      filter={@filter}
    />
    <table>
      <thead>
        <tr>
          <th>
            <.live_component
              module={AscendWeb.Live.SortingComponent}
              id={"sorting-name"}
              key={:name}
              display_name="Name"
              sorting={@sorting} />
          </th>
          <th>
            <.live_component
              module={AscendWeb.Live.SortingComponent}
              id={"sorting-metres"}
              key={:metres}
              display_name="Metres"
              sorting={@sorting} />
          </th>
          <th>
            <.live_component
              module={AscendWeb.Live.SortingComponent}
              id={"sorting-feet"}
              key={:feet}
              display_name="Feet"
              sorting={@sorting} />
          </th>
          <th>Grid ref</th>
          <th>Classification</th>
          <th>Region</th>
          <th>Area</th>
        </tr>
      </thead>
      <tbody id={"hills-#{@key}"} phx-update="append" phx-hook="InfinityScroll">
      <%= for hill <- @hills do %>
        <tr id={"hill-#{hill.id}"}>
          <td>
            <%= live_redirect "#{hill.name}", to: Routes.hill_show_path(@socket, :show, hill) %>
          </td>
          <td><%= hill.metres %></td>
          <td><%= hill.feet %></td>
          <td><%= hill.grid_ref %></td>
          <td><%= hill.classification %></td>
          <td><%= hill.region %></td>
          <td><%= hill.area %></td>
        </tr>
      <% end %>
      </tbody>
    </table>
    """
  end

  def mount(_params, _session, socket) do
    count = Hills.hill_count()
    key = :erlang.phash2(count)

    socket =
      socket
      |> assign(offset: 0, limit: 25, count: count, key: key)

    {:ok, socket, temporary_assigns: [hills: []]}
  end

  def handle_params(params, _url, socket) do
    socket =
      socket
      |> assign(:page_title, "Listing Hills")
      |> parse_params(params)
      |> load_hills()

    {:noreply, socket}
  end

  def handle_event("load-more", _params, socket) do
    %{offset: offset, limit: limit, count: count} = socket.assigns

    socket =
      if offset < count do
        socket
        |> assign(offset: offset + limit)
        |> load_hills()
      else
        socket
      end

    {:noreply, socket}
  end

  def handle_info({:update, opts}, socket) do
    params = merge_and_sanitize_params(socket, opts)
    path = Routes.live_path(socket, AscendWeb.InfinityLive, params)

    socket =
      socket
      |> assign(offset: 0)
      |> assign(limit: 25)
      |> assign(key: :erlang.phash2(params))

    {:noreply, push_patch(socket, to: path, replace: true)}
  end

  defp merge_and_sanitize_params(socket, overrides \\ %{}) do
    %{sorting: sorting, filter: filter} = socket.assigns

    %{}
    |> Map.merge(filter)
    |> Map.merge(sorting)
    |> Map.merge(overrides)
    |> Enum.reject(fn {_key, value} -> is_nil(value) end)
    |> Map.new()
  end

  defp parse_params(socket, params) do
    with {:ok, filter_opts} <- FilterForm.parse(params),
         {:ok, sorting_opts} <- SortingForm.parse(params) do
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

  defp load_hills(socket) do
    %{offset: offset, limit: limit} = socket.assigns

    params = merge_and_sanitize_params(socket)

    socket
    |> assign(:hills, Hills.list_hills_with_pagination(offset, limit, params))
    |> assign(:count, Hills.hill_count(params))
  end
end
