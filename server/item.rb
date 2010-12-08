class Item
  include Mongoid::Document
  field :name
  field :mass, :type => Integer
end
