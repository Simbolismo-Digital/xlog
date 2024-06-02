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
  def list_markdown_viewer do
    Repo.all(MarkdownViewer)
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
  def get_markdown_viewer!(id), do: Repo.get!(MarkdownViewer, id)

  @doc """
  Creates a markdown_viewer.

  ## Examples

      iex> create_markdown_viewer(%{field: value})
      {:ok, %MarkdownViewer{}}

      iex> create_markdown_viewer(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_markdown_viewer(attrs \\ %{}) do
    %MarkdownViewer{}
    |> MarkdownViewer.changeset(attrs)
    |> Repo.insert()
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