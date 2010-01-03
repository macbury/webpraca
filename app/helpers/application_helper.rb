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
		p.delete(:authenticity_token)
		p.merge!(o)
		return p
	end
	
	# add rss link
	def rss_link(title, path)
    tag :link, :type => 'application/rss+xml', :title => title, :href => path, :rel => "alternate"
  end

	def inline_errors(object, attribute)
		errors = object.errors.on(attribute)
		
		content_tag :p, errors.class == Array ? errors.join(', ') : errors, :class => 'inline-errors' unless errors.nil?
	end
	
	def title_from_params(default="oferty pracy")
		if default.class == Array
			default = default.first
		end
		if @localization
			title = ["#{default} w ", @localization.name]
		elsif @framework
			title = ["#{default} dla ", @framework.name]
		elsif @type_id
			title = ["#{default} dla ", JOB_LABELS[@type_id]]
		elsif @category
			title = ["#{default} w ", @category.name]
		else
			title = default.split(' ')
			first = title.first
			title.delete_at(0)
		end
		
		return [first,title]
	end
	
	def render_title_from_params(default="ofery pracy")
		title = title_from_params(default)
		
		return content_tag(:span, title[0]) + ' ' + title[1].join(' ')
	end
end