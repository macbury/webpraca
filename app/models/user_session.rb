class UserSession < Authlogic::Session::Base
	logout_on_timeout true
	consecutive_failed_logins_limit 5
end