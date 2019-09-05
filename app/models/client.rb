class Client < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable
  validates :subdomain,  presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true       
  
  #after_create :create_tenant
  #after_destroy :destroy_tenant
 

  # def self.find_for_authentication(warden_conditions)
  #   where(:email => warden_conditions[:email], :subdomain => warden_conditions[:subdomain]).first
  # end
  
  private

    def create_tenant
      Apartment::Tenant.create(subdomain)
    end

    def destroy_tenant
      Apartment::Tenant.drop(subdomain)
    end
end
