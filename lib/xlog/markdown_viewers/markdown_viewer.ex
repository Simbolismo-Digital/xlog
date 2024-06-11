defmodule Xlog.MarkdownViewers.MarkdownViewer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "markdown_viewer" do
    field :title, :string, virtual: true
    field :content, :string, virtual: true
    field :metadata, :map, virtual: true
    timestamps()
  end

  @doc false
  def changeset(markdown_viewer, attrs) do
    markdown_viewer
    |> cast(attrs, [:title, :content])
    |> validate_required([:title, :content])
    |> put_change(:id, Ecto.UUID.generate())
    |> put_metadata()
    |> merge_title()
  end

  def put_metadata(changeset) do
    case get_change(changeset, :title) do
      "" -> put_change(changeset, :metadata, %{title: "Untitled-#{get_change(changeset, :id)}"})

      nil -> put_change(changeset, :metadata, %{title: "Untitled-#{get_change(changeset, :id)}"})

      title -> put_change(changeset, :metadata, %{title: title})
    end
  end

  def merge_title(changeset) do
    case get_change(changeset, :title) do
      "" ->
        changeset

      nil ->
        changeset

      title ->
        content = get_change(changeset, :content)

        changeset
        |> put_change(
          :content,
          "# #{title}\n\n#{content}"
        )
    end
  end
end
