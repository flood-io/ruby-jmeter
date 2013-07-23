class String
  def strip_heredoc
    gsub /^#{self[/\A\s*/]}/, ''
  end
end