defmodule XlogWeb.MarkdownViewerLive.Functions do
  @moduledoc """
  Documentation for Templating render.
  """

  @doc """
  Hello world.

  """
  def as_html(lines, options \\ %Earmark.Options{}) do
    lines
    |> EEx.eval_string([], [])
    |> Earmark.as_html(options)
  end

  def youtube(video_id, width \\ 640, height \\ 360) do
    "<iframe id=\"youtube-player\" type=\"text/html\" width=\"#{width}\" height=\"#{height}\" src=\"http://www.youtube.com/embed/#{video_id}?autoplay=1\" frameborder=\"0\"></iframe>"
  end
end
