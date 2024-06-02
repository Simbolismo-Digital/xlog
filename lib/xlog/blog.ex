defmodule Xlog.Blog do

  @user_id "2e7dfede-0852-4990-b4c0-3510c520dfb9"
  @post_1_id "bec2178e-be3e-4e0d-b492-33ddef8ecb6d"

  def url() do
    "git@github.com:Simbolismo-Digital/blog.git"
  end

  def path() do
    "content/blog"
  end

  def repository() do
    %Git.Repository{path: "#{File.cwd!()}/#{path()}"}
  end

  def clone() do
    if File.exists?(path()) do
      {:ok, repository()}
    else
      Git.clone([url(), path()])
    end
  end

  def pull() do
    Git.pull(repository())
  end

  # Work with partial data

  # def fetch() do
  #   Git.fetch(repository())
  # end

  # def checkout() do
  #   checkout(@user_id, @post_1_id)
  # end

  # def checkout(user_id, post_1_id) do
  #   Git.checkout(repository(), ["origin/main", "--", "blog/content/#{user_id}/content/#{post_1_id}"])
  # end

  # def ls_files() do
  #   with {:ok, files} <- Git.ls_tree(repository(), ["-r", "--name-only", "main", "--", "blog/content/#{@user_id}"]) do
  #     {:ok, String.split(files, "\n", trim: true)}
  #   end
  # end
end
