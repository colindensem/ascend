defmodule Ascend.Hills do
  @moduledoc """
  The Hills context.
  """

  import Ecto.Query, warn: false
  alias Ascend.Repo
  alias Ascend.Hills.Hill

  @doc """
  Returns the list of hills.

  ## Examples

      iex> list_hills()
      [%Hill{}, ...]

  """
  def list_hills(opts \\ %{}) do
    from(h in Hill)
    |> filter(opts)
    |> sort(opts)
    |> Repo.all()
  end

  @doc """
  Returns a count of hills.

  ## Examples

      iex> hill_count()
      10

  """
  def hill_count(opts \\ %{}) do
    from(h in Hill)
    |> filter(opts)
    |> Repo.aggregate(:count)
  end

  @doc """
  Returns the list of hills with a total count

  ## Examples

      iex> list_hills_with_total_count(%{})
      %{hills: [%Hill{}, ...], total_count: 2}

  """
  def list_hills_with_total_count(opts \\ %{}) do
    query = from(h in Hill) |> filter(opts)

    total_count = Repo.aggregate(query, :count)

    result =
      query
      |> sort(opts)
      |> paginate(opts)
      |> Repo.all()

    %{hills: result, total_count: total_count}
  end

  def list_hills_with_pagination(offset, limit, opts \\ %{}) do
    from(h in Hill)
    |> filter(opts)
    |> limit(^limit)
    |> offset(^offset)
    |> Repo.all()
  end

  defp paginate(query, %{page: page, page_size: page_size})
       when is_integer(page) and is_integer(page_size) do
    offset = max(page - 1, 0) * page_size

    query
    |> limit(^page_size)
    |> offset(^offset)
  end

  defp paginate(query, _opts), do: query

  defp filter(query, opts) do
    query
    |> filter_by_name(opts)
  end

  defp filter_by_name(query, %{name: name})
       when is_binary(name) and name != "" do
    query_string = "%#{name}%"
    where(query, [h], like(h.name, ^query_string))
  end

  defp filter_by_name(query, _opts), do: query

  defp sort(query, %{sort_by: sort_by, sort_dir: sort_dir})
       when sort_by in [:dobih_id, :name, :metres, :feet] and
              sort_dir in [:asc, :desc] do
    order_by(query, {^sort_dir, ^sort_by})
  end

  defp sort(query, %{}) do
    order_by(query, {:asc, :metres})
  end

  @doc """
  Gets a single hill.

  Raises `Ecto.NoResultsError` if the Hill does not exist.

  ## Examples

      iex> get_hill!(123)
      %Hill{}

      iex> get_hill!(456)
      ** (Ecto.NoResultsError)

  """
  def get_hill!(id), do: Repo.get!(Hill, id)

  @doc """
  Creates a hill.

  ## Examples

      iex> create_hill(%{field: value})
      {:ok, %Hill{}}

      iex> create_hill(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_hill(attrs \\ %{}) do
    %Hill{}
    |> Hill.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a hill.

  ## Examples

      iex> update_hill(hill, %{field: new_value})
      {:ok, %Hill{}}

      iex> update_hill(hill, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_hill(%Hill{} = hill, attrs) do
    hill
    |> Hill.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a hill.

  ## Examples

      iex> delete_hill(hill)
      {:ok, %Hill{}}

      iex> delete_hill(hill)
      {:error, %Ecto.Changeset{}}

  """
  def delete_hill(%Hill{} = hill) do
    Repo.delete(hill)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking hill changes.

  ## Examples

      iex> change_hill(hill)
      %Ecto.Changeset{data: %Hill{}}

  """
  def change_hill(%Hill{} = hill, attrs \\ %{}) do
    Hill.changeset(hill, attrs)
  end

  def mappings do
    %{
      "Ma" => "Marylin",
      "Hu" => "Hump",
      "Sim" => "Simm",
      "5" => "Dodd",
      "M" => "Munro",
      "MT" => "Munro Top",
      "F" => "Furth",
      "C" => "Corbett",
      "G" => "Graham",
      "D" => "Donald",
      "DT" => "Donald Top",
      "Hew" => "Hewitt",
      "N" => "Nuttall",
      "Dew" => "Dewey",
      "DDew" => "Donald Dewey",
      "HF" => "Highland Five",
      "W" => "Wainwright",
      "WO" => "Wainwright Outlying Fell",
      "B" => "Birkett",
      "Sy" => "Synge",
      "Fel" => "Fellranger",
      "Dil" => "Dillon",
      "A" => "Arderin",
      "VL" => "Vandeleur-Lynam",
      "O" => "Other list",
      "Un" => "unclassified"
    }
  end
end
