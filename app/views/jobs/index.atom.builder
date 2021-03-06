atom_feed do |feed|
  feed.title(@page_title.join(' | '))
  unless @jobs.empty?
    feed.updated((@jobs.first.created_at))
  end

  @jobs.each do |job|
    feed.entry(job) do |entry|
      entry.title("[#{JOB_TYPES[job.type_id]}] #{job.title}")
      entry.content(truncate(job.description, :length => 512), :type => 'html')
    end
  end
end