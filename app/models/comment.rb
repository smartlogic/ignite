class Comment < ActiveRecord::Base
  belongs_to :parent, :polymorphic => true
  validates_presence_of :author, :content
end
