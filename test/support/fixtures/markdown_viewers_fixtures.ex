defmodule Xlog.MarkdownViewersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Xlog.MarkdownViewers` context.
  """

  @doc """
  Generate a markdown_viewer.
  """
  def markdown_viewer_fixture(attrs \\ %{}) do
    {:ok, markdown_viewer} =
      attrs
      |> Enum.into(%{})
      |> Xlog.MarkdownViewers.create_markdown_viewer()

    markdown_viewer
  end
end
