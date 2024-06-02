defmodule Xlog.MarkdownViewersTest do
  use Xlog.DataCase

  alias Xlog.MarkdownViewers

  describe "markdown_viewer" do
    alias Xlog.MarkdownViewers.MarkdownViewer

    import Xlog.MarkdownViewersFixtures

    @invalid_attrs %{}

    test "list_markdown_viewer/0 returns all markdown_viewer" do
      markdown_viewer = markdown_viewer_fixture()
      assert MarkdownViewers.list_markdown_viewer() == [markdown_viewer]
    end

    test "get_markdown_viewer!/1 returns the markdown_viewer with given id" do
      markdown_viewer = markdown_viewer_fixture()
      assert MarkdownViewers.get_markdown_viewer!(markdown_viewer.id) == markdown_viewer
    end

    test "create_markdown_viewer/1 with valid data creates a markdown_viewer" do
      valid_attrs = %{}

      assert {:ok, %MarkdownViewer{} = markdown_viewer} = MarkdownViewers.create_markdown_viewer(valid_attrs)
    end

    test "create_markdown_viewer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = MarkdownViewers.create_markdown_viewer(@invalid_attrs)
    end

    test "update_markdown_viewer/2 with valid data updates the markdown_viewer" do
      markdown_viewer = markdown_viewer_fixture()
      update_attrs = %{}

      assert {:ok, %MarkdownViewer{} = markdown_viewer} = MarkdownViewers.update_markdown_viewer(markdown_viewer, update_attrs)
    end

    test "update_markdown_viewer/2 with invalid data returns error changeset" do
      markdown_viewer = markdown_viewer_fixture()
      assert {:error, %Ecto.Changeset{}} = MarkdownViewers.update_markdown_viewer(markdown_viewer, @invalid_attrs)
      assert markdown_viewer == MarkdownViewers.get_markdown_viewer!(markdown_viewer.id)
    end

    test "delete_markdown_viewer/1 deletes the markdown_viewer" do
      markdown_viewer = markdown_viewer_fixture()
      assert {:ok, %MarkdownViewer{}} = MarkdownViewers.delete_markdown_viewer(markdown_viewer)
      assert_raise Ecto.NoResultsError, fn -> MarkdownViewers.get_markdown_viewer!(markdown_viewer.id) end
    end

    test "change_markdown_viewer/1 returns a markdown_viewer changeset" do
      markdown_viewer = markdown_viewer_fixture()
      assert %Ecto.Changeset{} = MarkdownViewers.change_markdown_viewer(markdown_viewer)
    end
  end
end
