defmodule Xlog.MarkdownViewers.MarkdownViewer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "markdown_viewer" do


    timestamps()
  end

  @doc false
  def changeset(markdown_viewer, attrs) do
    markdown_viewer
    |> cast(attrs, [])
    |> validate_required([])
  end
end
