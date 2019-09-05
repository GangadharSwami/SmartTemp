require 'rails_helper'

RSpec.describe Client, type: :model do

   let(:client) { clients(:one) }

  it "is not valid without subdomain" do
    client.subdomain = nil
    expect(client).not_to be_valid
  end

  it "is not valid without email" do
    client.email = nil
    expect(client).not_to be_valid
  end

  it "is not valid without password" do
    client.password = nil
    expect(client).not_to be_valid
  end
  it "must not create client with duplicate subdoamin" do
    result = client.save
    expect(result).to be false 
  end

  it "must not create client with duplicate email" do
    new_client = client
    expect(new_client.save).to be false
  end

  it "must create subdomain tenant after creating client" do
    new_client = Client.create(email: 'demo@test.com', subdomain: 'demotest', password: '123')
    expect(Apartment::Tenant.drop('demotest')).to eq 1
  end

  it "must delete subdomain tenant after deleting client" do
    new_client = Client.create(email: 'demo1@test.com', subdomain: 'demotest1', password: '123')
    new_client.destroy!
    expect { Apartment::Tenant.switch!('demotest1') }.to raise_error(Apartment::TenantNotFound)
  end

end
