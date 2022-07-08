defmodule AscendWeb.InfinityLive do
  use AscendWeb, :live_view

  alias Ascend.Hills
  alias AscendWeb.Forms.FilterForm

  def render(assigns) do
    ~H"""
    <h1>Listing <%= @count %> Hills</h1>
    <.live_component
      module={AscendWeb.Live.FilterComponent}
      id="filter"
      filter={@filter}
    />
    <table>
      <tbody id={"hills-#{@count}"} phx-update="append" phx-hook="InfinityScroll">
      <%= for hill <- @hills do %>
        <tr id={"hill-#{hill.id}"}>
          <td>
            <%= live_redirect "#{hill.name}", to: Routes.hill_show_path(@socket, :show, hill) %>
          </td>
          <td><%= hill.dobih_id %></td>
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

    socket =
      socket
      |> assign(offset: 0, limit: 25, count: count)

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

    {:noreply, push_patch(socket, to: path, replace: true)}
  end

  defp merge_and_sanitize_params(socket, overrides \\ %{}) do
    %{filter: filter} = socket.assigns

    %{}
    |> Map.merge(filter)
    |> Map.merge(overrides)
    |> Enum.reject(fn {_key, value} -> is_nil(value) end)
    |> Map.new()
  end

  defp parse_params(socket, params) do
    with {:ok, filter_opts} <- FilterForm.parse(params) do
      socket
      |> assign_filter(filter_opts)
    else
      _error ->
        socket
        |> assign_filter()
    end
  end

  defp assign_filter(socket, overrides \\ %{}) do
    assign(socket, :filter, FilterForm.default_values(overrides))
  end

  defp load_hills(socket) do
    %{offset: offset, limit: limit} = socket.assigns

    params = merge_and_sanitize_params(socket)

    socket
    |> assign(:hills, Hills.list_hills_with_pagination(offset, limit, params))
    |> assign(:count, Hills.hill_count(params))
  end
end
