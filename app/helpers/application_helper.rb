module ApplicationHelper
	def collection_from_types(hash)
		out = []
		types.each_with_index { |e,i| out << [e,i] }
		return out
	end
	
	def stripped_params(o={})
		p = params.clone
		p.delete(:controller)
		p.delete(:action)
		p.delete(:page)
		p.merge!(o)
		return p
	end
	
	# add rss link
	def rss_link(title, path)
    tag :link, :type => 'application/rss+xml', :title => title, :href => path
  end
end