OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
	if Settings.table_exists?
		provider :facebook, Settings.facebook_app_id, Settings.facebook_seceret
	end
end

