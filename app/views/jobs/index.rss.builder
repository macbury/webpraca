xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title @page_title.join(' | ')
    xml.link jobs_url(stripped_params(:format => :html))
    
    for job in @jobs
      xml.item do
        xml.title "[#{JOB_LABELS[job.type_id]}] #{job.title}"
        xml.description truncate(job.description, :length => 512)
        xml.pubDate job.created_at.to_s(:rfc822)
        xml.link seo_job_url(job)
        xml.guid job_url(job)
      end
    end


  end
end