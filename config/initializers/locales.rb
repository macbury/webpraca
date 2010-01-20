module I18n
  class << self
    def available_locales; backend.available_locales; end
  end
  module Backend
    class Simple
      def available_locales; translations.keys.collect { |l| l.to_s }.sort; end
    end
  end
end

# You need to "force-initialize" loaded locales
I18n.backend.send(:init_translations)

AVAILABLE_LOCALES = I18n.backend.available_locales
RAILS_DEFAULT_LOGGER.debug "* Loaded locales: #{AVAILABLE_LOCALES.inspect}"