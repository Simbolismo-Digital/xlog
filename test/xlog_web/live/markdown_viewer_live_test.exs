defmodule XlogWeb.MarkdownViewerLiveTest do
  use XlogWeb.ConnCase

  import Phoenix.LiveViewTest
  import Xlog.MarkdownViewersFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp create_markdown_viewer(_) do
    markdown_viewer = markdown_viewer_fixture()
    %{markdown_viewer: markdown_viewer}
  end

  describe "Index" do
    setup [:create_markdown_viewer]

    test "lists all markdown_viewer", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/markdown_viewer")

      assert html =~ "Listing Markdown viewer"
    end

    test "saves new markdown_viewer", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/markdown_viewer")

      assert index_live |> element("a", "Nova Publicação") |> render_click() =~
               "New Markdown viewer"

      assert_patch(index_live, ~p"/markdown_viewer/new")

      assert index_live
             |> form("#markdown_viewer-form", markdown_viewer: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#markdown_viewer-form", markdown_viewer: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/markdown_viewer")

      html = render(index_live)
      assert html =~ "Markdown viewer created successfully"
    end

    test "updates markdown_viewer in listing", %{conn: conn, markdown_viewer: markdown_viewer} do
      {:ok, index_live, _html} = live(conn, ~p"/markdown_viewer")

      assert index_live
             |> element("#markdown_viewer-#{markdown_viewer.id} a", "Edit")
             |> render_click() =~
               "Edit Markdown viewer"

      assert_patch(index_live, ~p"/markdown_viewer/#{markdown_viewer}/edit")

      assert index_live
             |> form("#markdown_viewer-form", markdown_viewer: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#markdown_viewer-form", markdown_viewer: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/markdown_viewer")

      html = render(index_live)
      assert html =~ "Markdown viewer updated successfully"
    end

    test "deletes markdown_viewer in listing", %{conn: conn, markdown_viewer: markdown_viewer} do
      {:ok, index_live, _html} = live(conn, ~p"/markdown_viewer")

      assert index_live
             |> element("#markdown_viewer-#{markdown_viewer.id} a", "Delete")
             |> render_click()

      refute has_element?(index_live, "#markdown_viewer-#{markdown_viewer.id}")
    end
  end

  describe "Show" do
    setup [:create_markdown_viewer]

    test "displays markdown_viewer", %{conn: conn, markdown_viewer: markdown_viewer} do
      {:ok, _show_live, html} = live(conn, ~p"/markdown_viewer/#{markdown_viewer}")

      assert html =~ "Show Markdown viewer"
    end

    test "updates markdown_viewer within modal", %{conn: conn, markdown_viewer: markdown_viewer} do
      {:ok, show_live, _html} = live(conn, ~p"/markdown_viewer/#{markdown_viewer}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Markdown viewer"

      assert_patch(show_live, ~p"/markdown_viewer/#{markdown_viewer}/show/edit")

      assert show_live
             |> form("#markdown_viewer-form", markdown_viewer: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#markdown_viewer-form", markdown_viewer: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/markdown_viewer/#{markdown_viewer}")

      html = render(show_live)
      assert html =~ "Markdown viewer updated successfully"
    end
  end
end
