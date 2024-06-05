defmodule Html do
  @moduledoc """
  HTML parsers
  """

  def youtube(video_id, width \\ 640, height \\ 360) do
    "<iframe id=\"ytplayer\" type=\"text/html\" width=\"#{width}\" height=\"#{height}\" src=\"http://www.youtube.com/embed/#{video_id}?autoplay=1\" frameborder=\"0\"/>"
  end
end
