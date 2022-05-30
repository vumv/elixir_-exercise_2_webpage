defmodule CrawlerWebpage.CrawledItemsTest do
  use CrawlerWebpage.DataCase

  alias CrawlerWebpage.CrawledItems

  describe "item" do
    alias CrawlerWebpage.CrawledItems.Items

    import CrawlerWebpage.CrawledItemsFixtures

    @invalid_attrs %{crawled_at: nil, full_series: nil, link: nil, number_of_episode: nil, thumbnail: nil, title: nil, year: nil}

    test "list_item/0 returns all item" do
      items = items_fixture()
      assert CrawledItems.list_item() == [items]
    end

    test "get_items!/1 returns the items with given id" do
      items = items_fixture()
      assert CrawledItems.get_items!(items.id) == items
    end

    test "create_items/1 with valid data creates a items" do
      valid_attrs = %{crawled_at: "some crawled_at", full_series: true, link: "some link", number_of_episode: 42, thumbnail: "some thumbnail", title: "some title", year: 42}

      assert {:ok, %Items{} = items} = CrawledItems.create_items(valid_attrs)
      assert items.crawled_at == "some crawled_at"
      assert items.full_series == true
      assert items.link == "some link"
      assert items.number_of_episode == 42
      assert items.thumbnail == "some thumbnail"
      assert items.title == "some title"
      assert items.year == 42
    end

    test "create_items/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = CrawledItems.create_items(@invalid_attrs)
    end

    test "update_items/2 with valid data updates the items" do
      items = items_fixture()
      update_attrs = %{crawled_at: "some updated crawled_at", full_series: false, link: "some updated link", number_of_episode: 43, thumbnail: "some updated thumbnail", title: "some updated title", year: 43}

      assert {:ok, %Items{} = items} = CrawledItems.update_items(items, update_attrs)
      assert items.crawled_at == "some updated crawled_at"
      assert items.full_series == false
      assert items.link == "some updated link"
      assert items.number_of_episode == 43
      assert items.thumbnail == "some updated thumbnail"
      assert items.title == "some updated title"
      assert items.year == 43
    end

    test "update_items/2 with invalid data returns error changeset" do
      items = items_fixture()
      assert {:error, %Ecto.Changeset{}} = CrawledItems.update_items(items, @invalid_attrs)
      assert items == CrawledItems.get_items!(items.id)
    end

    test "delete_items/1 deletes the items" do
      items = items_fixture()
      assert {:ok, %Items{}} = CrawledItems.delete_items(items)
      assert_raise Ecto.NoResultsError, fn -> CrawledItems.get_items!(items.id) end
    end

    test "change_items/1 returns a items changeset" do
      items = items_fixture()
      assert %Ecto.Changeset{} = CrawledItems.change_items(items)
    end
  end
end
