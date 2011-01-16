class Item
  include Mongoid::Document
  field :name
  field :mass, :type => Integer
  def to_hash
    {
      :name => name,
      :mass => mass,
      :id => _id
    }
  end
end
