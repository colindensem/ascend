defmodule AscendWeb.Live.FilterComponent do
  use AscendWeb, :live_component
  alias AscendWeb.Forms.FilterForm

  def render(assigns) do
    ~H"""
    <div>
      <.form let={f} for={@changeset} as="filter"
          phx-submit="search" phx-target={@myself}>
        <div>
          <div>
            <%= label f, :name %>
            <%= text_input f, :name %>
            <%= error_tag f, :name %>
          </div>
          <%= submit "Search" %>
        </div>
      </.form>
    </div>
    """
  end

  def update(%{filter: filter}, socket) do
    {:ok, assign(socket, :changeset, FilterForm.change_values(filter))}
  end

  def handle_event("search", %{"filter" => filter}, socket) do
    case FilterForm.parse(filter) do
      {:ok, opts} ->
        IO.puts("Send self 1")
        send(self(), {:update, opts})
        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end
