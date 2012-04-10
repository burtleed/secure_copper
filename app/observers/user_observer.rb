class UserObserver < ActiveRecord::Observer

	observe :user

   def after_create(record)
     ExpireSettingsMessage.create(:user_id => record.id) unless record.is_super_admin?
   end

end