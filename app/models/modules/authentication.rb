module Authentication
  def self.included(base)
    base.key :email,            String     # Case-insensitive
    base.key :username,         String
    base.key :crypted_password, String     
    base.key :salt,             String  
    
    base.validates_uniqueness_of   :email,    :case_sensitive => false, :if => :email_is_not_blank
    base.validates_format_of       :email,    :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :if => :email_is_not_blank
    base.validates_format_of       :username, :with => /[A-Za-z0-9]/m, :if => :username_is_not_blank
  end
  
  def email_is_not_blank
    return !email.blank?
  end
  
  def username_is_not_blank
    return !username.blank?
  end
end
