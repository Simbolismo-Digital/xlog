defmodule Xlog.Repo.Migrations.CreateMarkdownViewer do
  use Ecto.Migration

  def change do
    create table(:markdown_viewer) do
      timestamps()
    end
  end
end
