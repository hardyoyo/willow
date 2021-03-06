require 'rails_helper'

RSpec.describe Person, :vcr do
  describe 'class'  do
    it 'has human readable type person' do
      @obj = build(:person)
      expect(@obj.human_readable_type).to eq('Person')
    end
  end

  describe 'first_name' do
    it 'has a first name' do
      @obj = build(:person, first_name: ['Paddington'])
      expect(@obj.first_name).to be_kind_of ActiveTriples::Relation
      expect(@obj.first_name).to eq ['Paddington']
    end

    it 'indexes first_name' do
      @obj = build(:person, first_name: ['Paddington'])
      @doc = @obj.to_solr
      expect(@doc['first_name_tesim']).to eq(['Paddington'])
    end
  end

  describe 'last_name' do
    it 'has a last name' do
      @obj = build(:person, last_name: ['Brown'])
      expect(@obj.last_name).to be_kind_of ActiveTriples::Relation
      expect(@obj.last_name).to eq ['Brown']
    end

    it 'indexes last_name' do
      @obj = build(:person, last_name: ['Brown'])
      @doc = @obj.to_solr
      expect(@doc['last_name_tesim']).to eq(['Brown'])
    end
  end

  describe 'name' do
    it 'has a name' do
      @obj = build(:person, name: ['Paddington Bear'])
      expect(@obj.name).to be_kind_of ActiveTriples::Relation
      expect(@obj.name).to eq ['Paddington Bear']
    end

    it 'indexes name' do
      @obj = build(:person, name: ['Paddington Bear'])
      @doc = @obj.to_solr
      expect(@doc['name_tesim']).to eq(['Paddington Bear'])
      expect(@doc['name_sim']).to eq(['Paddington Bear'])
    end
  end

  describe 'role' do
    it 'has a role' do
      @obj = build(:person, role: ['Friend'])
      expect(@obj.role).to be_kind_of ActiveTriples::Relation
      expect(@obj.role).to eq ['Friend']
    end

    it 'indexes role' do
      @obj = build(:person, role: ['Friend'])
      @doc = @obj.to_solr
      expect(@doc['role_tesim']).to eq(['Friend'])
      expect(@doc['role_sim']).to eq(['Friend'])
    end
  end

  describe 'nested attributes for identifier_object' do
    it 'accepts identifier object attributes' do
      @obj = build(:person, identifier_nested_attributes: [{
          obj_id_scheme: 'ORCID',
          obj_id: '123456'
        }]
      )
      expect(@obj.identifier_nested.size).to eq(1)
      expect(@obj.identifier_nested.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.identifier_nested.first.obj_id_scheme).to eq ['ORCID']
      expect(@obj.identifier_nested.first.obj_id).to eq ['123456']
    end

    it 'has the correct uri' do
      @obj = build(:person, identifier_nested_attributes: [{
          obj_id_scheme: 'ORCID',
          obj_id: '123456'
        }]
      )
      expect(@obj.identifier_nested.first.id).to include('#identifier')
    end

    it 'rejects attributes if scheme or id are blank' do
      @obj = build(:person, identifier_nested_attributes: [
          {
            obj_id_scheme: 'ORCID'
          },
          {
            obj_id: '123456'
          },
          {
            obj_id_scheme: '',
            obj_id: nil
          },
          {
            obj_id_scheme: 'ORCID',
            obj_id: '123456'
          }]
      )
      expect(@obj.identifier_nested.size).to eq(1)
    end

    it 'destroys identifier object' do
      @obj = build(:person, identifier_nested_attributes: [{
            obj_id_scheme: 'ORCID',
            obj_id: '123456'
          }]
      )
      expect(@obj.identifier_nested.size).to eq(1)
      @obj.attributes = {
        identifier_nested_attributes: [{
            id: @obj.identifier_nested.first.id,
            obj_id_scheme: 'ORCID',
            obj_id: '123456',
            _destroy: "1"
          }]
      }
      expect(@obj.identifier_nested.size).to eq(0)
    end

    it 'indexes the identifier object' do
      @obj = build(:person, identifier_nested_attributes: [{
            obj_id_scheme: 'ORCID',
            obj_id: '123456'
        }, {
            obj_id_scheme: 'ARK',
            obj_id: '1dfsdfsd56'
        }]
      )
      @doc = @obj.to_solr
      expect(@doc).to include('identifier_nested_ssim')
      expect(@doc).to include('identifier_nested_ssm')
      expect(@doc['identifier_orcid_ssim']).to match_array(['123456'])
      expect(@doc['identifier_ark_ssim']).to match_array(['1dfsdfsd56'])
    end
  end

  describe 'nested attributes for contact' do
    it 'accepts contact attributes' do
      @obj = build(:person, contact_nested_attributes: [{
          label: ['home'],
          email: ['paddington.brown@example.com'],
          address: ['32 Windsor Gardens, London'],
          telephone: ['01234567890']
        }]
      )
      expect(@obj.contact_nested.size).to eq(1)
      expect(@obj.contact_nested.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.contact_nested.first.label).to eq ['home']
      expect(@obj.contact_nested.first.email).to eq ['paddington.brown@example.com']
      expect(@obj.contact_nested.first.address).to eq ['32 Windsor Gardens, London']
      expect(@obj.contact_nested.first.telephone).to eq ['01234567890']
    end

    it 'has the correct uri' do
      @obj = build(:person, contact_nested_attributes: [{
          label: 'home',
          email: 'paddington.brown@example.com'
        }]
      )
      expect(@obj.contact_nested.first.id).to include('#contact')
    end

    it 'rejects attributes if email, address and telephone are blank' do
      @obj = build(:person, contact_nested_attributes: [
          {
            telephone: nil,
            email: '',
            address: ''
          },
          {
            email: 'paddington.brown@example.com'
          },
          {
            telephone: '01234567890'
          },
          {
            address: '32 Windsor Gardens, London',
          },
          {
            label: 'home',
            telephone: '01234567891',
            email: 'paddington.bear@example.com',
            address: '32 Windsor Gardens'
          }]
      )
      expect(@obj.contact_nested.size).to eq(4)
    end

    it 'destroys contact object' do
      @obj = build(:person, contact_nested_attributes: [{
          label: 'home',
          email: 'paddington.brown@example.com'
        }]
      )
      expect(@obj.contact_nested.size).to eq(1)
      @obj.attributes = {
        contact_nested_attributes: [{
            id: @obj.contact_nested.first.id,
            label: 'home',
            email: 'paddington.brown@example.com',
            _destroy: "1"
          }]
      }
      expect(@obj.contact_nested.size).to eq(0)
    end

    it 'indexes the contact object' do
      @obj = build(:person, contact_nested_attributes: [{
          email: ['paddington.brown@example.com']
        },{
          telephone: '01234567890'
        },{
          address: '32 Windsor Gardens, London',
        },{
          label: 'home',
          telephone: '01234567891',
          email: 'paddington.bear@example.com',
          address: '32 Windsor Gardens'
        }]
      )
      @doc = @obj.to_solr
      expect(@doc).to include('contact_nested_ssm')
      expect(@doc['contact_email_tesim']).to match_array(['paddington.brown@example.com', 'paddington.bear@example.com'])
      expect(@doc['contact_telephone_ssim']).to match_array(['01234567890','01234567891'])
      expect(@doc['contact_address_tesim']).to match_array(['32 Windsor Gardens, London','32 Windsor Gardens'])
    end
  end

end
