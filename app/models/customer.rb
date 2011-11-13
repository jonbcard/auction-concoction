class Customer
  include MongoMapper::Document

  # Keys
  key :bidder_number,    String     # Permanent bidder number assigned to the customer
  key :first_name,       String     
  key :last_name,        String
  key :id_number,        String     # Typically a driver's license #
  key :email,            String     # Case-insensitive
  key :phone,            String     # Contact number
  key :address,          String     
  key :city,             String
  key :state,            String
  key :username,         String     # Username for web portal login
  key :crypted_password, String     # Password for web portal login
  key :salt,             String     # Salt applied to the crypted password
  

  # Validations
  #validates_length_of       :username, :within => 3..16
  #validates_format_of       :username, :with => /[A-Za-z0-9]/m
  validates_uniqueness_of   :email,    :case_sensitive => false
  #validates_uniqueness_of   :id_number
  validates_uniqueness_of   :bidder_number
  
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