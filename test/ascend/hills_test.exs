defmodule Ascend.HillsTest do
  use Ascend.DataCase

  alias Ascend.Hills

  describe "hills" do
    alias Ascend.Hills.Hill

    import Ascend.Factory

    @invalid_attrs %{
      area: nil,
      classification: nil,
      dobih_id: nil,
      feet: nil,
      grid_ref: nil,
      metres: nil,
      munro: nil,
      name: nil,
      region: nil,
      wainwright: nil,
      wainwright_outlying_fell: nil
    }

    test "list_hills/1 returns all hills" do
      hill1 = insert(:hill, metres: 500, feet: 1640.42)
      hill2 = insert(:hill, metres: 1000, feet: 3280.84)
      assert Hills.list_hills(%{}) == [hill2, hill1]
    end

    test "list_hills/1 with name sort" do
      hill1 = insert(:hill, name: "Z Hill")
      hill2 = insert(:hill, name: "A Hill")

      params = %{sort_by: :name, sort_dir: :asc}
      assert Hills.list_hills(params) == [hill2, hill1]
    end

    test "list_hills/1 with name filter" do
      hill1 = insert(:hill, name: "Z Hill")
      hill2 = insert(:hill, name: "A Hill")

      params = %{name: "a"}
      assert Hills.list_hills(params) == [hill2]
      params = %{name: "Z"}
      assert Hills.list_hills(params) == [hill1]
    end

    test "list_hills_with_total_count/1 returns all hills" do
      hill1 = insert(:hill, metres: 500, feet: 1640.42)
      hill2 = insert(:hill, metres: 1000, feet: 3280.84)

      assert Hills.list_hills_with_total_count(%{}) == %{
               hills: [hill2, hill1],
               total_count: 2
             }
    end

    test "list_hills_with_total_count/1 returns paginated hills" do
      insert(:hill, name: "Z Hill")
      hill2 = insert(:hill, name: "A Hill1")
      hill3 = insert(:hill, name: "A Hill2")
      hill4 = insert(:hill, name: "A Hill3")

      assert Hills.list_hills_with_total_count(%{name: "a", page_size: 2, page: 1}) == %{
               hills: [hill2, hill3],
               total_count: 3
             }

      assert Hills.list_hills_with_total_count(%{name: "a", page_size: 2, page: 2}) == %{
               hills: [hill4],
               total_count: 3
             }
    end

    test "hill_count/1 returns a count" do
      insert(:hill)
      assert Hills.hill_count(%{}) == 1
    end

    test "hill_count/1 returns a filtered count" do
      insert(:hill, name: "Z Hill")
      insert(:hill, name: "A Hill1")
      insert(:hill, name: "A Hill2")
      insert(:hill, name: "A Hill3")

      assert Hills.hill_count(%{name: "a"}) == 3
    end

    test "list_hills_with_pagination/3" do
      hill1 = insert(:hill, name: "A Hill1")
      hill2 = insert(:hill, name: "A Hill2")
      hill3 = insert(:hill, name: "A Hill3")

      assert Hills.list_hills_with_pagination(0, 1, %{}) == [hill1]
      assert Hills.list_hills_with_pagination(1, 2, %{}) == [hill2, hill3]
    end

    test "list_hills_with_pagination/3 with name sort" do
      insert(:hill, name: "Z Hill")
      hill2 = insert(:hill, name: "AB Hill")
      hill3 = insert(:hill, name: "AA Hill")

      params = %{name: "a", sort_by: :name, sort_dir: :asc}
      assert Hills.list_hills_with_pagination(0, 2, params) == [hill3, hill2]
      assert Hills.list_hills_with_pagination(0, 1, params) == [hill3]
      assert Hills.list_hills_with_pagination(1, 1, params) == [hill2]
    end

    test "get_hill!/1 returns the hill with given id" do
      hill = insert(:hill)
      assert Hills.get_hill!(hill.id) == hill
    end

    test "create_hill/1 with valid data creates a hill" do
      valid_attrs = %{
        area: "some area",
        classification: "some classification",
        dobih_id: 42,
        feet: 120.5,
        grid_ref: "some grid_ref",
        metres: 120.5,
        munro: true,
        name: "some name",
        region: "some region",
        wainwright: true,
        wainwright_outlying_fell: true
      }

      assert {:ok, %Hill{} = hill} = Hills.create_hill(valid_attrs)
      assert hill.area == "some area"
      assert hill.classification == "some classification"
      assert hill.dobih_id == 42
      assert hill.feet == 120.5
      assert hill.grid_ref == "some grid_ref"
      assert hill.metres == 120.5
      assert hill.munro == true
      assert hill.name == "some name"
      assert hill.region == "some region"
      assert hill.wainwright == true
      assert hill.wainwright_outlying_fell == true
    end

    test "create_hill/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Hills.create_hill(@invalid_attrs)
    end

    test "update_hill/2 with valid data updates the hill" do
      hill = insert(:hill)

      update_attrs = %{
        area: "some updated area",
        classification: "some updated classification",
        dobih_id: 43,
        feet: 456.7,
        grid_ref: "some updated grid_ref",
        metres: 456.7,
        munro: false,
        name: "some updated name",
        region: "some updated region",
        wainwright: false,
        wainwright_outlying_fell: false
      }

      assert {:ok, %Hill{} = hill} = Hills.update_hill(hill, update_attrs)
      assert hill.area == "some updated area"
      assert hill.classification == "some updated classification"
      assert hill.dobih_id == 43
      assert hill.feet == 456.7
      assert hill.grid_ref == "some updated grid_ref"
      assert hill.metres == 456.7
      assert hill.munro == false
      assert hill.name == "some updated name"
      assert hill.region == "some updated region"
      assert hill.wainwright == false
      assert hill.wainwright_outlying_fell == false
    end

    test "update_hill/2 with invalid data returns error changeset" do
      hill = insert(:hill)
      assert {:error, %Ecto.Changeset{}} = Hills.update_hill(hill, @invalid_attrs)
      assert hill == Hills.get_hill!(hill.id)
    end

    test "delete_hill/1 deletes the hill" do
      hill = insert(:hill)
      assert {:ok, %Hill{}} = Hills.delete_hill(hill)
      assert_raise Ecto.NoResultsError, fn -> Hills.get_hill!(hill.id) end
    end

    test "change_hill/1 returns a hill changeset" do
      hill = insert(:hill)
      assert %Ecto.Changeset{} = Hills.change_hill(hill)
    end
  end
end
