defmodule CrawlerWebpageWeb.ItemsControllerTest do
  use CrawlerWebpageWeb.ConnCase

  import CrawlerWebpage.CrawledItemsFixtures

  @create_attrs %{crawled_at: "some crawled_at", full_series: true, link: "some link", number_of_episode: 42, thumbnail: "some thumbnail", title: "some title", year: 42}
  @update_attrs %{crawled_at: "some updated crawled_at", full_series: false, link: "some updated link", number_of_episode: 43, thumbnail: "some updated thumbnail", title: "some updated title", year: 43}
  @invalid_attrs %{crawled_at: nil, full_series: nil, link: nil, number_of_episode: nil, thumbnail: nil, title: nil, year: nil}

  describe "index" do
    test "lists all item", %{conn: conn} do
      conn = get(conn, Routes.items_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Item"
    end
  end

  describe "new items" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.items_path(conn, :new))
      assert html_response(conn, 200) =~ "New Items"
    end
  end

  describe "create items" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.items_path(conn, :create), items: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.items_path(conn, :show, id)

      conn = get(conn, Routes.items_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Items"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.items_path(conn, :create), items: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Items"
    end
  end

  describe "edit items" do
    setup [:create_items]

    test "renders form for editing chosen items", %{conn: conn, items: items} do
      conn = get(conn, Routes.items_path(conn, :edit, items))
      assert html_response(conn, 200) =~ "Edit Items"
    end
  end

  describe "update items" do
    setup [:create_items]

    test "redirects when data is valid", %{conn: conn, items: items} do
      conn = put(conn, Routes.items_path(conn, :update, items), items: @update_attrs)
      assert redirected_to(conn) == Routes.items_path(conn, :show, items)

      conn = get(conn, Routes.items_path(conn, :show, items))
      assert html_response(conn, 200) =~ "some updated crawled_at"
    end

    test "renders errors when data is invalid", %{conn: conn, items: items} do
      conn = put(conn, Routes.items_path(conn, :update, items), items: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Items"
    end
  end

  describe "delete items" do
    setup [:create_items]

    test "deletes chosen items", %{conn: conn, items: items} do
      conn = delete(conn, Routes.items_path(conn, :delete, items))
      assert redirected_to(conn) == Routes.items_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.items_path(conn, :show, items))
      end
    end
  end

  defp create_items(_) do
    items = items_fixture()
    %{items: items}
  end
end
