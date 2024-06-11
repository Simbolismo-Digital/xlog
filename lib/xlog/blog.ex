defmodule Xlog.Blog do
  def url() do
    "git@github.com:Simbolismo-Digital/blog.git"
  end

  def repo_path() do
    "content/blog"
  end

  # write
  def repository() do
    %Git.Repository{path: "#{File.cwd!()}/#{repo_path()}"}
  end

  def clone() do
    if File.exists?(repo_path()) do
      {:ok, repository()}
    else
      with {:ok, _repo} <- Git.clone(["--no-checkout", url(), repo_path()]) do
        Git.reset(repository(), ["--hard"])
      end
    end
  end

  def fetch() do
    Git.fetch(repository(), ["origin", "main"])
  end

  def checkout(paths) do
    with {:ok, _} <- Git.checkout(repository(), ["origin/main", "--"] ++ paths) do
      paths
    end
  end

  def commit_and_merge(relative_path, message) do
    repository = repository()
    with :ok <- commit(repository, relative_path, message),
      :ok <- create_and_merge_pr(),
      {:ok, _} <- clean_temp(repository) do
        :ok
      end
  end

  def commit(repository, path, message) do
    with {:ok, _} <- Git.add(repository, path),
      {:ok, _} <- Git.commit(repository, "-m #{message}"),
      {:ok, _} <- Git.branch(repository, ["temp"]),
      {:ok, _} <- Git.push(repository, ["origin", "temp", "--force"]) do
        :ok
      end
  end

  def create_and_merge_pr() do
    with {url, 0} <- create_pr(),
      {_, 0} <- merge_pr(String.trim(url)) do
        :ok
    end
  end

  def clean_temp(repository) do
    Git.branch(repository, ["-D", "temp"])
  end

  def create_pr() do
    System.cmd("gh", ["pr", "create", "--head", "temp", "-f"], cd: repo_path())
  end

  def merge_pr(url) do
    System.cmd("gh", ["pr", "merge", "--merge", url], cd: repo_path())
  end

  def get_contents(contents, max \\ 10, skip \\ 0) do
    repository = repository()

    case log(repository, contents, max, skip) do
      [] -> []

      commit_hashes ->
        commit_range(commit_hashes)
        |> get_file_paths_between_commits!(repository)
        |> content_base_path(contents)
        |> dbg()
    end
  end

  def creation_time(file_path) do
    repository()
    |> Git.log([
      "--pretty=format:%aI",
      "--date=format-local:%Y-%m-%dT%H:%M:%S%z",
      file_path
    ])
  end

  # git log --max-count=2 --skip=0 --pretty=format:'%H | %aI | %s' --date=format-local:%Y-%m-%dT%H:%M:%S%z --relative=posts --no-merges origin/main
  # git log --max-count=2 --skip=0 --pretty=format:%H --relative=posts --no-merges origin/main
  def log(repository, resource, max \\ 10, skip \\ 0) do
    repository
    |> Git.log([
      "--pretty=format:%H",
      "--max-count=#{max+1}",
      "--skip=#{skip}",
      "--relative=#{resource}",
      "origin/main",
      "--no-merges"
    ])
    |> split!()
  end

  defp commit_range(commit_hashes) do
    "#{List.first(commit_hashes)}..#{List.last(commit_hashes)}"
  end

  def get_file_paths_between_commits!(commit_range, repository) do
    repository
    |> Git.diff(["--name-only", commit_range])
    |> split!()
  end

  defp split!({:ok, infos}) do
    String.split(infos, "\n", trim: true)
  end

  defp content_base_path(files, prefix) do
    files
    |> Enum.map(&Path.dirname/1)
    |> Enum.uniq()
    |> filter_content_uuid(prefix)
  end

  defp filter_content_uuid(paths, prefix) do
    Enum.filter(paths, & Regex.match?(~r/^#{prefix}\/[0-9a-fA-F-]{36}$/, &1))
  end
end
