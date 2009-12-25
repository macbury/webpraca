module ApplicationHelper
	def collection_from_types(hash)
		out = []
		hash.each_with_index { |e,i| out << [e,i] }
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

	def inline_errors(object, attribute)
		errors = object.errors.on(attribute)
		
		content_tag :p, errors.class == Array ? errors.join(', ') : errors, :class => 'inline-errors' unless errors.nil?
	end
end