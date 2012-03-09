class DynamicAsymmetricCredential
  include Mongoid::Document
  include Mongoid::Encryptor

  field :email
  field :password

  validates_presence_of :email, :password

  encrypts :password, :mode => :asymmetric,
    :private_key => :extract_private_key,
    :public_key_file => File.dirname(__FILE__) + '/../keys/public'

  private

  def extract_private_key
    File.read(File.dirname(__FILE__) + '/../keys/private')
  end
end
