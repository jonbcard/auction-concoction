require 'digest/sha1'

class Account
  include MongoMapper::Document
  include Authentication
  
  attr_accessor :password

  # Keys
  key :name,             String
  key :surname,          String
  key :role,             String

  # Validations
  validates_presence_of     :username, :role
  validates_presence_of     :password,                   :if => :password_required
  validates_presence_of     :password_confirmation,      :if => :password_required
  validates_length_of       :password, :within => 4..40, :if => :password_required
  validates_confirmation_of :password,                   :if => :password_required
  validates_length_of       :username,    :within => 3..25
  validates_uniqueness_of   :username,    :case_sensitive => false
  
  
  validates_format_of       :role,     :with => /[A-Za-z]/m

  # Callbacks
  before_save :generate_password

  ##
  # Authenticate the user against with the password provided. If authentication
  # is successful, the user will be returned. Otherwise, this will return nil.
  #
  def self.authenticate(username, password)
    account = first(:username => username) if username.present?
    account && account.password_clean == password ? account : nil
  end

  ##
  # Retrieve the original decrypted password.
  #
  def password_clean
    crypted_password.decrypt(salt)
  end

  private
    def generate_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{username}--") if new_record?
      self.crypted_password = password.encrypt(self.salt)
    end

    def password_required
      crypted_password.blank? || !password.blank?
    end


end