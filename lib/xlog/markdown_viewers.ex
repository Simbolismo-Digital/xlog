defmodule Xlog.MarkdownViewers do
  @moduledoc """
  The MarkdownViewers context.
  """

  import Ecto.Query, warn: false
  alias Xlog.Repo

  alias Xlog.MarkdownViewers.MarkdownViewer

  @doc """
  Returns the list of markdown_viewer.

  ## Examples

      iex> list_markdown_viewer()
      [%MarkdownViewer{}, ...]

  """
  def list_markdown_viewer(max, page) do
    Xlog.Blog.posts(max, max * page)
    |> Xlog.Blog.checkout()
    |> Enum.map(&get_from_file/1)
    |> Enum.sort_by(& &1.inserted_at, :desc)
  end

  def get_from_file(path) do
    id = Path.basename(path)
    {:ok, creation_time} = Xlog.Blog.creation_time(path)
    {:ok, metadata} = Xlog.Blog.post_metadata(id)

    %MarkdownViewer{
      id: id,
      title: metadata.title,
      metadata: metadata,
      inserted_at: creation_time,
      updated_at: creation_time
    }
  end

  def iso8601(time) do
    NaiveDateTime.from_erl!(time)
    |> NaiveDateTime.to_iso8601()
  end

  @doc """
  Gets a single markdown_viewer.

  Raises `Ecto.NoResultsError` if the Markdown viewer does not exist.

  ## Examples

      iex> get_markdown_viewer!(123)
      %MarkdownViewer{}

      iex> get_markdown_viewer!(456)
      ** (Ecto.NoResultsError)

  """
  def get_markdown_viewer!(id), do: Xlog.Blog.post_data!(id)

  @doc """
  Creates a markdown_viewer.

  ## Examples

      iex> create_markdown_viewer(%{field: value})
      {:ok, %MarkdownViewer{}}

      iex> create_markdown_viewer(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_markdown_viewer(attrs \\ %{}) do
    view =
      %MarkdownViewer{}
      |> MarkdownViewer.changeset(attrs)
      |> Ecto.Changeset.apply_changes()

    with :ok <- Xlog.Blog.post_data(view.id, view) do
      {:ok, view}
    end
  end

  @doc """
  Updates a markdown_viewer.

  ## Examples

      iex> update_markdown_viewer(markdown_viewer, %{field: new_value})
      {:ok, %MarkdownViewer{}}

      iex> update_markdown_viewer(markdown_viewer, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_markdown_viewer(%MarkdownViewer{} = markdown_viewer, attrs) do
    markdown_viewer
    |> MarkdownViewer.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a markdown_viewer.

  ## Examples

      iex> delete_markdown_viewer(markdown_viewer)
      {:ok, %MarkdownViewer{}}

      iex> delete_markdown_viewer(markdown_viewer)
      {:error, %Ecto.Changeset{}}

  """
  def delete_markdown_viewer(%MarkdownViewer{} = markdown_viewer) do
    Repo.delete(markdown_viewer)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking markdown_viewer changes.

  ## Examples

      iex> change_markdown_viewer(markdown_viewer)
      %Ecto.Changeset{data: %MarkdownViewer{}}

  """
  def change_markdown_viewer(%MarkdownViewer{} = markdown_viewer, attrs \\ %{}) do
    MarkdownViewer.changeset(markdown_viewer, attrs)
  end
end
