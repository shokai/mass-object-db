class Item
  include Mongoid::Document
  field :name
  field :mass, :type => Integer
  field :img_url
  def to_hash
    {
      :name => name,
      :mass => mass,
      :id => _id,
      :img_url => img_url
    }
  end
end
