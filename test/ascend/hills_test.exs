defmodule Ascend.HillsTest do
  use Ascend.DataCase

  alias Ascend.Hills

  describe "hills" do
    alias Ascend.Hills.Hill

    import Ascend.HillsFixtures

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

    test "list_hills/0 returns all hills" do
      hill = hill_fixture()
      assert Hills.list_hills() == [hill]
    end

    test "get_hill!/1 returns the hill with given id" do
      hill = hill_fixture()
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
      hill = hill_fixture()

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
      hill = hill_fixture()
      assert {:error, %Ecto.Changeset{}} = Hills.update_hill(hill, @invalid_attrs)
      assert hill == Hills.get_hill!(hill.id)
    end

    test "delete_hill/1 deletes the hill" do
      hill = hill_fixture()
      assert {:ok, %Hill{}} = Hills.delete_hill(hill)
      assert_raise Ecto.NoResultsError, fn -> Hills.get_hill!(hill.id) end
    end

    test "change_hill/1 returns a hill changeset" do
      hill = hill_fixture()
      assert %Ecto.Changeset{} = Hills.change_hill(hill)
    end
  end
end
